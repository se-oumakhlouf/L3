; little_endian.asm
; INVERSION en mémoire, big endian en registre
section .data
seq_numbers: dw 1, 2, 6, 3, 4, 22, 10, 0
; 0000 0000 0000 00001 | 0000 0001 0000 0000
; dw : 'typage' sur 2 octets
; seq_numbers: pointeur sur le premier octet
; [0000 0000] [0001 0100] = 22 (big endian) -> [0001 0100] [0000 0000] = 22 (little endian)
section .text
global _start
extern show_registers
_start:
    mov rbx, 0
    mov r12, seq_numbers
    mov r13, 5
    mov r14, 0
    mov bl, byte [r12+r13*2]
    ; décalage de 0 + 10
    ; après copie sur 1 octet
    ; rbx : 22, r14 : 0
    call show_registers
    mov r14d, dword [r12+2]
    ; dword : 4 octets
    ; décalage de 2 octets (sachant qu'une case fait 2 octets), prend 2 et 6 car dword 4 octets
    ; on  a [0000 0010] [0000 0000] [0110 0000] [0000 0000]
    ; après copie sur 4 octets
    ; r14 : 0000 0000 | 0000 0000 | 0000 0000 | 0000 0000 | 
    ;       0000 0000 | 0000 0110 | 0000 0000 | 0000 0010 
    ; rbx : 22, r14 : 393 218
    call show_registers
    mov rax, 60
    mov rdi, 0
    syscall
