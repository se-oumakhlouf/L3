; boucles

section .text
global _start
extern show_registers
_start:
    mov rbx, 0
    call show_registers
    jmp boucles

boucles:
    add rbx, 9
    call show_registers
    cmp rbx, 100
    jge exit
    jmp boucles

exit:
    mov rdi, 0
    mov rax, 60 ; Syscall pour exit
    syscall