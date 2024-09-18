section .data
		gn0_number dd 0x00
		gn1_number dd 0x00
		gn2_number dd 0x00
		gn3_number dd 0x00
		gn4_number dd 0x00

section .bss
		vstack resb 2048 ; 2048 bytes of virtual stack

section .text

vstack_clear:
		save_machine_state
		mov edi, vstack
		mov esi, 0xFFFF
		call vector_push
		call vector_push
		call vector_push
		call vector_push
		restore_machine_state
		ret

vstack_restore:
		save_machine_state
		mov esi, vstack
		call vector_pop
		call vector_pop
		call vector_pop
		call vector_pop
		restore_machine_state
		ret

gn4:
	section .bss
		.out resb 32
	section .text
		save_machine_state ; Save the flags register
		mov esi, vstack
		call vector_pop ; get gn4 off the stack
		cmp eax, 0xFFFF ; check if gn4 is "null", we start at 0 so we can't use that, instead 0xFFFF
		je .generate_new_number

	.generate_label:
			push eax
			mov byte [.out], "L"
			mov byte [.out + 1], "D"
			mov esi, eax
			mov edi, .out + 2
			call inttostr
			mov ebx, .out + 2
			add ebx, eax ; .out + 2 + length
			mov byte [ebx], 0x00 ; null terminate the string

			; restore the stack
			pop esi
			mov edi, vstack
			call vector_push

			jmp .end

	.generate_new_number:
			add dword [gn4_number], 1
			mov eax, [gn4_number]
			jmp .generate_label

	.end:
			restore_machine_state ; Restore the flags register
			mov eax, .out ; return .out
			ret

gn3:
	section .bss
		.out resb 32
	section .text
		save_machine_state ; Save the flags register
		mov esi, vstack
		call vector_pop ; pop gn4 number off the stack
		push eax ; store gn4 so we can add it later.
		call vector_pop ; get gn3 off the stack
		cmp eax, 0xFFFF ; check if gn3 is "null", we start at 0 so we can't use that, instead 0xFFFF
		je .generate_new_number

	.generate_label:
			push eax
			mov byte [.out], "L"
			mov byte [.out + 1], "C"
			mov esi, eax
			mov edi, .out + 2
			call inttostr
			mov ebx, .out + 2
			add ebx, eax ; .out + 2 + length
			mov byte [ebx], 0x00 ; null terminate the string

			; restore the stack
			pop esi
			mov edi, vstack
			call vector_push
			pop esi
			call vector_push

			jmp .end

	.generate_new_number:
			add dword [gn3_number], 1
			mov eax, [gn3_number]
			jmp .generate_label

	.end:
			restore_machine_state ; Restore the flags register
			mov eax, .out ; return .out
			ret

gn2:
	section .bss
		.out resb 32
	section .text
		save_machine_state ; Save the flags register
		mov esi, vstack
		call vector_pop ; pop gn4 number off the stack
		push eax ; store gn4 so we can add it later.
		call vector_pop ; pop gn3 number off the stack
		push eax ; store gn3 so we can add it later.
		call vector_pop ; get gn2 off the stack
		cmp eax, 0xFFFF ; check if gn2 is "null", we start at 0 so we can't use that, instead 0xFFFF
		je .generate_new_number

	.generate_label:
			push eax
			mov byte [.out], "L"
			mov byte [.out + 1], "B"
			mov esi, eax
			mov edi, .out + 2
			call inttostr
			mov ebx, .out + 2
			add ebx, eax ; .out + 2 + length
			mov byte [ebx], 0x00 ; null terminate the string

			; restore the stack
			pop esi
			mov edi, vstack
			call vector_push
			pop esi
			call vector_push
			pop esi
			call vector_push

			jmp .end

	.generate_new_number:
			add dword [gn2_number], 1
			mov eax, [gn2_number]
			jmp .generate_label

	.end:
			restore_machine_state ; Restore the flags register
			mov eax, .out ; return .out
			ret

gn1:
	section .bss
		.out resb 32
	section .text
		save_machine_state ; Save the flags register
		mov esi, vstack
		call vector_pop ; pop gn4 number off the stack
		push eax ; store gn4 so we can add it later.
		call vector_pop ; pop gn3 number off the stack
		push eax ; store gn3 so we can add it later.
		call vector_pop ; pop gn2 number off the stack
		push eax ; store gn2 so we can add it later.
		call vector_pop ; get gn1 off the stack
		cmp eax, 0xFFFF ; check if gn1 is "null", we start at 0 so we can't use that, instead 0xFFFF
		je .generate_new_number

	.generate_label:
			push eax
			mov byte [.out], "L"
			mov byte [.out + 1], "A"
			mov esi, eax
			mov edi, .out + 2
			call inttostr
			mov ebx, .out + 2
			add ebx, eax ; .out + 2 + length
			mov byte [ebx], 0x00 ; null terminate the string

			; restore the stack
			pop esi
			mov edi, vstack
			call vector_push
			pop esi
			call vector_push
			pop esi
			call vector_push
			pop esi
			call vector_push 

			jmp .end

	.generate_new_number:
			add dword [gn1_number], 1
			mov eax, [gn1_number]
			jmp .generate_label

	.end:
			restore_machine_state ; Restore the flags register
			mov eax, .out ; return .out
			ret

; Generates a new number every time it is invoked.
gn0:
	section .bss
		.out resb 32
	section .text
		save_machine_state ; Save the flags register
		add dword [gn0_number], 1
		mov eax, dword [gn0_number]
		jmp .generate_label

	.generate_label:
			mov esi, eax
			mov edi, .out
			call inttostr
			mov ebx, .out
			add ebx, eax ; .out + length
			mov byte [ebx], 0x00 ; null terminate the string

	.end:
			restore_machine_state ; Restore the flags register
			mov eax, .out ; return .out
			ret