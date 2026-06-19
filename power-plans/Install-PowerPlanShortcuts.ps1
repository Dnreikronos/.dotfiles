param(
    [string]$Desktop = (Join-Path $env:USERPROFILE 'OneDrive\Desktop')
)

$ErrorActionPreference = 'Stop'

$scriptPath = Join-Path $PSScriptRoot 'Switch-PowerPlan.ps1'
if (-not (Test-Path -LiteralPath $scriptPath)) {
    throw "Missing launcher script: $scriptPath"
}

$powershell = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'
$shortcuts = @(
    @{
        Name = 'Power - Balanced.lnk'
        Plan = 'Balanced'
        Description = 'Switch to Balanced power plan'
    }
    @{
        Name = 'Power - Best Performance.lnk'
        Plan = 'BestPerformance'
        Description = 'Switch to Best Performance power plan'
    }
    @{
        Name = 'Power - Ultimate Performance.lnk'
        Plan = 'UltimatePerformance'
        Description = 'Switch to Ultimate Performance power plan'
    }
)

$shell = New-Object -ComObject WScript.Shell

foreach ($item in $shortcuts) {
    $path = Join-Path $Desktop $item.Name
    $shortcut = $shell.CreateShortcut($path)
    $shortcut.TargetPath = $powershell
    $shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`" -Plan $($item.Plan)"
    $shortcut.WorkingDirectory = $PSScriptRoot
    $shortcut.Description = $item.Description
    $shortcut.Save()
}
