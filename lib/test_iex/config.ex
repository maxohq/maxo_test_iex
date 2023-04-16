defmodule TestIex.Config do
  def core_module(), do: Application.get_env(:maxo_test_iex, :core, TestIex.Core)

  @doc """
  FS events deduplication frame, so that we do not trigger too many test runs on file changes.
  """
  def watcher_dedup_timeout(),
    do: Application.get_env(:maxo_test_iex, :watcher_dedup_timeout, 2000)

  @doc """
  Should the watcher be started?
  """
  def watcher_enable(),
    do: Application.get_env(:maxo_test_iex, :watcher_enable, true)

  @doc """
  Watcher args, that are passed directly to `:file_system` package.
  - https://hexdocs.pm/file_system/readme.html
  """
  def watcher_args(),
    do: Application.get_env(:maxo_test_iex, :watcher_args, dirs: ["lib/", "test/"], latency: 0)
end
