# WSL setup (Fedora 45)

How this PC's WSL side was set up, in order, so another PC (or a rebuilt one) can repeat it. Afterwards the
same `master` runs from `~/.config/nvim` in WSL and from `%LOCALAPPDATA%\nvim` on Windows. Tool versions and
checks: [`dependencies.md`](dependencies.md).

## 1. WSL and Fedora (Windows, pwsh)

WSL must be **2.5.7 or newer**: Fedora 45 won't boot on 2.4.x.

```powershell
wsl --update            # elevated pwsh
wsl --version           # "WSL version: 2.5.7" or newer
wsl --install FedoraLinux-45
```

Create the Linux user when asked. The rest runs inside Fedora (`wsl -d FedoraLinux-45`) unless marked
Windows.

## 2. `/etc/wsl.conf`

Keep Windows' `PATH` out of WSL, so Linux tools never resolve to Windows binaries by accident (Windows tools
the config needs are linked into `~/.local/bin` below):

```ini
[boot]
systemd=true

[interop]
appendWindowsPath=false
```

Then, on Windows: `wsl --shutdown`, and open Fedora again.

## 3. Packages

```sh
sudo dnf install neovim git nodejs npm ripgrep fd-find tree-sitter-cli gcc make trash-cli zsh gawk unzip dotnet-sdk-10.0
sudo dnf copr enable atim/lazygit && sudo dnf install lazygit
```

`gawk` and `unzip` are only for the oh-my-posh installer (Fedora's WSL image has no `awk`). lazygit from
the COPR is 0.47 (old, but it works with the config).

npm global installs go to `~/.local` (no sudo):

```sh
mkdir -p ~/.local/bin
npm config set prefix ~/.local
npm i -g @fission-ai/openspec @johnnymorganz/stylua-bin @opencode/cli
```

oh-my-posh, with its themes in `~/.cache/oh-my-posh/themes` (the zsh profile uses `ys.omp.json` from
there):

```sh
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
```

## 4. Windows tools reached from WSL

With `appendWindowsPath=false`, these are links in `~/.local/bin`:

```sh
# Clipboard: "+/"* go to the Windows clipboard (needs Neovim installed on Windows)
ln -s "/mnt/c/Program Files/Neovim/bin/win32yank.exe" ~/.local/bin/
# VSCode's `code` command (Remote-WSL), see 9.
ln -s "/mnt/c/Users/<windows user>/AppData/Local/Programs/Microsoft VS Code/bin/code" ~/.local/bin/code
```

Opening URLs needs no link: the config calls `/mnt/c/Windows/explorer.exe` directly.

## 5. git

Use Windows' Credential Manager, so pushes to GitHub use the Windows login (needs Git for Windows):

```sh
git config --global user.name "<name>"
git config --global user.email "<email>"
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
git config --global core.autocrlf input
git config --global init.defaultBranch master
```

## 6. The config and the zsh profile

```sh
git clone https://github.com/Egglis/nvim-config.git ~/.config/nvim
ln -s ~/.config/nvim/shell/.zshrc ~/.zshrc
sudo usermod -s /usr/bin/zsh $USER
```

The login shell change applies to new WSL sessions (on Windows: `wsl --terminate FedoraLinux-45`).

## 7. First run and check

```sh
cd ~/.config/nvim
./gates.sh deps      # DEPS_EXIT:0
./gates.sh gates     # first run installs the plugins; GATES_EXIT:0
git status           # clean
```

The first start also builds the tree-sitter parsers in the background (a minute or so). If `git status`
shows `lazy-lock.json` changed (lazy.nvim's bootstrap clones its latest version), run
`nvim --headless "+Lazy! restore" +qa`, then `git checkout -- lazy-lock.json`.

## 8. opencode

Run `opencode`, then `/connect` to log in to the provider (once per platform; Windows has its own login).

## 9. Windows Terminal and VSCode (Windows)

- **Windows Terminal:** WSL adds a `FedoraLinux-45` profile. To make new tabs open Fedora: Settings →
  Startup → Default profile → FedoraLinux-45 (in `settings.json`: `defaultProfile` = that profile's
  `guid`, from `%LOCALAPPDATA%\Microsoft\Windows Terminal\Fragments\Microsoft.WSL\`).
- **VSCode:** `code --install-extension ms-vscode-remote.remote-wsl`. Then `code .` in a WSL folder opens it
  through Remote-WSL (the first run installs the VS Code Server in WSL).
