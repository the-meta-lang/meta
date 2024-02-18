%include './lib/asm_macros.asm'
    
section .bss
    last_match resb 100
    input_string resb 12000
    input_string_offset resb 2
    input_pointer resb 4
    lfbuffer resb 1
    vstack_1 resb 1
    gn1_number resb 1
    
section .text
    global _start
    
_start:
    mov eax, 3 ; syscall for 'read'
    mov ebx, 0 ; stdin file descriptor
    mov ecx, input_string ; Read Text input into `input_string`
    mov edx, 12000 ; We can read up to 12000 bytes
    int 0x80
    ; The count of read bytes is returned in eax, we need to null terminate the string
    add ecx, eax
    sub ecx, 1 ; Subtract one since a newline is included in the count
    mov byte [ecx], 0x00
    
AEXP:
    
LB1:
    test_for_id
    jne LB6
    test_input_string "="
    jne terminate_program
    test_for_number
    jne terminate_program
    print "Number: "
    copy_last_match
		call label
LB4:
    jmp LB1
LB6:
    mov eax, 1
    mov ebx, 0
    int 0x80