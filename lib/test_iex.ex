defmodule TestIex do
  @moduledoc """
  Allows running test files by substring of their names
  """
  alias TestIex.Core

  @doc """
  Run all test files
  """
  def run() do 
    run("")
  end

  @doc """
  Run all matching test files
  """
  def run(matcher) do
    Core.start()
    files = matched(matcher)
    IO.puts("RUNNING #{inspect(files)}")
    Core.test(files)
  end

  @doc """
  Run the first matching test file with a `line` selector
  """
  def run(matcher, line) do
    Core.start()
    file = List.first(matched(matcher))
    IO.puts("RUNNING #{inspect(file)} for line #{line}")
    Core.test(file, line)
  end

  def matched(matcher) do
    test_files() |> Enum.filter(fn x -> String.contains?(x, matcher) end)
  end

  def test_files do
    Path.wildcard("./test/**/**_test.exs") ++ Path.wildcard("./lib/**/**_test.exs")
  end
end
