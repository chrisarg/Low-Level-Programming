; Path: print_call.asm
; Assemble/link/run with:
; nasm -f elf64 print_call.asm
; ld -o print_call.exe print_call.o
; ./print_call.exe ; echo " Exit with status:  $? "

global _start
section .data
codes: 
    db '0123456789ABCDEF'


value:
    dq 0x0123456789ABCDEF

newline:
    db 10

print_len: equ 1    ; print a single character
field_len: equ 64   ; field length is 64 bits

section .text

print_newline:
    mov rax,1
    mov rdi, 1
    mov rdx, print_len
    mov rsi, newline
    syscall
    ret

print_hex:
    mov rax, rdi        ; hexadecimal input passed through rdi
    mov rdi, 1          ; file descriptor 1 is stdout
    mov rdx, print_len  ; print single character
    mov rcx, field_len  ; field length is 64 bits
.iterate:
    push rax
    sub rcx, 4
    sar rax, cl
    and rax, 0xF

    lea rsi, [codes+rax]
    ; prepare for syscall, need to preserve rax and rcx

    mov rax,1          ; syscall number for sys_write
    push rcx
    syscall
    pop rcx
    pop rax

    test rcx, rcx
    jnz .iterate

    ret;


_start:
    ; Print a single message
    call print_newline
    mov rdi, [value]    ; set rax to the 8 byte value we would like to print
    call print_hex
    call print_newline
    call print_newline
    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall

