section .data
		line dd 0x00

section .text
global _start

_start:
		mov ecx, line
		mov eax, 1
    mov dword [line], eax
		mov eax, 1
		mov ebx, 0
		int 0x80