; cond.asm

section .text
global _start
extern show_registers
_start:
    mov rbx, 12
    mov r12, 13
    cmp rbx, r12
    jg greater
    jl inferior 
    je equal

greater:
    mov rdi, 1  ; Si rbx > r12, définir rdi à 1
    mov rax, 60 ; Syscall pour exit
    syscall

inferior:
    mov rdi, -1 ; Si rbx < r12, définir rdi à -1
    mov rax, 60 ; Syscall pour exit
    syscall

equal:
    mov rdi, 0  ; Si les valeurs sont égales, définir rdi à 0
    mov rax, 60 ; Syscall pour exit
    syscall