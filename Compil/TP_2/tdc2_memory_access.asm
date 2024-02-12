; tdc2_memory_access.asm
section .data
seq_numbers: dw 1, 2, 6, 3, 4
seq_words: db "char", "pente"
section .text
global _start
extern show_registers
_start:
    mov rbx, 0
    mov r12, seq_numbers
    mov r13, 0
    mov r14, 0
    mov bx, word [r12]
    ; après initialisation
    call show_registers
    mov bx, word [r12+2]
    ; après décalage de 2 octets
    call show_registers
    mov ebx,0
    mov r13, 5
    mov bl, byte [r12+r13*2]
    ; après calcul d'adresse
    call show_registers
    mov rax, 60
    mov rdi, 0
    syscall
