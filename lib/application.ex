# TestIex.Watcher.start_link(dirs: ["lib/", "test/"], latency: 0)
# TestIex.Watcher.start_link(dirs: ["lib/", "test/"])
# TestIex.Watcher.set_command(fn -> TestIex.run("test") end)

defmodule TestIex.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("STARTING TestIex.Application")

    children = [
      {TestIex.Watcher, watcher_args()}
    ]

    opts = [strategy: :one_for_one, name: TestIex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def watcher_args do
    [dirs: ["lib/", "test/"], latency: 0]
  end
end
