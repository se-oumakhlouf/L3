; allocation.asm
section .data
seq_numbers: dw 2, 4, 8, 16, 32, 1, 0
section .text
global _start
extern show_registers
_start:
    mov rbx, 0
    mov r12, seq_numbers
    call show_registers
    jmp boucles

boucles:
    inc rbx
    cmp rbx, 8
    jg exit
    push [r12 + rbx]
    call show_registers
    jmp boucles


exit:
    mov rdi, 0
    mov rax, 60 ; Syscall pour exit
    syscall