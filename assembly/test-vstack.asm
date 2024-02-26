
section .data
		vstack_pointer dd 0x00
section .bss
		vstack resb 256 ; 256 bytes of virtual stack

section .text
	global _start

%macro vstack_push 1
		save_machine_state
		mov eax, vstack
		add eax, [vstack_pointer]
		mov word [eax], %1
		mov ax, word [vstack_pointer]
		add ax, 2 ; increment the pointer
		mov word [vstack_pointer], ax
		restore_machine_state
%endmacro

%macro vstack_pop 0
		pushfd
		push ebp ; Save the base pointer
		push ebx
		push ecx
		push edx
		push edi
		mov ax, word [vstack_pointer] ; Get the current pointer
		cmp ax, 0 ; Check if the pointer is 0
		je  %%_pre_terminate ; If it is, we can't pop anything, we need to return 0 to prevent writing into the memory before the vstack

		sub ax, 2	; Decrement the pointer
		mov word [vstack_pointer], ax ; Store the new pointer
		
		mov eax, vstack
		add eax, [vstack_pointer]
		mov eax, [eax] ; store the result in eax

		mov ebx, vstack 
		add ebx, [vstack_pointer] 
		mov word [ebx], 0x00 ; reset the value in the array to 0
		jmp %%_end
	%%_pre_terminate:
		mov eax, 0x00
	%%_end:
		; print "POP"
		; print_vstack
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop ebp ; Restore the base pointer
		popfd
%endmacro

%macro save_machine_state 0
		pushfd ; Save the flags register
		push ebp ; Save the base pointer
		push eax
		push ebx
		push ecx
		push edx
		push edi
%endmacro

%macro restore_machine_state 0
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		pop ebp ; Restore the base pointer
		popfd ; Restore the flags register
%endmacro

_start:
	mov eax, 1
	vstack_push 0xFFFF
	vstack_pop
	vstack_push 0x01
	vstack_push 0x02
	vstack_push 0x03
	vstack_pop
	vstack_pop

	mov eax, 1
	mov ebx, 0
	int 0x80