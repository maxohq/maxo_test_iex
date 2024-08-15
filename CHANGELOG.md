## v0.1.7 (2024-08-15)

Feat: update package `file_system` to 1.0.

## v0.1.6 (2023-04-20)

Feat: add config for watcher_extensions + refactorings
Feat: better docs / readme
Feat: add a `:debug` config for verbose logging
Refact: TestIex.run / watch with defaults
Refact: refactoring for TestIex.Core module
Feat: make test files selector configurable
Feat: configure CI to not start TestIex.Watcher process
Feat: more consistent config var naming
Feat: prevent watcher from starting

## v0.1.5 (2023-04-16)

- fix: do not fail on test compilation errors
- feat: more consistent logging

## v0.1.4 (2023-04-16)

- feat: configurable deduplication timeout for file events

## v0.1.3 (2023-04-16)

- feat: file event watcher de-duplication

## v0.1.2 (2023-04-16)

- feat: flexible file watcher [experimental, without de-bouncing or other robust features]

## v0.1.1 (2023-04-15)

- feat: coloured logs
- feat: matching on copy-pasted `file:line` strings from ExUnit exceptions, like:
  `lib/users/user_test.exs:54`
- feat: unit tests
- feat: Github CI

## v0.1.0 (2023-04-10)

### First release

- Putting it on Hex.pm for simpler installation. Rather stable API, put to use on multiple projects.
