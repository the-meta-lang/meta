section .text
global _start
print_imm32:
		push edi
		mov eax, 4          ; syscall: sys_write
		mov ebx, 1          ; file descriptor: STDOUT
		mov ecx, esp  ; string to write
		mov edx, 1          ; length is 32 bits
		int 0x80            ; invoke syscall
		pop edi
		ret

_start:
		mov edi, 0x24
		call print_imm32
		mov eax, 4
		mov ebx, 1
		int 0x80