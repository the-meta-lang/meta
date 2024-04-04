section .data
struc SymbolTable
	.parent resd 1 ; *SymbolTable
	.table resd 1	; *HashTable
endstruc

struc HashTable
	.size resd 1 ; int
	.capacity resd 1 ; int
	.entries resd 1 ; void**
	.entry_size resd 1 ; int
endstruc

section .text
global _start


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
		push ebp
		mov ebp, esp
		push ebx

		;--assert_prewalloced--
		mov edx, [ptr_wilderness]
		test edx, edx ; check if edx is zero, ensure the wilderness pointer is set
		je .error
		;----------------------

		;--store_req_space--
		mov esi, dword [ebp+8]
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
		pop ebp
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
		push ebp
		mov ebp, esp
		push ebx
		mov esi, dword [ebp+8]
		mov dword [ptr_wilderness], fbin + 8
		mov dword [ptr_bss_end], fbin + 8
		sbrk esi ; increment break by requested size
		pop ebx
		pop ebp
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
		mov eax, edx
		ret

; HashTable* hash_table_create(int capacity, int entry_size)
hash_table_create:
	push ebp
	mov ebp, esp
	mov eax, HashTable_size ; sizeof(HashTable)
	push eax
	call malloc ; malloc(sizeof(HashTable))
	pop edi
	mov ebx, eax ; store pointer to HashTable
	mov eax, dword [ebp+12] ; capacity
	mov dword [ebx + HashTable.capacity], eax
	mov dword [ebx + HashTable.size], 0
	mov ecx, dword [ebp+8] ; entry_size
	mov dword [ebx + HashTable.entry_size], ecx
	mul ecx ; capacity * entry_size
	push eax
	call malloc ; malloc(capacity * sizeof(void*))
	pop edi
	mov dword [ebx + HashTable.entries], eax
	mov eax, ebx
	pop ebp
	ret

; any* hash_table_get(HashTable* table, char* key[])
hash_table_get:
	push ebp
	mov ebp, esp
	mov eax, dword [ebp+12] ; table
	mov esi, dword [eax + HashTable.capacity] ; table->capacity
	mov edi, dword [ebp+8] ; key
	call one_at_a_time ; hash = one_at_a_time(key, table->capacity)
	
	mov ebx, dword [ebp+12] ; ebx = table
	mul dword [ebx + HashTable.entry_size] ; hash * table->entry_size
	add eax, dword [ebx + HashTable.entries] ; hash += table->entries
	mov eax, [eax] ; eax = table->entries[hash]
	pop ebp
	ret

; void hash_table_put(HashTable* table, char* key[], void* value)
hash_table_put:
	push ebp
	mov ebp, esp
	mov eax, dword [ebp+16] ; table
	mov esi, dword [eax + HashTable.capacity] ; table->capacity
	mov edi, dword [ebp+12] ; key
	call one_at_a_time ; hash = one_at_a_time(key, table->capacity)
	
	mov ebx, dword [ebp+16] ; ebx = table
	mul dword [ebx + HashTable.entry_size] ; hash * table->entry_size
	add eax, dword [ebx + HashTable.entries] ; hash += table->entries
	mov ebx , [ebp+8] ; value
	mov dword [eax], ebx ; table->entries[hash] = value
	pop ebp
	ret

; SymbolTable* symbol_table_create(HashTable* parent, int capacity, int entry_size)
symbol_table_create:
	push ebp
	mov ebp, esp
	push dword [ebp+12] ; capacity
	push dword [ebp+8] ; entry_size
	call hash_table_create ; hash_table_create(capacity, entry_size)
	pop edi
	pop edi
	mov ebx, eax ; ebx = HashTable*
	; Allocate memory for the SymbolTable
	push SymbolTable_size ; sizeof(SymbolTable)
	call malloc ; malloc(sizeof(SymbolTable))
	pop edi
	mov ecx, eax ; store pointer to SymbolTable

	; Move the parent into the SymbolTable
	mov eax, dword [ebp+16] ; parent
	mov dword [ecx + SymbolTable.parent], eax
	mov dword [ecx + SymbolTable.table], ebx
	mov eax, ecx
	pop ebp
	ret

; void* symbol_table_get(SymbolTable* table, char* key)
symbol_table_get:
	push ebp
	mov ebp, esp
	mov eax, dword [ebp+12] ; table
	mov eax, dword [eax+SymbolTable.table]
	push eax
	mov eax, dword [ebp+8] ; key
	push eax
	call hash_table_get ; eax = hash_table_get(table->table, key)
	; if eax == 0, go to parent
	test eax, eax
	jnz .done
	mov esi, dword [ebp+12] ; table
	.loop_parent:
		mov ebx, dword [esi+SymbolTable.parent]
		cmp ebx, 0 ; ebx == nullptr?
		je .not_found
		push dword [ebx+SymbolTable.table]
		push dword [ebp+8]
		call hash_table_get ; eax = hash_table_get(parent->table, key)
		pop edi
		pop edi
		test eax, eax
		jnz .done
		mov esi, ebx
		jmp .loop_parent
	.not_found:
		xor eax, eax
	.done:
		pop edi
		pop edi
		pop ebp
		ret

; void symbol_table_put(SymbolTable* table, char* key, void* value)
symbol_table_put:
	push ebp
	mov ebp, esp
	mov eax, dword [ebp+16] ; table
	mov eax, dword [eax+SymbolTable.table]
	push eax
	push dword [ebp+12]
	push dword [ebp+8]
	call hash_table_put ; hash_table_put(table->table, key, value)
	pop edi
	pop edi
	pop edi
	pop ebp
	ret

; void symbol_table_remove(SymbolTable* table, char* key)
symbol_table_remove:
	push ebp
	mov ebp, esp
	push dword [ebp+12] ; table
	push dword [ebp+8] ; key
	push 0x00
	call hash_table_put ; hash_table_put(table->table, key, 0x00)
	pop edi
	pop edi
	pop edi
	pop ebp
	ret

; void symbol_table_free(SymbolTable* table)
; Frees the memory for the SymbolTable and its HashTable
; as well as the entries of that HashTable
symbol_table_free:
	push ebp
	mov ebp, esp
	mov eax, [ebp+8] ; table
	mov ebx, dword [eax + SymbolTable.table] ; free(table->table->entries)
	push dword [ebx + HashTable.entries]
	call free
	pop edi
	mov eax, [ebp+8] ; table
	push dword [eax + SymbolTable.table] ; free(table->table)
	call free
	pop edi
	push dword [ebp+8] ; free(table)
	call free
	pop edi
	pop ebp
	ret


section .data
	name db "me", 0

section .text

_start:
	push 0
	call premalloc
	pop edi
	push 0x00 ; parent* (nullptr)
	push 256 ; capacity
	push 4 ; entry_size
	call symbol_table_create
	pop edi
	pop edi
	pop edi

	push eax
	push name
	push 24
	call symbol_table_put
	pop edi
	pop edi
	pop eax ; table*

	push eax ; parent*
	push 256 ; capacity
	push 4 ; entry_size
	call symbol_table_create
	pop edi
	pop edi
	pop edi

	push eax ; store table

	pop eax

	push eax
	push name
	call symbol_table_get
	pop edi
	pop edi
	

	mov eax, 1
	mov ebx, 0
	int 0x80