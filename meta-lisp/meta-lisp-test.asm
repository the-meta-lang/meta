section .text
    global _start
    
_start:
    push ebp
    mov ebp, esp
    jmp LA1
    
crc32:
    push ebp
    mov ebp, esp
    mov dword [ebp-16], edi ; use input
    mov eax, 3988292384
    mov dword [ebp-20], eax ; define divisor
    mov eax, 4294967295
    mov dword [ebp-24], eax ; define crc
    mov eax, 0
    mov dword [ebp-28], eax ; define i
    
LA2:
    mov eax, dword [ebp-16] ; use input
    push eax
    mov ebx, dword [ebp-28] ; use i
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    push ebx
    mov ebx, eax
    xor eax, eax
    mov al, byte [ebx]
    pop ebx
    push eax
    mov ebx, 0
    push ebx
    pop ebx
    pop eax
    cmp eax, ebx
    jne LA3
    mov eax, 0
    jmp LB3
    
LA3:
    mov eax, 1
    
LB3:
    cmp eax, 0 ; while
    je LB2
    mov eax, dword [ebp-16] ; use input
    push eax
    mov ebx, dword [ebp-28] ; use i
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    push ebx
    mov ebx, eax
    xor eax, eax
    mov al, byte [ebx]
    pop ebx
    mov dword [ebp-32], eax ; define byte
    mov edi, dword [ebp-24] ; use crc
    mov esi, dword [ebp-32] ; use byte
    call xor
    mov dword [ebp-24], eax ; set crc
    mov eax, 0
    mov dword [ebp-36], eax ; define j
    
LA4:
    mov eax, dword [ebp-36] ; use j
    push eax
    mov ebx, 8
    push ebx
    pop ebx
    pop eax
    cmp eax, ebx
    jne LA5
    mov eax, 0
    jmp LB5
    
LA5:
    mov eax, 1
    
LB5:
    cmp eax, 0 ; while
    je LB4
    mov edi, dword [ebp-24] ; use crc
    mov esi, 1
    call and
    cmp eax, 0
    je LA6
    mov edi, dword [ebp-24] ; use crc
    mov esi, 1
    call zfrs
    mov edi, eax
    mov esi, dword [ebp-20] ; use divisor
    call xor
    mov dword [ebp-24], eax ; set crc
    jmp LB6
    
LA6:
    mov edi, dword [ebp-24] ; use crc
    mov esi, 1
    call zfrs
    mov dword [ebp-24], eax ; set crc
    
LB6:
    mov eax, dword [ebp-36] ; use j
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [ebp-36], eax ; set j
    jmp LA4
    
LB4:
    mov eax, dword [ebp-28] ; use i
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [ebp-28], eax ; set i
    jmp LA2
    
LB2:
    mov edi, dword [ebp-24] ; use crc
    mov esi, 4294967295
    call xor
    pop ebp
    ret
    pop ebp
    ret
    
LA1:
    jmp LA7
    
xor:
    push ebp
    mov ebp, esp
    mov dword [ebp-24], edi ; use num1
    mov dword [ebp-28], esi ; use num2
    xor edi, esi
    mov eax, edi
    pop ebp
    ret
    
LA7:
    jmp LA8
    
zfrs:
    push ebp
    mov ebp, esp
    mov dword [ebp-12], edi ; use num1
    mov dword [ebp-16], esi ; use num2
    mov eax, esi
    mov cl, al
    shr edi, cl
    mov eax, edi
    pop ebp
    ret
    
LA8:
    jmp LA9
    
and:
    push ebp
    mov ebp, esp
    mov dword [ebp-12], edi ; use num1
    mov dword [ebp-16], esi ; use num2
    and edi, esi
    mov eax, edi
    pop ebp
    ret
    
LA9:
    
section .data
    LC1 db "Hello", 0x00
    
section .text
    mov edi, LC1
    call crc32
    pop ebp
    mov eax, 1
    mov ebx, 0
    int 0x80