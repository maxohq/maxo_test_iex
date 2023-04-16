defmodule TestIex.Watcher do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    {:ok, watcher_pid} = FileSystem.start_link(args)
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid, cmd: nil}}
  end

  def set_command(fun) do
    GenServer.call(__MODULE__, {:set_command, fun})
  end

  def handle_call({:set_command, fun}, _, state) do
    state = %{state | cmd: fun}
    {:reply, :ok, state}
  end

  def handle_info(
        {:file_event, watcher_pid, {path, events}},
        %{watcher_pid: watcher_pid, cmd: cmd} = state
      ) do
    # Your own logic for path and events
    IO.inspect({path, events}, label: "file_event")

    if Path.extname(path) in [".ex", ".exs"] && cmd do
      cmd.()
    end

    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    # Your own logic when monitor stop
    IO.inspect("STOPPING WATCHER? #{inspect(watcher_pid)}", label: "file_event")
    {:noreply, state}
  end
end
