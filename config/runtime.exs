import Config

if config_env() == :test do
  # NO need to watch for tests on CI
  if System.get_env("CI"), do: config(:maxo_test_iex, watcher_enable: false)
  config :maxo_test_iex, watcher_dedup_timeout: 500
  config :maxo_test_iex, watcher_args: [dirs: ["lib/", "test/"], latency: 0]
  config :maxo_test_iex, debug: false
end
