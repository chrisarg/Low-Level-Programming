section .text

; single argument, the exit code of the program passed to rdi
exit:
    mov rax, 60
    syscall
    ret

string_length:
    xor rax, rax
.loop:
    cmp byte [rdi + rax], 0
    je .done
    inc rax
    jmp .loop
.done:
    ret

print_string:
    push rdi
    call string_length  ; rax = length of string in rdi
    mov rdx, rax        ; rdx = length of string in rdi
    mov rax, 1          ; syscall number for sys_write
    pop rsi             ; addmovress of string to write
    mov rdi, 1          ; file descriptor 1 is stdout
    syscall
    ret


print_char:
    push rdi
    mov rsi, rsp

    mov rax, 1          ; syscall number for sys_write
    mov rdi, 1          ; file descriptor 1 is stdout
    mov rdx, 1          ; number of bytes to write
    syscall
    pop rdi
    ret

print_newline:
    mov rdi, 0xA
    jmp print_char      ; reuse print char code

; prints an unsigned 8 byte integer to stdout as a string
print_uint:
    mov rax, rdi
    mov r8,10
    ; maximum value of an 8 byte integer is 18446744073709551615
    ; 20 characters are needed to represent this number + 1 for null terminator
    ; so allocate 24 bytes in the stack
    mov rdi,rsp         ; current position of the stack
    push 0
    sub rsp, 16         ; a total of 24 bytes have now been allocated in the stack
    dec rdi             ; 
    .loop:
        xor rdx, rdx
        div r8
        add dl,'0'
        dec rdi
        mov [rdi], dl
        test rax,rax
        jnz .loop
    call print_string
    add rsp,24
    ret


print_int:
    test rdi, rdi
    jns print_uint
    push rdi
    mov rdi, '-'
    call print_char
    pop rdi
    neg rdi
    call print_uint

    ret

; test two strings passed as pointers for equality
string_equals:
        mov al,  byte [rdi]
        cmp  al, byte [rsi]
        jnz .notequal
        inc rdi
        inc rsi
        test al, al ; end of string ?
        jnz string_equals
        mov rax,1
    ret
    .notequal
        xor rax,rax
    ret


read_char:
    xor rax, rax    ; 0 syscall code
    xor rdi, rdi    ; 0 for stdin
    push 0          ; create space in the stack to store the character
    mov rsi, rsp    ; get the address
    mov rdx, 1      ; read one character
    syscall
    pop rax         ; return the character that was just read
    ret 

read_word:
    ret

; rdi points to a string
; returns rax: number, rdx : length
parse_uint:
    xor rax, rax
    ret

; rdi points to a string
; returns rax: number, rdx : length
parse_int:
    xor rax, rax
    ret 

; RDI : string, RSI: buffer location, RDX : buffer size 
string_copy:
    call string_length ; RAX has string length
    dec rax
    cmp rdx,rax
    ja .largebuffer
    xor rax,rax
    ret
    .largebuffer
    mov rax,rsi
    .loop
        mov cl, byte [rdi]
        mov byte [rsi], cl
        inc rdi
        inc rsi
        test cl,cl
        jnz .loop
    ret