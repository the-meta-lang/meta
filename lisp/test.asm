%macro sbrk 1
    mov ebx, %1
    add ebx, [ptr_bss_end]
    mov eax, 0x2d
    int 0x80
    add dword [ptr_bss_end], %1
%endmacro

%macro get_free_space 1
     mov %1, [ptr_bss_end] ; get end of program break
     sub %1, [ptr_wilderness] ; total space - used space = available space
%endmacro

%macro link_free 1
    mov ebx, [fbin]
    mov [%1 - 4], ebx
    mov [fbin], %1
    ;newchunk->fd = fbin->fd
    ;fbin->fd = newchunk
%endmacro

%macro unlink_free 2
    mov ecx, [%1 - 4]
    mov dword [%2 - 4], ecx
%endmacro
section .bss
    ptr_wilderness: resb 4 ; pointer to free memory, 4 bytes
    ptr_bss_end: resb 4 ; pointer to end of bss, 4 bytes
    fbin: resb 4 ; free bin stores freed chunks with single linked list starting at fd_ptr, 4 bytes
section .text

; Allocates memory of size esi
; Returns pointer to allocated memory
; Returns 0 if no memory is available or premalloc has not been called before.
malloc:
		push ebx

		;--assert_prewalloced--
		mov edx, [ptr_wilderness]
		test edx, edx ; check if edx is zero, ensure the wilderness pointer is set
		je .error
		;----------------------

		;--store_req_space--
		add esi, 8 ; add space for metadata to do size check
		;-------------------

		;--check_free_chunks--
		mov eax, [fbin]
		mov ebx, fbin + 4
		.size_check_loop:
		test eax, eax
		je .check_wilderness ; if end of free chunks, then use space of wilderness
		cmp esi, [eax - 8]
		jg .no_fit
		mov dword [eax - 8], esi
		unlink_free eax, ebx
		jmp .return
		.no_fit:
		mov ebx, eax ; save prev linked chunk in case of unlink
		mov eax, [eax - 4] ; move fd pointer of current chunk into eax
		jmp .size_check_loop
		;---------------------

		;--use-wilderness--
		.check_wilderness:
		get_free_space eax
		cmp eax, esi ; compare available space to requested space
		jge .set_meta ; if available space is bigger than requested, set metadata
		sub esi, eax ; remove excess space
		sbrk esi
		;------------------

		;--write_size--
		.set_meta:
		mov dword [edx], esi ; set size at pointer to wilderness or free chunk
		add [ptr_wilderness], esi ; increase pointer to wilderness by new chunk size
		;--------------

		;--set_return_value--
		mov eax, edx ; move edx
		add eax, 8
		;--------------------

		.return:
		pop ebx
		ret

		.error:
		xor eax, eax
		jmp .return

free:
		push ebx
		mov eax, [esp + 8]
		link_free eax
		pop ebx
		ret

premalloc:
		push ebx
		mov dword [ptr_wilderness], fbin + 8
		mov dword [ptr_bss_end], fbin + 8
		sbrk esi ; increment break by requested size
		pop ebx
		ret

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
    
derefdw:
    push ebp
    mov ebp, esp
    mov ebx, dword [ebp+8]
    xor eax, eax
    mov eax, dword [ebx]
    mov esp, ebp
    pop ebp
    ret
    
LA2:
    jmp LA3
    
strlen:
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
    jne LA4
    mov eax, dword [ebp-4] ; get length
    mov ebx, 1
    
    add eax, ebx
    mov [ebp-4], eax ; set 
    jmp LB1
    
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
    
setmemb:
    push ebp
    mov ebp, esp
    mov al, byte [ebp+8]
    mov ebx, dword [ebp+12]
    mov byte [ebx], al
    mov esp, ebp
    pop ebp
    ret
    
LA5:
    jmp LA6
    
setmemdw:
    push ebp
    mov ebp, esp
    mov eax, dword [ebp+8]
    mov ebx, dword [ebp+12]
    mov dword [ebx], eax
    mov esp, ebp
    pop ebp
    ret
    
LA6:
    jmp LA7
    
printstr:
    push ebp
    mov ebp, esp
    mov dword [ebp-4], 0 ; define i
    sub esp, 4
    mov eax, dword [ebp+8] ; get string
    push eax
    call strlen
    pop edi
    mov dword [ebp-8], eax ; define length
    sub esp, 4
    mov eax, 4
    mov ebx, 1
    mov ecx, dword [ebp+8]
    mov edx, dword [ebp-8]
    int 0x80
    mov esp, ebp
    pop ebp
    ret
    
LA7:
    jmp LA8
    
strcat:
    push ebp
    mov ebp, esp
    mov eax, dword [ebp+12] ; get dest
    push eax
    call strlen
    pop edi
    mov dword [ebp-4], eax ; define destlength
    sub esp, 4
    mov eax, dword [ebp+8] ; get source
    push eax
    call strlen
    pop edi
    mov dword [ebp-8], eax ; define sourcelength
    sub esp, 4
    mov eax, dword [ebp-4] ; get destlength
    mov ebx, dword [ebp-8] ; get sourcelength
    
    
    add eax, ebx
    mov dword [ebp-12], eax ; define needed
    sub esp, 4
    mov eax, dword [ebp-12] ; get needed
    push eax
    call malloc
    pop edi
    mov dword [ebp-16], eax ; define space
    sub esp, 4
    mov dword [ebp-20], 0 ; define i
    sub esp, 4
    
LB2:
    mov eax, dword [ebp-20] ; get i
    mov ebx, dword [ebp-4] ; get destlength
    
    
    cmp eax, ebx
    mov eax, 0
    setne al
    cmp eax, 1
    jne LA9
    mov eax, dword [ebp-16] ; get space
    mov ebx, dword [ebp-20] ; get i
    
    
    add eax, ebx
    push eax
    
    mov eax, dword [ebp+12] ; get dest
    mov ebx, dword [ebp-20] ; get i
    
    
    add eax, ebx
    push eax
    
    call derefb
    pop edi
    push eax
    
    call setmemb
    pop edi
    mov eax, dword [ebp-20] ; get i
    mov ebx, 1
    
    add eax, ebx
    mov [ebp-20], eax ; set 
    jmp LB2
    
LA9:
    mov dword [ebp-24], 0 ; define j
    sub esp, 4
    
LB3:
    mov eax, dword [ebp-24] ; get j
    mov ebx, dword [ebp-8] ; get sourcelength
    
    
    cmp eax, ebx
    mov eax, 0
    setne al
    cmp eax, 1
    jne LA10
    mov eax, dword [ebp-16] ; get space
    mov ebx, dword [ebp-20] ; get i
    
    
    add eax, ebx
    push eax
    
    mov eax, dword [ebp+8] ; get source
    mov ebx, dword [ebp-24] ; get j
    
    
    add eax, ebx
    push eax
    
    call derefb
    pop edi
    push eax
    
    call setmemb
    pop edi
    mov eax, dword [ebp-20] ; get i
    mov ebx, 1
    
    add eax, ebx
    mov [ebp-20], eax ; set 
    mov eax, dword [ebp-24] ; get j
    mov ebx, 1
    
    add eax, ebx
    mov [ebp-24], eax ; set 
    jmp LB3
    
LA10:
    mov eax, dword [ebp-16] ; get space
    push eax
    mov esp, ebp
    pop ebp
    ret
    mov esp, ebp
    pop ebp
    ret
    
LA8:
    jmp LA11
    
one_at_a_time:
    push ebp
    mov ebp, esp
    mov dword [ebp-4], 0 ; define i
    sub esp, 4
    mov dword [ebp-8], 0 ; define hash
    sub esp, 4
    
LB4:
    mov eax, dword [ebp+8] ; get string
    mov ebx, dword [ebp-4] ; get i
    
    
    add eax, ebx
    push eax
    
    call derefb
    pop edi
    mov ebx, 0
    
    cmp eax, ebx
    mov eax, 0
    setne al
    cmp eax, 1
    jne LA12
    mov eax, dword [ebp-8] ; get hash
    mov eax, dword [ebp+8] ; get string
    mov ebx, dword [ebp-4] ; get i
    
    
    add eax, ebx
    push eax
    
    call derefb
    pop edi
    
    
    add eax, ebx
    mov [ebp-8], eax ; set 
    mov eax, dword [ebp-8] ; get hash
    mov eax, dword [ebp-8] ; get hash
    mov ebx, 10
    
    mov ecx, ebx
    shl eax, cl
    
    
    add eax, ebx
    mov [ebp-8], eax ; set 
    mov eax, dword [ebp-8] ; get hash
    mov eax, dword [ebp-8] ; get hash
    mov ebx, 6
    
    mov ecx, ebx
    shr eax, cl
    
    
    xor eax, ebx
    mov [ebp-8], eax ; set 
    mov eax, dword [ebp-4] ; get i
    mov ebx, 1
    
    add eax, ebx
    mov [ebp-4], eax ; set 
    jmp LB4
    
LA12:
    mov eax, dword [ebp-8] ; get hash
    mov eax, dword [ebp-8] ; get hash
    mov ebx, 3
    
    mov ecx, ebx
    shl eax, cl
    
    
    add eax, ebx
    mov [ebp-8], eax ; set 
    mov eax, dword [ebp-8] ; get hash
    mov eax, dword [ebp-8] ; get hash
    mov ebx, 11
    
    mov ecx, ebx
    shr eax, cl
    
    
    xor eax, ebx
    mov [ebp-8], eax ; set 
    mov eax, dword [ebp-8] ; get hash
    mov eax, dword [ebp-8] ; get hash
    mov ebx, 15
    
    mov ecx, ebx
    shl eax, cl
    
    
    add eax, ebx
    mov [ebp-8], eax ; set 
    mov eax, dword [ebp-8] ; get hash
    push eax
    mov esp, ebp
    pop ebp
    ret
    mov esp, ebp
    pop ebp
    ret
    
LA11:
    jmp LA13
    
hash_set:
    push ebp
    mov ebp, esp
    mov eax, dword [ebp+12] ; get key
    push eax
    call one_at_a_time
    pop edi
    mov dword [ebp-4], eax ; define hash
    sub esp, 4
    mov eax, dword [ebp-4] ; get hash
    mov ebx, 32768
    
    xor edx, edx
    div ebx
    mov eax, edx
    mov [ebp-4], eax ; set 
    mov eax, dword [ebp+16] ; get hashmap
    mov ebx, dword [ebp-4] ; get hash
    
    
    add eax, ebx
    push eax
    
    mov eax, dword [ebp+8] ; get value
    push eax
    call setmemdw
    pop edi
    pop edi
    mov eax, dword [ebp+8] ; get value
    push eax
    mov esp, ebp
    pop ebp
    ret
    mov esp, ebp
    pop ebp
    ret
    
LA13:
    jmp LA14
    
hash_get:
    push ebp
    mov ebp, esp
    mov eax, dword [ebp+8] ; get key
    push eax
    call one_at_a_time
    pop edi
    mov dword [ebp-4], eax ; define hash
    sub esp, 4
    mov eax, dword [ebp-4] ; get hash
    mov ebx, 32768
    
    xor edx, edx
    div ebx
    mov eax, edx
    mov [ebp-4], eax ; set 
    mov eax, dword [ebp+12] ; get hashmap
    mov ebx, dword [ebp-4] ; get hash
    
    
    add eax, ebx
    push eax
    
    call derefdw
    pop edi
    push eax
    
    mov esp, ebp
    pop ebp
    ret
    mov esp, ebp
    pop ebp
    ret
    
LA14:
    push 0
    call premalloc
    pop edi
    
section .data
    LC1 db "Hey ", 0x00
    
section .text
    push LC1
    
    
section .data
    LC2 db "You", 0x00
    
section .text
    push LC2
    
    call strcat
    pop edi
    pop edi
    push eax
    
    call printstr
    pop edi
    push 32768
    call malloc
    pop edi
    
section .bss
    hashmap resd 1
    
section .text
    mov dword [hashmap], eax ; define hash
    jmp LA15
    
main:
    push ebp
    mov ebp, esp
    mov eax, dword [hashmap]
    push eax
    
section .data
    LC3 db "Key", 0x00
    
section .text
    push LC3
    
    push 4
    call hash_set
    pop edi
    pop edi
    pop edi
    mov eax, dword [hashmap]
    push eax
    
section .data
    LC4 db "Key", 0x00
    
section .text
    push LC4
    
    call hash_get
    pop edi
    pop edi
    mov esp, ebp
    pop ebp
    ret
    
LA15:
    call main
    mov esp, ebp
    pop ebp
    mov ebx, eax
    mov eax, 1
    int 0x80
    
