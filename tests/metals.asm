section .data
	value db "Hello", 0x00
section .bss
	array resb 512
section .text
    global _start
    
_start:
    jmp LA1
    
pushArray:
    push ebp
    mov ebp, esp
    mov dword [ebp-4], esi
    mov dword [ebp-8], edi
    mov eax, dword [ebp-4] ; get ptrArray
    mov eax, dword [eax]
    mov eax, eax
    mov dword [ebp-12], eax
    mov eax, 0
    mov dword [ebp-16], eax
    mov ecx, dword [ebp-4] ; get ptrArray
    mov ebx, dword [ebp-12] ; get length
    mov eax, ecx
    add eax, ebx
    mov ebx, 4
    add eax, ebx
    mov eax, eax
    mov dword [ebp-20], eax
    
LA2:
    mov ecx, dword [ebp-8] ; get value
    mov ebx, dword [ebp-16] ; get i
    mov eax, ecx
    add eax, ebx
    mov ebx, 0
    cmp eax, ebx
    mov eax, 0
    setne al
    cmp al, 1
    jne LB1
    mov ecx, dword [ebp-20] ; get end
    mov ebx, dword [ebp-16] ; get i
    mov eax, ecx
    add eax, ebx
    mov eax, eax
    push eax
    mov ecx, dword [ebp-8] ; get value
    mov ebx, dword [ebp-16] ; get i
    mov eax, ecx
    add eax, ebx
    mov eax, eax
    mov ebx, eax
    xor eax, eax
    mov al, byte [ebx]
    pop eax
    mov ebx, eax
    mov dword [eax], ebx
    mov ecx, dword [ebp-16] ; get i
    mov ebx, 1
    mov eax, ecx
    add eax, ebx
    mov eax, dword [ebp-16] ; get i
    mov ebx, eax
    mov dword [eax], ebx
    jmp LA2
    
LB1:
    mov ecx, dword [ebp-12] ; get length
    mov ebx, dword [ebp-16] ; get i
    mov eax, ecx
    add eax, ebx
    mov eax, dword [ebp-4] ; get ptrArray
    mov ebx, eax
    mov dword [eax], ebx
    mov esp, ebp
    pop ebp
    ret
    
LA1:
		mov esi, array
		mov edi, value
		call pushArray
exit:
    push ebp
    mov ebp, esp
    mov eax, 1
    mov ebx, dword [ebp+8]
    int 0x80