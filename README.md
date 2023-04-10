# TestIex


## Usage


```elixir
$ MIX_ENV=test iex -S mix

# run all 
iex> TestIex.run

# run matching files
iex> TestIex.run("word")

# run test on line 45 for first matchin file
iex> TestIex.run("word", 45)
```

## Installation

```elixir
def deps do
  [
    {:maxo_test_iex, "~> 0.1", only: [:test]},
  ]
end
```
