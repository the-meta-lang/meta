section .bss
	hashmap resb 65536 ; 2^16

section .data
	key db "hello", 0x00
	key2 db "hello!", 0x00
	value db 0x04 ; only integers for now

section .text
global _start

hash_set:
		; Input:
    ;   edi - pointer to the beginning of the hashmap
    ;   esi - pointer to the beginning of the key
		;   edx - value to store in the hashmap
	push edi
	push edx
	mov edi, esi
	mov esi, 65536
	call djb2_hash
	mov esi, eax ; move result of hash function in esi
	pop edx
	pop edi	
	mov [edi + esi], edx ; store value in hashmap
	ret

hash_get:
		; Input:
    ;   edi - pointer to the beginning of the hashmap
    ;   esi - pointer to the beginning of the key
    ; Output:
    ;   eax - value from the hashmap
	push edi
	mov edi, esi
	mov esi, 65536
	call djb2_hash
	mov esi, eax ; move result of hash function in esi
	pop edi	
	mov eax, [edi + esi] ; retrieve value from hashmap
	ret

djb2_hash:
    ; Input:
    ;   edi - pointer to the beginning of the string
    ;   esi - size of the hash table
    ; Output:
    ;   eax - compressed hash value
	mov eax, 5381
	.loop:
		movzx ecx, byte [edi]
		test cl, cl
		jz .done
		imul eax, eax, 33
		add eax, ecx
		inc edi
		jmp .loop
	.done:
		xor edx, edx ; clear edx for division
		div esi ; Calculate hash % size using xor (hash folding) (eax % esi)
		ret

_start:
	mov edi, hashmap
	mov esi, key
	mov edx, [value]
	call hash_set

	mov edi, hashmap
	mov esi, key2
	mov edx, 412312
	call hash_set

	mov edi, hashmap
	mov esi, key
	call hash_get

	mov eax, 1
	mov ebx, 1
	int 0x80