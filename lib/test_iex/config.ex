defmodule TestIex.Config do
  @moduledoc """
  Central module for all provided configuration options
  """

  @doc false
  def debug(), do: from_env(:debug, true)

  @doc false
  def core_module(), do: from_env(:core, TestIex.Core)

  @doc """
  FS events deduplication frame, so that we do not trigger too many test runs on file changes.

  defaults:
    `500`
  """
  def watcher_dedup_timeout(), do: from_env(:watcher_dedup_timeout, 500)

  @doc """
  Should the watcher be started?

  defaults:
    `true`
  """
  def watcher_enable(), do: from_env(:watcher_enable, true)

  @doc """
  Watcher args, that are passed directly to `:file_system` package.
  - https://hexdocs.pm/file_system/readme.html

  defaults:
    - `[dirs: ["lib/", "test/"], latency: 0]`
  """
  def watcher_args(), do: from_env(:watcher_args, dirs: ["lib/", "test/"], latency: 0)

  @doc """
  Which file extentions do we consider relevant for re-running tests?

  defaults:
    - `[".ex", ".exs"]`
  """
  def watcher_extensions, do: from_env(:watcher_extensions, [".ex", ".exs"])

  @doc """
  Which test files should be matched? List of path globs, compatible with `Path.wildcard`

  defaults:
    `[
      "./test/**/**_test.exs",
      "./lib/**/**_test.exs"
    ]`
  """
  def test_file_globs(),
    do:
      from_env(:test_file_globs, [
        "./test/**/**_test.exs",
        "./lib/**/**_test.exs"
      ])

  def from_env(val, default) do
    Application.get_env(:maxo_test_iex, val, default)
  end
end
