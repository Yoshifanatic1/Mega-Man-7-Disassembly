@echo off
setlocal EnableDelayedExpansion

set PATH="../../Global"

asar.exe ExtractBankC4Tables.asm MM7.sfc > output1.asm

pause

asar.exe output1.asm MM7.sfc > TableData1.asm

pause
exit