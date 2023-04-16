defmodule TestIex.Watcher.State do
  defstruct watcher_pid: nil, cmd: nil, last_event: nil
end

defmodule TestIex.Watcher do
  @moduledoc """
  Watcher for file events + evtl. running a configured `cmd` function
  """

  use GenServer

  alias TestIex.Config
  alias TestIex.Log
  alias TestIex.Watcher.State

  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    {:ok, watcher_pid} = FileSystem.start_link(args)
    FileSystem.subscribe(watcher_pid)
    {:ok, state_default(watcher_pid)}
  end

  def set_command(fun) do
    GenServer.call(__MODULE__, {:set_command, fun})
  end

  def handle_call({:set_command, fun}, _, %State{} = state) do
    {:reply, :ok, state_cmd(state, fun)}
  end

  def handle_info(
        {:file_event, w_pid, {path, events} = fs_event},
        %State{watcher_pid: w_pid} = state
      ) do
    Log.debug("file_event " <> inspect(fs_event))
    exec_if_needed(state, fs_event)

    {:noreply, state_evt(state, {path, events, now_in_ms()})}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    {:noreply, state}
  end

  defp exec_if_needed(state, {path, events}) do
    if should_run?(state, {path, events}),
      do: safe_exec(state.cmd),
      else: Log.debug("Skipping duplicate event for #{path}")
  end

  defp should_run?(%State{} = state, {path, events}) do
    code_file = Path.extname(path) in Config.watcher_extensions()
    cmd_set = state.cmd != nil
    duplicate = duplicate_event?(state.last_event, {path, events})

    code_file && cmd_set && !duplicate
  end

  # first event!
  defp duplicate_event?(nil, {_path, _events}), do: false

  defp duplicate_event?({l_path, _l_events, l_time}, {path, _events}) do
    # same path + less than dedup_timeout_ms ago executed
    l_path == path && now_in_ms() - l_time < watcher_dedup_timeout()
  end

  defp state_default(watcher_pid), do: %State{watcher_pid: watcher_pid}
  defp state_cmd(state, cmd), do: %State{state | cmd: cmd}
  defp state_evt(state, evt), do: %State{state | last_event: evt}

  defp now_in_ms, do: DateTime.to_unix(DateTime.utc_now(), :millisecond)
  defp watcher_dedup_timeout, do: Config.watcher_dedup_timeout()

  defp safe_exec(fun) do
    try do
      fun.()
    rescue
      e ->
        Logger.error(Exception.format(:error, e, __STACKTRACE__))
    end
  end
end
