@echo off
                           
curl -Lo winget.msixbundle https://github.com/microsoft/winget-cli/releases/download/v1.6.3482/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
winget.msixbundle
del winget.msixbundle
winget install -e --id RubyInstallerTeam.Ruby.3.2 --accept-source-agreements --accept-package-agreements
SET PATH=C:\Ruby32-x64\bin;%PATH%

if defined CI (
  ruby -v
  ruby bin/bootstrap/redo
  ruby test/bootstrap/windows_test.rb
) else (
  ruby "%USERPROFILE%/dotfiles/bin/bootstrap/redo"
)
