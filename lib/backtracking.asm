backtrack_store:
		; We need to store backtracking information so we can restore it later on
		mov byte [backtrack_switch], 1 ; We're backtracking boisss
		mov esi, dword [outbuff_offset]
		mov edi, bk_outbuff_offset
		call vector_push
		; Push the input buffer offset onto the stack
		mov esi, dword [cursor]
		mov edi, bk_inbuff_offset
		call vector_push
		; Save the token for later.
		mov edi, bk_token
		mov esi, last_match
		call vector_push_string_mm32
		ret

backtrack_restore:
		; Restore backtracking, we encountered an error.
		mov byte [eswitch], 0 ; Restore the error switch so we don't go into descent hell
		; Pop the input position from the stack
		mov esi, bk_inbuff_offset
		call vector_pop
		mov dword [cursor], eax
		; Pop the output position from the stack
		mov esi, bk_outbuff_offset
		call vector_pop
		mov dword [outbuff_offset], eax
		; Pop the token off the stack and copy it back into last_match
		mov esi, bk_token
		call vector_pop_string
		mov edi, eax ; Mov the pointer to the token into edi
		mov esi, last_match ; Move the target pointer into esi
		call strcpy
		ret


backtrack_clear:
		mov byte [backtrack_switch], 0 ; Alright, we're done here.
		; Clear all backtracking information, we're done here!
		; Pop the input position from the stack
		mov esi, bk_inbuff_offset
		call vector_pop
		; Pop the output position from the stack
		mov esi, bk_outbuff_offset
		call vector_pop
		; Pop the token off the stack
		mov esi, bk_token
		call vector_pop_string
		ret