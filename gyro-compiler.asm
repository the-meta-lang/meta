
%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .text
    global _start
    
_start:
    call _read_file_argument
    call _read_file
    call PROGRAM
    mov eax, 1
    mov ebx, 0
    int 0x80
    
PROGRAM:
    call label
    print "section .text"
    call newline
    print "global _start"
    call newline
    call label
    print "_start:"
    call newline
    
LB1:
    vstack_push 0xFFFF
    call LET_DEFINITION
    call vstack_pop
    jne LB2
    
LB2:
    je LB3
    vstack_push 0xFFFF
    call FUNCTION_DECLARATION
    call vstack_pop
    jne LB4
    
LB4:
    
LB3:
    je LB1
    call set_true
    jne terminate_program
    
LB5:
    
LB6:
    ret
    
LET_DEFINITION:
    test_input_string "let"
    jne LB7
    call test_for_id
    jne terminate_program
    test_input_string "="
    jne terminate_program
    call test_for_number
    jne terminate_program
    print "mov esi, "
    call copy_last_match
    call newline
    test_input_string ";"
    jne terminate_program
    call label
    print "section .text"
    call newline
    
LB7:
    
LB8:
    ret
    
FUNCTION_DECLARATION:
    test_input_string "fn"
    jne LB9
    call test_for_id
    jne terminate_program
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "("
    jne terminate_program
    
LB10:
    vstack_push 0xFFFF
    call FUNCTION_DECLARATION_ARGUMENT
    call vstack_pop
    jne LB11
    
LB11:
    
LB12:
    je LB10
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    test_input_string "{"
    jne terminate_program
    vstack_push 0xFFFF
    call FUNCTION_BODY
    call vstack_pop
    jne terminate_program
    test_input_string "}"
    jne terminate_program
    
LB9:
    
LB13:
    ret
    
FUNCTION_DECLARATION_ARGUMENT:
    call test_for_id
    jne LB14
    print "pop "
    call copy_last_match
    call newline
    
LB14:
    
LB15:
    ret
    
FUNCTION_BODY:
    
LB16:
    vstack_push 0xFFFF
    call LET_DEFINITION
    call vstack_pop
    jne LB17
    
LB17:
    je LB18
    vstack_push 0xFFFF
    call FUNCTION_CALL
    call vstack_pop
    jne LB19
    
LB19:
    je LB18
    vstack_push 0xFFFF
    call FUNCTION_DECLARATION
    call vstack_pop
    jne LB20
    
LB20:
    
LB18:
    je LB16
    call set_true
    jne LB21
    
LB21:
    
LB22:
    ret
    
FUNCTION_CALL:
    call test_for_id
    jne LB23
    vector_push_string_mm32 str_vector_8192, last_match
    jne terminate_program
    test_input_string "("
    jne terminate_program
    
LB24:
    vstack_push 0xFFFF
    call FUNCTION_CALL_ARGUMENT
    call vstack_pop
    jne LB25
    
LB25:
    
LB26:
    je LB24
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    print "call "
    vector_pop_string str_vector_8192
    mov edi, eax
    mov eax, 4
    mov ebx, 1
    mov ecx, [edi+4]
    mov edx, [edi]
    int 0x80
    call newline
    test_input_string ";"
    jne terminate_program
    
LB23:
    
LB27:
    ret
    
FUNCTION_CALL_ARGUMENT:
    call test_for_id
    jne LB28
    print "push "
    call copy_last_match
    call newline
    
LB28:
    
LB29:
    ret
    