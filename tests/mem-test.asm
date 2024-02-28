section .text

global _start

_start:
	push 12
	push 11
	push 10
	push 9
	push 8
	push 7
	mov ecx, 6
	mov edx, 5
	mov esi, 4
	mov edi, 3
	call main
	add esp, 40
	mov eax, 1
	mov ebx, 1
	int 0x80


main:
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]
	pop ebp
	ret