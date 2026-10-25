@echo off
setlocal

rem ------------------------------------------------------------------
rem  Remove / restore the shortcut arrow overlay on desktop icons.
rem  Usage:
rem    remove_shortcut_arrow.bat          -> remove the arrow
rem    remove_shortcut_arrow.bat restore  -> bring the arrow back
rem  Run by double-clicking (needs admin, so approve the UAC prompt).
rem ------------------------------------------------------------------

:: Re-launch as administrator if needed
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -ArgumentList '%~1' -Verb RunAs"
    exit /b
)

if /i "%~1"=="restore" goto restore

echo Creating a truly blank (transparent) icon...
powershell -NoProfile -Command "$b='AAABAAcAEBAAAAEAIABMAAAAdgAAABgYAAABACAAUwAAAMIAAAAgIAAAAQAgAFMAAAAVAQAAMDAAAAEAIABYAAAAaAEAAEBAAAABACAAYAAAAMABAACAgAAAAQAgAJAAAAAgAgAAAAAAAAEAIABOAQAAsAIAAIlQTkcNChoKAAAADUlIRFIAAAAQAAAAEAgGAAAAH/P/YQAAABNJREFUeJxjYBgFo2AUjAIGMAAABBAAAbGsecwAAAAASUVORK5CYIKJUE5HDQoaCgAAAA1JSERSAAAAGAAAABgIBgAAAOB3PfgAAAAaSURBVHic7dABDQAAAMKg90/t7AERKAAAPjAJGAAB6q7+pAAAAABJRU5ErkJggolQTkcNChoKAAAADUlIRFIAAAAgAAAAIAgGAAAAc3p69AAAABpJREFUeJztwQEBAAAAgiD/r25IQAEAAADvBhAgAAEZQzTuAAAAAElFTkSuQmCCiVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAAH0lEQVR4nO3BAQEAAACCIP+vbkhAAQAAAAAAAAAALwYkMAAB5ewAXAAAAABJRU5ErkJggolQTkcNChoKAAAADUlIRFIAAABAAAAAQAgGAAAAqmlx3gAAACdJREFUeJztwQENAAAAwqD3T20ON6AAAAAAAAAAAAAAAAAAAACAzg1AQAABDQc1jQAAAABJRU5ErkJggolQTkcNChoKAAAADUlIRFIAAACAAAAAgAgGAAAAwz5hywAAAFdJREFUeJztwTEBAAAAwqD1T20MH6AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACguwEAjwABTwRlHQAAAABJRU5ErkJggolQTkcNChoKAAAADUlIRFIAAAEAAAABAAgGAAAAXHKoZgAAARVJREFUeJztwTEBAAAAwqD1T+1rCKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOgMATwAAaPb0psAAAAASUVORK5CYII=';[IO.File]::WriteAllBytes($env:SystemRoot + '\blank.ico',[Convert]::FromBase64String($b))"

echo Removing the shortcut arrow...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /t REG_SZ /d "%SystemRoot%\blank.ico" /f
goto refresh

:restore
echo Restoring the shortcut arrow...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /f
del "%SystemRoot%\blank.ico" >nul 2>&1

:refresh
echo Clearing the icon cache and restarting Explorer...
taskkill /f /im explorer.exe >nul 2>&1
del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /q "%LocalAppData%\IconCache_*.db" >nul 2>&1
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
ie4uinit.exe -show
start explorer.exe

echo.
echo Done. If any icon still looks wrong, log off and on again.
pause
