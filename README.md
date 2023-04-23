[![CI](https://github.com/maxohq/maxo_test_iex/actions/workflows/ci.yml/badge.svg?style=flat)](https://github.com/maxohq/maxo_test_iex/actions/workflows/ci.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/maxo_test_iex.svg?style=flat)](https://hex.pm/packages/maxo_test_iex)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg?style=flat)](https://hexdocs.pm/maxo_test_iex/)
[![Total Downloads](https://img.shields.io/hexpm/dt/maxo_test_iex.svg?style=flat)](https://hex.pm/packages/maxo_test_iex)
[![Licence](https://img.shields.io/hexpm/l/maxo_test_iex.svg?style=flat)](https://github.com/maxohq/maxo_test_iex/blob/main/LICENCE)

# TestIex

TestIex is an interactive ExUnit test runner, that provides following features:

- Easy to learn:

  - the public API consists of 3 functions:
    - TestIex.run(matcher // "")
    - TestIex.run(matcher, line)
    - TestIex.watch(matcher // "")
    - TestIex.watch(matcher, line)
    - TestIex.unwatch()

- Rapid feedback:

  - since there is no re-incurring cost of starting an OS process with Elixir + Mix + your code for every run

- With sensible defaults:

  - you won't have to spend a lot of time to get it configured. Default configs provide great experience for the majority of Elixir projects

- Usable

  - File event de-duplication during watch mode means you only run tests once, even if there are rapid multiple consecutive file events for a single file

- Robust

  - it does code recompilation + loading of tests in a predictable manner

- Flexible:

  - should you have some special needs, there are config options to tune.
  - they are all conveniently kept in a single module [TestIex.Config](https://github.com/maxohq/maxo_test_iex/blob/main/lib/test_iex/config.ex).
  - heck, you could even swap the TestIex.Core module, if desired! It exposes only 3 public functions:
    - start()
    - test(files)
    - test(file, line)

- Inspectable

  - you can turn on debug logs to see what happens
  - this helps you to narrow down issues with your configuration

- Support for test file co-location:

  - it comes with support for co-located ExUnit tests out of the box!
  - Examples of real-life projects using co-located test files
    - https://github.com/maxohq/maxo_adapt/blob/main/lib/maxo_adapt_test.exs
  - To configure co-located test you'll need to adjust following files

    - https://github.com/maxohq/maxo_adapt/blob/main/mix.exs (test_paths, test_pattern)
    - create a test helper in `lib`: https://github.com/maxohq/maxo_adapt/blob/main/lib/test_helper.exs

  - Now you're running!
  - This pattern is very common in Golang / JS / TypeScript and we think it should be also more common in the Elixir community.

- Low - tech:

  - it does not require a particular editor extension or similar. Just simple Elixir + ExUnit in your terminal.
  - your workflow wont have to change in future, since the foundation for TestIex is very stable:
    - ExUnit + file system watching + Iex

- Maintainable:

  - since it requires very little code, it's very easy to maintain and adjust on new Elixir releases
  - the core is in [TestIex.Core](https://github.com/maxohq/maxo_test_iex/blob/main/lib/test_iex/core.ex).
  - It is less than 40 lines of Elixir code with lots of docs.
  - besides it does not have any hairy GenServer logic and also has no ambitions to grow more features and become more complex
  - by not supporting umbrella projects, we keep the code complexity much lower
  - every Elixir project is considered to be in a single root folder with
    following directories under it:
    - `lib`
    - `test`

Please give it a try and see if you like it!

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

## Configuration

```elixir
# in config/runtime.exs
import Config

if config_env() == :test do
  # for default values look into:
  # - https://github.com/maxohq/maxo_test_iex/blob/main/lib/test_iex/config.ex

  # NO need to watch for tests on CI
  if System.get_env("CI"), do: config :maxo_test_iex, watcher_enable: false

  # how long multiple consecutive events on the same file should be considered duplicates?
  config :maxo_test_iex, watcher_dedup_timeout: 500

  # which file changes should trigger a test re-run?
  config :maxo_test_iex, watcher_args: [dirs: ["lib/", "test/"], latency: 0]

  # which file extensions are relevant to trigger a test re-run?
  config :maxo_test_iex, watcher_extensions: [".ex", ".exs"]

  # should we log debug messages?
  config :maxo_test_iex, debug: false
end
```

## Installation

```elixir
def deps do
  [
    {:maxo_test_iex, "~> 0.1", only: [:test]},
  ]
end
```

## Alternatives

- https://hex.pm/packages/test_iex (the core is take from this project and was extended / improved)
- https://hex.pm/packages/tix
- https://hex.pm/packages/mix_test_watch
- https://hex.pm/packages/mix_test_interactive
- https://github.com/marciol/mix_test_iex
- https://hex.pm/packages/mr_t

## Support

<p>
  <a href="https://quantor.consulting/?utm_source=github&utm_campaign=maxo_test_iex">
    <img src="https://raw.githubusercontent.com/maxohq/sponsors/main/assets/quantor_consulting_logo.svg"
      alt="Sponsored by Quantor Consulting" width="210">
  </a>
</p>

## License

The lib is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
