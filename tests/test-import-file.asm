%define MAX_INPUT_LENGTH 65536
section .data
		gn1_number dd 0x00
		input_string db "Hello There!", 0x00
		input_string_offset dd 5

section .bss
		last_match resb 512
		input_pointer resb 4
		lfbuffer resb 1
		FILE resb 256
		import_file_content resb 32768
		temp_import_buffer resb MAX_INPUT_LENGTH

section .text

%macro import_meta_file 1
	section .data
		%%_import_file db %1, 0x00
		%%_import_file_length dd 0x00
	section .text
		; Open and read the file specified in
		; the FILE constant to enable easier debugging.
		mov eax, 5 ; syscall for 'open'
		mov ebx, %%_import_file ; File to open
		mov ecx, 0 ; O_RDONLY
		int 0x80

		mov ebx, eax ; Save the file descriptor
		mov eax, 3 ; syscall for 'read'
		mov ecx, import_file_content ; Read Text input into `import_file_content`
		mov edx, 32768 ; Let's read the maximum number of bytes
		int 0x80

		mov eax, 6 ; syscall for 'close'
		int 0x80

		; Go through the file content 1 byte at a time and count the number of chars
		; to get the length of the file.
		mov eax, import_file_content
		mov ecx, 0
	%%_import_file_length_loop:
		cmp byte [eax], 0x00
		je %%_import_file_length_done
		add eax, 1
		inc ecx
		jmp %%_import_file_length_loop
	%%_import_file_length_done:
		mov [%%_import_file_length], ecx

		; Move the file content into the input_string at the current index, moving the
		; rest of the input_string to the right.
		mov esi, input_string
		add esi, [input_string_offset]
		mov edi, temp_import_buffer

		call copy_string ; Store the input_string in a temporary buffer
		; We have now stored the input_string inside a temporary buffer.
		; Let's write the imported file content into the input_string
		; and then append the temporary buffer again.
		mov esi, import_file_content
		mov edi, input_string
		add edi, [input_string_offset]
		call copy_string


		mov esi, temp_import_buffer
		mov edi, input_string
		add edi, [%%_import_file_length]
		add edi, [input_string_offset]

		call copy_string
%endmacro

; Copies a string from a given memory location into another memory location until it hits
; a null terminator.
; input:
; - esi: Source memory location (mm32)
; - edi: Destination memory location (mm32)
copy_string:
	.copy_loop:
		push eax
		xor eax, eax
		mov al, byte [esi]
		cmp al, 0x00 ; End if we reach the null terminator
		je .end_copy
		mov byte [edi], al
		add esi, 1
		add edi, 1
		jmp .copy_loop
	.end_copy:
		pop eax
		ret

section .text
global _start

_start:
		mov eax, 1
    ; Test input against string
		import_meta_file "./gyro-test.txt"

    ; Exit
		mov eax, 0x01
		mov ebx, 0x00
    int 0x80