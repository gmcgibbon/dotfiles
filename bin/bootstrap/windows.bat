@echo off

curl -Lo winget.appxbundle https://github.com/microsoft/winget-cli/releases/download/v0.1.4331-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle
winget.appxbundle
del winget.appxbundle
winget install -e Ruby

ruby bin/bootstrap/redo
