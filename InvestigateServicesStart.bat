@echo off
setlocal enabledelayedexpansion

SET /A num=1

:Next
IF %num% EQU 1 (
	SET service="Nuix-Config"
	GOTO ResolveInitialState
)
IF %num% EQU 2 (
	SET service="Nuix-MariaDB"
	GOTO ResolveInitialState
)
IF %num% == 3 (
	SET service="Nuix-UMS"
	GOTO ResolveInitialState
)
IF %num% == 4 (
	SET service="Nuix-REST"
	GOTO ResolveInitialState
)
IF %num% == 5 (
	SET service="Nuix-MMS"
	GOTO ResolveInitialState
)
IF %num% == 6 (
	SET service="Nuix Web Review"
	GOTO ResolveInitialState
) ELSE (
	GOTO:eof
)

:ResolveInitialState
SC query %service% | FIND "STATE" | FIND "STOPPED" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO StartService
SC query %service% | FIND "STATE" | FIND "RUNNING" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO StartedService
SC query %service% | FIND "STATE" | FIND "PAUSED" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceUnavailable
SC query %service% | FIND "FAILED" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceUnavailable
SC query %service% | FIND "ServiceUnavailable" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceUnavailable
echo Service State is changing, waiting for service to resolve its state before making changes
SC query %service% | Find "STATE"
timeout /t 1 /nobreak >NUL
GOTO ResolveInitialState

:StartService
<nul set /p=Starting !service!
SC start %service% >NUL
GOTO StartingService

:StartingServiceDelay
<nul set /p=.
timeout /t 1 /nobreak >NUL

:StartingService
SC query !service! | FIND "STATE" | FIND "RUNNING" >NUL
IF errorlevel 1 GOTO StartingServiceDelay
echo.

:StartedService
echo !service! is started
SET /A num+=1
GOTO Next

:ServiceUnavailable
echo !service! is not available
SET /A num+=1
GOTO Next