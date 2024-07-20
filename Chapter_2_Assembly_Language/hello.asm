; Path: hello.asm
; Assemble/link/run with:
; nasm -f elf64 hello.asm
; ld -o hello.exe hello.o
; ./hello.exe ; echo " Wrote $? bytes "

global _start
section .data
message: db 'Hello, World!', 10
len: equ $-message
separator: db '----------------', 10
len_sep: equ $-separator
messages: times 2 db 'Hello, Gedi Prime!', 10
len_messages: equ $-messages


section .text
_start:
    ; Print a single message
    mov rax, 1          ; syscall number for sys_write
    mov rdi, 1          ; file descriptor 1 is stdout
    mov rsi, message    ; address of the message
    mov rdx, len        ; message length
    syscall

    ; Print a separator
    mov rax, 1
    mov rdi, 1
    mov rsi, separator
    mov rdx, len_sep
    syscall

    ; Print multiple messages
    mov rax, 1
    mov rdi, 1
    mov rsi, messages
    mov rdx, len_messages
    syscall

    ; Exit
    mov rax, 60
    mov rdi, len_messages+len_sep+len ; exit code = bytes written
    syscall

