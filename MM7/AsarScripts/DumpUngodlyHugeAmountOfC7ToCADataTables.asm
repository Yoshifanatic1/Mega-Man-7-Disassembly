@asar 1.81
; This will dump the data for an asar patch that will be applied to the USA MM7 ROM. Said patch will dump the hundreds of tables in bank C7-CA pointed to from $C7373C-$C7660A when applied to the ROM.
; The reason I'm generating a patch and not the tables directly is because of asar limitations. I don't think it's possible for asar to resolve commands through a define while in a print statement.
; Also, it may take a second before asar starts displaying anything on the command line. In addition, you'll need to replace the ' with " in the output patch, otherwise asar won't assemble the patch.
; This patch may take a while to take effect. Be patient.
; Lastly, the last pointer's data must be extracted manually.

!Offset = $C7373C
!EndOffset = $C76607

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

!SkipBytes = 0
!LoopCounter1 = 0
print "hirom"

while !Offset+!LoopCounter1 < !EndOffset
	!Input1 = read3(!Offset+!LoopCounter1)
	!Input2 = read3(!Offset+!LoopCounter1+$03+!SkipBytes)
	%ClearDefines()
	!ByteCount = 0
	!RowByteCount = 0
	!PrintData = ""
	if !Input2 > !Input1
		print "print 'DATA_',hex(!Input1),':'"
		while !Input2-(!ByteCount+!Input1) != $00
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
		!LoopCounter1 #= !LoopCounter1+3+!SkipBytes
		!SkipBytes #= 0
		print "print ''"
	else
		!SkipBytes #= !SkipBytes+3
	endif
endif
