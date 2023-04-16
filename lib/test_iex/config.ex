defmodule TestIex.Config do
  def core_module(), do: Application.get_env(:maxo_test_iex, :core, TestIex.Core)
  def event_dedup_timeout(), do: Application.get_env(:maxo_test_iex, :event_dedup_timeout, 2000)
  def enable_watching(), do: Application.get_env(:maxo_test_iex, :enable_watching, true)

  def watcher_args(),
    do: Application.get_env(:maxo_test_iex, :watcher_args, dirs: ["lib/", "test/"], latency: 0)
end
