
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
    call LET_EXPRESSION
    call vstack_pop
    jne LB2
    test_input_string ";"
    jne terminate_program
    
LB2:
    je LB3
    vstack_push 0xFFFF
    call FN_EXPRESSION
    call vstack_pop
    jne LB4
    
LB4:
    je LB3
    vstack_push 0xFFFF
    call FN_CALL
    call vstack_pop
    jne LB5
    test_input_string ";"
    jne terminate_program
    
LB5:
    
LB3:
    je LB1
    call set_true
    jne terminate_program
    print "mov eax, 4"
    call newline
    print "mov ebx, 1"
    call newline
    print "int 0x80"
    call newline
    
LB6:
    
LB7:
    ret
    
AEXP:
    vstack_push 0xFFFF
    call EX2
    call vstack_pop
    jne LB8
    
LB9:
    test_input_string "+"
    jne LB10
    vstack_push 0xFFFF
    call EX2
    call vstack_pop
    jne terminate_program
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "add eax, ebx"
    call newline
    print "push eax"
    call newline
    
LB10:
    je LB11
    test_input_string "-"
    jne LB12
    vstack_push 0xFFFF
    call EX2
    call vstack_pop
    jne terminate_program
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "sub eax, ebx"
    call newline
    print "push eax"
    call newline
    
LB12:
    
LB11:
    je LB9
    call set_true
    jne terminate_program
    
LB8:
    
LB13:
    ret
    
EX2:
    vstack_push 0xFFFF
    call EX3
    call vstack_pop
    jne LB14
    
LB15:
    test_input_string "*"
    jne LB16
    vstack_push 0xFFFF
    call EX3
    call vstack_pop
    jne terminate_program
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "mul eax, ebx"
    call newline
    print "push eax"
    call newline
    
LB16:
    je LB17
    test_input_string "/"
    jne LB18
    vstack_push 0xFFFF
    call EX3
    call vstack_pop
    jne terminate_program
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "idiv eax, ebx"
    call newline
    print "push eax"
    call newline
    
LB18:
    
LB17:
    je LB15
    call set_true
    jne terminate_program
    
LB14:
    
LB19:
    ret
    
EX3:
    vstack_push 0xFFFF
    call EX4
    call vstack_pop
    jne LB20
    
LB21:
    test_input_string "^"
    jne LB22
    vstack_push 0xFFFF
    call EX3
    call vstack_pop
    jne terminate_program
    print "exp"
    call newline
    
LB22:
    
LB23:
    je LB21
    call set_true
    jne terminate_program
    
LB20:
    
LB24:
    ret
    
EX4:
    test_input_string "+"
    jne LB25
    vstack_push 0xFFFF
    call EX5
    call vstack_pop
    jne terminate_program
    
LB25:
    je LB26
    test_input_string "-"
    jne LB27
    vstack_push 0xFFFF
    call EX5
    call vstack_pop
    jne terminate_program
    print "minus"
    call newline
    
LB27:
    je LB26
    vstack_push 0xFFFF
    call EX5
    call vstack_pop
    jne LB28
    
LB28:
    
LB26:
    ret
    
EX5:
    call test_for_id
    jne LB29
    print "push dword ["
    call copy_last_match
    print "]"
    call newline
    
LB29:
    je LB30
    call test_for_number
    jne LB31
    print "push "
    call copy_last_match
    call newline
    
LB31:
    je LB30
    test_input_string "("
    jne LB32
    vstack_push 0xFFFF
    call AEXP
    call vstack_pop
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB32:
    
LB30:
    ret
    
FN_EXPRESSION:
    test_input_string "fn"
    jne LB33
    print "jmp "
    call gn1
    call newline
    call test_for_id
    jne terminate_program
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "("
    jne terminate_program
    
LB34:
    vstack_push 0xFFFF
    call FN_ARGUMENTS
    call vstack_pop
    je LB34
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    test_input_string "{"
    jne terminate_program
    vstack_push 0xFFFF
    call BODY
    call vstack_pop
    jne terminate_program
    test_input_string "}"
    jne terminate_program
    print "push ebp"
    call newline
    print "ret"
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LB33:
    
LB35:
    ret
    
FN_ARGUMENTS:
    call test_for_id
    jne LB36
    call label
    print "section .data"
    call newline
    call copy_last_match
    print " dd 0x00"
    call newline
    call label
    print "section .text"
    call newline
    print "pop ebp"
    call newline
    print "pop eax"
    call newline
    print "mov ["
    call copy_last_match
    print "], eax"
    call newline
    
LB37:
    test_input_string ","
    jne LB38
    call test_for_id
    jne terminate_program
    print "pop "
    call copy_last_match
    call newline
    
LB38:
    
LB39:
    je LB37
    call set_true
    jne terminate_program
    
LB36:
    
LB40:
    ret
    
BODY:
    
LB41:
    vstack_push 0xFFFF
    call RETURN_EXPRESSION
    call vstack_pop
    jne LB42
    test_input_string ";"
    jne terminate_program
    
LB42:
    je LB43
    vstack_push 0xFFFF
    call IF_STATEMENT
    call vstack_pop
    jne LB44
    
LB44:
    je LB43
    vstack_push 0xFFFF
    call LET_EXPRESSION
    call vstack_pop
    jne LB45
    test_input_string ";"
    jne terminate_program
    
LB45:
    je LB43
    vstack_push 0xFFFF
    call FN_CALL
    call vstack_pop
    jne LB46
    test_input_string ";"
    jne terminate_program
    
LB46:
    je LB43
    vstack_push 0xFFFF
    call FN_EXPRESSION
    call vstack_pop
    jne LB47
    
LB47:
    
LB43:
    je LB41
    call set_true
    jne LB48
    
LB48:
    
LB49:
    ret
    
FN_CALL:
    call test_for_id
    jne LB50
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    jne terminate_program
    test_input_string "("
    jne terminate_program
    
LB51:
    vstack_push 0xFFFF
    call FN_CALL_ARGUMENTS
    call vstack_pop
    je LB51
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    mov edi, eax
    call print_mm32
    call newline
    
LB50:
    
LB52:
    ret
    
FN_CALL_ARGUMENTS:
    vstack_push 0xFFFF
    call FN_CALL_NUM_ARG
    call vstack_pop
    jne LB53
    
LB53:
    je LB54
    vstack_push 0xFFFF
    call FN_CALL_ID_ARG
    call vstack_pop
    jne LB55
    
LB55:
    
LB54:
    jne LB56
    
LB57:
    test_input_string ","
    jne LB58
    vstack_push 0xFFFF
    call FN_CALL_NUM_ARG
    call vstack_pop
    jne LB59
    
LB59:
    je LB60
    vstack_push 0xFFFF
    call FN_CALL_ID_ARG
    call vstack_pop
    jne LB61
    
LB61:
    
LB60:
    jne terminate_program
    
LB58:
    
LB62:
    je LB57
    call set_true
    jne terminate_program
    
LB56:
    
LB63:
    ret
    
FN_CALL_NUM_ARG:
    call test_for_number
    jne LB64
    print "push "
    call copy_last_match
    call newline
    
LB64:
    
LB65:
    ret
    
FN_CALL_ID_ARG:
    call test_for_id
    jne LB66
    print "push ["
    call copy_last_match
    print "]"
    call newline
    
LB66:
    
LB67:
    ret
    
IF_STATEMENT:
    test_input_string "if"
    jne LB68
    test_input_string "("
    jne terminate_program
    vstack_push 0xFFFF
    call AEXP
    call vstack_pop
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    print "pop eax"
    call newline
    print "cmp eax, 0"
    call newline
    print "jne "
    call gn1
    call newline
    test_input_string "{"
    jne terminate_program
    vstack_push 0xFFFF
    call BODY
    call vstack_pop
    jne terminate_program
    test_input_string "}"
    jne terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LB68:
    
LB69:
    ret
    
RETURN_EXPRESSION:
    test_input_string "return"
    jne LB70
    vstack_push 0xFFFF
    call AEXP
    call vstack_pop
    jne terminate_program
    print "pop eax"
    call newline
    print "push ebp"
    call newline
    print "ret"
    call newline
    
LB70:
    
LB71:
    ret
    
LET_EXPRESSION:
    test_input_string "let"
    jne LB72
    call test_for_id
    jne terminate_program
    call label
    print "section .data"
    call newline
    call copy_last_match
    print " dd 0x00"
    call newline
    call label
    print "section .text"
    call newline
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    jne terminate_program
    test_input_string "="
    jne terminate_program
    vstack_push 0xFFFF
    call AEXP
    call vstack_pop
    jne terminate_program
    print "pop eax"
    call newline
    print "mov ["
    mov edi, str_vector_8192
    call vector_pop_string
    mov edi, eax
    call print_mm32
    print "], eax"
    call newline
    
LB72:
    
LB73:
    ret
    
