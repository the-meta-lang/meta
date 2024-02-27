section .text
    global _start
    
_start:
    jmp LB1
    
fibonacci:
    
section .data
    num dd 0x00
    
section .text
    pop ebp
    pop eax
    mov [num], eax
    push dword [num]
    push 4
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    push ebp
    ret
    
LB1:
    push 4
    call fibonacci
    mov eax, 4
    mov ebx, 1
    int 0x80