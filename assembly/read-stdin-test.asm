section .bss
    input_string resb 12000 ; Reserve 12000 bytes for input_string

section .text
global _start

_start:
    ; Read from stdin
    mov eax, 3          ; syscall for 'read'
    mov ebx, 0          ; stdin file descriptor
    mov ecx, input_string   ; Pointer to the buffer
    mov edx, 12000      ; Maximum bytes to read
    int 0x80

    ; Print what was read
    mov eax, 4          ; syscall for 'write'
    mov ebx, 1          ; stdout file descriptor
    mov ecx, input_string   ; Pointer to the string
    int 0x80

    ; Exit
    mov eax, 1          ; syscall for 'exit'
    xor ebx, ebx        ; exit code 0
    int 0x80
