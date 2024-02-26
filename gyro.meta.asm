
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
    call PAREN_EXPRESSION
    call vstack_pop
    je LB1
    call set_true
    jne terminate_program
    
LB2:
    
LB3:
    ret
    
PAREN_EXPRESSION:
    test_input_string "("
    jne LB4
    vstack_push 0xFFFF
    call ARITHMETIC_EXPRESSION
    call vstack_pop
    jne LB5
    
LB5:
    je LB6
    vstack_push 0xFFFF
    call DEFINE_STATEMENT
    call vstack_pop
    jne LB7
    
LB7:
    je LB6
    vstack_push 0xFFFF
    call BUILTINS
    call vstack_pop
    jne LB8
    
LB8:
    je LB6
    vstack_push 0xFFFF
    call FUNCTION_CALL
    call vstack_pop
    jne LB9
    
LB9:
    
LB6:
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB4:
    
LB10:
    ret
    
DEFINE_STATEMENT:
    test_input_string "define"
    jne LB11
    vstack_push 0xFFFF
    call DEFINE_CONST_STATEMENT
    call vstack_pop
    jne LB12
    
LB12:
    je LB13
    vstack_push 0xFFFF
    call DEFINE_FUNCTION_STATEMENT
    call vstack_pop
    jne LB14
    
LB14:
    
LB13:
    jne terminate_program
    
LB11:
    
LB15:
    ret
    
DEFINE_CONST_STATEMENT:
    call test_for_id
    jne LB16
    call label
    print "section .data"
    call newline
    call copy_last_match
    print " db "
    call test_for_number
    jne terminate_program
    call copy_last_match
    call newline
    call label
    print "section .text"
    call newline
    
LB16:
    
LB17:
    ret
    
DEFINE_FUNCTION_STATEMENT:
    test_input_string "("
    jne LB18
    call test_for_id
    jne terminate_program
    call label
    call copy_last_match
    print ":"
    call newline
    
LB19:
    call test_for_id
    jne LB20
    
LB20:
    
LB21:
    je LB19
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB22:
    vstack_push 0xFFFF
    call PAREN_EXPRESSION
    call vstack_pop
    je LB22
    call set_true
    jne terminate_program
    
LB18:
    
LB23:
    ret
    
ARITHMETIC_EXPRESSION:
    test_input_string "*"
    jne LB24
    vstack_push 0xFFFF
    call ARITHMETIC_EXPRESSION_ARGUMENT_FIRST
    call vstack_pop
    jne terminate_program
    vstack_push 0xFFFF
    call ARITHMETIC_EXPRESSION_ARGUMENT_REST
    call vstack_pop
    jne terminate_program
    
LB24:
    
LB25:
    ret
    
ARITHMETIC_EXPRESSION_ARGUMENT_FIRST:
    call test_for_id
    jne LB26
    print "mov eax, ["
    call copy_last_match
    print "]"
    call newline
    
LB26:
    
LB27:
    jne LB28
    
LB28:
    je LB29
    call test_for_number
    jne LB30
    print "mov eax, "
    call copy_last_match
    call newline
    
LB30:
    
LB31:
    jne LB32
    
LB32:
    
LB29:
    ret
    
ARITHMETIC_EXPRESSION_ARGUMENT_REST:
    call test_for_id
    jne LB33
    print "imul eax, ["
    call copy_last_match
    print "]"
    call newline
    
LB33:
    
LB34:
    jne LB35
    
LB35:
    je LB36
    call test_for_number
    jne LB37
    print "imul eax, "
    call copy_last_match
    call newline
    
LB37:
    
LB38:
    jne LB39
    
LB39:
    
LB36:
    ret
    
FUNCTION_CALL:
    call test_for_id
    jne LB40
    vector_push_string_mm32 str_vector_8192, last_match
    jne terminate_program
    vstack_push 0xFFFF
    call FUNCTION_CALL_ARGUMENT
    call vstack_pop
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
    
LB40:
    
LB41:
    ret
    
FUNCTION_CALL_ARGUMENT:
    call test_for_id
    jne LB42
    print "push ["
    call copy_last_match
    print "]"
    call newline
    
LB42:
    je LB43
    call test_for_number
    jne LB44
    print "push "
    call copy_last_match
    call newline
    
LB44:
    
LB43:
    ret
    
BUILTINS:
    test_input_string "print"
    jne LB45
    
LB45:
    je LB46
    test_input_string "println"
    jne LB47
    
LB47:
    je LB46
    test_input_string "input"
    jne LB48
    
LB48:
    je LB46
    test_input_string "exit"
    jne LB49
    print "mov eax, 1"
    call newline
    print "mov ebx, 0"
    call newline
    print "int 0x80"
    call newline
    
LB49:
    
LB46:
    ret
    
