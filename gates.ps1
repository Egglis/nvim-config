# nvim config — gate targets. Usage: pwsh ./gates.ps1 <target> [<target> ...]
#
# Every gate prints its own exit code as `LABEL_EXIT:<n>` and exits with it, so a
# result can be quoted rather than inferred from output that may look clean.
# `gates` runs the whole set without stopping, so one run reports every failure.
[CmdletBinding()]
param([Parameter(Position = 0, ValueFromRemainingArguments = $true)][string[]]$Target = @('gates'))

$ErrorActionPreference = 'Continue'
Set-Location -LiteralPath $PSScriptRoot

# Runs a native command line, prints LABEL_EXIT:<n>, returns <n>.
function Invoke-Gate([string]$Label, [scriptblock]$Cmd) {
    $global:LASTEXITCODE = 0
    try { & $Cmd 2>&1 | Out-Host; $code = [int]$LASTEXITCODE }
    catch { Write-Host $_; $code = 1 }
    Write-Host "${Label}_EXIT:$code"
    return $code
}

function Get-Changes {
    if (-not (Test-Path openspec/changes)) { return @() }
    @(Get-ChildItem openspec/changes -Directory | Where-Object Name -ne 'archive' | ForEach-Object Name)
}

$targets = [ordered]@{
    # Starts Neovim headless with this config; any startup error fails the gate.
    'build'  = { Invoke-Gate 'BUILD'  { nvim --headless -u init.lua "+lua if vim.v.errmsg ~= '' then io.stderr:write(vim.v.errmsg .. '\n') vim.cmd('cquit 1') else vim.cmd('qall!') end" } }
    'format' = { Invoke-Gate 'FORMAT' { stylua --check --indent-type Spaces --indent-width 2 init.lua lua } }

    # Validates every active change. No active change is a failure, not a silent pass.
    'validate' = {
        $fail = 0
        $changes = Get-Changes
        if ($changes.Count -eq 0) { Write-Host 'no active change found under openspec/changes/'; $fail = 1 }
        else { foreach ($c in $changes) { openspec validate $c --strict 2>&1 | Out-Host; if ($LASTEXITCODE -ne 0) { $fail = 1 } } }
        Write-Host "VALIDATE_EXIT:$fail"; $fail
    }

    'changes' = { (Get-Changes) -join ' ' | Write-Host; 0 }

    # Every tool and login in docs/dependencies.md — keep the two in step. Not part of
    # `gates`: it checks the machine, not the code, and auth checks may need the network.
    'deps' = {
        $script:depFail = 0
        function Check([string]$Msg, [scriptblock]$Cmd) {
            $global:LASTEXITCODE = 0
            try { & $Cmd *> $null; $ok = $LASTEXITCODE -eq 0 } catch { $ok = $false }
            if (-not $ok) { Write-Host $Msg; $script:depFail = 1 }
        }
        Check 'MISSING nvim — winget install Neovim.Neovim' { nvim --version }
        Check 'MISSING stylua — winget install JohnnyMorganz.StyLua' { stylua --version }
        Check 'MISSING git — winget install Git.Git' { git --version }
        Check 'MISSING node — winget install OpenJS.NodeJS.LTS' { node --version }
        Check 'MISSING openspec — npm i -g @fission-ai/openspec' { openspec --version }
        Check 'MISSING pwsh — winget install Microsoft.PowerShell' { pwsh --version }
        Write-Host "DEPS_EXIT:$($script:depFail)"; $script:depFail
    }
}

$GateTargets = @('build', 'format', 'validate')

$overall = 0
foreach ($t in $Target) {
    if ($t -eq 'gates') {
        $code = 0
        foreach ($g in $GateTargets) { $r = & $targets[$g] | Select-Object -Last 1; if ($r -ne 0) { $code = 1 } }
        Write-Host "GATES_EXIT:$code"
    }
    elseif ($targets.Contains($t)) { $code = & $targets[$t] | Select-Object -Last 1 }
    else { Write-Host "unknown target '$t'. Known: $(@($targets.Keys) + 'gates' -join ', ')"; $code = 2 }
    if ($code -ne 0) { $overall = $code }
}
exit $overall
