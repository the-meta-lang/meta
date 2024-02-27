
; Print the contents of a memory location specified in <edi> to stdout
; input: edi - memory location to print
; output: none
print_mm32:
		save_machine_state
		mov eax, 4          ; syscall: sys_write
		mov ebx, 1          ; file descriptor: STDOUT
		mov ecx, edi  ; string to write
		mov edx, 0          ; length will be determined dynamically
.calculate_length:
		cmp byte [ecx + edx], 0  ; check for null terminator
		je  .end_calculate_length
		inc edx
		jmp .calculate_length
.end_calculate_length:
		int 0x80            ; invoke syscall
		restore_machine_state
		ret

print_imm32:
		save_machine_state
		push edi
		mov eax, 4          ; syscall: sys_write
		mov ebx, 1          ; file descriptor: STDOUT
		mov ecx, esp  ; string to write
		mov edx, 1          ; length is 32 bits
		int 0x80            ; invoke syscall
		pop edi
		restore_machine_state
		ret

; Print the contents of a memory location specified in <esi> to stdout
; while removing <eax> bytes from the beginning and <ebx> bytes from the end
; input: esi - memory location to print
;        eax - number of bytes to remove from the beginning
;        ebx - number of bytes to remove from the end
print_mm32_cut_ends:
		save_machine_state
		mov ecx, edi  ; string to write
		mov edx, 0          ; length will be determined dynamically
.calculate_length:
		cmp byte [ecx + edx], 0  ; check for null terminator
		je  .end_calculate_length
		inc edx
		jmp .calculate_length
.end_calculate_length:
		add ecx, eax ; remove <eax> bytes from the beginning
		sub edx, ebx ; remove <ebx> bytes from the end

		mov eax, 4          ; syscall: sys_write
		mov ebx, 1          ; file descriptor: STDOUT
		int 0x80            ; invoke syscall
		restore_machine_state
		ret

