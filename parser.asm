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
extrn printf:proc

.data
	;Strings
	path BYTE ".\sample.exe", 0
    msg_32bit db "**FILE IS 32 BIT**", 10, 0
    msg_64bit db "**FILE IS 64 BIT**", 10, 0
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
	SectionAlignment DWORD ?
	FileAlignment DWORD ?
	SizeOfImage DWORD ?

	;Image Directory
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

	;Section header
	section_header_offset DWORD ?

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


;PARSING AND PRINTING SECTION + IMPORT HEADER
; Each import size is 20 bytes, totalImports = (Size/20)-1
; Get importRVA, sections VA and VSize and Raw Offset
; Import header offset = optional_header_offset + optional_header_size
; Counter = 0
; Get into a loop:
;	Compare counter to Sections Count, if equal, exit
;	Read 16 bytes
;	Read first 8 byte to get the section name, print it
;	Next 8 byte, first 4 byte is VA, last 4 byte is VSize, print it
; 	Check that section[i]VA < importRVA < section[i]VA + section[i]VSize
;	If true than save that section Raw Offset, VA, VSize
;	Inc counter, Inc buffer by 40 byte
; jmp loop
;
;
; After that goes into a loop:
; 	Check if next 20 bytes is 0, if true, exit
; 	Get import DLL Offset: <section>.RawOffset + (import.RVA ? <section>.VA)
; 	Save the OFT (byte 0 - 3) and nameRVA (byte 12 - 15)
; 	Get DLL name: <section>.RawOffset + (nameRVA ? <section>.VA). Read until 00 00 byte
;   Print DLL name
; 		2nd loop to get the function names:
;			Check if next 8 byte is 0, if true, exit
;			Increase counter
;			Get firstThunkOffset and firstFunctionOffset
;			<section>.RawOffset + (OFT ? <section>.VA)
;			<section>.RawOffset + (firstThunkOffset ? <section>.VA)] + 2
;			Read until 00 00 byte
;           Print function name
;			jmp 2ndloop
; Increase buffer by 20 byte
; jmp 1stloop



	jmp Exit
































; Parsing Optional, Section header of 32 bit PE file
PE32bit:
	lea rcx, msg_32bit
	call printf
	jmp Exit

Exit:
	mov rcx, 0
	call ExitProcess
main endp
END