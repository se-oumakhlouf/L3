section .text
global carre

carre:
    push rbp
    mov rbp, rsp

    mov rdi, r12
    imul rdi, rdi
    mov rax, rdi

    mov rsp, rbp
    pop rbp
    ret
