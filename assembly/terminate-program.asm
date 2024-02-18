section .data
    error_message db "BRANCH ERROR Executed - Something is Wrong!", 0x0A, 0  ; Null-terminate the message
    error_message_length equ $ - error_message

section .text
    global _start

    _start:
        ; Write error message to stdout
        mov eax, 4            ; System call number for sys_write
        mov ebx, 1            ; File descriptor for standard output (stdout)
        mov ecx, error_message ; Pointer to the error message
        mov edx, error_message_length ; Length of the error message
        int 0x80              ; Invoke the kernel to write the message to stdout

        ; Exit the program
        mov eax, 1            ; System call number for sys_exit
        mov ebx, 1          ; Exit code 1
        int 0x80              ; Invoke the kernel to exit the program
