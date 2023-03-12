section .text 
	global _start 
_start: 
	push 5
	push 2
	push 5
	pop ebx 
	pop eax 
	imul eax, ebx 
	push eax 
	push 5
	pop ebx 
	pop eax 
	cdq 
	idiv ebx 
	push eax 
	pop ebx 
	pop eax 
	add eax, ebx 
	mov eax, 4 
	pop ecx 
	mov ebx, 1 
	mov edx, 4 
	int 0x80 
	mov eax, 1   ; system call for exit 
	xor ebx, ebx ; exit status 
	int 0x80 
