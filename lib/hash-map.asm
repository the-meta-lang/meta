hash_set:
		; Input:
    ;   edi - pointer to the beginning of the hashmap
    ;   esi - pointer to the beginning of the key
		;   edx - value to store in the hashmap
		; Output:
		;   eax - value that was passed in edx
	push edi
	push edx
	mov edi, esi
	mov esi, 262144
	call djb2_hash
	mov esi, eax ; move result of hash function in esi
	pop edx
	pop edi	
	mov [edi + esi], edx ; store value in hashmap
	mov eax, edx ; return the value in edx
	ret

hash_get:
		; Input:
    ;   edi - pointer to the beginning of the hashmap
    ;   esi - pointer to the beginning of the key
    ; Output:
    ;   eax - value from the hashmap
	push edi
	mov edi, esi
	mov esi, 262144
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