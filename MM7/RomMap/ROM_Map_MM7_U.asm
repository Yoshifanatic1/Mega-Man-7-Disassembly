
macro MM7_GameSpecificAssemblySettings()
	!ROM_MM7_U = $0001							;\ These defines assign each ROM version with a different bit so version difference checks will work. Do not touch them!
	!ROM_MM7_E = $0002							;|
	!ROM_MM7_J = $0004							;/

	%SetROMToAssembleForHack(MM7_U, !ROMID)
endmacro

macro MM7_LoadGameSpecificMainSNESFiles()
	incsrc ../Misc_Defines_MM7.asm
	incsrc ../RAM_Map_MM7.asm
	incsrc ../Routine_Macros_MM7.asm
	incsrc ../SNES_Macros_MM7.asm
endmacro

macro MM7_LoadGameSpecificMainSPC700Files()
	incsrc ../SPC700/ARAM_Map_MM7.asm
	incsrc ../Misc_Defines_MM7.asm
	incsrc ../SPC700/SPC700_Macros_MM7.asm
endmacro

macro MM7_LoadGameSpecificMainExtraHardwareFiles()
endmacro

macro MM7_LoadGameSpecificMSU1Files()
endmacro

macro MM7_GlobalAssemblySettings()
	!Define_Global_ApplyAsarPatches = !FALSE
	!Define_Global_InsertRATSTags = !TRUE
	!Define_Global_IgnoreCodeAlignments = !FALSE
	!Define_Global_IgnoreOriginalFreespace = !FALSE
	!Define_Global_CompatibleControllers = !Controller_StandardJoypad
	!Define_Global_DisableROMMirroring = !FALSE
	!Define_Global_CartridgeHeaderVersion = $02
	!Define_Global_FixIncorrectChecksumHack = !FALSE
	!Define_Global_ROMFrameworkVer = 1
	!Define_Global_ROMFrameworkSubVer = 0
	!Define_Global_ROMFrameworkSubSubVer = 1
	!Define_Global_AsarChecksum = $0000
	!Define_Global_LicenseeName = "Capcom"
	!Define_Global_DeveloperName = "Capcom"
	!Define_Global_ReleaseDate = "September 1995"
	!Define_Global_BaseROMMD5Hash = "301d8c4f1b5de2cd10b68686b17b281a"

	!Define_Global_MakerCode = "08"
	!Define_Global_GameCode = "A7RE"
	!Define_Global_ReservedSpace = $00,$00,$00,$00,$00,$00
	!Define_Global_ExpansionFlashSize = !ExpansionMemorySize_0KB
	!Define_Global_ExpansionRAMSize = !ExpansionMemorySize_0KB
	!Define_Global_IsSpecialVersion = $00
	!Define_Global_InternalName = "MEGAMAN 7            "
	!Define_Global_ROMLayout = !ROMLayout_HiROM_FastROM
	!Define_Global_ROMType = !ROMType_ROM
	!Define_Global_CustomChip = !Chip_None
	!Define_Global_ROMSize = !ROMSize_2MB
	!Define_Global_SRAMSize = !SRAMSize_0KB
	!Define_Global_Region = !Region_NorthAmerica
	!Define_Global_LicenseeID = $33
	!Define_Global_VersionNumber = $00
	!Define_Global_ChecksumCompliment = !Define_Global_Checksum^$FFFF
	!Define_Global_Checksum = $F199
	!UnusedNativeModeVector1 = $FFFF
	!UnusedNativeModeVector2 = $FFFF
	!NativeModeCOPVector = CODE_80FF94
	!NativeModeBRKVector = CODE_80FF94
	!NativeModeAbortVector = CODE_80FF94
	!NativeModeNMIVector = CODE_80FFA8
	!NativeModeResetVector = CODE_80FF94
	!NativeModeIRQVector = CODE_80FF90
	!UnusedEmulationModeVector1 = $FFFF
	!UnusedEmulationModeVector2 = $FFFF
	!EmulationModeCOPVector = CODE_80FF94
	!EmulationModeBRKVector = CODE_80FF94
	!EmulationModeAbortVector = CODE_80FF94
	!EmulationModeNMIVector = CODE_80FF94
	!EmulationModeResetVector = CODE_80FF98
	!EmulationModeIRQVector = CODE_80FF94
	%LoadExtraRAMFile("SRAM_Map_MM7.asm")
endmacro

macro MM7_LoadROMMap()
	%MM7BankC0Macros(!BANK_00, !BANK_00)
	%MM7BankC1Macros(!BANK_01, !BANK_01)
	%MM7BankC2Macros(!BANK_02, !BANK_02)
	%MM7BankC3Macros(!BANK_03, !BANK_03)
	%MM7BankC4Macros(!BANK_04, !BANK_04)
	%MM7BankC5Macros(!BANK_05, !BANK_05)
	%MM7BankC6Macros(!BANK_06, !BANK_06)
	%MM7BankC7Macros(!BANK_07, !BANK_07)
	%MM7BankC8Macros(!BANK_08, !BANK_08)
	%MM7BankC9Macros(!BANK_09, !BANK_09)
	%MM7BankCAMacros(!BANK_0A, !BANK_17)
	%MM7BankD8Macros(!BANK_18, !BANK_18)
	%MM7BankD9Macros(!BANK_19, !BANK_1F)
endmacro
