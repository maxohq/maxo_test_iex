defmodule TestIex.Log do
  alias TestIex.Config
  require Logger

  def debug(msg) do
    if Config.debug() do
      [msg]
      |> colorize()
      |> Logger.debug()
    end
  end

  def log_msg(msg), do: log([msg])

  def log_file_and_line(file, line) do
    log([
      " Running ",
      :red,
      :bright,
      inspect(file),
      :default_color,
      " for line ",
      :red,
      :bright,
      line
    ])
  end

  def log_files(files) do
    log([
      " Running ",
      :red,
      :bright,
      inspect(files)
    ])
  end

  defp log(parts) when is_list(parts) do
    parts
    |> colorize()
    |> Logger.info()
  end

  def colorize(parts) when is_list(parts) do
    ([
       :bright,
       :green,
       "[test_iex] ",
       :default_color
     ] ++ parts)
    |> IO.ANSI.format()
  end
end
