#!/usr/bin/env bash
# nvim config — gate targets for Linux (incl. WSL). Usage: ./gates.sh <target> [<target> ...]
# Mirrors gates.ps1: a gate change lands in both scripts.
#
# Every gate prints its own exit code as `LABEL_EXIT:<n>` and exits with it, so a
# result can be quoted rather than inferred from output that may look clean.
# `gates` runs the whole set without stopping, so one run reports every failure.
set -u

TARGETS=(build format validate changes deps gates)
GATE_TARGETS=(build format validate)

cd "$(dirname "$(readlink -f "$0")")" || exit 1

# Runs a command, prints LABEL_EXIT:<n>, returns <n>.
gate() {
  local label=$1
  shift
  "$@" 2>&1
  local code=$?
  echo "${label}_EXIT:$code"
  return "$code"
}

changes() {
  [ -d openspec/changes ] || return 0
  find openspec/changes -mindepth 1 -maxdepth 1 -type d ! -name archive -printf '%f\n' | sort
}

# Starts Neovim headless with this config; any startup error fails the gate. stdpath("config") is
# pointed at this checkout, so it also works outside ~/.config/nvim (e.g. the Windows checkout under /mnt/c).
build() {
  XDG_CONFIG_HOME="$(dirname "$PWD")" NVIM_APPNAME="$(basename "$PWD")" \
    nvim --headless -u init.lua \
    "+lua if vim.v.errmsg ~= '' then io.stderr:write(vim.v.errmsg .. '\n') vim.cmd('cquit 1') else vim.cmd('qall!') end"
}

format() {
  stylua --check init.lua lua
}

# Validates every active change. No active change is a failure, not a silent pass.
validate() {
  local fail=0 c list
  list=$(changes)
  if [ -z "$list" ]; then
    echo 'no active change found under openspec/changes/'
    fail=1
  else
    for c in $list; do
      openspec validate "$c" --strict 2>&1 || fail=1
    done
  fi
  echo "VALIDATE_EXIT:$fail"
  return "$fail"
}

# True when $1 >= $2 (dotted versions).
version_ge() {
  [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

is_wsl() {
  [ -n "${WSL_DISTRO_NAME:-}" ] || [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]
}

# Every tool and login in docs/dependencies.md for Linux — keep the two in step. Not part of
# `gates`: it checks the machine, not the code.
deps() {
  local fail=0 v
  check() {
    local msg=$1
    shift
    if ! "$@" >/dev/null 2>&1; then
      echo "MISSING $msg"
      fail=1
    fi
  }
  nvim_ok() {
    v=$(nvim --version 2>/dev/null | head -n1 | sed -E 's/^NVIM v([0-9.]+).*/\1/') && version_ge "$v" 0.12
  }
  ts_ok() {
    v=$(tree-sitter --version 2>/dev/null | head -n1 | sed -E 's/^tree-sitter ([0-9.]+).*/\1/') && version_ge "$v" 0.26.1
  }
  check 'nvim 0.12+ — sudo dnf install neovim' nvim_ok
  check 'stylua — npm i -g @johnnymorganz/stylua-bin' stylua --version
  check 'git — sudo dnf install git' git --version
  check 'node — sudo dnf install nodejs npm' node --version
  check 'openspec — npm i -g @fission-ai/openspec' openspec --version
  check 'rg — sudo dnf install ripgrep' rg --version
  check 'fd — sudo dnf install fd-find' fd --version
  check 'opencode — npm i -g @opencode/cli' opencode --version
  check 'lazygit — sudo dnf copr enable atim/lazygit && sudo dnf install lazygit' lazygit --version
  check 'tree-sitter 0.26.1+ — sudo dnf install tree-sitter-cli' ts_ok
  check 'gcc — sudo dnf install gcc' gcc --version
  check 'make — sudo dnf install make' make --version
  check 'trash — sudo dnf install trash-cli' command -v trash
  check 'zsh — sudo dnf install zsh' zsh --version
  check 'oh-my-posh — sudo dnf install gawk unzip && curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin' oh-my-posh --version
  if is_wsl; then
    check 'win32yank.exe — ln -s "/mnt/c/Program Files/Neovim/bin/win32yank.exe" ~/.local/bin/ (see docs/wsl.md)' \
      command -v win32yank.exe
  fi
  echo "DEPS_EXIT:$fail"
  return "$fail"
}

[ $# -eq 0 ] && set -- gates

overall=0
for t in "$@"; do
  case $t in
    build) gate BUILD build ;;
    format) gate FORMAT format ;;
    validate) validate ;;
    changes) changes | paste -sd' ' ;;
    deps) deps ;;
    gates)
      code=0
      for g in "${GATE_TARGETS[@]}"; do
        case $g in
          build) gate BUILD build || code=1 ;;
          format) gate FORMAT format || code=1 ;;
          validate) validate || code=1 ;;
        esac
      done
      echo "GATES_EXIT:$code"
      (exit "$code")
      ;;
    *)
      echo "unknown target '$t'. Known: ${TARGETS[*]}"
      (exit 2)
      ;;
  esac
  code=$?
  [ "$code" -ne 0 ] && overall=$code
done
exit "$overall"
