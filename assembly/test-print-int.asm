%macro print_int 1
		pushfd ; Save the flags register
		mov eax, %1 ; Move the number into eax
		mov edi, 0 ; Clear the counter
%%_divide_loop:
		cmp eax, 0
		je  %%_print_loop
		mov edx, 0
		mov ebx, 10
		div ebx
		add edx, 0x30
		push edx
		inc edi ; Increment the counter for every new digit we add
		jmp %%_divide_loop
%%_print_loop:
		cmp edi, 0
		je  %%_end_print_loop
		dec edi ; Decrement the counter

		mov eax, 4 ; syscall number for sys_write
		mov ebx, 1 ; file descriptor 1 is stdout
		mov ecx, esp ; Move the address of the next digit to ecx
		mov edx, 1 ; we are going to write one byte
		int 0x80            ; invoke syscall
		pop ecx ; Pop the next digit off the stack
		jmp %%_print_loop
%%_end_print_loop:
		popfd ; Restore the flags register
%endmacro

section .bss
		gn1_number resb 1

section .text
global _start
_start:
    ; Test input against string
		mov eax, [gn1_number]
		add eax, 511
		mov [gn1_number], eax
    print_int [gn1_number]

    ; Exit
		mov ebx, 0x00
		mov eax, 0x01
    int 0x80