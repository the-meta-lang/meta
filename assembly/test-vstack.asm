section .bss
	vstack resb 512
	vstack_pointer resb 1

section .text
	global _start

%macro vstack_push 1
		mov eax, vstack
		add eax, [vstack_pointer]
		mov byte [eax], %1
		mov al, [vstack_pointer]
		add al, 1 ; increment the pointer
		mov byte [vstack_pointer], al
%endmacro

%macro vstack_pop 0
		mov al, byte [vstack_pointer] ; Get the current pointer
		sub al, 1	; Decrement the pointer
		mov byte [vstack_pointer], al ; Store the new pointer
		
		mov eax, vstack
		add eax, [vstack_pointer]
		mov eax, [eax]

		mov ebx, vstack 
		add ebx, [vstack_pointer] 
		mov byte [ebx], 0x00 ; reset the value in the array to 0
%endmacro


%macro store_vstack 0
		mov eax, vstack
		add eax, [vstack_pointer]
		; TODO: Do something with this
%endmacro

_start:
	mov eax, 0x01
	vstack_push 0x01
	vstack_pop
	mov eax, 0x00
	mov eax, [vstack]

	mov eax, 1
	mov ebx, 0
	int 0x80