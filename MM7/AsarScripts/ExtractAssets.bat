@echo off

set PATH="../../Global"
set Input1=
set ROMName=MM7.sfc
set MemMap=hirom

setlocal EnableDelayedExpansion

echo To fully extract all files for supported ROMs, you'll need one of the following ROMs in each group:
echo - Graphics: (USA)
echo - Level Data: (USA)
echo - Tilemaps: (USA)
echo - Map16/Map32: (USA)
echo - Samples: (USA)
echo - Music: (USA)
echo.

:Start
echo Place a headerless MM7 ROM named %ROMName% in this folder, then type the number representing what version %ROMName% is.
echo 0 = MM7 (USA)
echo 1 = MM7 (PAL)
echo 2 = MM7 (Japan)

:Mode
set /p Input1=""
if exist %ROMName% goto :ROMExists

echo You need to place a MM7 ROM named %ROMName% in this folder before you can extract any assets^^!
goto :Mode

:ROMExists
if "%Input1%" equ "0" goto :USA
if "%Input1%" equ "1" goto :PAL
if "%Input1%" equ "2" goto :Japan

echo %Input1% is not a valid mode.
goto :Mode

:USA
set UGFXLoc="../Graphics"
set CGFXLoc="../Graphics/Compressed"
set Map16Loc="../Tilemaps/Map16"
set Map32Loc="../Tilemaps/Map32"
set TileBehaveLoc="../Tilemaps/Map16/TileBehaviorData"
set TilemapLoc="../Tilemaps"
set LevelDatLoc="../LevelData"
set SPCDatLoc="../SPC700"
set ROMBit=$0001
goto :BeginExtract

:PAL
echo The PAL ROM is not supported by the disassembly
goto :Mode
set UGFXLoc="../Graphics"
set CGFXLoc="../Graphics/Compressed"
set Map16Loc="../Tilemaps/Map16"
set Map32Loc="../Tilemaps/Map32"
set TileBehaveLoc="../Tilemaps/Map16/TileBehaviorData"
set TilemapLoc="../Tilemaps"
set LevelDatLoc="../LevelData"
set SPCDatLoc="../SPC700"
set ROMBit=$0002
goto :BeginExtract

:Japan
echo The Japanese ROM is not supported by the disassembly
goto :Mode
set UGFXLoc="../Graphics"
set CGFXLoc="../Graphics/Compressed"
set Map16Loc="../Tilemaps/Map16"
set Map32Loc="../Tilemaps/Map32"
set TileBehaveLoc="../Tilemaps/Map16/TileBehaviorData"
set TilemapLoc="../Tilemaps"
set LevelDatLoc="../LevelData"
set SPCDatLoc="../SPC700"
set ROMBit=$0004
goto :BeginExtract

:BeginExtract
set i=0
set PointerSet=0

echo Generating temporary ROM
asar --fix-checksum=off --no-title-check --define ROMVer="%ROMBit%" "AssetPointersAndFiles.asm" TEMP.sfc

CALL :GetLoopIndex
set MaxFileTypes=%Length%
set PointerSet=6

:GetNewLoopIndex
CALL :GetLoopIndex

:ExtractLoop
if %i% equ %Length% goto :NewFileType

CALL :GetGFXFileName
CALL :ExtractFile
set /a i = %i%+1
if exist TEMP1.asm del TEMP1.asm
if exist TEMP2.asm del TEMP2.asm
if exist TEMP3.txt del TEMP3.txt
goto :ExtractLoop

:NewFileType
echo Moving extracted files to appropriate locations
if %PointerSet% equ 6 goto :MoveUGFX
if %PointerSet% equ 12 goto :MoveCGFX
if %PointerSet% equ 18 goto :MoveMap16
if %PointerSet% equ 24 goto :MoveMap32
if %PointerSet% equ 30 goto :MoveTileBehavior
if %PointerSet% equ 36 goto :MoveTilemaps
if %PointerSet% equ 42 goto :MoveLevelData
if %PointerSet% equ 48 goto :MoveSPCData
goto :MoveNothing

:MoveUGFX
move "*.bin" %UGFXLoc%
goto :MoveNothing

:MoveCGFX
move "*.bin" %CGFXLoc%
goto :MoveNothing

:MoveMap16
move "*.bin" %Map16Loc%
goto :MoveNothing

:MoveMap32
move "*.bin" %Map32Loc%
goto :MoveNothing

:MoveTileBehavior
move "*.bin" %TileBehaveLoc%
goto :MoveNothing

:MoveTilemaps
move "*.bin" %TilemapLoc%
goto :MoveNothing

:MoveLevelData
move "*.bin" %LevelDatLoc%
goto :MoveNothing

:MoveSPCData
move "*.bin" %SPCDatLoc%
goto :MoveNothing

:MoveNothing
set i=0
set /a PointerSet = %PointerSet%+6
if %PointerSet% neq %MaxFileTypes% goto :GetNewLoopIndex
if exist TEMP.sfc del TEMP.sfc

echo Done^^!
goto :Start

EXIT /B %ERRORLEVEL% 

:ExtractFile
echo:%MemMap% >> TEMP1.asm
echo:org $C00000 >> TEMP1.asm
echo:check bankcross off >> TEMP1.asm
echo:^^!OffsetStart #= snestopc(readfile3("TEMP.sfc", snestopc(readfile3("TEMP.sfc", snestopc($C00000+%PointerSet%))+$00+(%i%*$0C)))) >> TEMP1.asm
echo:^^!OffsetEnd #= snestopc(readfile3("TEMP.sfc", snestopc(readfile3("TEMP.sfc", snestopc($C00000+%PointerSet%))+$03+(%i%*$0C)))) >> TEMP1.asm
echo:incbin %ROMName%:(^^!OffsetStart)-(^^!OffsetEnd) >> TEMP1.asm

echo Extracting %FileName%
asar --fix-checksum=off --no-title-check "TEMP1.asm" %FileName%
EXIT /B 0

:GetGFXFileName
echo:%MemMap% >> TEMP2.asm
echo:org $C00000 >> TEMP2.asm
echo:^^!FileNameStart #= snestopc(readfile3("TEMP.sfc", snestopc(readfile3("TEMP.sfc", snestopc($C00000+%PointerSet%))+$06+(%i%*$0C)))) >> TEMP2.asm
echo:^^!FileNameEnd #= snestopc(readfile3("TEMP.sfc", snestopc(readfile3("TEMP.sfc", snestopc($C00000+%PointerSet%))+$09+(%i%*$0C)))) >> TEMP2.asm
echo:incbin TEMP.sfc:(^^!FileNameStart)-(^^!FileNameEnd) >> TEMP2.asm
asar --fix-checksum=off --no-title-check "TEMP2.asm" TEMP3.txt

for /f "delims=" %%x in (TEMP3.txt) do set FileName=%%x

EXIT /B 0

:GetLoopIndex
echo:%MemMap% >> TEMP4.asm
echo:org $C00000 >> TEMP4.asm
echo:^^!OnesDigit = 0 >> TEMP4.asm
echo:^^!TensDigit = 0 >> TEMP4.asm
echo:^^!HundredsDigit = 0 >> TEMP4.asm
echo:^^!ThousandsDigit = 0 >> TEMP4.asm
echo:^^!TensDigitSet = 0 >> TEMP4.asm
echo:^^!HundredsDigitSet = 0 >> TEMP4.asm
echo:^^!ThousandsDigitSet = 0 >> TEMP4.asm
echo:^^!Offset #= readfile3("TEMP.sfc", snestopc($C00000+%PointerSet%+$03)) >> TEMP4.asm
echo:while ^^!Offset ^> 0 >> TEMP4.asm
::echo:print hex(^^!Offset) >> TEMP4.asm
echo:^^!OnesDigit #= ^^!OnesDigit+1 >> TEMP4.asm
echo:if ^^!OnesDigit == 10 >> TEMP4.asm
echo:^^!OnesDigit #= 0 >> TEMP4.asm
echo:^^!TensDigit #= ^^!TensDigit+1 >> TEMP4.asm
echo:^^!TensDigitSet #= 1 >> TEMP4.asm
echo:endif >> TEMP4.asm
echo:if ^^!TensDigit == 10 >> TEMP4.asm
echo:^^!TensDigit #= 0 >> TEMP4.asm
echo:^^!HundredsDigit #= ^^!HundredsDigit+1 >> TEMP4.asm
echo:^^!HundredsDigitSet #= 1 >> TEMP4.asm
echo:endif >> TEMP4.asm
echo:if ^^!HundredsDigit == 10 >> TEMP4.asm
echo:^^!HundredsDigit #= 0 >> TEMP4.asm
echo:^^!ThousandsDigit #= ^^!ThousandsDigit+1 >> TEMP4.asm
echo:^^!ThousandsDigitSet #= 1 >> TEMP4.asm
echo:endif >> TEMP4.asm
echo:^^!Offset #= ^^!Offset-1 >> TEMP4.asm
echo:endif >> TEMP4.asm
echo:if ^^!ThousandsDigitSet == 1 >> TEMP4.asm
echo:db ^^!ThousandsDigit+$30 >> TEMP4.asm
echo:endif >> TEMP4.asm
echo:if ^^!HundredsDigitSet == 1 >> TEMP4.asm
echo:db ^^!HundredsDigit+$30 >> TEMP4.asm
echo:endif >> TEMP4.asm
echo:if ^^!TensDigitSet == 1 >> TEMP4.asm
echo:db ^^!TensDigit+$30 >> TEMP4.asm
echo:endif >> TEMP4.asm
echo:db ^^!OnesDigit+$30 >> TEMP4.asm
asar --fix-checksum=off --no-title-check "TEMP4.asm" TEMP5.txt

for /f "delims=" %%x in (TEMP5.txt) do set Length=%%x

if exist TEMP4.asm del TEMP4.asm
if exist TEMP5.txt del TEMP5.txt

EXIT /B 0
