section .text
global _start
extern show_registers
extern carre

_start:
    mov r12, 120
    mov r13, 0
    mov r14, 0

    call carre
    mov rbx, rax
    call show_registers

    mov rax, 60
    mov rdi, 0
    syscall



