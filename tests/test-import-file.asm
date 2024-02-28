%define MAX_INPUT_LENGTH 65536
section .bss
	import_file_content resb MAX_INPUT_LENGTH / 2
	temp_import_buffer resb MAX_INPUT_LENGTH / 2
section .data
	import_file_content_length dd 0x00
	input_string db "Hello There!", 0x00
	input_string_offset dd 5
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
		add edi, [import_file_content_length]
		add edi, [input_string_offset]

		call copy_string
		ret


%macro import_meta_file 1
	section .data
		%%_import_file db %1, 0x00
	section .text
		mov esi, %%_import_file
		call import_meta_file_mm32
%endmacro

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
		pop edi
		pop esi
		pop eax
		ret

section .text
global _start

_start:
		mov eax, 1
    ; Test input against string
		import_meta_file "./aexp-test.txt"

    ; Exit
		mov eax, 0x01
		mov ebx, 0x00
    int 0x80