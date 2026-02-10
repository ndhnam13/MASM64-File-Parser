ExitProcess proto
CreateFileA proto
ReadFile  proto
SetFilePointer proto
extrn printf:proc

.data
	;Strings
	path BYTE ".\sample.exe", 0

	msg_dosheader db "DOS HEADER:", 10, 0
	msg_dosheader_magic db 9, "Magic: 0x%X", 10, 0
	msg_dosheader_e_lfanew db 9, "File address of new exe header: 0x%X", 10, 0

	msg_ntheader db "NT HEADER:", 10, 0
	msg_ntheader_signature db 9, "PE Signature: 0x%X", 10, 0

	;Others
	SIZEOF_IMAGE_FILE_HEADER dd 18h
.data?
	;Others
	hFile QWORD ?

	;DOS header
	e_magic WORD ?
	e_lfanew DWORD ?
	
	;NT header
	Signature DWORD ?

	;Optional header
	Magic WORD ?

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

	;Read file architecture (Magic)
	mov rcx, hFile
	mov edx, e_lfanew
	add edx, SIZEOF_IMAGE_FILE_HEADER
	mov r8, 0
	mov r9, 0
	call SetFilePointer
	mov rcx, hFile
	lea rdx, Magic
	mov r8, 2
	mov r9, 0
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
	;Print info of NT header
	lea rcx, msg_ntheader
	call printf
	lea rcx, msg_ntheader_signature
	mov edx, Signature
	call printf
	
	;Check file architecture (Magic)
	cmp [Magic], 020Bh
	jnz PE32bit


; Parsing Optional, Section header of 64 bit PE file
PE64bit:
	mov rax, 2
	jmp Exit



; Parsing Optional, Section header of 32 bit PE file
PE32bit:
	mov rax, 1
	jmp Exit

Exit:
	mov rcx, 0
	call ExitProcess
main endp
END