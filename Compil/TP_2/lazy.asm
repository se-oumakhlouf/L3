; lazy.asm
; does nothing
section .text
global _start
extern show_registers
_start:
	; later your code will be here
	mov rax, 60
	mov rdi, 0
	syscall
