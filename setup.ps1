$working = "C:\Support\nightly"

mkdir $working
Invoke-WebRequest -Uri "https://github.com/nativeit/mine/archive/refs/heads/main.zip" -OutFile 'C:\Support\nightly\main.zip'

$mainzip = "C:\Support\nightly\main.zip"

Expand-Archive $mainzip -DestinationPath $working -Force
& "C:\Support\nightly\mine-main\init.ps1"