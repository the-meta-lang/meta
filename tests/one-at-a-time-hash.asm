
section .data
		LC1 db "Hello", 0x00
section .text

global _start

_start:
		mov edi, LC1
		mov esi, 32768
		call one_at_a_time
		mov eax, 1
		mov ebx, 0
		int 0x80


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
	.done
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