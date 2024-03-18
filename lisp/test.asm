
section .text
    global _start
    
_start:
    push ebp
    mov ebp, esp
    jmp LA1
    
strcpy:
    push ebp
    mov ebp, esp
    mov dword [ebp-4], 0 ; define i
    sub esp, 4
    
LB1:
    mov eax, dword [ebp+12] ; get src
    push eax
    mov eax, dword [ebp-4] ; get i
    push eax
    pop ebx
    pop eax
    add eax, ebx
    mov ebx, eax
    xor eax, eax
    mov al, byte [ebx]
    push eax
    push 0
    pop ebx
    pop eax
    cmp eax, ebx
    mov eax, 0
    setne al
    cmp eax, 1
    jne LA2
    mov eax, dword [ebp+12] ; get src
    push eax
    mov eax, dword [ebp-4] ; get i
    push eax
    pop ebx
    pop eax
    add eax, ebx
    mov ebx, eax
    xor eax, eax
    mov al, byte [ebx]
    mov ebx, eax
    push ebx
    mov eax, dword [ebp+8] ; get dest
    push eax
    mov eax, dword [ebp-4] ; get i
    push eax
    pop ebx
    pop eax
    add eax, ebx
    mov eax, eax
    pop ebx
    mov byte [eax], bl
    mov eax, dword [ebp-4] ; get i
    push eax
    push 1
    pop ebx
    pop eax
    add eax, ebx
    mov [ebp-4], eax ; set i
    jmp LB1
    
LA2:
    mov esp, ebp
    pop ebp
    ret
    
LA1:
    jmp LA3
    
strlen:
    push ebp
    mov ebp, esp
    mov dword [ebp-4], 0 ; define length
    sub esp, 4
    
LB2:
    mov eax, dword [ebp+8] ; get string
    push eax
    mov eax, dword [ebp-4] ; get length
    push eax
    pop ebx
    pop eax
    add eax, ebx
    mov ebx, eax
    xor eax, eax
    mov al, byte [ebx]
    push eax
    push 0
    pop ebx
    pop eax
    cmp eax, ebx
    mov eax, 0
    setne al
    cmp eax, 1
    jne LA4
    mov eax, dword [ebp-4] ; get length
    push eax
    push 1
    pop ebx
    pop eax
    add eax, ebx
    mov [ebp-4], eax ; set length
    jmp LB2
    
LA4:
    mov eax, dword [ebp-4] ; get length
    push eax
    mov esp, ebp
    pop ebp
    ret
    mov esp, ebp
    pop ebp
    ret
    
LA3:
    jmp LA5
    
print:
    push ebp
    mov ebp, esp
    mov eax, dword [ebp+8] ; get string
    push eax
    call strlen
    mov dword [ebp-4], eax ; define length
    sub esp, 4
    mov eax, dword [ebp+8] ; get string
    mov ecx, eax
    mov eax, dword [ebp-4] ; get length
    mov edx, eax
    mov ebx, 1
    mov eax, 4
    int 0x80
    mov esp, ebp
    pop ebp
    ret
    
LA5:
    
section .data
    LC1 db "   ", 0x00
    
section .text
    mov dword [ebp+4], LC1 ; define string1
    sub esp, 4
    
section .data
    LC2 db "Hey", 0x00
    
section .text
    mov dword [ebp+0], LC2 ; define string2
    sub esp, 4
    mov eax, dword [ebp+0] ; get string2
    push eax
    mov eax, dword [ebp+4] ; get string1
    push eax
    call strcpy
    mov eax, dword [ebp+4] ; get string1
    push eax
    call print
    mov esp, ebp
    pop ebp
    mov eax, 1
    mov ebx, 0
    int 0x80
    