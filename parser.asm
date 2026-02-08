section .data
    filename db "./main.exe", 0

    msg_not_pe db "Not a PE file", 0
    msg_not_pe_len equ $ - msg_not_pe
    msg_is_pe db "Is a PE file", 0
    msg_is_pe_len equ $ - msg_is_pe
section .bss
    dos_magic resb 2
    e_lfanew resb 4
    pe_magic resb 4

    optional_header_offset resb 4
    file_bit resb 2
section .text
    global _start

_start:
    ;read file
    mov rax, 2
    mov rdi, filename
    mov rsi, 0
    mov rdx, 0
    syscall

    ;get dos magic
    mov rdi, rax
    mov rax, 0
    mov rsi, dos_magic
    mov rdx, 2
    syscall

    ;pe file check
    cmp word [dos_magic], 0x5A4D
    jnz fail
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_is_pe
    mov rdx, msg_is_pe_len
    syscall

;getting NT header
    ;set file offset to e_lfanew
    mov rax, 8
    mov rdi, 3
    mov rsi, 0x3C
    mov rdx, 0
    syscall
    ;read NT header offset
    mov rax, 0
    mov rdi, 3
    mov rsi, e_lfanew
    mov rdx, 4
    syscall
    ;set file offset to NT header
    mov rax, 8
    mov rsi, [e_lfanew]
    mov rdi, 3
    mov rdx, 0
    syscall
    ;read the NT header
    mov rax, 0
    mov rdi, 3
    mov rsi, pe_magic
    mov rdx, 4
    syscall
    cmp dword [pe_magic], 0x00004550
    jnz fail

;Checking 32 or 64 bit
    ;set offset to after 4 byte (PE magic)
    mov eax, [e_lfanew]
    add eax, 24
    mov [optional_header_offset], eax
    mov rax, 8
    mov rdi, 3
    mov rsi, [optional_header_offset]
    mov rdx, 0
    syscall
    ;read the file bit
    mov rax, 0
    mov rdi, 3
    mov rsi, file_bit
    mov rdx, 2
    syscall
    cmp word [file_bit], 0x020B

    jmp exit

fail:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_not_pe
    mov rdx, msg_not_pe_len
    syscall
    jmp exit

exit:
    mov rax, 60
    mov rdi, 0
    syscall