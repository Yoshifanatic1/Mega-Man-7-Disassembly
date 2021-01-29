@echo off
setlocal EnableDelayedExpansion

set PATH="../../Global"

asar.exe DumpUngodlyHugeAmountOfC7PointerTables.asm MM7.sfc > output1.asm

pause

asar.exe output1.asm MM7.sfc > TableData1.asm

pause

asar.exe DumpUngodlyHugeAmountOfC7ToCADataTables.asm MM7.sfc > output2.asm

pause

asar.exe output2.asm MM7.sfc > TableData2.asm

pause
exit