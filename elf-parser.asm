CreateFileA Proto
ReadFile Proto
GetFileSizeEx Proto
VirtualAlloc Proto
ExitProcess Proto
extern printf:proc

.data
;Strings 
	path db "sample", 0
	msg_readfilefail db "FAILED TO READ FILE", 10, 0
	msg_notelf db "FILE IS NOT AN ELF FILE", 10, 0
	msg_fail db "PARSING FAILED", 10, 0
	msg_32bit db 9, "**FILE IS 32 BIT**", 10, 0
	msg_64bit db 9, "**FILE IS 64 BIT**", 10 ,0
;Elf_Ehdr
	ELFMAGIC DWORD 464c457fh
	msg_elfheader db "1. ELF Header:", 10, 0
	msg_elfheader_elfmagic db 9, "ELF Magic: 0x%X", 10, 0
	msg_ei_class db 9, "Class (1-32Bit, 2-64Bit) :0x%X", 10, 0
	msg_ei_osabi db 9, "OSABI :0x%X", 10, 0
	msg_ei_abiversion db 9, "OSABI Version :0x%X", 10, 0
	msg_e_type db 9, "Object File Type :0x%X", 10, 0
	msg_e_machine db 9, "Architecture :0x%X", 10, 0
	msg_e_version db 9, "Object File Version :0x%X", 10, 0
	msg_e_entry db 9, "Entry point virtual address :0x%X", 10, 0
	msg_e_phoff db 9, "Program header table file offset :0x%llX", 10, 0
	msg_e_shoff db 9, "Section header table file offset :0x%llX", 10, 0
	msg_e_ehsize db 9, "ELF header size :0x%X", 10, 0
	msg_e_phentsize db 9, "Program header table entry size :0x%X", 10, 0
	msg_e_phnum db 9, "Program header table entry count :0x%X", 10, 0
	msg_e_shentsize db 9, "Section header table entry size :0x%X", 10, 0
	msg_e_shnum db 9, "Section header table entry count :0x%X", 10, 0
	msg_e_shstrndx db 9, "Section header string table index :0x%X", 10, 0
;Program Header
	msg_programheader db "2. Program Header:", 10, 0
	msg_programheader_count db 9, "- Entry %d:", 10, 0
	msg_p_type db 9, 9, "Segment type :0x%X", 10, 0
	msg_p_flags db 9, 9, "Segment flags :0x%X", 10, 0
	msg_p_offset db 9, 9, "Segment file offset :0x%llX", 10, 0
	msg_p_vaddr db 9, 9, "Segment virtual address :0x%llX", 10, 0
	msg_p_paddr db 9, 9, "Segment physical address :0x%llX", 10, 0
	msg_p_filesz db 9, 9, "Segment size in file :0x%llX", 10, 0
	msg_p_memsz db 9, 9, "Segment size in memory :0x%llX", 10, 0
	msg_p_align db 9, 9, "Segment alignment :0x%llX", 10, 0
;Section Header
	msg_sectionheader db "3. Section Header", 10 ,0
	msg_sectionheader_count db 9, "- Section %d: ", 0
	msg_sectionheader_sectionname db "%s", 10, 0
	msg_sh_name db 9, 9, "Section name index (.shstrtab index):0x%X", 10, 0
    msg_sh_type db 9, 9, "Section type :0x%X", 10, 0
    msg_sh_flags db 9, 9, "Section flags :0x%llX", 10, 0
    msg_sh_addr db 9, 9, "Section virtual addr at execution :0x%llX", 10, 0
    msg_sh_offset db 9, 9, "Section file offset :0x%llX", 10, 0
    msg_sh_size db 9, 9, "Section size :0x%llX", 10, 0
    msg_sh_link db 9, 9, "Link to another section :0x%X", 10, 0
    msg_sh_info db 9, 9, "Additional section information :0x%X", 10, 0
    msg_sh_addralign db 9, 9, "Section alignment :0x%llX", 10, 0
    msg_sh_entsize db 9, 9, "Entry size if section holds table :0x%llX", 10, 0

;Symbol table
	SHT_SYMTAB DWORD 2
	SHT_DYNSYM DWORD 0Bh
	SHT_STRTAB DWORD 3
	ST_ENTSIZE QWORD 24
	msg_symboltable db 9, 9, "* Symbol Table:", 10, 0
	msg_symboltable_symbol db 9, 9, " + Symbol %d: %s", 10, 0
	msg_st_name db 9, 9, 9, "Symbol name index (.strtab idx) :0x%X", 10, 0
    msg_st_info db 9, 9, 9, "Symbol type and binding :0x%X", 10, 0
    msg_st_other db 9, 9, 9, "Symbol visibility :0x%X", 10, 0
    msg_st_shndx db 9, 9, 9, "Section index :0x%X", 10, 0
    msg_st_value db 9, 9, 9, "Symbol value :0x%X", 10, 0
    msg_st_size db 9, 9, 9, "Symbol size :0x%X", 10, 0

.data?
;Others
	hFile QWORD ?
	FileSize QWORD ?
	lpFileBuffer QWORD ?
	CurrentOffset QWORD ?
	
;Elf_Ehdr
	ei_class DWORD ?

	e_phoff QWORD ? ;Program header offset
	e_phentsize DWORD ?; Program header entry size
	e_phnum DWORD ?; Program header entry count

	e_shoff QWORD ? ;Section header offset
	e_shentsize DWORD ? ;Section header entry size
	e_shnum DWORD ? ;Section header entry count

	e_shstrndx DWORD ? ;The index of section .shstrtab in section header

;Section header
	SectionHeaderStringTableOffset QWORD ?

;Symbol table
	StringTableOffset QWORD ?
	ST_ENTNUM QWORD ?
	

.code
main PROC
	sub rsp, 40

;Set up
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
	cmp rax, -1
	jz FailToReadFile
	;Get file size
	mov rcx, hFile
	lea rdx, FileSize
	call GetFileSizeEx
	test rax, rax
	jz ExitFail
	;Allocate buffer with file size
	mov rcx, 0
	mov rdx, FileSize
	mov r8, 00003000h
	mov r9, 4
	call VirtualAlloc
	test rax, rax
	jz ExitFail
	mov lpFileBuffer, rax
	;Read the whole file into buffer
	mov rcx, hFile
	mov rdx, lpFileBuffer
	mov r8, FileSize
	mov r9, 0
	mov DWORD PTR [rsp+20h], 0
	call ReadFile

;Move the file buffer address into rdi
	mov rdi, lpFileBuffer

	; Parsing and printing Elf indent header
	lea rcx, msg_elfheader
	call printf

	;ELFMAGIC
	lea rcx, msg_elfheader_elfmagic
	mov edx, DWORD PTR [rdi]
	cmp edx, ELFMAGIC
	jnz NotElf
	call printf
	;ei_class
    lea rcx, msg_ei_class
    movzx edx, BYTE PTR [rdi+4]
	mov ei_class, edx
    call printf
    ;ei_osabi
    lea rcx, msg_ei_osabi
    movzx edx, BYTE PTR [rdi+7]
    call printf
    ;ei_abiversion
    lea rcx, msg_ei_abiversion
    movzx edx, BYTE PTR [rdi+8]
    call printf
	;Check file bit
	cmp ei_class, 1
	je Parse32Bit
Parse64Bit: ;Structure size after ELF indent header of 32 and 64Bit is different 
	lea rcx, msg_64bit
	call printf
;Parsing and printing the remaining of Elf header
    ;e_type
    lea rcx, msg_e_type
    movzx edx, WORD PTR [rdi+10h]
    call printf
    ;e_machine
    lea rcx, msg_e_machine
    movzx edx, WORD PTR [rdi+12h]
    call printf
    ;e_version
    lea rcx, msg_e_version
    mov edx, DWORD PTR [rdi+14h]
    call printf
    ;e_entry
    lea rcx, msg_e_entry
    mov rdx, QWORD PTR [rdi+18h]
    call printf
    ;e_phoff + Save the PH offset
    lea rcx, msg_e_phoff
    mov rdx, QWORD PTR [rdi+20h]
	mov e_phoff, rdx
    call printf
    ;e_shoff + Save the SH offset
    lea rcx, msg_e_shoff
    mov rdx, QWORD PTR [rdi+28h]
	mov e_shoff, rdx
    call printf
    ;e_ehsize
    lea rcx, msg_e_ehsize
    movzx edx, WORD PTR [rdi+34h]
    call printf
    ;e_phentsize + Save the PH entry size
    lea rcx, msg_e_phentsize
    movzx edx, WORD PTR [rdi+36h]
	mov e_phentsize, edx
    call printf
    ;e_phnum + Save the PH entry count
    lea rcx, msg_e_phnum
    movzx edx, WORD PTR [rdi+38h]
	mov e_phnum, edx
    call printf
    ;e_shentsize + Save the SH entry size
    lea rcx, msg_e_shentsize
    movzx edx, WORD PTR [rdi+3Ah]
	mov e_shentsize, edx
    call printf
    ;e_shnum + Save the SH entry count
    lea rcx, msg_e_shnum
    movzx edx, WORD PTR [rdi+3Ch]
	mov e_shnum, edx
    call printf
    ;e_shstrndx
    lea rcx, msg_e_shstrndx
    movzx edx, WORD PTR [rdi+3Eh]
	mov e_shstrndx, edx
    call printf

; Parsing and printing Program header
	lea rcx, msg_programheader
	call printf


	mov rax, lpFileBuffer ; RAX has address of offset 0 of file buffer
	add rax, e_phoff ; Program header offset
	mov CurrentOffset, rax 
	; Value of CurrentOffset is now an address pointing to the program header start of file buffer

	mov r15, 0	;Counter
ParseProgramHeader64Loop:
	cmp r15d, e_phnum
	je ParseSectionHeader64

	lea rcx, msg_programheader_count
	mov edx, r15d
	call printf
	mov rbx, CurrentOffset ; rbx now is the address pointing to the program header offset of file buffer
	;p_type
    lea rcx, msg_p_type
    mov edx, DWORD PTR [rbx]
    call printf
    ;p_flags
    lea rcx, msg_p_flags
    mov edx, DWORD PTR [rbx+4]
    call printf
    ;p_offset
    lea rcx, msg_p_offset
    mov rdx, QWORD PTR [rbx+8]
    call printf
    ;p_vaddr
    lea rcx, msg_p_vaddr
    mov rdx, QWORD PTR [rbx+16]
    call printf
    ;p_paddr
    lea rcx, msg_p_paddr
    mov rdx, QWORD PTR [rbx+24]
    call printf
    ;p_filesz
    lea rcx, msg_p_filesz
    mov rdx, QWORD PTR [rbx+32]
    call printf
    ;p_memsz
    lea rcx, msg_p_memsz
    mov rdx, QWORD PTR [rbx+40]
    call printf
    ;p_align
    lea rcx, msg_p_align
    mov rdx, QWORD PTR [rbx+48]
    call printf

	inc r15
	mov rbx, CurrentOffset
	mov eax, e_phentsize
	add rbx, rax
	mov CurrentOffset, rbx
	jmp ParseProgramHeader64Loop

; Parsing and printing Section header
ParseSectionHeader64:
	lea rcx, msg_sectionheader
	call printf

	mov rax, lpFileBuffer
	add rax, e_shoff
	mov CurrentOffset, rax ;CurrentOffset now has the address of section header

	;Get the address of .shstrtab section header: lpFileBuffer + e_shoff + e_shstrndx*e_shentsize
	;Get the sh_offset value off .shstrtab section
	mov rbx, CurrentOffset
	mov eax, e_shstrndx
	mov ecx, e_shentsize
	mul ecx
	add rbx, rax
	mov rax, QWORD PTR [rbx+18h]
	mov SectionHeaderStringTableOffset, rax

	mov r15, 0 ;Counter
ParseSectionHeader64Loop:
	cmp r15d, e_shnum
	je PLACEHOLDER

	lea rcx, msg_sectionheader_count
	mov rdx, r15
	call printf
	
	mov rbx, CurrentOffset
	;Get current Section name offset:
	mov rdi, lpFileBuffer
	add rdi, SectionHeaderStringTableOffset
	mov eax, DWORD PTR [rbx] ;sh_name
	add rdi, rax

	lea rcx, msg_sectionheader_sectionname
	mov rdx, rdi
	call printf
	;sh_name
    lea rcx, msg_sh_name
    mov edx, DWORD PTR [rbx]
    call printf
    ;sh_type
    lea rcx, msg_sh_type
    mov edx, DWORD PTR [rbx+4]
    call printf
    ;sh_flags
    lea rcx, msg_sh_flags
    mov rdx, QWORD PTR [rbx+8]
    call printf
    ;sh_addr
    lea rcx, msg_sh_addr
    mov rdx, QWORD PTR [rbx+10h]
    call printf
    ;sh_offset
    lea rcx, msg_sh_offset
    mov rdx, QWORD PTR [rbx+18h]
    call printf
    ;sh_size
    lea rcx, msg_sh_size
    mov rdx, QWORD PTR [rbx+20h]
    call printf
    ;sh_link
    lea rcx, msg_sh_link
    mov edx, DWORD PTR [rbx+28h]
    call printf
    ;sh_info
    lea rcx, msg_sh_info
    mov edx, DWORD PTR [rbx+2Ch]
    call printf
    ;sh_addralign
    lea rcx, msg_sh_addralign
    mov rdx, QWORD PTR [rbx+30h]
    call printf
    ;sh_entsize
    lea rcx, msg_sh_entsize
    mov rdx, QWORD PTR [rbx+38h]
    call printf

;---;
;To get the name of symbols:
; Using sh_link (the index of the string table associated with the symbol table): 
; Each symbol tbl has an associated string table which contains the symbolic names for the symbols
	;Check if sh_type is SHT_SYMTAB || SHT_DYNSYM
SymTab64Check:
	mov edx, DWORD PTR [rbx+4] ;sh_type
	cmp edx, SHT_SYMTAB
	jnz DynSymCheck
DynSymCheck:
	cmp edx, SHT_DYNSYM
	jnz ParseSectionHeader64LoopCont
	;Get sh_link
	mov ecx, DWORD PTR [rbx+28h]
	;Get the address of .strtab || .dynstr section header: lpFileBuffer + e_shoff + sh_link*e_shentsize
	mov eax, e_shentsize
	mul ecx
	mov r8, lpFileBuffer
	mov r9, e_shoff
	add rax, r8
	add rax, r9
	;Get that string table section offset 
	mov rdx, QWORD PTR [rax+18h] ;sh_offset
	mov StringTableOffset, rdx
;---;
	lea rcx, msg_symboltable
	call printf
	;Get symbol table offset from sh_offset
	mov rdi, lpFileBuffer
	mov rdx, QWORD PTR [rbx+18h] ;sh_offset
	add rdi, rdx
	;Parse and print symbol table info
	mov r14, 0 ; 2nd Counter
	;Get symbols count: ST_ENTNUM = sh_size / ST_ENTSIZE
	mov rax, QWORD PTR [rbx+20h] ;sh_size
	mov rdx, 0
	mov rcx, ST_ENTSIZE
	div rcx
	mov ST_ENTNUM, rax
	ParseSymbolTable64Loop:
		cmp r14, ST_ENTNUM
		je ParseSectionHeader64LoopCont

		lea rcx, msg_symboltable_symbol
		mov rdx, r14
		;Get current symbol name offset
		mov rax, lpFileBuffer
		add rax, StringTableOffset
		mov ebx, DWORD PTR [rdi]
		add rax, rbx
		mov r8, rax
		call printf
		;st_name
		lea rcx, msg_st_name
		mov edx, DWORD PTR [rdi]
		call printf
		;st_info
		lea rcx, msg_st_info
		movzx edx, BYTE PTR [rdi+4]
		call printf
		;st_other
		lea rcx, msg_st_other
		movzx edx, BYTE PTR [rdi+5]
		call printf
		;st_shndx
		lea rcx, msg_st_shndx
		movzx edx, WORD PTR [rdi+6]
		call printf
		;st_value
		lea rcx, msg_st_value
		mov rdx, QWORD PTR [rdi+8]
		call printf
		;st_size
		lea rcx, msg_st_size
		mov rdx, QWORD PTR [rdi+10h]
		call printf

		inc r14
		mov rax, ST_ENTSIZE
		add rdi, rax
		jmp ParseSymbolTable64Loop

ParseSectionHeader64LoopCont:
	inc r15
	mov rax, CurrentOffset
	mov ebx, e_shentsize 
	add rax, rbx
	mov CurrentOffset, rax
	jmp ParseSectionHeader64Loop
	
PLACEHOLDER:


	jmp Exit

Parse32Bit:
	lea rcx, msg_32bit
	call printf
;Parsing and printing the remaining of Elf header

	jmp Exit


Exit:
	mov rcx, 0
	call ExitProcess

FailToReadFile:
	lea rcx, msg_readfilefail
	call printf
	jmp Exit
NotElf:
	lea rcx, msg_notelf
	call printf
	jmp Exit
ExitFail:
	lea rcx, msg_fail
	call printf 
	jmp Exit

main ENDP
END