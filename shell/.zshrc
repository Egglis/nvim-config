# zsh profile. Linked from ~/.zshrc: ln -s ~/.config/nvim/shell/.zshrc ~/.zshrc
# Same aliases as powershell/Microsoft.PowerShell_profile.ps1 (sprofile is pwsh-only).

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
export EDITOR=nvim

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history hist_ignore_dups hist_ignore_space

autoload -Uz compinit && compinit

# Theme
if command -v oh-my-posh >/dev/null 2>&1; then
  _omp_theme="$HOME/.cache/oh-my-posh/themes/ys.omp.json"
  if [[ -f $_omp_theme ]]; then
    eval "$(oh-my-posh init zsh --config "$_omp_theme")"
  else
    eval "$(oh-my-posh init zsh)"
  fi
  unset _omp_theme
fi

# Aliases
nconfig() { cd "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"; }
nvc() { nvim +SessionRestore; }
nvimf() { nvim .; }

# In WSL, desk/doc go to the Windows user's folders. %USERPROFILE% is looked up on first use only (a
# Windows process is slow to start) and cached; cmd.exe runs from /mnt/c to avoid its UNC-path warning.
_win_home() {
  if [[ -z $_WIN_HOME ]]; then
    local p
    p=$(cd /mnt/c && /mnt/c/Windows/System32/cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')
    [[ -n $p ]] && _WIN_HOME=$(wslpath -u "$p")
  fi
  [[ -n $_WIN_HOME ]]
}
_user_dir() {
  local base=$HOME
  if [[ -n $WSL_DISTRO_NAME || -e /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
    _win_home || { print -u2 "Windows user folder not found"; return 1; }
    base=$_WIN_HOME
  fi
  cd "$base/$1"
}
desk() { _user_dir Desktop; }
doc() { _user_dir Documents; }

phelp() {
  print "nconfig - Go to Neovim Config Directory"
  print "nvc - Open Neovim restoring this folder's session"
  print "nvimf - Open Neovim in file explorer"
  print "desk - Go to Desktop"
  print "doc - Go to Documents"
  print "phelp - List these aliases"
}
