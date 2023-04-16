[![Hex.pm](https://img.shields.io/hexpm/v/maxo_test_iex.svg?style=flat)](https://hex.pm/packages/maxo_test_iex)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg?style=flat)](https://hexdocs.pm/maxo_test_iex/)
[![Total Download](https://img.shields.io/hexpm/dt/maxo_test_iex.svg?style=flat)](https://hex.pm/packages/maxo_test_iex)
[![License](https://img.shields.io/hexpm/l/maxo_test_iex.svg?style=flat)](https://github.com/maxohq/maxo_test_iex/blob/main/LICENSE)
[![CI](https://github.com/maxohq/maxo_test_iex/actions/workflows/ci.yml/badge.svg?style=flat)](https://github.com/maxohq/maxo_test_iex/actions/workflows/ci.yml)

# TestIex

## Usage

```elixir
$ MIX_ENV=test iex -S mix

# Run all tests
iex> TestIex.run

# Run all matching files
iex> TestIex.run("word")

# Run test on line 45 for the first matching file
iex> TestIex.run("word", 45)

# Run test on line 45 for the first matching file
iex> TestIex.run("users_test.exs:45")

# Run test on line 45 for the first matching file
iex> TestIex.run("users:45")

# Watching on file changes and re-running tests.
# Currently only .ex / .exs files in `lib` or `test` folders trigger a re-run.
iex> TestIex.watch("users:45")

# Reset watching
iex> TestIex.unwatch()
```

## Installation

```elixir
def deps do
  [
    {:maxo_test_iex, "~> 0.1", only: [:test]},
  ]
end
```
