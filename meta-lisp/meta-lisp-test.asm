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
    mov dword [ebp-36], edi ; use num1
    mov dword [ebp-40], esi ; use num2
    xor edi, esi
    mov eax, edi
    pop ebp
    ret
    
LA7:
    jmp LA8
    
zfrs:
    push ebp
    mov ebp, esp
    mov dword [ebp-40], edi ; use num1
    mov dword [ebp-44], esi ; use num2
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
    mov dword [ebp-44], edi ; use num1
    mov dword [ebp-48], esi ; use num2
    and edi, esi
    mov eax, edi
    pop ebp
    ret
    
LA9:
    jmp LA10
    
print_int:
    push ebp
    mov ebp, esp
    mov dword [ebp-48], edi ; use num
    
section .bss
    LC1 resb 10
    
section .text
    mov eax, LC1
    mov dword [ebp-52], eax ; define space
    mov eax, 0
    mov dword [ebp-56], eax ; define i
    mov eax, 0
    mov dword [ebp-60], eax ; define length
    
LA11:
    mov eax, dword [ebp-48] ; use num
    push eax
    mov ebx, 0
    push ebx
    pop ebx
    pop eax
    cmp eax, ebx
    jne LA12
    mov eax, 0
    jmp LB12
    
LA12:
    mov eax, 1
    
LB12:
    cmp eax, 0 ; while
    je LB11
    mov eax, dword [ebp-48] ; use num
    push eax
    mov ebx, 10
    push ebx
    pop ebx
    pop eax
    xor edx, edx
    div ebx
    mov eax, edx
    push eax
    mov ebx, 48
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [ebp-64], eax ; define mod
    mov eax, dword [ebp-52] ; use space
    push eax
    mov ebx, dword [ebp-56] ; use i
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov edi, eax
    mov esi, dword [ebp-64] ; use mod
    call memset
    mov eax, dword [ebp-48] ; use num
    push eax
    mov ebx, 10
    push ebx
    pop ebx
    pop eax
    xor edx, edx
    div ebx
    mov dword [ebp-48], eax ; set num
    mov eax, dword [ebp-56] ; use i
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [ebp-56], eax ; set i
    mov eax, dword [ebp-60] ; use length
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [ebp-60], eax ; set length
    jmp LA11
    
LB11:
    mov ebx, 0
    mov dword [ebp-68], eax ; define j
    
LA13:
    mov eax, dword [ebp-56] ; use i
    push eax
    mov ebx, 0
    push ebx
    pop ebx
    pop eax
    cmp eax, ebx
    jge LA14
    mov eax, 0
    jmp LB14
    
LA14:
    mov eax, 1
    
LB14:
    cmp eax, 0 ; while
    je LB13
    mov eax, dword [ebp-52] ; use space
    push eax
    mov ebx, dword [ebp-60] ; use length
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    push eax
    mov ebx, dword [ebp-68] ; use j
    push ebx
    pop ebx
    pop eax
    sub eax, ebx
    mov ecx, eax
    mov eax, 4
    mov ebx, 1
    mov edx, 1
    int 0x80
    mov eax, dword [ebp-68] ; use j
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [ebp-68], eax ; set j
    mov eax, dword [ebp-56] ; use i
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    sub eax, ebx
    mov dword [ebp-56], eax ; set i
    jmp LA13
    
LB13:
    pop ebp
    ret
    
LA10:
    jmp LA15
    
memget:
    push ebp
    mov ebp, esp
    mov dword [ebp-68], edi ; use mem
    mov eax, [edi]
    pop ebp
    ret
    
LA15:
    jmp LA16
    
memset:
    push ebp
    mov ebp, esp
    mov dword [ebp-68], edi ; use mem
    mov dword [ebp-72], esi ; use value
    mov [edi], esi
    pop ebp
    ret
    
LA16:
    
section .data
    LC2 db "Hello", 0x00
    
section .text
    mov edi, LC2
    call crc32
    mov edi, eax
    call print_int
    pop ebp
    mov eax, 1
    mov ebx, 0
    int 0x80