defmodule TestIex.Matcher do
  @moduledoc """
  File matching logic in a separate module for easier testing
  """
  @line_matcher_rgx ~r/\:\d+$/

  def match(matcher, files) do
    cond do
      Regex.match?(@line_matcher_rgx, matcher) ->
        [file, line] = matcher |> String.split(":")
        match(file, line, files)

      true ->
        {for_matcher(matcher, files), nil}
    end
  end

  def match(matcher, line, files) do
    file = List.first(for_matcher(matcher, files))
    {file, line}
  end

  defp for_matcher(matcher, files) do
    files |> Enum.filter(fn x -> String.contains?(x, matcher) end)
  end
end
