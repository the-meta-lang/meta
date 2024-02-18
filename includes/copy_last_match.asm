%macro copy_last_match 0
    mov eax, 4          ; syscall: sys_write
    mov ebx, 1          ; file descriptor: STDOUT
		mov ecx, last_match  ; string to write
    mov edx, 0          ; length will be determined dynamically
%%_calculate_length:
    cmp byte [ecx + edx], 0  ; check for null terminator
    je  %%_end_calculate_length
    inc edx
    jmp %%_calculate_length
%%_end_calculate_length:
    int 0x80            ; invoke syscall
%endmacro