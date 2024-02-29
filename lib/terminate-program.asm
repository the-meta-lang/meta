section .data
		error_message db "BRANCH ERROR Executed - Something is Wrong!", 0x0A, 0  ; Null-terminate the message
		error_message_length equ $ - error_message

section .text
terminate_program:
		print 0x0a
		print 0x0a

		label_with_newline "Error Encountered, recovery impossible."
		print "Error signal id: "
		print_int esi

		mov edi, input_string
		add edi, [input_string_offset]
		call print_mm32


		; Exit the program
		mov eax, 1            ; System call number for sys_exit
		mov ebx, 1          ; Exit code 1
		int 0x80              ; Invoke the kernel to exit the program