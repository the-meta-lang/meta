section .data
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
		save_machine_state ; Save the flags register
		mov esi, vstack
		call vector_pop
		cmp eax, 0xFFFF
		je .generate_new_number

	.print_label:
			push eax
			print "LD"
			pop eax
			mov esi, eax
			push eax
			mov edi, outbuff
			add edi, dword [outbuff_offset]
			call inttostr
			add dword [outbuff_offset], eax
			pop eax

			mov esi, eax
			mov edi, vstack
			call vector_push

			jmp .end

	.generate_new_number:
			add dword [gn4_number], 1
			mov eax, [gn4_number]
			jmp .print_label

	.end:
			restore_machine_state ; Restore the flags register
			ret

gn3:
		save_machine_state ; Save the flags register
		mov esi, vstack
		call vector_pop ; pop gn4 number off the stack
		push eax ; store gn4 so we can add it later.
		call vector_pop ; get gn3 off the stack
		cmp eax, 0xFFFF ; check if gn3 is "null", we start at 0 so we can't use that, instead 0xFFFF
		je .generate_new_number

	.print_label:
			push eax
			print "LC"
			pop eax
			mov esi, eax
			push eax
			mov edi, outbuff
			add edi, dword [outbuff_offset]
			call inttostr
			add dword [outbuff_offset], eax
			pop eax

			mov esi, eax
			mov edi, vstack
			call vector_push
			pop esi
			call vector_push 

			jmp .end

	.generate_new_number:
			add dword [gn3_number], 1
			mov eax, [gn3_number]
			jmp .print_label

	.end:
			restore_machine_state ; Restore the flags register
			ret

gn2:
		save_machine_state ; Save the flags register
		mov esi, vstack
		call vector_pop ; pop gn4 number off the stack
		push eax ; store gn4 so we can add it later.
		call vector_pop ; pop gn3 number off the stack
		push eax ; store gn3 so we can add it later.
		call vector_pop ; get gn2 off the stack
		cmp eax, 0xFFFF ; check if gn2 is "null", we start at 0 so we can't use that, instead 0xFFFF
		je .generate_new_number

	.print_label:
			push eax
			print "LB"
			pop eax
			mov esi, eax
			push eax
			mov edi, outbuff
			add edi, dword [outbuff_offset]
			call inttostr
			add dword [outbuff_offset], eax
			pop eax

			mov esi, eax
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
			jmp .print_label

	.end:
			restore_machine_state ; Restore the flags register
			ret

gn1:
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

	.print_label:
			push eax
			print "LA"
			pop eax
			mov esi, eax
			push eax
			mov edi, outbuff
			add edi, dword [outbuff_offset]
			call inttostr
			add dword [outbuff_offset], eax
			pop eax

			mov esi, eax
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
			jmp .print_label

	.end:
			restore_machine_state ; Restore the flags register
			ret