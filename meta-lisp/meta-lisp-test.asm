
section .text
    global _start
    
_start:
    push ebp
    mov ebp, esp
    
section .bss
    ptr_wilderness resb 4
    
section .text
    
section .bss
    ptr_bss_end resb 4
    
section .text
    
section .bss
    fbin resb 4
    
section .text
    jmp LA1
    
premalloc:
    push ebp
    mov ebp, esp
    mov dword [ebp-16], edi ; use space
    mov dword [ptr_wilderness], fbin + 8
    mov dword [ptr_bss_end], fbin + 8
    mov ebx, edi
    add ebx, [ptr_bss_end]
    mov eax, 0x2d
    int 0x80
    add dword [ptr_bss_end], edi
    pop ebp
    ret
    
LA1:
    jmp LA2
    
free:
    push ebp
    mov ebp, esp
    mov dword [ebp-16], edi ; use pt
    mov ebx, [fbin]
    mov [edi - 4], ebx
    mov [fbin], edi
    pop ebp
    ret
    
LA2:
    jmp LA3
    
malloc:
    push ebp
    mov ebp, esp
    mov dword [ebp-16], edi ; use size
    mov edx, [ptr_wilderness]
    test edx, edx
    je .error
    add edi, 8
    mov eax, [fbin]
    mov ebx, fbin + 4
    .size_check_loop:
    test eax, eax
    je .check_wilderness
    cmp edi, [eax - 8]
    jg .no_fit
    mov dword [eax - 8], edi
    mov ecx, [eax - 4]
    mov dword [ebx - 4], ecx
    jmp .return
    .no_fit:
    mov ebx, eax
    mov eax, [eax - 4]
    jmp .size_check_loop
    .check_wilderness:
    mov eax, [ptr_bss_end]
    sub eax, [ptr_wilderness]
    cmp eax, edi
    jge .set_meta
    sub edi, eax
    mov ebx, edi
    add ebx, [ptr_bss_end]
    mov eax, 0x2d
    int 0x80
    add dword [ptr_bss_end], edi
    .set_meta:
    mov dword [edx], edi
    add [ptr_wilderness], edi
    mov eax, edx ; move edx
    add eax, 8
    .return:
    pop ebp
    ret
    .error:
    xor eax, eax
    jmp .return
    pop ebp
    ret
    
LA3:
    mov edi, 0
    call premalloc
    mov edi, 20
    call malloc
    
section .data
    memory dd 0x00
    
section .text
    mov [memory], eax
    jmp LA4
    
printf:
    push ebp
    mov ebp, esp
    mov dword [ebp-16], edi ; use str
    mov dword [ebp-20], esi ; use value
    mov eax, 0
    mov dword [ebp-24], eax ; define last_was_percent
    mov eax, 0
    mov dword [ebp-28], eax ; define i
    
LA5:
    mov eax, dword [ebp-16] ; use str
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
    jne LA6
    mov eax, 0
    jmp LB6
    
LA6:
    mov eax, 1
    
LB6:
    cmp eax, 0 ; while
    je LB5
    mov eax, dword [ebp-16] ; use str
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
    mov dword [ebp-32], eax ; define char
    mov eax, dword [ebp-32] ; use char
    push eax
    mov ebx, 37
    push ebx
    pop ebx
    pop eax
    cmp eax, ebx
    je LA7
    mov eax, 0
    jmp LB7
    
LA7:
    mov eax, 1
    
LB7:
    cmp eax, 0
    je LA8
    mov eax, 1
    mov dword [ebp-24], eax ; set last_was_percent
    
LA8:
    mov eax, dword [ebp-24] ; use last_was_percent
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    cmp eax, ebx
    je LA9
    mov eax, 0
    jmp LB9
    
LA9:
    mov eax, 1
    
LB9:
    cmp eax, 0
    je LA10
    mov eax, dword [ebp-32] ; use char
    push eax
    mov ebx, 115
    push ebx
    pop ebx
    pop eax
    cmp eax, ebx
    je LA11
    mov eax, 0
    jmp LB11
    
LA11:
    mov eax, 1
    
LB11:
    cmp eax, 0
    je LA12
    mov edi, dword [ebp-20] ; use value
    call printm
    
LA12:
    mov eax, dword [ebp-32] ; use char
    push eax
    mov ebx, 100
    push ebx
    pop ebx
    pop eax
    cmp eax, ebx
    je LA13
    mov eax, 0
    jmp LB13
    
LA13:
    mov eax, 1
    
LB13:
    cmp eax, 0
    je LA14
    mov edi, dword [ebp-20] ; use value
    call printi
    
LA14:
    
LA10:
    mov eax, dword [ebp-28] ; use i
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [ebp-28], eax ; set i
    jmp LA5
    
LB5:
    pop ebp
    ret
    
LA4:
    jmp LA15
    
memwritestring:
    push ebp
    mov ebp, esp
    mov dword [ebp-32], edi ; use address
    mov dword [ebp-36], esi ; use str
    mov dword [ebp-40], edx ; use offset
    mov eax, 0
    mov dword [ebp-44], eax ; define i
    
LA16:
    mov eax, dword [ebp-36] ; use str
    push eax
    mov ebx, dword [ebp-44] ; use i
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
    jne LA17
    mov eax, 0
    jmp LB17
    
LA17:
    mov eax, 1
    
LB17:
    cmp eax, 0 ; while
    je LB16
    mov eax, dword [ebp-32] ; use address
    push eax
    mov eax, dword [ebp-44] ; use i
    push eax
    mov ebx, dword [ebp-40] ; use offset
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov edi, eax
    mov eax, dword [ebp-36] ; use str
    push eax
    mov ebx, dword [ebp-44] ; use i
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    push ebx
    mov ebx, eax
    xor eax, eax
    mov al, byte [ebx]
    pop ebx
    mov esi, eax
    call memwrite
    mov eax, dword [ebp-44] ; use i
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [ebp-44], eax ; set i
    jmp LA16
    
LB16:
    mov eax, dword [ebp-44] ; use i
    pop ebp
    ret
    pop ebp
    ret
    
LA15:
    jmp LA18
    
memwrite:
    push ebp
    mov ebp, esp
    mov dword [ebp-44], edi ; use address
    mov dword [ebp-48], esi ; use value
    mov [edi], esi
    pop ebp
    ret
    
LA18:
    jmp LA19
    
printi:
    push ebp
    mov ebp, esp
    mov dword [ebp-48], edi ; use num
    mov edi, 10
    call malloc
    mov dword [ebp-52], eax ; define space
    mov eax, 0
    mov dword [ebp-56], eax ; define i
    mov eax, 0
    mov dword [ebp-60], eax ; define length
    
LA20:
    mov eax, dword [ebp-48] ; use num
    push eax
    mov ebx, 0
    push ebx
    pop ebx
    pop eax
    cmp eax, ebx
    jne LA21
    mov eax, 0
    jmp LB21
    
LA21:
    mov eax, 1
    
LB21:
    cmp eax, 0 ; while
    je LB20
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
    call memwrite
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
    jmp LA20
    
LB20:
    mov eax, 0
    mov dword [ebp-68], eax ; define j
    
LA22:
    mov eax, dword [ebp-56] ; use i
    push eax
    mov ebx, 0
    push ebx
    pop ebx
    pop eax
    cmp eax, ebx
    jge LA23
    mov eax, 0
    jmp LB23
    
LA23:
    mov eax, 1
    
LB23:
    cmp eax, 0 ; while
    je LB22
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
    mov ecx, eax ; asm/mov
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
    jmp LA22
    
LB22:
    mov edi, dword [ebp-52] ; use space
    call free
    pop ebp
    ret
    
LA19:
    jmp LA24
    
printm:
    push ebp
    mov ebp, esp
    mov dword [ebp-68], edi ; use pt
    mov eax, 0
    mov dword [ebp-72], eax ; define i
    
LA25:
    mov eax, dword [ebp-68] ; use pt
    push eax
    mov ebx, dword [ebp-72] ; use i
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
    jne LA26
    mov eax, 0
    jmp LB26
    
LA26:
    mov eax, 1
    
LB26:
    cmp eax, 0 ; while
    je LB25
    mov eax, dword [ebp-72] ; use i
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [ebp-72], eax ; set i
    jmp LA25
    
LB25:
    mov eax, dword [ebp-72] ; use i
    mov edx, eax ; asm/mov
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    int 0x80
    pop ebp
    ret
    
LA24:
    mov edi, 4096
    call malloc
    
section .data
    buffer dd 0x00
    
section .text
    mov [buffer], eax
    
section .data
    LC1 db "%d", 0x00
    
section .text
    mov edi, LC1
    mov esi, 123456576
    call printf
    mov edi, dword [memory] ; use memory
    call free
    pop ebp
    mov eax, 1
    mov ebx, 0
    int 0x80
    