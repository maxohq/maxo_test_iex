defmodule TestIex do
  @moduledoc """
  Allows running test files by substring of their names
  """

  alias TestIex.Matcher
  alias TestIex.Log

  @doc """
  Run all test files
  """
  def run(), do: run("")

  @doc """
  Run all matching test files

  Examples:

    iex> TestIex.run("user")
    iex> TestIex.run("user_test.exs")
    iex> TestIex.run("some_file:12")
  """
  def run(matcher) do
    result = Matcher.match(matcher, test_files())

    case result do
      {files, nil} -> do_run(files)
      {file, line} -> do_run_line(file, line)
    end
  end

  @doc """
  Run the first matching test file with a `line` selector

  Examples:
    # run first matching file for "user" on line 40
    iex> TestIex.run("user", 40)

    # same as
    iex> TestIex.run("user:40")

  """
  def run(matcher, line) do
    run("#{matcher}:#{line}")
  end

  defp do_run(files) do
    Log.log_files(files)
    core_module().start()
    core_module().test(files)
  end

  defp do_run_line(file, line) do
    Log.log_file_and_line(file, line)
    core_module().start()
    core_module().test(file, line)
  end

  ##
  ## WATCHING
  ##
  def watch(matcher) do
    cmd = fn -> TestIex.run(matcher) end
    TestIex.Watcher.set_command(cmd)
  end

  def watch(matcher, line) do
    cmd = fn -> TestIex.run("#{matcher}:#{line}") end
    TestIex.Watcher.set_command(cmd)
  end

  def unwatch() do
    TestIex.Watcher.set_command(nil)
  end

  ##
  ## Public just for introspection, internal functions
  ##
  def test_files do
    Path.wildcard("./test/**/**_test.exs") ++ Path.wildcard("./lib/**/**_test.exs")
  end

  def core_module(), do: Application.get_env(:maxo_test_iex, :core, TestIex.Core)
end
