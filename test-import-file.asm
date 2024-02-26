%define MAX_INPUT_LENGTH 65536
section .data
		gn1_number dd 0x00

section .bss
		last_match resb 512
		input_string resb MAX_INPUT_LENGTH
		input_string_offset resb 2
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
		mov ecx, import_file_content
		mov eax, 0
	%%_import_file_length_loop:
		cmp byte [ecx], 0x00
		je %%_import_file_length_done
		inc ecx
		inc eax
		jmp %%_import_file_length_loop
	%%_import_file_length_done:
		mov [%%_import_file_length], eax

		; Move the file content into the input_string at the current index, moving the
		; rest of the input_string to the right.
		call copy_input_string_into_temp_buffer_from_current_index
		mov esi, input_string
		mov edi, import_file_content
		mov ecx, [%%_import_file_length]
		rep movsb
		mov esi, temp_import_buffer
		mov edi, input_string
		add edi, [%%_import_file_length]
		mov ecx, MAX_INPUT_LENGTH
		sub ecx, [%%_import_file_length]
		rep movsb
%endmacro

copy_input_string_into_temp_buffer_from_current_index:
	mov esi, input_string
	add esi, [input_string_offset] ; Add the offset to the input_string
	mov edi, temp_import_buffer
	mov ecx, MAX_INPUT_LENGTH
	sub ecx, [input_string_offset] ; Subtract the offset from the length
	rep movsb
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