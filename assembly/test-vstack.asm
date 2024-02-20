section .bss
	vstack resb 8191
	vstack_pointer resb 2

section .text
	global _start

%macro vstack_push 1
		mov eax, vstack
		add eax, [vstack_pointer]
		mov word [eax], %1
		mov ax, [vstack_pointer]
		add ax, 1 ; increment the pointer
		mov word [vstack_pointer], ax
%endmacro

%macro vstack_pop 0
		mov ax, word [vstack_pointer] ; Get the current pointer
		cmp ax, 0 ; Check if the pointer is 0
		je  %%_pre_terminate ; If it is, we can't pop anything, we need to return 0 to prevent writing into the memory before the vstack

		sub ax, 1	; Decrement the pointer
		mov word [vstack_pointer], ax ; Store the new pointer
		
		mov eax, vstack
		add eax, [vstack_pointer]
		mov eax, [eax]

		mov ebx, vstack 
		add ebx, [vstack_pointer] 
		mov word [ebx], 0x00 ; reset the value in the array to 0
		jmp %%_end
	%%_pre_terminate:
		mov eax, 0x00
	%%_end:
%endmacro


%macro store_vstack 0
		mov eax, vstack
		add eax, [vstack_pointer]
		; TODO: Do something with this
%endmacro

_start:
	mov bx, 0x02
	vstack_push bx
	vstack_pop
	vstack_pop
	vstack_pop
	mov eax, 0x00
	mov eax, [vstack]

	mov eax, 1
	mov ebx, 0
	int 0x80