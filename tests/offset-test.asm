section .text

global _start

_start:
		push ebp
		mov ebp, esp
		mov ebx, [ebp+16]
		mov ecx, dword [ebp+16]
		pop ebp
		mov eax, 1
		mov ebx, 0
		int 0x80