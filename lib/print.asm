
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

; Prints the value in edi as a number
; Input:
;   edi - number to print
print_int:
		save_machine_state
		mov eax, edi ; Move the number into eax
		cmp eax, 0x00 ; Check if the number is zero, if it is, we need to print 0 directly since the checks will not work
		je .print_zero
		mov edi, 0 ; Clear the counter
.divide_loop:
		cmp eax, 0
		je .print_loop
		mov edx, 0
		mov ebx, 10
		div ebx
		add edx, 0x30
		push edx
		inc edi ; Increment the counter for every new digit we add
		jmp .divide_loop
.print_loop:
		cmp edi, 0
		je .end_print_loop
		dec edi ; Decrement the counter

		mov eax, 4 ; syscall number for sys_write
		mov ebx, 1 ; file descriptor 1 is stdout
		mov ecx, esp ; Move the address of the next digit to ecx
		mov edx, 1 ; we are going to write one byte
		int 0x80            ; invoke syscall
		pop ecx ; Pop the next digit off the stack
		jmp .print_loop
.print_zero:
		push 0x30 ; Push the ASCII value of 0 to the stack
		mov eax, 4 ; syscall number for sys_write
		mov ebx, 1 ; file descriptor 1 is stdout
		mov ecx, esp
		mov edx, 1 ; we are going to write one byte
		int 0x80            ; invoke syscall
		pop ecx ; Pop the next digit off the stack
.end_print_loop:
	restore_machine_state
	ret