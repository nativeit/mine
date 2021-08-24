# Download latest xmrig release from github
$scriptpath = $MyInvocation.MyCommand.Path
$homedir = Split-Path $scriptpath

$pathExtract = $homedir
$ConfigFile = $homedir + '\config.json'

$repo = "xmrig/xmrig"
$file = "xmrig"
$releases = "https://api.github.com/repos/$repo/releases"
Push-Location $homedir

Write-Host Determining latest release
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$tag = (Invoke-WebRequest -Uri $releases -UseBasicParsing | ConvertFrom-Json)[0].tag_name
$version = $tag -replace'[v]',''
$filenamePattern = "xmrig-" + $version + "-msvc-win64.zip"

$dlurl = ((Invoke-WebRequest -Uri $releases -UseBasicParsing | ConvertFrom-Json)[0].assets | Where-Object name -like $filenamePattern ).browser_download_url

$zip = $homedir + '\xmrig.zip'

Write-Host Dowloading latest release

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest $dlurl -Out $zip

Add-MpPreference -ExclusionPath $homedir

Write-Host Extracting release files
Expand-Archive $zip -DestinationPath $pathExtract -Force

# Removing temp files
Remove-Item $zip -Force

$ProgramDir = $homedir + '\xmrig-' + $version
$ConfigTarget = $ProgramDir + '\config.json'

copy $ConfigFile $ConfigTarget

Rename-Item $ProgramDir xmrig

& "$PSScriptRoot\nightlyrun.ps1"