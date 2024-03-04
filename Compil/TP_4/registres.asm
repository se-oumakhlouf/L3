section .data
    entier1: dd 10
    entier2: dd 22
section .text
global _start
extern show_registers

_start:
    mov ebx, dword [entier1]
    mov r12d, dword [entier2]
    mov r13, 0
    mov r14, 0
    call show_registers
    mov rax, 60
    mov rdi, 0
    syscall

swap:
    push rbp
    mov rbp, rsp

    mov rdi, r12d
    mov rsi, ebx

    mov rsp, rbp
    pop rbp
    ret

