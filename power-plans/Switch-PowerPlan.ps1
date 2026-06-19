param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('Balanced', 'BestPerformance', 'UltimatePerformance')]
    [string]$Plan
)

$ErrorActionPreference = 'Stop'

$plans = @{
    Balanced = @{
        Name = 'Balanced'
        DesiredGuid = '381b4222-f694-41f0-9685-ff5bb260df2e'
        TemplateGuid = '381b4222-f694-41f0-9685-ff5bb260df2e'
        CanRecreate = $false
    }
    BestPerformance = @{
        Name = 'Best Performance'
        DesiredGuid = '706ba7b4-dc87-4f1b-84af-7e08b2cbc699'
        TemplateGuid = '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
        CanRecreate = $true
    }
    UltimatePerformance = @{
        Name = 'Ultimate Performance'
        DesiredGuid = 'a142273c-70db-42f0-a28c-38f277b304a6'
        TemplateGuid = 'e9a42b02-d5df-448d-aa00-03f14749eb61'
        CanRecreate = $true
    }
}

function Test-PowerScheme {
    param([Parameter(Mandatory = $true)][string]$Guid)

    & cmd.exe /d /c "powercfg.exe /query $Guid >NUL 2>NUL"
    return $LASTEXITCODE -eq 0
}

function Invoke-PowerCfg {
    param(
        [Parameter(Mandatory = $true)][string[]]$Arguments,
        [Parameter(Mandatory = $true)][string]$FailureMessage
    )

    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $output = & powercfg.exe @Arguments 2>&1 | Out-String
    }
    finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }

    if ($LASTEXITCODE -ne 0) {
        throw "$FailureMessage`n$output"
    }

    return $output
}

$target = $plans[$Plan]
$guid = $target.DesiredGuid

if (-not (Test-PowerScheme -Guid $guid)) {
    if (-not $target.CanRecreate) {
        throw "Power scheme '$($target.Name)' ($guid) is missing and this launcher will not restore default schemes automatically."
    }

    Invoke-PowerCfg `
        -Arguments @('/duplicatescheme', $target.TemplateGuid, $guid) `
        -FailureMessage "Failed to recreate '$($target.Name)' from template $($target.TemplateGuid)." | Out-Null
}

Invoke-PowerCfg `
    -Arguments @('/changename', $guid, $target.Name) `
    -FailureMessage "Failed to name power scheme '$($target.Name)'." | Out-Null

Invoke-PowerCfg `
    -Arguments @('/setactive', $guid) `
    -FailureMessage "Failed to activate power scheme '$($target.Name)'." | Out-Null
