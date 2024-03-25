%define MAX_INPUT_LENGTH 8192

section .bss
	import_file_content resb MAX_INPUT_LENGTH / 2
	temp_import_buffer resb MAX_INPUT_LENGTH / 2
section .data
	import_file_content_length dd 0x00

section .data
	tflag db 0
	; Parse Flag, indicates a parsing error which may be recovered from
	; by backtracking 
	pflag db 0
	; Error switch, indicates a parsing error that is not recoverable
	eswitch db 0
	outbuff_offset dd 0
	backtrack_switch db 0

	cursor dd 0


section .bss
		input_string resb MAX_INPUT_LENGTH
		input_pointer resb 4
		lfbuffer resb 1
		FILE resb 256
		str_vector_8192 resb 8192
		last_match resb 512

		err_inbuff_offset resb 512
		err_fn_names resb 8192

		; TODO: This is a temporary solution, we should use a dynamic buffer
		outbuff resb 5242880 ; 5MB for the output buffer
		

		; Space for the backtracking output buffer (int[])
		bk_outbuff_offset resb 512
		; Space for the backtracking input buffer (int[])
		bk_inbuff_offset resb 512
		; Space for the backtracking token buffer (string[])
		bk_token resb 8192
section .text

; Reads a file and stores the content in the input_string
; input:
; esi: The file path
import_meta_file_mm32:
	; Open and read the file specified in
		; the FILE constant to enable easier debugging.
		mov eax, 5 ; syscall for 'open'
		mov ebx, esi ; File to open
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
	.import_file_length_loop:
		cmp byte [eax], 0x00
		je .import_file_length_done
		add eax, 1
		inc ecx
		jmp .import_file_length_loop
	.import_file_length_done:
		mov [import_file_content_length], ecx

		; Move the file content into the input_string at the current index, moving the
		; rest of the input_string to the right.
		mov esi, input_string
		add esi, [cursor]
		mov edi, temp_import_buffer
		call copy_string ; Store the input_string in a temporary buffer
		
		; Let's write the imported file content into the input_string
		; and then append the temporary buffer again.
		mov esi, import_file_content
		mov edi, input_string
		add edi, [cursor]
		call copy_string

		mov esi, temp_import_buffer
		mov edi, input_string
		add edi, [import_file_content_length]
		add edi, [cursor]
		call copy_string
		mov eax, dword [import_file_content_length]
		add dword [cursor], eax

		ret

; Copies a string from a given memory location into another memory location until it hits
; a null terminator.
; input:
; - esi: Source memory location (mm32)
; - edi: Destination memory location (mm32)
copy_string:
	push eax
	push esi
	push edi
	.copy_loop:
		xor eax, eax
		mov al, byte [esi]
		cmp al, 0x00 ; End if we reach the null terminator
		je .end_copy
		mov byte [edi], al
		add esi, 1
		add edi, 1
		jmp .copy_loop
	.end_copy:
		; Add the null terminator to the end of the string
		mov byte [edi], 0x00
		pop edi
		pop esi
		pop eax
		ret

section .data
		file db "stuff/file.txt", 0x00

section .text
global _start
_start:
	; Import the file
	mov esi, file
	mov byte [input_string], 72
	mov byte [input_string+1], 97
	mov byte [input_string+2], 108
	mov byte [input_string+3], 108
	mov byte [input_string+4], 111
	add dword [cursor], 5
	call import_meta_file_mm32
	mov eax, input_string
	add eax, dword [cursor]
	mov byte [eax], 111