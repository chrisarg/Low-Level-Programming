; Path: print_rax.asm
; Assemble/link/run with:
; nasm -f elf64 print_rax.asm
; ld -o print_rax.exe print_rax.o
; ./print_rax.exe ; echo " Exit with status:  $? "

global _start
section .data
codes: 
    db '0123456789ABCDEF'

value:
    dq 0x123456789ABCDEF0

newline:
    db 10

print_len: equ 1    ; print a single character
field_len: equ 64   ; field length is 64 bits

section .text
_start:
    ; Print a single message
    mov rax, [value]    ; set rax to the 8 byte value we would like to print
    mov rdi, 1          ; file descriptor 1 is stdout
    mov rdx, print_len  ; print single character
    mov rcx, field_len  ; field length is 64 bits

.loop:
    push rax
    sub rcx, 4
    sar rax, cl
    and rax, 0xF

    lea rsi, [codes+rax]
    ; prepare for syscall, need to preserve rax and rcx
    mov rax,1          ; syscall number for sys_write
    push rcx
    syscall

    ; no need to restore rax and rcx
    mov rsi,newline       ; print a newline
    syscall
    ; restore rax and rcx
    pop rcx
    pop rax

    test rcx, rcx
    jnz .loop

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall

