; registers.asm
; registres, chevauchements
section .text
global _start
extern show_registers
_start:
	mov rbx, 2
	mov r12, 10
	mov r13, 0
	mov r14, 0
	; après initialisation
	; rbx : 2, r12 : 10, r13 : 0, r14 : 0
	call show_registers
	add rbx, r12
	; après addition sur 64 bits
	; rbx : 12, r12 : 10, r13 : 0, r14 : 0
	call show_registers
	add bl, 2
	; après addition sur 8 bits
	; rbx : 14, r12 : 10, r13 : 0, r14 : 0
	call show_registers
	mov ebx, 256
	; après copie sur 32 bits
	; rbx : 256, r12 : 10, r13 : 0, r14 : 0
	call show_registers
    mov rax, 0
	mov al,  bh
	mov r13, rax
	; après copie sur 8 bits
	; rbx : 256, r12 : 10, r13 : 1, r14 : 0
	call show_registers
	add bh, 1
	; après addition sur 8 bits
	; rbx : 512, r12 : 10, r13 ; 1, r14 : 0
	call show_registers
	mov rax, 60
	mov rdi, 0
	syscall
