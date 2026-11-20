# Merges the Neovim-related actions and key bindings in neovim.json into Windows Terminal's settings.json.
# Safe to run again: entries with the same action id, or a binding on the same keys, are replaced.
# The old settings.json is kept as settings.json.bak.
param([string]$SettingsPath)

$ErrorActionPreference = "Stop"

if (-not $SettingsPath) {
  $SettingsPath = @(
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json",
    "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
  ) | Where-Object { Test-Path $_ } | Select-Object -First 1
}
if (-not $SettingsPath -or -not (Test-Path $SettingsPath)) {
  throw "Windows Terminal settings.json not found; start Windows Terminal once, or pass -SettingsPath"
}

$ours = Get-Content (Join-Path $PSScriptRoot "neovim.json") -Raw | ConvertFrom-Json
$settings = Get-Content $SettingsPath -Raw | ConvertFrom-Json

$actionIds = $ours.actions | ForEach-Object { $_.id }
$keys = $ours.keybindings | ForEach-Object { $_.keys }
$actions = @($settings.actions | Where-Object { $_.id -notin $actionIds }) + $ours.actions
$bindings = @($settings.keybindings | Where-Object { $_.keys -notin $keys }) + $ours.keybindings

$settings | Add-Member -Force -NotePropertyName actions -NotePropertyValue $actions
$settings | Add-Member -Force -NotePropertyName keybindings -NotePropertyValue $bindings

Copy-Item $SettingsPath "$SettingsPath.bak" -Force
[IO.File]::WriteAllText($SettingsPath, ($settings | ConvertTo-Json -Depth 100), [Text.UTF8Encoding]::new($false))
Write-Host "Updated $SettingsPath (backup: $SettingsPath.bak)"
