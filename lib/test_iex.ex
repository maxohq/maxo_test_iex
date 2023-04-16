defmodule TestIex do
  @moduledoc """
  Allows running test files by substring of their names
  """

  alias TestIex.Matcher
  alias TestIex.Log

  @doc """
  Run all matching test files

  Examples:

    iex> TestIex.run("user")
    iex> TestIex.run("user_test.exs")
    iex> TestIex.run("some_file:12")
  """
  def run(matcher \\ "") do
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

  @doc """
  Set which test files / lines should run on each file change
  `TestIex.Config.test_file_globs()` defines which files would trigger a re-run
  """
  def watch(matcher \\ "") do
    cmd = fn -> TestIex.run(matcher) end
    TestIex.Watcher.set_command(cmd)
  end

  def watch(matcher, line) do
    cmd = fn -> TestIex.run("#{matcher}:#{line}") end
    TestIex.Watcher.set_command(cmd)
  end

  @doc """
  Stop watching changes on files
  """
  def unwatch() do
    TestIex.Watcher.set_command(nil)
  end

  ##
  ## Public just for introspection, internal functions
  ##
  def test_files do
    Enum.reduce(TestIex.Config.test_file_globs(), [], fn path, acc ->
      acc ++ Path.wildcard(path)
    end)
  end

  def core_module(), do: TestIex.Config.core_module()
end
