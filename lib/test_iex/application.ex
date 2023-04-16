defmodule TestIex.Application do
  @moduledoc false
  use Application
  alias TestIex.Config

  @impl true
  def start(_type, _args) do
    children = start_watcher_if_needed(Config.watcher_enable())

    opts = [strategy: :one_for_one, name: TestIex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp start_watcher_if_needed(true), do: [{TestIex.Watcher, Config.watcher_args()}]
  defp start_watcher_if_needed(_), do: []
end
