# oh-my-posh themes path (3.1), and gawk

<!-- Section: 3 · Task: 3.1 · Base: ec91e72 -->

- **Themes dir (design Open Question): `~/.cache/oh-my-posh/themes`** (the installer's default,
  `${cache_dir}/themes`; `ys.omp.json` is there, 125 themes). `.zshrc` uses
  `~/.cache/oh-my-posh/themes/ys.omp.json`.
- The user's own oh-my-posh 32.0.0 came without themes; their `~/.bashrc` loads `ys` from the GitHub raw URL.
- **The installer needs `awk`**, which the Fedora 45 WSL image doesn't have (`awk: command not found` →
  "amd64 builds for  are not available", rc 1). User's call: install `gawk` and rerun the installer
  (rejected: remote theme URL, fetching only `ys.omp.json`). `sudo -n dnf install -y gawk` worked
  (passwordless sudo in this distro). gawk is not a separate deps row: it's only for the installer, so
  it's in the oh-my-posh row's Fedora install command (`sudo dnf install gawk unzip`, then the curl) and
  the matching `MISSING` hint in `gates.sh`. `docs/wsl.md` (4.1) must include it.
- Verified in WSL: installer rc 0, `oh-my-posh --version` → 32.0.0, `ls ~/.cache/oh-my-posh/themes/ys.omp.json`
  OK, `./gates.sh deps` → `DEPS_EXIT:0`.

## Next

- Task 3.2: `shell/.zshrc` per D7 with the theme at `~/.cache/oh-my-posh/themes/ys.omp.json`, then 3.3 docs.
