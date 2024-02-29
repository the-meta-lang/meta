
section .text
    global _start

_start:
    push ebp
    mov ebp, esp
    mov eax, 0
    mov dword [ebp+16], eax
    jmp LA1
    
get_string:
    push ebp
    mov ebp, esp
    mov eax, dword [ebp+16]
    cmp eax, ebx
    je LA2
    mov eax, 1
    jmp LB2
    
LA2:
    mov eax, 0
    
LB2:
    cmp eax, 0
    je LA3
    
section .data
    LC1 db "Hello", 0x00
    
section .text
    mov edi, LC1
    call print
    jmp LB3
    
LA3:
    
section .data
    LC2 db "World!", 0x00
    
section .text
    mov edi, LC2
    call print
    
LB3:
    pop ebp
    ret
    
LA1:
    call get_string
    jmp LA4
    
print:
    push ebp
    mov ebp, esp
    mov dword [ebp+16], edi
    mov eax, 4 ; syscall: sys_write
    mov ebx, 1 ; file descriptor: STDOUT
    mov ecx, edi ; string to write
    mov edx, 0 ; length will be determined dynamically
    .calculate_length:
    cmp byte [ecx + edx], 0 ; check for null terminator
    je  .end_calculate_length
    inc edx
    jmp .calculate_length
    .end_calculate_length:
    int 0x80 ; invoke syscall
    pop ebp
    ret
    
LA4:
    pop ebp
    mov eax, 1
    mov ebx, 0
    int 0x80
    
