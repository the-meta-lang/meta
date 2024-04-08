section .data
		error_message db "Program was terminated due to an error. See the rest of the input string:", 0x0A, 0x0A, 0  ; Null-terminate the message
		error_message_length equ $ - error_message

section .text
terminate_program:
		mov eax, 4
		mov ebx, 1
		mov ecx, error_message
		mov edx, error_message_length
		int 0x80

		call stacktrace

		mov edi, [cursor]
		call print_int

		mov edi, input_string
		add edi, [cursor]
		call print_mm32


		; Exit the program
		mov eax, 1            ; System call number for sys_exit
		mov ebx, 1          ; Exit code 1
		int 0x80              ; Invoke the kernel to exit the program

stacktrace:
	mov dword [outbuff_offset], 0
	print "Stacktrace:"
	print 0x0A

	.loop:
		mov esi, err_inbuff_offset
		call vector_pop
		cmp eax, 0x00
		je .end
		push eax

		mov esi, err_fn_names
		call vector_pop_string
		mov esi, eax
		mov edi, outbuff
		add edi, [outbuff_offset]
		call strcpy
		add dword [outbuff_offset], eax

		print " at line "

		pop eax
		mov edi, input_string
		mov esi, eax
		push eax
		call getnewlines
		mov esi, eax
		mov edi, outbuff
		add edi, dword [outbuff_offset]
		call inttostr
		add dword [outbuff_offset], eax

		print " char "

		pop eax
		mov esi, eax
		mov edi, outbuff
		add edi, dword [outbuff_offset]
		call inttostr
		add dword [outbuff_offset], eax

		print 0x0A

		jmp .loop
	.end:
		mov edi, outbuff
		call print_mm32
		ret

; Returns the amount of newlines up until the cursor
; Input
;	edi: The input string
;	esi: The cursor
; Output
;	eax: The amount of newlines
getnewlines:
		mov eax, 1
		xor ecx, ecx
	.loop:
		cmp ecx, esi
		je .end
		add edi, 1
		inc ecx
		cmp byte [edi], 0x0A
		jne .loop
		inc eax
		jmp .loop
	.end:
		ret