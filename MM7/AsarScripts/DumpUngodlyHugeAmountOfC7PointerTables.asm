@asar 1.81
; This will dump the data for an asar patch that will be applied to the USA MM7 ROM. Said patch will dump the hundreds of tables in bank C7 pointed to from $C73600 when applied to the ROM.
; The reason I'm generating a patch and not the tables directly is because of asar limitations. I don't think it's possible for asar to resolve commands through a define while in a print statement.
; Also, it may take a second before asar starts displaying anything on the command line. In addition, you'll need to replace the ' with " in the output patch, otherwise asar won't assemble the patch.

!Offset = $C73600
!EndOffset = $C7373C

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
		!PrintData += "	dl DATA_',hex(!Output<ID>, 6)"
	else
		!PrintData += ",',DATA_',hex(!Output<ID>, 6)"
	endif
endmacro

macro PrintVariableData(Data)
	print "print '<Data>"
endmacro

!SkipBytes = 0
!LoopCounter1 = 0
print "hirom"

while !Offset+!LoopCounter1 < !EndOffset
	!Input1 = read2(!Offset+!LoopCounter1)+(!Offset&$FF0000)
	!Input2 = read2(!Offset+!LoopCounter1+$02+!SkipBytes)+(!Offset&$FF0000)
	%ClearDefines()
	!ByteCount = 0
	!RowByteCount = 0
	!PrintData = ""
	if !Input2 > !Input1
		print "print 'DATA_',hex(!Input1),':'"
		while !Input2-(!ByteCount+!Input1) != $00
			!Input3 = read3(!Input1+!ByteCount)
			%HandleVariableDefine(!RowByteCount)
			%HandleLineOfData(!RowByteCount)
			!ByteCount #= !ByteCount+3
			!RowByteCount #= !RowByteCount+1
			if !RowByteCount == 8
				%PrintVariableData("!PrintData")
				%ClearDefines()
				!PrintData = ""
				!RowByteCount #= $00
			endif
		endif
		if !RowByteCount != 0
			%PrintVariableData("!PrintData")
		endif
		!LoopCounter1 #= !LoopCounter1+2+!SkipBytes
		!SkipBytes #= 0
		print "print ''"
	else
		!SkipBytes #= !SkipBytes+2
	endif
endif
