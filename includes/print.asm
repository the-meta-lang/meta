; Macro for printing to stdout
; Expects 1 argument (string) and automatically calculates it's length and outputs it
%macro print 1
section .data
		%%_str db %1, 0x00
section .text
    mov eax, 4          ; syscall: sys_write
    mov ebx, 1          ; file descriptor: STDOUT
		mov ecx, %%_str  ; string to write
    mov edx, 0          ; length will be determined dynamically
%%_calculate_length:
    cmp byte [ecx + edx], 0  ; check for null terminator
    je  %%_end_calculate_length
    inc edx
    jmp %%_calculate_length
%%_end_calculate_length:
    int 0x80            ; invoke syscall
%endmacro