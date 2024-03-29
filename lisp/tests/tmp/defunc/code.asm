
section .text
    global _start
    
_start:
    push ebp
    mov ebp, esp
    jmp LA1
    
derefb:
    push ebp
    mov ebp, esp
    mov ebx, dword [ebp+8]
    xor eax, eax
    mov al, byte [ebx]
    mov esp, ebp
    pop ebp
    ret
    
LA1:
    jmp LA2
    
println:
    push ebp
    mov ebp, esp
    mov dword [ebp-4], 0 ; define length
    sub esp, 4
    
LB1:
    mov eax, dword [ebp+8] ; get string
    mov ebx, dword [ebp-4] ; get length
    
    
    add eax, ebx
    push eax
    
    call derefb
    pop edi
    mov ebx, 0
    
    cmp eax, ebx
    mov eax, 0
    setne al
    cmp eax, 1
    jne LA3
    mov eax, dword [ebp-4] ; get length
    mov ebx, 1
    
    add eax, ebx
    mov [ebp-4], eax ; set 
    jmp LB1
    
LA3:
    mov eax, 4
    mov ebx, 1
    mov ecx, dword [ebp+8]
    mov edx, dword [ebp-4]
    int 0x80
    mov esp, ebp
    pop ebp
    ret
    
LA2:
    jmp LA4
    
sayHello:
    push ebp
    mov ebp, esp
    
section .data
    LC1 db "Hello, World!", 0x00
    
section .text
    push LC1
    
    call println
    pop edi
    mov esp, ebp
    pop ebp
    ret
    
LA4:
    call sayHello
    mov esp, ebp
    pop ebp
    mov ebx, eax
    mov eax, 1
    int 0x80
    