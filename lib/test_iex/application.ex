# TestIex.Watcher.start_link(dirs: ["lib/", "test/"], latency: 0)
# TestIex.Watcher.start_link(dirs: ["lib/", "test/"])
# TestIex.Watcher.set_command(fn -> TestIex.run("test") end)

defmodule TestIex.Application do
  @moduledoc false
  use Application
  alias TestIex.Config

  @impl true
  def start(_type, _args) do
    children = start_watcher_if_needed(Config.enable_watching())

    opts = [strategy: :one_for_one, name: TestIex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp start_watcher_if_needed(true), do: [{TestIex.Watcher, Config.watcher_args()}]
  defp start_watcher_if_needed(_), do: []
end
