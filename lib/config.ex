defmodule TestIex.Config do
  def core_module(), do: Application.get_env(:maxo_test_iex, :core, TestIex.Core)
  def event_dedup_timeout(), do: Application.get_env(:maxo_test_iex, :event_dedup_timeout, 2000)
end
