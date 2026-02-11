;Linker addition dep
;kernel32.lib
;ucrt.lib
;vcruntime.lib
;msvcrt.lib
;legacy_stdio_definitions.lib

ExitProcess proto
CreateFileA proto
ReadFile  proto
SetFilePointer proto
VirtualAlloc proto
extrn printf:proc

.data
;Strings
    msg_32bit db "**FILE IS 32 BIT**", 10, 0
    msg_64bit db "**FILE IS 64 BIT**", 10, 0
	msg_fail db "**FAIL**", 10, 0
	path db "./sample.exe", 0
; DOS header
	msg_dosheader db "1. DOS HEADER:", 10, 0
	msg_dosheader_magic db 9, "Magic: 0x%X", 10, 0
	msg_dosheader_e_lfanew db 9, "File address of new exe header: 0x%X", 10, 0

; NT header
	msg_ntheader db "2. NT HEADER:", 10, 0
	msg_fileheader db 9, "- File Header:", 10, 0
	msg_fileheader_signature db 9, 9, "PE Signature: 0x%X", 10, 0
    msg_fileheader_machine db 9, 9, "Machine: 0x%X", 10, 0
    msg_fileheader_numberofsections db 9, 9, "NumberOfSections: 0x%X", 10, 0
    msg_fileheader_sizeofoptionalheader db 9, 9, "SizeOfOptionalHeader: 0x%X", 10, 0
    msg_fileheader_characteristics db 9, 9, "Characteristics: 0x%X", 10, 0
	msg_optionalheader db 9, "- Optional Header:", 10, 0
	msg_optionalheader_magic db 9, 9, "Magic: 0x%X", 10, 0
	msg_optionalheader_sizeofcode db 9, 9, "SizeOfCode: 0x%X", 10, 0
	msg_optionalheader_sizeofinitializeddata db 9, 9, "SizeOfInitializedData: 0x%X", 10, 0
	msg_optionalheader_sizeofuninitializeddata db 9, 9, "SizeOfUninitializedData: 0x%X", 10, 0
	msg_optionalheader_addressofentrypoint db 9, 9, "AddressOfEntryPoint: 0x%X", 10, 0
	msg_optionalheader_baseofcode db 9, 9, "BaseOfCode: 0x%X", 10, 0
	msg_optionalheader_baseofdata32 db 9, 9, "BaseOfData: 0x%X", 10, 0 ; Only 32bit
	msg_optionalheader_imagebase db 9, 9, "ImageBase: 0x%llX", 10, 0
	msg_optionalheader_sectionalignment db 9, 9, "SectionAlignment: 0x%X", 10, 0
	msg_optionalheader_filealignment db 9, 9, "FileAlignment: 0x%X", 10, 0
	msg_optionalheader_sizeofimage db 9, 9, "SizeOfImage: 0x%X", 10, 0
	;Data Dir
	msg_optionalheader_datadir db 9, "+ Data Directory:", 10, 0 
	msg_optionalheader_datadir_exporttable db 9, 9, "Export Table (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_importtable db 9, 9, "Import Table (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_resourcetable db 9, 9, "Resource Table (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_exceptiontable db 9, 9, "Exception Table (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_certificatetable db 9, 9, "Certificate Table (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_baserelocationtable db 9, 9, "Base Relocation Table (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_debugdirectory db 9, 9, "Debug Directory (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_architecturedirectory db 9, 9, "Architecture Directory (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_globalptrdirectory db 9, 9, "GlobalPtr Directory (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_tlstable db 9, 9, "TLS Table (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_loadconfigtable db 9, 9, "Load Config Table (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_boundimporttable db 9, 9, "Bound Import Table (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_importaddresstable db 9, 9, "Import Address Table (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_delayimportdescriptor db 9, 9, "Delay Import Descriptor (RVA, Size): 0x%X, 0x%X", 10, 0
	msg_optionalheader_datadir_clrruntimeheader db 9, 9, "CLR Runtime Header (RVA, Size): 0x%X, 0x%X", 10, 0

; Section Header
	msg_sectionheader db "3. Section Header:", 10, 0
	msg_sectionheader_number db 9, "- Section %d", 10, 0
	msg_sectionheader_offset db 9, 9, "Offset in file: 0x%X", 10, 0
	msg_sectionheader_name db 9, 9, "Name: %.8s", 10, 0
	msg_sectionheader_virtualsize db 9, 9, "VirtualSize: 0x%X", 10, 0
	msg_sectionheader_virtualaddress db 9, 9, "VirtualAddress: 0x%X", 10, 0
	msg_sectionheader_sizeofrawdata db 9, 9, "SizeOfRawData: 0x%X", 10, 0
	msg_sectionheader_pointertorawdata db 9, 9, "PointerToRawData: 0x%X", 10, 0
	msg_sectionheader_pointertorelocations db 9, 9, "PointerToRelocations: 0x%X", 10, 0
	msg_sectionheader_pointertolinenumbers db 9, 9, "PointerToLinenumbers: 0x%X", 10, 0
	msg_sectionheader_numberofrelocations db 9, 9, "NumberOfRelocations: 0x%X", 10, 0
	msg_sectionheader_numberoflinenumbers db 9, 9, "NumberOfLinenumbers: 0x%X", 10, 0
	msg_sectionheader_characteristics db 9, 9, "Characteristics: 0x%X", 10, 0
	msg_sectionheader_foundimporttable db 9, 9, "**IMPORT TABLE IS IN: %.8s**", 10, 0

; Import Dir
	msg_importdir db "4. Import Directory:", 10, 0
	msg_importdir_totalimports db 9, "Total Imports: %d", 10, 0
	msg_importdir_dllname db 9, "Name: %s", 10, 0
	msg_importdir_function db 9, 9, "Imported Functions:", 10, 0
	msg_importdir_functionname db 9, 9, "+ %s", 10, 0

;Constants
	SIZEOF_IMAGE_FILE_HEADER dd 18h

.data?
;Others
	hFile QWORD ?

;DOS header
	e_magic WORD ?
	e_lfanew DWORD ?
	
;NT HEADER
	;File header
	Signature DWORD ?
    Machine WORD ?
    NumberOfSections WORD ?
    SizeOfOptionalHeader WORD ?
    Characteristics WORD ?

	;Optional header
	optional_header_offset DWORD ?
	Magic WORD ?
	SizeOfCode DWORD ?
	SizeOfInitializedData DWORD ?
	SizeOfUninitializedData DWORD ?
	AddressOfEntryPoint DWORD ?
	BaseOfCode DWORD ?
	BaseOfData32 DWORD ? ;Only 32bit
	ImageBase QWORD ?
	ImageBase32 DWORD ? ;4b less in 32bit
	SectionAlignment DWORD ?
	FileAlignment DWORD ?
	SizeOfImage DWORD ?

	;Image Directories
	ExportTable QWORD ?
	ExportTable_RVA DWORD ?
	ExportTable_Size DWORD ?
	ImportTable QWORD ?
	ImportTable_RVA DWORD ?
	ImportTable_Size DWORD ?
	ResourceTable QWORD ?
	ResourceTable_RVA DWORD ?
	ResourceTable_Size DWORD ?
	ExceptionTable QWORD ?
	ExceptionTable_RVA DWORD ?
	ExceptionTable_Size DWORD ?
	CertificateTable QWORD ?
	CertificateTable_RVA DWORD ?
	CertificateTable_Size DWORD ?
	BaseRelocationTable QWORD ?
	BaseRelocationTable_RVA  DWORD ?
	BaseRelocationTable_Size DWORD ?
	DebugDirectory QWORD ?
	DebugDirectory_RVA DWORD ?
	DebugDirectory_Size DWORD ?
	ArchitectureDirectory QWORD ?
	ArchitectureDirectory_RVA DWORD ?
	ArchitectureDirectory_Size DWORD ?
	GlobalPtrDirectory QWORD ?
	GlobalPtrDirectory_RVA DWORD ?
	GlobalPtrDirectory_Size DWORD ?
	TLSTable QWORD ?
	TLSTable_RVA DWORD ?
	TLSTable_Size DWORD ?
	LoadConfigTable QWORD ?
	LoadConfigTable_RVA DWORD ?
	LoadConfigTable_Size DWORD ?
	BoundImportTable QWORD ?
	BoundImportTable_RVA DWORD ?
	BoundImportTable_Size DWORD ?
	ImportAddressTable QWORD ?
	ImportAddressTable_RVA DWORD ?
	ImportAddressTable_Size DWORD ?
	DelayImportDescriptor QWORD ?
	DelayImportDescriptor_RVA DWORD ?
	DelayImportDescriptor_Size DWORD ?
	CLRRuntimeHeader QWORD ?
	CLRRuntimeHeader_RVA DWORD ?
	CLRRuntimeHeader_Size DWORD ?

	;ImportDir
	TotalImports DWORD ?

	SectionContainsImportOffset DWORD ?
	SectionContainsImportVA DWORD ?
	SectionContainsImportRawAddr DWORD ?

	CurrentImportOffset DWORD ?
	CurrentImportNameOffset DWORD ?
	CurrentImportFirstThunkOffset DWORD ?
	CurrentImportFunctionNameRVA QWORD ?
	CurrentImportFunctionNameRVA32 DWORD ? ;32bit has 4 byte less
	CurrentImportFunctionNameOffset DWORD ?
	CurrentImportBuffer QWORD ?
	CurrentNameBuffer QWORD ?

;Section header
	section_header_offset DWORD ?
	CurrentSectionOffset DWORD ?
	CurrentSectionVSize DWORD ?
	CurrentSectionVA DWORD ?
	CurrentSectionRawAddr DWORD ?
	CurrentSectionBuffer QWORD ?
	

.code
main proc
	sub rsp, 40

;Check PE file arch: Reading the offsets using SetFilePointer + ReadFile
	;Get file handle
	lea rcx, path
	mov rdx, 80000000h ;GENERIC_READ
	mov r8, 1 ;FILE_SHARE_READ
	mov r9, 0
	mov DWORD PTR [rsp+20h], 3 ;OPEN_EXISTING
	mov DWORD PTR [rsp+28h], 1 ;FILE_ATTRIBUTE_READONLY
	mov DWORD PTR [rsp+30h], 0
	call CreateFileA
	mov hFile, rax

	;Read the DOS magic
	mov rcx, hFile
	lea rdx, e_magic
	mov r8, 2
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	;Dos magic check
	cmp [e_magic], 5A4Dh
	jnz Exit

	;Get NT magic offset
	mov rcx, hFile
	mov rdx, 3Ch
	mov r8, 0
	mov r9, 0
	call SetFilePointer 
	mov rcx, hFile
	lea rdx, e_lfanew
	mov r8, 4
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	
	;Read + NT magic check
	mov rcx, hFile
	mov edx, e_lfanew
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, Signature
	mov r8, 4
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	cmp [Signature], 00004550h
	jnz Exit

	;Calculate optional header offset e_lfanew + size of file header
	mov ebx, e_lfanew
	add ebx, SIZEOF_IMAGE_FILE_HEADER
	mov optional_header_offset, ebx
	;Read file architecture (Magic) of Optional header
	mov rcx, hFile
	mov edx, optional_header_offset
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, Magic
	mov r8, 2
	mov r9, 0
	call ReadFile

;Parsing File header
    ;Reading Machine
    mov rcx, hFile
    mov edx, e_lfanew
    add rdx, 4
    mov r8, 0
    mov r9, 0
    call SetFilePointer
    mov rcx, hFile
    lea rdx, Machine
    mov r8, 2
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
    call ReadFile
    ;Read NumberOfSections
    mov rcx, hFile
    mov edx, e_lfanew
    add rdx, 6
    mov r8, 0
    mov r9, 0
    call SetFilePointer
    mov rcx, hFile
    lea rdx, NumberOfSections
    mov r8, 2
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
    call ReadFile
    ;Read SizeOfOptionalHeader
    mov rcx, hFile
    mov edx, e_lfanew
    add rdx, 20
    mov r8, 0
    mov r9, 0
    call SetFilePointer
    mov rcx, hFile
    lea rdx, SizeOfOptionalHeader
    mov r8, 2
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
    call ReadFile
    ;Read characteristics
    mov rcx, hFile
    mov edx, e_lfanew
    add rdx, 22
    mov r8, 0
    mov r9, 0
    call SetFilePointer
    mov rcx, hFile
    lea rdx, Characteristics
    mov r8, 2
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
    call ReadFile

;Print info of DOS header
	lea rcx, msg_dosheader
	call printf
	lea rcx, msg_dosheader_magic
	movzx edx, e_magic
	call printf
	lea rcx, msg_dosheader_e_lfanew
	mov edx, e_lfanew
	call printf
;Print info of File header
	lea rcx, msg_ntheader
	call printf
	lea rcx, msg_fileheader
	call printf
	lea rcx, msg_fileheader_signature
	mov edx, Signature
	call printf
    lea rcx, msg_fileheader_machine
    movzx edx, Machine
    call printf
    lea rcx, msg_fileheader_numberofsections
    movzx edx, NumberOfSections
    call printf
    lea rcx, msg_fileheader_sizeofoptionalheader
    movzx edx, SizeOfOptionalHeader
	call printf
    lea rcx, msg_fileheader_characteristics
    movzx edx, Characteristics
    call printf

	;Check file architecture (Magic)
	cmp [Magic], 020Bh
	jnz PE32bit

; Parsing Optional, Section header of 64 bit PE file
PE64bit:
	lea rcx, msg_64bit
	call printf

;Parsing optional header
	;SizeOfCode
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 4
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, SizeOfCode
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
	call ReadFile
	;SizeOfInitializedData
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 8
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, SizeOfInitializedData
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
	call ReadFile
	;SizeOfUninitializedData
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 12
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, SizeOfUninitializedData
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
	call ReadFile
	;AddressOfEntryPoint
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 16
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, AddressOfEntryPoint
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
	call ReadFile
	;BaseOfCode
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 20
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, BaseOfCode
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
	call ReadFile
	;ImageBase
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 24
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, ImageBase
    mov r8, 8
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0	
	call ReadFile
	;SectionAlignment
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 32
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, SectionAlignment
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0	
	call ReadFile
	;FileAlignment
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 36
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, FileAlignment
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0	
	call ReadFile
	;SizeOfImage
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 56
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, SizeOfImage
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0	
	call ReadFile
	;Parsing data directories
	;ExportTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 112
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, ExportTable
    mov r8, 8
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0	
	call ReadFile
	mov eax, DWORD PTR [ExportTable]
	mov ExportTable_RVA, eax
	mov eax, DWORD PTR [ExportTable+4]
	mov ExportTable_Size, eax
	;ImportTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 120
	xor r8, r8
	xor r9, r9
	call SetFilePointer
	mov rcx, hFile
	lea rdx, ImportTable
	mov r8, 8
	xor r9, r9
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [ImportTable]
	mov ImportTable_RVA, eax
	mov eax, DWORD PTR [ImportTable+4]
	mov ImportTable_Size, eax
	;ResourceTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 128
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, ResourceTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [ResourceTable]
	mov ResourceTable_RVA, eax
	mov eax, DWORD PTR [ResourceTable+4]
	mov ResourceTable_Size, eax
	;ExceptionTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 136
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, ExceptionTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [ExceptionTable]
	mov ExceptionTable_RVA, eax
	mov eax, DWORD PTR [ExceptionTable+4]
	mov ExceptionTable_Size, eax
	;CertificateTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 144
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, CertificateTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [CertificateTable]
	mov CertificateTable_RVA, eax
	mov eax, DWORD PTR [CertificateTable+4]
	mov CertificateTable_Size, eax
	;BaseRelocationTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 152
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, BaseRelocationTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [BaseRelocationTable]
	mov BaseRelocationTable_RVA, eax
	mov eax, DWORD PTR [BaseRelocationTable+4]
	mov BaseRelocationTable_Size, eax
	;DebugDirectory
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 160
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, DebugDirectory
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [DebugDirectory]
	mov DebugDirectory_RVA, eax
	mov eax, DWORD PTR [DebugDirectory+4]
	mov DebugDirectory_Size, eax
	;ArchitectureDirectory
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 168
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, ArchitectureDirectory
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [ArchitectureDirectory]
	mov ArchitectureDirectory_RVA, eax
	mov eax, DWORD PTR [ArchitectureDirectory+4]
	mov ArchitectureDirectory_Size, eax
	;GlobalPtrDirectory
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 176
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, GlobalPtrDirectory
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [GlobalPtrDirectory]
	mov GlobalPtrDirectory_RVA, eax
	mov eax, DWORD PTR [GlobalPtrDirectory+4]
	mov GlobalPtrDirectory_Size, eax
	;TLSTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 184
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, TLSTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [TLSTable]
	mov TLSTable_RVA, eax
	mov eax, DWORD PTR [TLSTable+4]
	mov TLSTable_Size, eax
	;LoadConfigTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 192
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, LoadConfigTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [LoadConfigTable]
	mov LoadConfigTable_RVA, eax
	mov eax, DWORD PTR [LoadConfigTable+4]
	mov LoadConfigTable_Size, eax
	;BoundImportTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 200
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, BoundImportTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [BoundImportTable]
	mov BoundImportTable_RVA, eax
	mov eax, DWORD PTR [BoundImportTable+4]
	mov BoundImportTable_Size, eax
	;ImportAddressTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 208
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, ImportAddressTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [ImportAddressTable]
	mov ImportAddressTable_RVA, eax
	mov eax, DWORD PTR [ImportAddressTable+4]
	mov ImportAddressTable_Size, eax
	;DelayImportDescriptor
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 216
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, DelayImportDescriptor
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [DelayImportDescriptor]
	mov DelayImportDescriptor_RVA, eax
	mov eax, DWORD PTR [DelayImportDescriptor+4]
	mov DelayImportDescriptor_Size, eax
	;CLRRuntimeHeader
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 224
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, CLRRuntimeHeader
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [CLRRuntimeHeader]
	mov CLRRuntimeHeader_RVA, eax
	mov eax, DWORD PTR [CLRRuntimeHeader+4]
	mov CLRRuntimeHeader_Size, eax

;Print info of optional header
	lea rcx, msg_optionalheader
	call printf
	lea rcx, msg_optionalheader_magic
	movzx edx, Magic
	call printf
	lea rcx, msg_optionalheader_sizeofcode
	mov edx, SizeOfCode
	call printf
	lea rcx, msg_optionalheader_sizeofinitializeddata
	mov edx, SizeOfInitializedData
	call printf
	lea rcx, msg_optionalheader_sizeofuninitializeddata
	mov edx, SizeOfUninitializedData
	call printf
	lea rcx, msg_optionalheader_addressofentrypoint
	mov edx, AddressOfEntryPoint
	call printf
	lea rcx, msg_optionalheader_baseofcode
	mov edx, BaseOfCode
	call printf
	lea rcx, msg_optionalheader_imagebase
	mov rdx, ImageBase
	call printf
	lea rcx, msg_optionalheader_sectionalignment
	mov edx, SectionAlignment
	call printf
	lea rcx, msg_optionalheader_filealignment
	mov edx, FileAlignMent
	call printf
	lea rcx, msg_optionalheader_sizeofimage
	mov edx, SizeOfImage
	call printf
	;Print info of data directories
	lea rcx, msg_optionalheader_datadir
	call printf
	lea rcx, msg_optionalheader_datadir_exporttable
	mov edx, ExportTable_RVA
	mov r8d, ExportTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_importtable
	mov edx, ImportTable_RVA
	mov r8d, ImportTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_resourcetable
	mov edx, ResourceTable_RVA
	mov r8d, ResourceTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_exceptiontable
	mov edx, ExceptionTable_RVA
	mov r8d, ExceptionTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_certificatetable
	mov edx, CertificateTable_RVA
	mov r8d, CertificateTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_baserelocationtable
	mov edx, BaseRelocationTable_RVA
	mov r8d, BaseRelocationTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_debugdirectory
	mov edx, DebugDirectory_RVA
	mov r8d, DebugDirectory_Size
	call printf
	lea rcx, msg_optionalheader_datadir_architecturedirectory
	mov edx, ArchitectureDirectory_RVA
	mov r8d, ArchitectureDirectory_Size
	call printf
	lea rcx, msg_optionalheader_datadir_globalptrdirectory
	mov edx, GlobalPtrDirectory_RVA
	mov r8d, GlobalPtrDirectory_Size
	call printf
	lea rcx, msg_optionalheader_datadir_tlstable
	mov edx, TLSTable_RVA
	mov r8d, TLSTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_loadconfigtable
	mov edx, LoadConfigTable_RVA
	mov r8d, LoadConfigTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_boundimporttable
	mov edx, BoundImportTable_RVA
	mov r8d, BoundImportTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_importaddresstable
	mov edx, ImportAddressTable_RVA
	mov r8d, ImportAddressTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_delayimportdescriptor
	mov edx, DelayImportDescriptor_RVA
	mov r8d, DelayImportDescriptor_Size
	call printf
	lea rcx, msg_optionalheader_datadir_clrruntimeheader
	mov edx, CLRRuntimeHeader_RVA
	mov r8d, CLRRuntimeHeader_Size
	call printf


;PARSING AND PRINTING SECTION HEADER + IMPORT DIRECTORY
; Section header offset = optional_header_offset + optional_header_size
; Counter = 0
; Get into a loop:
;	Compare counter to Sections Count, if equal, exit
;	Read 40 bytes
;	Read then print all info of that section
;	From offset 8: VSize (4b), offset 12: VA (4b)
; 	Check that section[i]VA < importRVA < section[i]VA + section[i]VSize
;	If true than save that section Raw Address, VA, VSize
;	Inc counter, Inc buffer by 40 byte
; jmp loop
; GOAL: Get the section contains import dir (VA and VSize)

	;Calculate section header offset
	mov eax, optional_header_offset
	movzx ebx, SizeOfOptionalHeader
	add eax, ebx
	mov section_header_offset, eax

	;Allocate 40 bytes buffer
	mov rcx, 0
	mov rdx, 40
	mov r8, 00003000h
	mov r9, 4
	call VirtualAlloc

	test rax, rax
	jz ExitFail

	mov CurrentSectionBuffer, rax

	mov ebx, section_header_offset
	mov CurrentSectionOffset, ebx ;Offset
	mov r15, 0 ;Counter

	lea rcx, msg_sectionheader
	call printf

ParseSectionHeaderLoop:
	cmp r15w, NumberOfSections
	je ParseImportDir
	
	;Read 40 bytes into buffer
	mov rcx, hFile
	mov edx, CurrentSectionOffset
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	mov rdx, CurrentSectionBuffer
	mov r8, 40
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile

	; Parsing section infos
	lea rcx, msg_sectionheader_number
	mov rdx, r15
	call printf
	;Offset, Save the current Offset
	lea rcx, msg_sectionheader_offset
	mov edx, CurrentSectionOffset
	call printf
	;Name
	lea rcx, msg_sectionheader_name
	mov rdx, CurrentSectionBuffer
	call printf
	;VirtualSize, Save the current VSize
	lea rcx, msg_sectionheader_virtualsize
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR [rax+8]
	mov CurrentSectionVSize, edx
	call printf
	;VirtualAddress, Save the current VA
	lea rcx, msg_sectionheader_virtualaddress
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR [rax+12]
	mov CurrentSectionVA, edx
	call printf
	;SizeOfRawData
	lea rcx, msg_sectionheader_sizeofrawdata
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR [rax+16]
	call printf
	;PointerToRawData, save the current RawAddr
	lea rcx, msg_sectionheader_pointertorawdata
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR [rax+20]
	mov CurrentSectionRawAddr, edx
	call printf
	;PointerToRelocations
	lea rcx, msg_sectionheader_pointertorelocations
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR [rax+24]
	call printf
	;PointerToLinenumbers
	lea rcx, msg_sectionheader_pointertolinenumbers
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR [rax+28]
	call printf
	;NumberOfRelocations
	lea rcx, msg_sectionheader_numberofrelocations
	mov rax, CurrentSectionBuffer
	movzx edx, WORD PTR [rax+32]
	call printf
	;NumberOfLinenumbers
	lea rcx, msg_sectionheader_numberoflinenumbers
	mov rax, CurrentSectionBuffer
	movzx edx, WORD PTR [rax+34]
	call printf
	;Characteristics
	lea rcx, msg_sectionheader_characteristics
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR [rax+36]
	call printf

	; Check which section contains import dir: 
	;section[i]VA < importRVA < section[i]VA + section[i]VSize
	mov ebx, CurrentSectionVA
	cmp ImportTable_RVA, ebx
	jb ParseSectionHeaderLoopCont
	mov ebx, CurrentSectionVA
	add ebx, CurrentSectionVSize
	cmp ImportTable_RVA, ebx
	jg ParseSectionHeaderLoopCont
	lea rcx, msg_sectionheader_foundimporttable
	mov rdx, CurrentSectionBuffer
	call printf

	;Save the section Raw Addr and VA contains import dir
	mov ebx, CurrentSectionRawAddr
	mov SectionContainsImportRawAddr, ebx
	mov ebx, CurrentSectionVA
	mov SectionContainsImportVA, ebx


ParseSectionHeaderLoopCont:
	;Increase counter and offset
	inc r15
	mov edi, CurrentSectionOffset
	add edi, 40
	mov CurrentSectionOffset, edi
	jmp ParseSectionHeaderLoop

; Each import size is 20 bytes, TotalImports = (Size/20)-1
; Get importRVA; sections VA and VSize and Raw Offset
; Goes into a loop:
; 	CMP counter to totalImports, if equal, exit
; 	Get import DLL Offset: <section>.RawAddr + (import.RVA - <section>.VA)
; 	Save the OFT (byte 0 - 3) and nameRVA (byte 12 - 15)
; 	Get DLL name: <section>.RawAddr + (nameRVA - <section>.VA). Read until 00 00 byte
;   Print DLL name
; 		2nd loop to get the function names:
;			Check if next 8 byte is 0, if true, exit
;			Increase counter
;			Get firstThunkOffset and firstFunctionOffset
;			firstThunkOffset: <section>.RawAddr + (OFT - <section>.VA)
;			Get 8 byte of OriginalThunk from firstThunkOffset
;			firstFunctionOffset: <section>.RawAddr + (OriginalThunk - <section>.VA)] + 2
;			Read until 00 00 byte
;           Print function name
;			jmp 2ndloop
; Increase buffer by 20 byte
; jmp 1stloop	

ParseImportDir:
	; Allocate 20b for import buffer
	mov rcx, 0
	mov rdx, 20
	mov r8, 00003000h
	mov r9, 4
	call VirtualAlloc 
	mov CurrentImportBuffer, rax
	; Allocate 256b for reading names buffer 
	; (Idea is to create a buffer large enough for ReadFile so that printf stops printing at null byte)
	mov rcx, 0
	mov rdx, 256
	mov r8, 00003000h
	mov r9, 4
	call VirtualAlloc 
	mov CurrentNameBuffer, rax

	;Calculate TotalImports
	mov eax, ImportTable_Size
	mov edx, 0
	mov ecx, 20
	div ecx
	dec eax
	mov TotalImports, eax
	;Print total import
	lea rcx, msg_importdir
	call printf
	lea rcx, msg_importdir_totalimports
	mov edx, TotalImports
	call printf

	;ImportOffset: <section>.RawAddr + (import.RVA - <section>.VA)
	mov ebx, SectionContainsImportRawAddr
	add ebx, ImportTable_RVA
	sub ebx, SectionContainsImportVA
	mov CurrentImportOffset, ebx

	mov r15, 0 ; 1st Counter for DLL name

ParseImportLoop:
	cmp r15d, TotalImports
	je Exit

	;Read 20 bytes import
	mov rcx, hFile
	mov edx, CurrentImportOffset
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	mov rdx, CurrentImportBuffer
	mov r8, 20
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile

	;DLL name offset: <section>.RawAddr + (nameRVA - <section>.VA)
	;nameRVA (byte 12-15)
	mov rax, CurrentImportBuffer
	mov ebx, DWORD PTR [rax+12]
	add ebx, SectionContainsImportRawAddr
	sub ebx, SectionContainsImportVA
	mov CurrentImportNameOffset, ebx
	mov rcx, hFile
	mov edx, CurrentImportNameOffset
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	mov rdx, CurrentNameBuffer
	mov r8, 256
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	lea rcx, msg_importdir_dllname
	mov rdx, CurrentNameBuffer
	call printf

	;For each DLL, get the names of imported function, OFT (byte 0 - 3)
	;firstThunkOffset: <section>.RawAddr + (OFT - <section>.VA)
	mov rax, CurrentImportBuffer
	mov ebx, DWORD PTR [rax]
	add ebx, SectionContainsImportRawAddr
	sub ebx, SectionContainsImportVA
	mov CurrentImportFirstThunkOffset, ebx

	ParseFunctionLoop:
		mov rcx, hFile
		mov edx, CurrentImportFirstThunkOffset
		mov r8, 0
		mov r9, 0
		call SetFilePointer
		mov rcx, hFile
		lea rdx, CurrentImportFunctionNameRVA
		mov r8, 8
		mov r9, 0
		mov DWORD PTR [rsp+20h], 0
		call ReadFile
		mov rbx, CurrentImportFunctionNameRVA
		test rbx, rbx ; Check if 8 bit is 0 byte
		je ParseImportLoopCont
		;Get the RVA
		mov rbx, CurrentImportFunctionNameRVA
		;Function name offset: [<section>.RawAddr + (OT - <section>.VA)] + 2
		add ebx, SectionContainsImportRawAddr
		sub ebx, SectionContainsImportVA
		add rbx, 2
		mov CurrentImportFunctionNameOffset, ebx
		mov rcx, hFile
		mov edx, CurrentImportFunctionNameOffset
		mov r8, 0
		mov r9, 0
		call SetFilePointer
		mov rcx, hFile
		mov rdx, CurrentNameBuffer
		mov r8, 256
		mov r9, 0
		mov DWORD PTR [rsp+20h], 0
		call ReadFile
		lea rcx, msg_importdir_functionname
		mov rdx, CurrentNameBuffer
		call printf

		add CurrentImportFirstThunkOffset, 8
		jmp ParseFunctionLoop

ParseImportLoopCont:
	mov ebx, CurrentImportOffset
	add ebx, 20
	mov CurrentImportOffset, ebx
	inc r15
	jmp ParseImportLoop



	jmp Exit

; Parsing Optional, Section header of 32 bit PE file
PE32bit:
	lea rcx, msg_32bit
	call printf

;Parsing optional header
	;SizeOfCode
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 4
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, SizeOfCode
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
	call ReadFile
	;SizeOfInitializedData
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 8
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, SizeOfInitializedData
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
	call ReadFile
	;SizeOfUninitializedData
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 12
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, SizeOfUninitializedData
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
	call ReadFile
	;AddressOfEntryPoint
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 16
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, AddressOfEntryPoint
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
	call ReadFile
	;BaseOfCode
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 20
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, BaseOfCode
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
	call ReadFile
	;BaseOfData
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 24
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, BaseOfData32
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0
	call ReadFile
	;ImageBase
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 28
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, ImageBase32
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0	
	call ReadFile
	;SectionAlignment
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 32
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, SectionAlignment
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0	
	call ReadFile
	;FileAlignment
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 36
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, FileAlignment
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0	
	call ReadFile
	;SizeOfImage
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 56
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, SizeOfImage
    mov r8, 4
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0	
	call ReadFile
	;Parsing data directories
	;ExportTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 96
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
    lea rdx, ExportTable
    mov r8, 8
    mov r9, 0
    mov DWORD PTR [rsp+20h], 0	
	call ReadFile
	mov eax, DWORD PTR [ExportTable]
	mov ExportTable_RVA, eax
	mov eax, DWORD PTR [ExportTable+4]
	mov ExportTable_Size, eax
	;ImportTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 104
	xor r8, r8
	xor r9, r9
	call SetFilePointer
	mov rcx, hFile
	lea rdx, ImportTable
	mov r8, 8
	xor r9, r9
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [ImportTable]
	mov ImportTable_RVA, eax
	mov eax, DWORD PTR [ImportTable+4]
	mov ImportTable_Size, eax
	;ResourceTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 112
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, ResourceTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [ResourceTable]
	mov ResourceTable_RVA, eax
	mov eax, DWORD PTR [ResourceTable+4]
	mov ResourceTable_Size, eax
	;ExceptionTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 120
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, ExceptionTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [ExceptionTable]
	mov ExceptionTable_RVA, eax
	mov eax, DWORD PTR [ExceptionTable+4]
	mov ExceptionTable_Size, eax
	;CertificateTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 128
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, CertificateTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [CertificateTable]
	mov CertificateTable_RVA, eax
	mov eax, DWORD PTR [CertificateTable+4]
	mov CertificateTable_Size, eax
	;BaseRelocationTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 136
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, BaseRelocationTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [BaseRelocationTable]
	mov BaseRelocationTable_RVA, eax
	mov eax, DWORD PTR [BaseRelocationTable+4]
	mov BaseRelocationTable_Size, eax
	;DebugDirectory
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 144
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, DebugDirectory
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [DebugDirectory]
	mov DebugDirectory_RVA, eax
	mov eax, DWORD PTR [DebugDirectory+4]
	mov DebugDirectory_Size, eax
	;ArchitectureDirectory
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 152
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, ArchitectureDirectory
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [ArchitectureDirectory]
	mov ArchitectureDirectory_RVA, eax
	mov eax, DWORD PTR [ArchitectureDirectory+4]
	mov ArchitectureDirectory_Size, eax
	;GlobalPtrDirectory
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 160
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, GlobalPtrDirectory
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [GlobalPtrDirectory]
	mov GlobalPtrDirectory_RVA, eax
	mov eax, DWORD PTR [GlobalPtrDirectory+4]
	mov GlobalPtrDirectory_Size, eax
	;TLSTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 168
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, TLSTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [TLSTable]
	mov TLSTable_RVA, eax
	mov eax, DWORD PTR [TLSTable+4]
	mov TLSTable_Size, eax
	;LoadConfigTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 176
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, LoadConfigTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [LoadConfigTable]
	mov LoadConfigTable_RVA, eax
	mov eax, DWORD PTR [LoadConfigTable+4]
	mov LoadConfigTable_Size, eax
	;BoundImportTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 184
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, BoundImportTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [BoundImportTable]
	mov BoundImportTable_RVA, eax
	mov eax, DWORD PTR [BoundImportTable+4]
	mov BoundImportTable_Size, eax
	;ImportAddressTable
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 192
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, ImportAddressTable
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [ImportAddressTable]
	mov ImportAddressTable_RVA, eax
	mov eax, DWORD PTR [ImportAddressTable+4]
	mov ImportAddressTable_Size, eax
	;DelayImportDescriptor
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 200
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, DelayImportDescriptor
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [DelayImportDescriptor]
	mov DelayImportDescriptor_RVA, eax
	mov eax, DWORD PTR [DelayImportDescriptor+4]
	mov DelayImportDescriptor_Size, eax
	;CLRRuntimeHeader
	mov rcx, hFile
	mov edx, optional_header_offset
	add rdx, 208
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, CLRRuntimeHeader
	mov r8, 8
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	mov eax, DWORD PTR [CLRRuntimeHeader]
	mov CLRRuntimeHeader_RVA, eax
	mov eax, DWORD PTR [CLRRuntimeHeader+4]
	mov CLRRuntimeHeader_Size, eax

;Print info of optional header
	lea rcx, msg_optionalheader
	call printf
	lea rcx, msg_optionalheader_magic
	movzx edx, Magic
	call printf
	lea rcx, msg_optionalheader_sizeofcode
	mov edx, SizeOfCode
	call printf
	lea rcx, msg_optionalheader_sizeofinitializeddata
	mov edx, SizeOfInitializedData
	call printf
	lea rcx, msg_optionalheader_sizeofuninitializeddata
	mov edx, SizeOfUninitializedData
	call printf
	lea rcx, msg_optionalheader_addressofentrypoint
	mov edx, AddressOfEntryPoint
	call printf
	lea rcx, msg_optionalheader_baseofcode
	mov edx, BaseOfCode
	call printf
	lea rcx, msg_optionalheader_baseofdata32
	mov edx, BaseOfData32
	call printf
	lea rcx, msg_optionalheader_imagebase
	mov edx, ImageBase32
	call printf
	lea rcx, msg_optionalheader_sectionalignment
	mov edx, SectionAlignment
	call printf
	lea rcx, msg_optionalheader_filealignment
	mov edx, FileAlignMent
	call printf
	lea rcx, msg_optionalheader_sizeofimage
	mov edx, SizeOfImage
	call printf
	;Print info of data directories
	lea rcx, msg_optionalheader_datadir
	call printf
	lea rcx, msg_optionalheader_datadir_exporttable
	mov edx, ExportTable_RVA
	mov r8d, ExportTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_importtable
	mov edx, ImportTable_RVA
	mov r8d, ImportTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_resourcetable
	mov edx, ResourceTable_RVA
	mov r8d, ResourceTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_exceptiontable
	mov edx, ExceptionTable_RVA
	mov r8d, ExceptionTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_certificatetable
	mov edx, CertificateTable_RVA
	mov r8d, CertificateTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_baserelocationtable
	mov edx, BaseRelocationTable_RVA
	mov r8d, BaseRelocationTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_debugdirectory
	mov edx, DebugDirectory_RVA
	mov r8d, DebugDirectory_Size
	call printf
	lea rcx, msg_optionalheader_datadir_architecturedirectory
	mov edx, ArchitectureDirectory_RVA
	mov r8d, ArchitectureDirectory_Size
	call printf
	lea rcx, msg_optionalheader_datadir_globalptrdirectory
	mov edx, GlobalPtrDirectory_RVA
	mov r8d, GlobalPtrDirectory_Size
	call printf
	lea rcx, msg_optionalheader_datadir_tlstable
	mov edx, TLSTable_RVA
	mov r8d, TLSTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_loadconfigtable
	mov edx, LoadConfigTable_RVA
	mov r8d, LoadConfigTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_boundimporttable
	mov edx, BoundImportTable_RVA
	mov r8d, BoundImportTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_importaddresstable
	mov edx, ImportAddressTable_RVA
	mov r8d, ImportAddressTable_Size
	call printf
	lea rcx, msg_optionalheader_datadir_delayimportdescriptor
	mov edx, DelayImportDescriptor_RVA
	mov r8d, DelayImportDescriptor_Size
	call printf
	lea rcx, msg_optionalheader_datadir_clrruntimeheader
	mov edx, CLRRuntimeHeader_RVA
	mov r8d, CLRRuntimeHeader_Size
	call printf

; Parsing section
	;Calculate section header offset
	mov ebx, optional_header_offset
	movzx eax, SizeOfOptionalHeader
	add ebx, eax
	mov section_header_offset, ebx
	mov CurrentSectionOffset, ebx
	;Allocate 40 bytes for section buffer
	mov rcx, 0
	mov rdx, 40
	mov r8, 00003000h
	mov r9, 4
	call VirtualAlloc
	mov CurrentSectionBuffer, rax
	lea rcx, msg_sectionheader
	call printf
	mov r15, 0 ; Counter
	;Parsing section header loop
ParseSectionHeaderLoop32:
	cmp r15w, NumberOfSections
	je ParseImportDir32
	lea rcx, msg_sectionheader_number
	mov rdx, r15
	call printf

	; Fill the buffer
	mov rcx, hFile
	mov edx, CurrentSectionOffset
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	mov rdx, CurrentSectionBuffer
	mov r8, 40
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile

	; Read and print info
	;Name
	lea rcx, msg_sectionheader_name
	mov rdx, CurrentSectionBuffer
	call printf
	;VSize + Save current VSize
	lea rcx, msg_sectionheader_virtualsize
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR[rax+8]
	mov CurrentSectionVSize, edx
	call printf
	;VirtualAddress + Save current VA
	lea rcx, msg_sectionheader_virtualaddress
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR[rax+12]
	mov CurrentSectionVA, edx
	call printf
	;SizeOfRawData
	lea rcx, msg_sectionheader_sizeofrawdata
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR [rax+16]
	call printf
	;PointerToRawData, save the current RawAddr
	lea rcx, msg_sectionheader_pointertorawdata
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR [rax+20]
	mov CurrentSectionRawAddr, edx
	call printf
	;PointerToRelocations
	lea rcx, msg_sectionheader_pointertorelocations
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR [rax+24]
	call printf
	;PointerToLinenumbers
	lea rcx, msg_sectionheader_pointertolinenumbers
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR [rax+28]
	call printf
	;NumberOfRelocations
	lea rcx, msg_sectionheader_numberofrelocations
	mov rax, CurrentSectionBuffer
	movzx edx, WORD PTR [rax+32]
	call printf
	;NumberOfLinenumbers
	lea rcx, msg_sectionheader_numberoflinenumbers
	mov rax, CurrentSectionBuffer
	movzx edx, WORD PTR [rax+34]
	call printf
	;Characteristics
	lea rcx, msg_sectionheader_characteristics
	mov rax, CurrentSectionBuffer
	mov edx, DWORD PTR [rax+36]
	call printf

	;Check for sectionVA < importRVA < sectionVA + sectionVSize
	mov eax, ImportTable_RVA
	mov ebx, CurrentSectionVA
	cmp eax, ebx
	jb ParseSectionHeaderLoop32Cont
	mov ecx, CurrentSectionVSize
	add ebx, ecx
	cmp eax, ebx
	jae ParseSectionHeaderLoop32Cont
	lea rcx, msg_sectionheader_foundimporttable
	mov rdx, CurrentSectionBuffer
	call printf

	;Save the section Raw Addr and VA that contains import dir
	mov ebx, CurrentSectionRawAddr
	mov SectionContainsImportRawAddr, ebx
	mov ebx, CurrentSectionVA
	mov SectionContainsImportVA, ebx

ParseSectionHeaderLoop32Cont:
	inc r15w
	add CurrentSectionOffset, 40
	jmp ParseSectionHeaderLoop32

;32BIT HAS DIFFERENT BYTE SIZE SO SOME VARIBLE SIZE SHOULD BE CHANGED
ParseImportDir32:
	; Allocate 20b for import buffer
	mov rcx, 0
	mov rdx, 20
	mov r8, 00003000h
	mov r9, 4
	call VirtualAlloc 
	mov CurrentImportBuffer, rax
	; Allocate 256b for reading names buffer 
	; (Idea is to create a buffer large enough for ReadFile so that printf stops printing at null byte)
	mov rcx, 0
	mov rdx, 256
	mov r8, 00003000h
	mov r9, 4
	call VirtualAlloc 
	mov CurrentNameBuffer, rax

	;Calculate TotalImports
	mov eax, ImportTable_Size
	mov edx, 0
	mov ecx, 20
	div ecx
	dec eax
	mov TotalImports, eax
	;Print total import
	lea rcx, msg_importdir
	call printf
	lea rcx, msg_importdir_totalimports
	mov edx, TotalImports
	call printf

	;ImportOffset: <section>.RawAddr + (import.RVA - <section>.VA)
	mov ebx, SectionContainsImportRawAddr
	add ebx, ImportTable_RVA
	sub ebx, SectionContainsImportVA
	mov CurrentImportOffset, ebx

	mov r15, 0 ; 1st Counter for DLL name

ParseImportLoop32:
	cmp r15d, TotalImports
	je Exit

	;Read 20 bytes import
	mov rcx, hFile
	mov edx, CurrentImportOffset
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	mov rdx, CurrentImportBuffer
	mov r8, 20
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile

	;DLL name offset: <section>.RawAddr + (nameRVA - <section>.VA)
	;nameRVA (byte 12-15)
	mov rax, CurrentImportBuffer
	mov ebx, DWORD PTR [rax+12]
	add ebx, SectionContainsImportRawAddr
	sub ebx, SectionContainsImportVA
	mov CurrentImportNameOffset, ebx
	mov rcx, hFile
	mov edx, CurrentImportNameOffset
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	mov rdx, CurrentNameBuffer
	mov r8, 256
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile
	lea rcx, msg_importdir_dllname
	mov rdx, CurrentNameBuffer
	call printf

	;For each DLL, get the names of imported function, OFT (byte 0 - 3)
	;firstThunkOffset: <section>.RawAddr + (OFT - <section>.VA)
	mov rax, CurrentImportBuffer
	mov ebx, DWORD PTR [rax]
	add ebx, SectionContainsImportRawAddr
	sub ebx, SectionContainsImportVA
	mov CurrentImportFirstThunkOffset, ebx

	ParseFunctionLoop32:
		mov rcx, hFile
		mov edx, CurrentImportFirstThunkOffset
		mov r8, 0
		mov r9, 0
		call SetFilePointer
		mov rcx, hFile
		lea rdx, CurrentImportFunctionNameRVA32
		mov r8, 4
		mov r9, 0
		mov DWORD PTR [rsp+20h], 0
		call ReadFile
		mov ebx, CurrentImportFunctionNameRVA32
		test ebx, ebx ; Check if 4 bit is 0 byte
		je ParseImportLoop32Cont
		;Get the RVA
		mov ebx, CurrentImportFunctionNameRVA32
		;Function name offset: [<section>.RawAddr + (OT - <section>.VA)] + 2
		add ebx, SectionContainsImportRawAddr
		sub ebx, SectionContainsImportVA
		add rbx, 2
		mov CurrentImportFunctionNameOffset, ebx
		mov rcx, hFile
		mov edx, CurrentImportFunctionNameOffset
		mov r8, 0
		mov r9, 0
		call SetFilePointer
		mov rcx, hFile
		mov rdx, CurrentNameBuffer
		mov r8, 256
		mov r9, 0
		mov DWORD PTR [rsp+20h], 0
		call ReadFile
		lea rcx, msg_importdir_functionname
		mov rdx, CurrentNameBuffer
		call printf

		add CurrentImportFirstThunkOffset, 4
		jmp ParseFunctionLoop32

ParseImportLoop32Cont:
	mov ebx, CurrentImportOffset
	add ebx, 20
	mov CurrentImportOffset, ebx
	inc r15
	jmp ParseImportLoop32

	jmp Exit
Exit:
	mov rcx, 0
	call ExitProcess

ExitFail:
	lea rcx, msg_fail
	call printf
	mov rcx, 0
	call ExitProcess
main endp
END