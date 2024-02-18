.text
_start:
				mov [input_string], dword "   Hello"
				mov [test_string], dword "Hello"
				call test_input_string
strip:
				mov ecx, 1
strip_loop:
				cmp [esi], 32 ; Whitespace Character
				jne strip_loop_end
				add [esi], 2
				add ecx, 1
				loop strip_loop
        ret
strip_loop_end:
				ret
test_input_string:
        mov esi, [input_string]
        mov edi, [test_string]
				call strip
        mov ecx, 1
        cmps
        ret
.bss
        input_string resb 12
        test_string resb 12
        input_pointer resb 4