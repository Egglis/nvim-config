<# Powershell Profile #>
<# File is ran on startup #>

<# Theme #>
oh-my-posh --init --shell pwsh --config ~/AppData/Local/Programs/oh-my-posh/themes/tokyonight_storm.omp.json | Invoke-Expression

<# Windows Powershell Aliases  #>
Function goto-nvimconfig {Set-Location -Path ~/AppData/Local/nvim}
Set-Alias -Name nconfig -Value goto-nvimconfig

Function saveto-git-repo {cp ~/Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 ~/AppData/Local/nvim/powershell}
Set-Alias -Name sprofile saveto-git-repo

clear
