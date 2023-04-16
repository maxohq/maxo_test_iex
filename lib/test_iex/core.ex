defmodule TestIex.Core do
  # Copied from https://github.com/scottming/test_iex/blob/scott/lib/test_iex.ex
  @moduledoc """
  A utility module that helps you iterate faster on unit tests.
  This module lets execute specific tests from within a running iex shell to
  avoid needing to start and stop the whole application every time.
  """

  @doc """
  Starts the testing context.
  ## Examples
      iex> TestIex.start()
  """
  def start() do
    ExUnit.start()
    Code.compiler_options(ignore_module_conflict: true)

    if File.exists?("test/test_helper.exs") do
      load_helper("test/test_helper.exs")
    end

    if File.exists?("lib/test_helper.exs") do
      load_helper("lib/test_helper.exs")
    end

    :ok
  end

  @doc """
  Loads or reloads testing helpers
  ## Examples
      iex> TestIex.load_helper(“test/test_helper.exs”)
  """
  def load_helper(file_name) do
    Code.eval_file(file_name, File.cwd!())
  end

  @doc """
  Runs a single test, a test file, or multiple test files
  ## Example: Run a single test
      iex> TestIex.test("./path/test/file/test_file_test.exs", line_number)
  ## Example: Run a single test file
      iex> TestIex.test("./path/test/file/test_file_test.exs")
  ## Example: Run several test files:
      iex> TestIex.test(["./path/test/file/test_file_test.exs", "./path/test/file/test_file_2_test.exs"])
  """
  def test(path, line \\ nil)

  def test(path, line) when is_binary(path) do
    if line do
      ExUnit.configure(exclude: [:test], include: [line: line])
    else
      ExUnit.configure(exclude: [], include: [])
    end

    IEx.Helpers.recompile()
    Code.compile_file(path)
    server_modules_loaded()
    ExUnit.run()
  end

  def test(paths, _line) when is_list(paths) do
    ExUnit.configure(exclude: [], include: [])
    IEx.Helpers.recompile()
    Enum.map(paths, &Code.compile_file/1)
    server_modules_loaded()
    ExUnit.run()
  end

  if System.version() > "1.14.1" do
    defp server_modules_loaded(), do: ExUnit.Server.modules_loaded(false)
  else
    defp server_modules_loaded(), do: ExUnit.Server.modules_loaded()
  end
end
