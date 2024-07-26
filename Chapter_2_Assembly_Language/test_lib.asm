; Path: test_lib.asm
; Assemble/link/run with:
; nasm -f elf64 test_lib.asm
; ld -o test_lib.exe test_lib.o
; ./test_lib.exe ; echo " Exit with status:  $? "

%include "io_lib.inc"  ; include the io_lib.inc file
section .data
string1: db 'Hello, World!', 0
len1: equ $-string1
string2: db 'Hello, World#',0
len2: equ $-string2

string3: db 'String equality test yielded : ',0
string4: db 'Enter a single character : ',0
string5: db 'Read character : ',0
string6: db 'String length : ',0
string7: db 'Buffer length : ',0
string8: db 'Copy buffer returned : ',0
global _start
section .text
_start:
    ;--------------------------------------------------------------------------
    ; Print a single message
    mov rdi, string1    ; address of the message
    ; find the length and save it in the stack for latter use 
    call string_length
    call print_string
    call print_newline
    ;--------------------------------------------------------------------------
    ; print a single character
    mov rdi, 'W'
    call print_char
    call print_newline
    ;--------------------------------------------------------------------------
    ; print an unsigned number
    mov rdi,2507234        ; print this number
    call print_uint
    call print_newline
    ;--------------------------------------------------------------------------
    ; print a negative number   
    mov rdi, -098765
    call print_int
    call print_newline
    ;--------------------------------------------------------------------------
    ; test 2 strings for equality - same address location
    mov rdi, string1
    mov rsi, string1
    call string_equals
    push rax

    mov rdi, string3
    call print_string

    pop rdi
    call print_uint
    call print_newline
    ;--------------------------------------------------------------------------
    ; different strings
    mov rdi, string1
    mov rsi, string2
    call string_equals
    push rax

    mov rdi, string3
    call print_string

    pop rdi
    call print_uint
    call print_newline
    ; -------------------------------------------------------------------------
    ; test reading a single character
    mov rdi, string4
    call print_string

    call read_char
    push rax

    mov rdi, string5
    call print_string

    pop rdi
    call print_char 
    call print_newline
    ;--------------------------------------------------------------------------
    ; string copy - large buffer
    mov rdi, string1
    push rdi
    push 100                ; buffer length
    call string_length
    push rax
    mov rdi, string6
    call print_string
    pop rdi
    call print_uint    ; print string length
    call print_newline

    mov rdi, string7
    call print_string
    mov rdi, [rsp]      ; don't pop the size yet
    call print_uint
    call print_newline

    pop rdx             ; string buffer size
    pop rdi             ; string
    mov rsi, rsp        ; beginning of buffer in stack
    sub rsp, rdx        ; reserve size in stack

   call string_copy
    push rax            ; return value of string_copy
    mov rdi, string8
    call print_string
    mov rdi,[rsp]
    call print_uint 
    call print_newline
    pop rdi
    test rdi,rdi
    jz .outofhere
    call print_string
    call print_newline
    .outofhere
     ;--------------------------------------------------------------------------
    ; string buffer - short buffer
    mov rdi, string1
    push rdi
    push 5                ; buffer length
    call string_length
    push rax
    mov rdi, string6
    call print_string
    pop rdi
    call print_uint    ; print string length
    call print_newline

    mov rdi, string7
    call print_string
    mov rdi, [rsp]      ; don't pop the size yet
    call print_uint
    call print_newline

    pop rdx             ; string buffer size
    pop rdi             ; string
    mov rsi, rsp        ; beginning of buffer in stack
    sub rsp, rdx        ; reserve size in stack

    call string_copy
    push rax            ; return value of string_copy
    mov rdi, string8
    call print_string
    mov rdi,[rsp]
    call print_uint 
    call print_newline
    pop rdi
    test rdi,rdi
    jz .outofhere1
    call print_string
    call print_newline
    .outofhere1
    ;--------------------------------------------------------------------------
    ; exit now
    mov rdi,1
    call exit

