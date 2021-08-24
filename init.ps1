$scriptpath = $MyInvocation.MyCommand.Path
$homedir = Split-Path $scriptpath

$InputFilePath = $homedir + '\data.json'
$OutputFilePath = $homedir + '\config.json'
$nodename = $env:COMPUTERNAME

$JsonData = Get-Content -Raw -Path $InputFilePath | ConvertFrom-Json
$JsonData.pools | ForEach{$_.pass += $nodename}
$JsonData | ConvertTo-Json -Depth 4  | set-content $OutputFilePath

$Timeout = 60
$timer = [Diagnostics.Stopwatch]::StartNew()
while (-not (Test-Path -Path $OutputFilePath -PathType Leaf)) {
    Write-Verbose -Message "Still waiting for action to complete after [$totalSecs] seconds..."
}
$timer.Stop()

& "$PSScriptRoot\dl-latest.ps1"