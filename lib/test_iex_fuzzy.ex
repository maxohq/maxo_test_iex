defmodule TestIexFuzzy do
  def start do
    TestIex.start()
  end

  def run(matcher) do
    TestIex.test(matched(matcher))
  end

  def matched(matcher) do
    test_files() |> Enum.filter(fn x -> String.contains?(x, matcher) end)
  end

  def test_files do
    # TODO: make flexible
    Path.wildcard("./test/**/**_test.exs")
  end
end
