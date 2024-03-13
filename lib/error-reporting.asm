error_clear:
	mov esi, err_inbuff_offset
	call vector_pop
	mov esi, err_fn_names
	call vector_pop_string
	ret

%macro error_store 1
section .data
		%%_fn_name db %1, 0
		%%_len equ $-%%_fn_name
section .text
		; Store information to form an error response if we encounter an error.
		mov edi, err_inbuff_offset
		mov esi, dword [cursor]
		call vector_push

		; Store the current function name
		mov edi, err_fn_names
		mov esi, %%_fn_name
		call vector_push_string_mm32
%endmacro