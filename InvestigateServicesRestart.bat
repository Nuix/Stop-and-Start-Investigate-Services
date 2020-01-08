@echo off
setlocal enabledelayedexpansion

:Stopping
SET PROCESS=Stopping
SET /A num=1
GOTO Next

:Starting
echo=
SET PROCESS=Starting
SET /A num=1
GOTO Next


:: COMMON METHODS
:Next
IF %num% EQU 1 (
	SET service="Nuix-Config"
	GOTO ResolveInitialState%PROCESS%
)
IF %num% EQU 2 (
	SET service="Nuix-MariaDB"
	GOTO ResolveInitialState%PROCESS%
)
IF %num% == 3 (
	SET service="Nuix-UMS"
	GOTO ResolveInitialState%PROCESS%
)
IF %num% == 4 (
	SET service="Nuix-REST"
	GOTO ResolveInitialState%PROCESS%
)
IF %num% == 5 (
	SET service="Nuix-MMS"
	GOTO ResolveInitialState%PROCESS%
)
IF %num% == 6 (
	SET service="Nuix Web Review"
	GOTO ResolveInitialState%PROCESS%
) ELSE (
	IF "%PROCESS%" == "Stopping" (
		GOTO Starting
	) ELSE (
		GOTO:eof
	)
)

:Delay
<nul set /p=.
timeout /t 1 /nobreak >NUL
GOTO Service%PROCESS%

:ServiceUnavailable
echo !service! is not available  >> "%DIR%\backup.log"
SET /A num+=1
GOTO Next

:: STOPPING
:ResolveInitialStateStopping
SC query %service% | FIND "STATE" | FIND "RUNNING" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceStop
SC query %service% | FIND "STATE" | FIND "STOPPED" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceStopped
SC query %service% | FIND "STATE" | FIND "PAUSED" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceUnavailable
SC query %service% | FIND "FAILED" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceUnavailable
SC query %service% | FIND "ServiceUnavailable" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceUnavailable
SC query %service% | FIND "not available" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceUnavailable
echo Service State is changing, waiting for service to resolve its state before making changes
SC query %service% | Find "STATE"
timeout /t 1 /nobreak >NUL
GOTO ResolveInitialState-Stopping

:ServiceStop
<nul set /p=Stopping !service!
SC stop %service% >NUL
GOTO ServiceStopping

:ServiceStopping
SC query %service% | FIND "STATE" | FIND "STOPPED" >NUL
IF errorlevel 1 GOTO Delay
echo.

:ServiceStopped
echo !service! is stopped  >> "%DIR%\backup.log"
SET /A num+=1
GOTO Next

:: STARTING
:ResolveInitialStateStarting
SC query %service% | FIND "STATE" | FIND "STOPPED" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceStart
SC query %service% | FIND "STATE" | FIND "RUNNING" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceStarted
SC query %service% | FIND "STATE" | FIND "PAUSED" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceUnavailable
SC query %service% | FIND "FAILED" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceUnavailable
SC query %service% | FIND "ServiceUnavailable" >NUL
IF errorlevel 0 IF NOT errorlevel 1 GOTO ServiceUnavailable
echo Service State is changing, waiting for service to resolve its state before making changes
SC query %service% | Find "STATE"
timeout /t 1 /nobreak >NUL
GOTO ResolveInitialState-Starting

:ServiceStart
<nul set /p=Starting !service!
SC start %service% >NUL
GOTO ServiceStarting

:ServiceStarting
SC query !service! | FIND "STATE" | FIND "RUNNING" >NUL
IF errorlevel 1 GOTO Delay
echo.

:ServiceStarted
echo !service! is started  >> "%DIR%\backup.log"
SET /A num+=1
GOTO Next