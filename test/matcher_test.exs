defmodule MatcherTest do
  use ExUnit.Case
  use Mneme, action: :accept, default_pattern: :last
  alias TestIex.Matcher

  describe "match" do
    @files ["test/some/user_test.exs", "test/some/admin_test.exs", "lib/auth/token_test.exs"]

    test "matches multiple files" do
      auto_assert({["test/some/user_test.exs"], nil} <- Matcher.match("user", @files))

      auto_assert(
        {["test/some/user_test.exs", "test/some/admin_test.exs", "lib/auth/token_test.exs"], nil} <-
          Matcher.match("test", @files)
      )

      auto_assert(
        {["test/some/user_test.exs", "test/some/admin_test.exs"], nil} <-
          Matcher.match("some", @files)
      )

      auto_assert({["test/some/admin_test.exs"], nil} <- Matcher.match("admin", @files))
    end

    test "matches single file with given line" do
      auto_assert({"test/some/user_test.exs", "40"} <- Matcher.match("user:40", @files))
      auto_assert({"test/some/user_test.exs", 50} <- Matcher.match("user", 50, @files))
    end
  end
end
