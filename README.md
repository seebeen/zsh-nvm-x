# zsh-nvm-x

Fast Zsh plugin to **install, update, and load** [`nvm`](https://github.com/nvm-sh/nvm), with optional lazy-loading and `.nvmrc` auto-use support.

Repository: **https://github.com/seebeen/zsh-nvm-x**

---

## Features

- Installs `nvm` automatically if missing
- Eager load or lazy load `nvm`
- `nvm upgrade` / `nvm revert` wrapper support
- `.nvmrc` auto-use on directory changes
- Optional completion loading
- Installs `rc` and `nightly` aliases through wrapper helpers

---

## Installation

> [!IMPORTANT]
> Set `NVM_*` options before loading `zsh-nvm-x`.
> With plugin managers, place your `export ...` lines in shell init before plugin bootstrap.

### Manual (git clone)

```zsh
git clone https://github.com/seebeen/zsh-nvm-x /path/to/zsh-nvm-x

export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

source /path/to/zsh-nvm-x/zsh-nvm-x.plugin.zsh
```

### Oh My Zsh

```zsh
git clone https://github.com/seebeen/zsh-nvm-x ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-nvm-x
```

Then in `~/.zshrc`:

```zsh
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

plugins=(... zsh-nvm-x)
# later in the file:
# source $ZSH/oh-my-zsh.sh
```

### Antigen

```zsh
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

antigen bundle seebeen/zsh-nvm-x
antigen apply
```

### Antibody

Add to your plugins list:

```text
seebeen/zsh-nvm-x
```

And in your shell init (before sourcing Antibody output):

```zsh
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
```

### Zinit

```zsh
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

zinit light seebeen/zsh-nvm-x
```

### zplug

```zsh
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

zplug "seebeen/zsh-nvm-x"
```

### zgenom / zgen

```zsh
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

zgenom load seebeen/zsh-nvm-x
```

### ZimFW

In your `~/.zimrc`:

```zsh
zmodule seebeen/zsh-nvm-x
```

Set options in your shell init before ZimFW initialization:

```zsh
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
```

Then rebuild:

```zsh
zimfw install
```

### Sheldon

In `~/.config/sheldon/plugins.toml`:

```toml
[plugins.zsh-nvm-x]
github = "seebeen/zsh-nvm-x"
```

And in `~/.zshrc` before `eval "$(sheldon source)"`:

```zsh
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
```

---

## Configuration options

Set these before loading `zsh-nvm-x` (typically near the top of your `~/.zshrc` or equivalent).

| Option                         | Default      | Description                                                                                   |
| ------------------------------ | ------------ | --------------------------------------------------------------------------------------------- |
| `NVM_DIR`                      | `$HOME/.nvm` | Where `nvm` is installed/loaded from.                                                         |
| `NVM_COMPLETION`               | `false`      | When `true`, loads `nvm` completion (`$NVM_DIR/bash_completion`).                             |
| `NVM_LAZY_LOAD`                | `false`      | When `true`, creates lazy wrappers and loads `nvm` only when needed.                          |
| `NVM_LAZY_LOAD_EXTRA_COMMANDS` | `()`         | Extra commands that should also trigger lazy load.                                            |
| `NVM_NO_USE`                   | `false`      | When `true`, loads `nvm` with `--no-use` (does not auto-select Node version).                 |
| `NVM_AUTO_USE`                 | `false`      | When `true`, auto-runs `nvm use` / `nvm install` based on `.nvmrc` when changing directories. |
| `ZSH_NVM_NO_LOAD`              | `false`      | Debug/testing switch to skip plugin initialization entirely.                                  |

### Recommended setup

```zsh
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
export NVM_COMPLETION=true
```

### Example with extra lazy trigger commands

```zsh
export NVM_LAZY_LOAD=true
typeset -ga NVM_LAZY_LOAD_EXTRA_COMMANDS
NVM_LAZY_LOAD_EXTRA_COMMANDS+=(vim nvim)
```

---

## Behavior notes

> [!NOTE]
> On first run, a missing `nvm` installation is bootstrapped automatically into `NVM_DIR`.

- If `nvm` is missing, the plugin clones `nvm` into `NVM_DIR` and checks out the latest release tag.
- If lazy load is enabled, wrappers are created for `nvm`, global npm binaries, and any extra commands you define.
- With `NVM_AUTO_USE=true`:
  - entering a directory with `.nvmrc` runs `nvm use` (or `nvm install` if needed)
  - leaving that tree can revert to `nvm` default

---

## Extended `nvm` commands provided by this plugin

> [!WARNING]
> `nvm upgrade` and `nvm revert` modify your local `nvm` checkout.
> Use them intentionally, especially in shared or reproducible environments.

- `nvm upgrade` – upgrade installed `nvm` to latest tag
- `nvm revert` – revert to previous `nvm` tag
- `nvm install rc` – install latest RC and alias as `rc`
- `nvm install nightly` – install latest nightly and alias as `nightly`

`nvm_update` is kept as a compatibility alias and prints a deprecation message.

---

## Development

### Project layout

- `zsh-nvm-x.plugin.zsh` – entrypoint/bootstrap
- `lib/zsh-nvm-x-state.zsh` – internal state
- `lib/zsh-nvm-x-core.zsh` – install/load/completion/core helpers
- `lib/zsh-nvm-x-lazy.zsh` – lazy-load implementation
- `lib/zsh-nvm-x-auto-use.zsh` – `.nvmrc` auto-use hook logic
- `lib/zsh-nvm-x-wrappers.zsh` – wrapper commands (`upgrade`, `revert`, `install` helpers)

### Local setup (Fedora)

```bash
sudo dnf install -y zsh git curl make
```

Clone and enter the project:

```bash
git clone https://github.com/seebeen/zsh-nvm-x
cd zsh-nvm-x
```

Install ShellSpec (if needed):

```bash
curl -fsSL https://git.io/shellspec | sh -s -- --yes
```

### Typical workflow

Run all checks:

```bash
make test
```

Useful commands:

- `make lint-shell` – syntax check plugin, libraries, and specs
- `make test-unit` – run ShellSpec suite
- `make test-smoke` – run smoke tests under `test/smoke/`

### Contribution checklist

- Keep behavior flags/env vars documented (`NVM_*`, `ZSH_NVM_NO_LOAD`)
- Add/update tests for behavioral changes
- Run `make test` before opening a PR
- Update README when user-facing behavior changes

---

## Testing

This repository uses **ShellSpec** for unit/integration-style shell tests and simple smoke scripts for startup/lazy-load validation.

### Local prerequisites (Fedora)

```bash
sudo dnf install -y zsh git curl make
```

Install ShellSpec (if not already installed):

```bash
curl -fsSL https://git.io/shellspec | sh -s -- --yes
```

### Run tests

```bash
make test
```

Useful targets:

- `make lint-shell` – syntax-check plugin, library, and spec files
- `make test-unit` – run ShellSpec suite
- `make test-smoke` – run smoke tests from `test/smoke/`

CI is configured in `.github/workflows/test.yml` and runs the same test pipeline on Ubuntu and macOS.

---

## Credits

This project is a fork/rework of the original [`zsh-nvm`](https://github.com/lukechilds/zsh-nvm) by **Luke Childs**.

- Original author: **Luke Childs**
- Original repo: https://github.com/lukechilds/zsh-nvm
- Fork maintainer: **Sibin Grasic** <sibin.grasic@oblak.studio>
- Fork repo: https://github.com/seebeen/zsh-nvm-x

Huge thanks to Luke for the original work.

---

## License

MIT — see [LICENSE](./LICENSE).
