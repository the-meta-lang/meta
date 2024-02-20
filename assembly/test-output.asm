%include './lib/asm_macros.asm'

section .data
		input_string db "x = 5 + 2;", 0x00

section .bss
    last_match resb 100
    ; input_string resb 12000
    input_string_offset resb 2
    input_pointer resb 4
    lfbuffer resb 1
    vstack_1 resb 1
    gn1_number resb 1
    
section .text
    global _start
    
_start:
    ; mov eax, 3 ; syscall for 'read'
    ; mov ebx, 0 ; stdin file descriptor
    ; mov ecx, input_string ; Read Text input into `input_string`
    ; mov edx, 12000 ; We can read up to 12000 bytes
    ; int 0x80
    ; ; The count of read bytes is returned in eax, we need to null terminate the string
    ; add ecx, eax
    ; sub ecx, 1 ; Subtract one since a newline is included in the count
    ; mov byte [ecx], 0x00
    
AEXP:
    call AS
    
LB1:
    call AS
    
LB2:
    
LB3:
    je LB4
    set_true
    jne terminate_program
    
LB4:
    
LB5:
    ret
    
AS:
    test_for_id
    print "address "
    copy_last_match
    newline
    test_input_string "="
    jne terminate_program
    call EX1
    jne terminate_program
    print "store"
    newline
    test_input_string ";"
    jne terminate_program
    
LB6:
    
LB7:
    ret
    
EX1:
    call EX5
    
LB8:
    test_input_string "+"
    call EX5
    jne terminate_program
    print "add"
    newline
    
LB9:
    test_input_string "-"
    call EX5
    jne terminate_program
    print "sub"
    newline
    
LB10:
    
LB11:
    je LB12
    set_true
    jne terminate_program
    
LB12:
    
LB13:
    ret
    
EX5:
    test_for_id
		jne LB14
    print "load "
    copy_last_match
    newline
    
LB14:
    test_for_number
		jne LB15
    print "literal "
    copy_last_match
    newline
    
LB15:
    test_input_string "("
    call EX1
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB16:
    
LB17:
    ret
    mov eax, 1
    mov ebx, 0
    int 0x80