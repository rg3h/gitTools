:: @fileoverfiew gt.bat windows batch file that runs the linux bash gt.sh
:: This script runs gitTools (gt) commands like gt addRepo and gt ls
:: For example: gt ls   <--- lists your github repositories
:: For example: gt add newRepo -public   <-- adds "newRepo" to your github
@echo off
setlocal
SET scriptPath=%~dp0
call bash %scriptPath%\gt.sh %*
endlocal
