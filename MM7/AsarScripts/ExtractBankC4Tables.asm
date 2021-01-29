@asar 1.81
; This will dump the data for an asar patch that will be applied to the USA MM7 ROM. Said patch will dump the hundreds of tables in bank C4 pointed to from $C40000 when applied to the ROM.
; The reason I'm generating a patch and not the tables directly is because of asar limitations. I don't think it's possible for asar to resolve commands through a define while in a print statement.
; Also, it may take a second before asar starts displaying anything on the command line. In addition, you'll need to replace the ' with " in the output patch, otherwise asar won't assemble the patch.

!Offset = $C40000
!EndOffset = $C4013C
!EndOffset2 = $C4678D

hirom

macro HandleVariableDefine(ID)
	!Output<ID> #= !Input3
endmacro

macro ClearDefines()
	!Output0 = ""
	!Output1 = ""
	!Output2 = ""
	!Output3 = ""
	!Output4 = ""
	!Output5 = ""
	!Output6 = ""
	!Output7 = ""
	!Output8 = ""
	!Output9 = ""
	!Output10 = ""
	!Output11 = ""
	!Output12 = ""
	!Output13 = ""
	!Output14 = ""
	!Output15 = ""
endmacro

macro HandleLineOfData(ID)
	if <ID> == 0
		!PrintData += "	db $',hex(!Output<ID>, 2)"
	else
		!PrintData += ",',$',hex(!Output<ID>, 2)"
	endif
endmacro

macro PrintVariableData(Data)
	print "print '<Data>"
endmacro

macro SortPointerTable(Offset, EndOffset, Index2, FinalValue, MinimumVal, DupePointerVar)
!LoopCounter3 #= $0000
!LoopCounter4 #= $0000
!HighestValue = $0000
!<DupePointerVar> = 0
!PrevLowestValue = <MinimumVal>
;print "<Offset>....<EndOffset>"
while <Offset>+!LoopCounter3 < <EndOffset>
	!DataValue #= read2(<Offset>+!LoopCounter3)
	if !DataValue > !HighestValue
		!HighestValue #= !DataValue
	endif
	!LoopCounter3 #= !LoopCounter3+2
endif
while !PrevLowestValue < !HighestValue
	!LoopCounter3 #= $0000
	!LowestValue #= $7FFFFF
	while <Offset>+!LoopCounter3 < <EndOffset>
		!DataValue #= read2(<Offset>+!LoopCounter3)
		if !DataValue > !PrevLowestValue
			if !DataValue < !LowestValue
				!LowestValue #= !DataValue
			elseif !DataValue == !LowestValue
				!<DupePointerVar> #= !<DupePointerVar>+2
			endif
		endif
		!LoopCounter3 #= !LoopCounter3+2
	endif
	%SetPointerDefine(!LowestValue, !LoopCounter4, <Index2>)
	!PrevLowestValue #= !LowestValue
	!LoopCounter4 #= !LoopCounter4+2
endif
%SetPointerDefine(<FinalValue>, !LoopCounter4, <Index2>)
endmacro

macro SetPointerDefine(Address, Index, Index2)
	;print "ROM_<Index>_<Index2> = ",hex(<Address>, 6)
	!ROM_<Index>_<Index2> #= <Address>+(!Offset&$FF0000)
endmacro

macro ReadPointerDefine(Var, Index, Index2)
	!<Var> #= !ROM_<Index>_<Index2>
endmacro

%SortPointerTable(!Offset, !EndOffset, 0, !EndOffset2&$00FFFF, $000000, DupePointerCount1)

!LoopCounter1 = 0
!LoopCounter2 = 0
!LoopCounter5 = 0
!TEMP1 = 0
!TEMP2 = 0
!TEMP3 = 0
!Input1 = 1
!Input2 = 1
print "hirom"

while !Offset+!LoopCounter2 < !EndOffset
	%ReadPointerDefine(TEMP1, !LoopCounter2, 0)
	!PointerStartOffset #= !TEMP1
	!TEMP2 #= !LoopCounter2+2
	%ReadPointerDefine(TEMP3, !TEMP2, 0)
	!PointerEndOffset #= !TEMP3
	!TEMP2 #= $FFFF
	!LoopCounter5 #= 0
	print "print 'DATA_',hex(!PointerStartOffset, 6),':'"
	while !TEMP2&$00FFFF != $0000
		!TEMP2 #= read2(!TEMP1+!LoopCounter5)+(!Offset&$FF0000)
		if !TEMP2&$00FFFF != $0000
			print "print 'dw DATA_',hex(!TEMP2, 6)"
			!LoopCounter5 #= !LoopCounter5+2
		endif
	endif
	print "print 'dw $0000'"
	print "print ''"
	!TEMP2 #= (!TEMP1+!LoopCounter5)
	!TEMP3 #= !PointerEndOffset&$00FFFF
	%SortPointerTable(!TEMP1, !TEMP2, 1, !TEMP3, $000000, DupePointerCount2)
	!LoopCounter1 #= 0
	!PointerEndOffset #= !TEMP2
	while !PointerStartOffset+!LoopCounter1+!DupePointerCount2 < !PointerEndOffset
		%ReadPointerDefine(Input1, !LoopCounter1, 1)
		!TEMP2 #= !LoopCounter1+2
		%ReadPointerDefine(Input2, !TEMP2, 1)
		%ClearDefines()
		!ByteCount = 0
		!RowByteCount = 0
		!PrintData = ""
		print "print 'DATA_',hex(!Input1, 6),':'"
		;print hex(!Input1, 6),"____",dec(!LoopCounter1)
		;print hex(!Input2, 6),"____",dec(!LoopCounter1+2)
		;if !Input1 > !Input2
			;print "Invalid inputs!"
			;!TEMP4 #= !Input1
			;!Input1 #= !Input2
			;!Input2 #= !TEMP4
		;endif
		while !Input2-(!ByteCount+!Input1) != $00
			;!Input3 = 0
			!Input3 = read1(!Input1+!ByteCount)
			%HandleVariableDefine(!RowByteCount)
			%HandleLineOfData(!RowByteCount)
			!ByteCount #= !ByteCount+1
			!RowByteCount #= !RowByteCount+1
			if !RowByteCount == 16
				%PrintVariableData("!PrintData")
				%ClearDefines()
				!PrintData = ""
				!RowByteCount #= $00
			endif
		endif
		if !RowByteCount != 0
			%PrintVariableData("!PrintData")
		endif
		!LoopCounter1 #= !LoopCounter1+2
		print "print ''"
	endif
	!LoopCounter2 #= !LoopCounter2+2
endif
