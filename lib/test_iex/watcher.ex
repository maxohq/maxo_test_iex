defmodule TestIex.Watcher.State do
  defstruct watcher_pid: nil, cmd: nil, last_event: nil
end

defmodule TestIex.Watcher do
  @moduledoc """
  Watcher for file events + evtl. running a configured `cmd` function
  """

  use GenServer
  alias TestIex.Watcher.State
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    {:ok, watcher_pid} = FileSystem.start_link(args)
    FileSystem.subscribe(watcher_pid)
    {:ok, %State{watcher_pid: watcher_pid, cmd: nil, last_event: nil}}
  end

  def set_command(fun) do
    GenServer.call(__MODULE__, {:set_command, fun})
  end

  def handle_call({:set_command, fun}, _, %State{} = state) do
    state = %State{state | cmd: fun}
    {:reply, :ok, state}
  end

  def handle_info(
        {:file_event, watcher_pid, {path, events}},
        %State{watcher_pid: watcher_pid} = state
      ) do
    TestIex.Log.log_msg("file_event " <> inspect({path, events}))

    if should_run?(state, {path, events}) do
      try do
        state.cmd.()
      rescue
        e ->
          Logger.error(Exception.format(:error, e, __STACKTRACE__))
      end
    else
      TestIex.Log.log_msg("Skipping duplicate event for #{path}")
    end

    new_last_event = {path, events, now_in_ms()}
    state = %State{state | last_event: new_last_event}

    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    TestIex.Log.log_msg("file_event: STOPPING WATCHER #{inspect(watcher_pid)}")
    {:noreply, state}
  end

  defp should_run?(%State{} = state, {path, events}) do
    code_file = Path.extname(path) in [".ex", ".exs"]
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

  defp now_in_ms do
    DateTime.utc_now() |> DateTime.to_unix(:millisecond)
  end

  defp watcher_dedup_timeout do
    TestIex.Config.watcher_dedup_timeout()
  end
end
