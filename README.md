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
