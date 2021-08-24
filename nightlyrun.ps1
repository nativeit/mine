# Setup scheduled task to run xmrig each night
$scriptpath = $MyInvocation.MyCommand.Path
$homedir = Split-Path $scriptpath
$ProgramDir = $homedir + '\xmrig'
$ProgramExe = $ProgramDir + '\xmrig.exe'

# Add exception to Windows Defender
Add-MpPreference -ExclusionPath $homedir

# Setup schedule to start xmrig daily at 11pm

$action = New-ScheduledTaskAction -Execute $ProgramExe -Argument '-NoProfile -WindowStyle Hidden'

$trigger = New-ScheduledTaskTrigger -Daily -At 11pm

Register-ScheduledTask -Action $action -Trigger $trigger -RunLevel Highest -TaskName "Start xmrig" -Description "Start xmrig"


# Setup schedule to stop xmrig daily at 7am

$stopAction = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -command "taskkill /im xmrig.exe /f"'

$stopTrigger =  New-ScheduledTaskTrigger -Daily -At 7am

Register-ScheduledTask -Action $stopAction -Trigger $stopTrigger -RunLevel Highest -TaskName "Stop xmrig" -Description "Stop xmrig"
