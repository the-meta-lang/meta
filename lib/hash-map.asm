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
	call one_at_a_time
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
	call one_at_a_time
	mov esi, eax ; move result of hash function in esi
	pop edi	
	mov eax, [edi + esi] ; retrieve value from hashmap
	ret

; We use jenkins one at a time hash function
; uint32_t jenkins_one_at_a_time_hash(const uint8_t* key, size_t length) {
;   size_t i = 0;
;   uint32_t hash = 0;
;   while (i != length) {
;     hash += key[i++];
;     hash += hash << 10;
;     hash ^= hash >> 6;
;   }
;   hash += hash << 3;
;   hash ^= hash >> 11;
;   hash += hash << 15;
;   return hash;
; }

one_at_a_time:
    ; Input:
    ;   edi - pointer to the beginning of the string
    ;   esi - size of the hash table
    ; Output:
    ;   eax - compressed hash value
		mov ecx, 0 ; i = 0
		mov eax, 0 ; hash = 0
	.loop:
		xor edx, edx
		mov dl, byte [edi + ecx] ; key[i]
		cmp dl, 0 ; key[i] != 0 -> Stop once we reach the end of the string
		je .done
		add eax, edx ; hash += key[i]
		mov ebx, eax
		shl ebx, 10
		add eax, ebx ; hash += hash << 10
		mov ebx, eax
		shr ebx, 6
		xor eax, ebx ; hash ^= hash >> 6
		inc ecx ; i++
		jmp .loop
	.done:
		mov ebx, eax
		shl ebx, 3
		add eax, ebx ; hash += hash << 3
		mov ebx, eax
		shr ebx, 11
		xor eax, ebx ; hash ^= hash >> 11
		mov ebx, eax
		shl ebx, 15
		add eax, ebx ; hash += hash << 15
		xor edx, edx
		div esi ; hash % size -> Adjust to hash table size
		ret