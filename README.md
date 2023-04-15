[![Hex.pm](https://img.shields.io/hexpm/v/maxo_test_iex.svg)](https://hex.pm/packages/maxo_test_iex)
[![Docs](https://img.shields.io/badge/hexdocs-docs-8e7ce6.svg)](https://hexdocs.pm/maxo_test_iex)
[![CI](https://github.com/maxohq/maxo_test_iex/actions/workflows/ci.yml/badge.svg)](https://github.com/maxohq/maxo_test_iex/actions/workflows/ci.yml)

# TestIex

## Usage

```elixir
$ MIX_ENV=test iex -S mix

# run all
iex> TestIex.run

# run all matching files
iex> TestIex.run("word")

# run test on line 45 for the first matching file
iex> TestIex.run("word", 45)

# run test on line 45 for the first matching file
iex> TestIex.run("users_test.exs:45")

# run test on line 45 for the first matching file
iex> TestIex.run("users:45")

```

## Installation

```elixir
def deps do
  [
    {:maxo_test_iex, "~> 0.1", only: [:test]},
  ]
end
```
