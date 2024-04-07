
section .text
    global _start
    
_start:
    push ebp
    mov ebp, esp
    jmp LA1
    
addnum:
    push ebp
    mov ebp, esp
    mov dword [ebp-4], 1 ; define q
    sub esp, 4
    mov dword [ebp-8], 1 ; define k
    sub esp, 4
    mov dword [ebp-12], 1 ; define p
    sub esp, 4
    push dword [ebp+8] ; get a
    push dword [ebp+12] ; get b
    push dword [ebp+16] ; get c
    push dword [ebp-8] ; get k
    pop ebx
    pop eax
    add eax, ebx
    push eax
    pop ebx
    pop eax
    add eax, ebx
    push eax
    pop ebx
    pop eax
    add eax, ebx
    push eax
    mov esp, ebp
    pop ebp
    ret
    
LA1:
    jmp LA2
    
main:
    push ebp
    mov ebp, esp
    mov dword [ebp-4], 1 ; define x
    sub esp, 4
    push 8
    push 7
    push dword [ebp-4]
    push 5
    call addnum
    add esp, 16
    push eax
    
    push 3
    push dword [ebp-4]
    push 1
    call addnum
    add esp, 16
    mov esp, ebp
    pop ebp
    ret
    
LA2:
    call main
    add esp, 0
    mov esp, ebp
    pop ebp
    mov ebx, eax
    mov eax, 1
    int 0x80
    
