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

		mov edi, [input_string_offset]
		call print_int

		mov edi, input_string
		add edi, [input_string_offset]
		call print_mm32


		; Exit the program
		mov eax, 1            ; System call number for sys_exit
		mov ebx, 1          ; Exit code 1
		int 0x80              ; Invoke the kernel to exit the program