%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .data
    x db "awd", 0x00
    
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
    print "%define MAX_INPUT_LENGTH 65536"
    call newline
    call label
    print "%include './lib/asm_macros.asm'"
    call newline
    
LB1:
    test_input_string ".DATA"
    jne LB2
    call label
    print "section .data"
    call newline
    
LB3:
    vstack_push 0xFFFF
    call DATA_DEFINITION
    call vstack_pop
    jne LB4
    
LB4:
    
LB5:
    je LB3
    call set_true
    jne terminate_program
    
LB2:
    
LB6:
    jne LB7
    
LB7:
    je LB8
    test_input_string ".IMPORT"
    jne LB9
    call label
    print "section .text"
    call newline
    call test_for_string
    jne terminate_program
    print "import_meta_file "
    call copy_last_match
    call newline
    
LB9:
    
LB10:
    jne LB11
    
LB11:
    je LB8
    test_input_string ".SYNTAX"
    jne LB12
    call test_for_id
    jne terminate_program
    call label
    print "section .text"
    call newline
    print "global _start"
    call newline
    call label
    print "_start:"
    call newline
    print "call _read_file_argument"
    call newline
    print "call _read_file"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "mov eax, 1"
    call newline
    print "mov ebx, 0"
    call newline
    print "int 0x80"
    call newline
    
LB13:
    vstack_push 0xFFFF
    call DEFINITION
    call vstack_pop
    jne LB14
    
LB14:
    
LB15:
    je LB13
    call set_true
    jne terminate_program
    test_input_string ".END"
    jne terminate_program
    
LB12:
    
LB16:
    jne LB17
    
LB17:
    
LB8:
    je LB1
    call set_true
    jne terminate_program
    
LB18:
    
LB19:
    ret
    
DATA_DEFINITION:
    call test_for_id
    jne LB20
    call copy_last_match
    test_input_string "="
    jne terminate_program
    vstack_push 0xFFFF
    call DATA_TYPE
    call vstack_pop
    jne terminate_program
    test_input_string ";"
    jne terminate_program
    
LB20:
    
LB21:
    ret
    
DATA_TYPE:
    call test_for_string
    jne LB22
    print " db "
    call copy_last_match
    print ", 0x00"
    call newline
    
LB22:
    
LB23:
    jne LB24
    
LB24:
    je LB25
    call test_for_number
    jne LB26
    print " dd "
    call copy_last_match
    call newline
    
LB26:
    
LB27:
    jne LB28
    
LB28:
    
LB25:
    ret
    
OUT1:
    test_input_string "*1"
    jne LB29
    print "call gn1"
    call newline
    
LB29:
    je LB30
    test_input_string "*2"
    jne LB31
    print "call gn2"
    call newline
    
LB31:
    je LB30
    test_input_string "*"
    jne LB32
    print "call copy_last_match"
    call newline
    
LB32:
    je LB30
    test_input_string "%"
    jne LB33
    print "vector_pop_string str_vector_8192"
    call newline
    print "mov edi, eax"
    call newline
    print "mov eax, 4"
    call newline
    print "mov ebx, 1"
    call newline
    print "mov ecx, [edi+4]"
    call newline
    print "mov edx, [edi]"
    call newline
    print "int 0x80"
    call newline
    
LB33:
    je LB30
    test_input_string "["
    jne LB34
    call test_for_id
    jne terminate_program
    print "print_ref "
    call copy_last_match
    call newline
    test_input_string "]"
    jne terminate_program
    
LB34:
    je LB30
    call test_for_string
    jne LB35
    print "print "
    call copy_last_match
    call newline
    
LB35:
    
LB30:
    ret
    
OUTPUT:
    test_input_string "->"
    jne LB36
    test_input_string "("
    jne terminate_program
    
LB37:
    vstack_push 0xFFFF
    call OUT1
    call vstack_pop
    je LB37
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    print "call newline"
    call newline
    
LB36:
    je LB38
    test_input_string ".LABEL"
    jne LB39
    print "call label"
    call newline
    test_input_string "("
    jne terminate_program
    
LB40:
    vstack_push 0xFFFF
    call OUT1
    call vstack_pop
    je LB40
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    print "call newline"
    call newline
    
LB39:
    je LB38
    test_input_string ".RS"
    jne LB41
    test_input_string "("
    jne terminate_program
    
LB42:
    vstack_push 0xFFFF
    call OUT1
    call vstack_pop
    je LB42
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB41:
    
LB38:
    jne LB43
    
LB43:
    je LB44
    test_input_string ".OUT"
    jne LB45
    test_input_string "("
    jne terminate_program
    
LB46:
    vstack_push 0xFFFF
    call OUT1
    call vstack_pop
    je LB46
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB45:
    
LB44:
    ret
    
EX3:
    call test_for_id
    jne LB47
    print "vstack_push 0xFFFF"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_pop"
    call newline
    
LB47:
    je LB48
    call test_for_string
    jne LB49
    print "test_input_string "
    call copy_last_match
    call newline
    
LB49:
    je LB48
    test_input_string ".ID"
    jne LB50
    print "call test_for_id"
    call newline
    
LB50:
    je LB48
    test_input_string ".RET"
    jne LB51
    print "ret"
    call newline
    
LB51:
    je LB48
    test_input_string ".NOT"
    jne LB52
    call test_for_string
    jne LB53
    
LB53:
    je LB54
    call test_for_number
    jne LB55
    
LB55:
    
LB54:
    jne terminate_program
    print "match_not "
    call copy_last_match
    call newline
    
LB52:
    je LB48
    test_input_string ".NUMBER"
    jne LB56
    print "call test_for_number"
    call newline
    
LB56:
    je LB48
    test_input_string ".STRING"
    jne LB57
    print "call test_for_string"
    call newline
    
LB57:
    je LB48
    test_input_string "%>"
    jne LB58
    print "vector_push_string_mm32 str_vector_8192, last_match"
    call newline
    
LB58:
    je LB48
    test_input_string "("
    jne LB59
    vstack_push 0xFFFF
    call EX1
    call vstack_pop
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB59:
    je LB48
    test_input_string ".EMPTY"
    jne LB60
    print "call set_true"
    call newline
    
LB60:
    je LB48
    test_input_string "$"
    jne LB61
    call label
    call gn1
    print ":"
    call newline
    vstack_push 0xFFFF
    call EX3
    call vstack_pop
    jne terminate_program
    print "je "
    call gn1
    call newline
    print "call set_true"
    call newline
    
LB61:
    
LB48:
    ret
    
EX2:
    vstack_push 0xFFFF
    call EX3
    call vstack_pop
    jne LB62
    print "jne "
    call gn1
    call newline
    
LB62:
    je LB63
    vstack_push 0xFFFF
    call OUTPUT
    call vstack_pop
    jne LB64
    
LB64:
    
LB63:
    jne LB65
    
LB66:
    vstack_push 0xFFFF
    call EX3
    call vstack_pop
    jne LB67
    print "jne terminate_program"
    call newline
    
LB67:
    je LB68
    vstack_push 0xFFFF
    call OUTPUT
    call vstack_pop
    jne LB69
    
LB69:
    
LB68:
    je LB66
    call set_true
    jne terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LB65:
    
LB70:
    ret
    
EX1:
    vstack_push 0xFFFF
    call EX2
    call vstack_pop
    jne LB71
    
LB72:
    test_input_string "|"
    jne LB73
    print "je "
    call gn1
    call newline
    vstack_push 0xFFFF
    call EX2
    call vstack_pop
    jne terminate_program
    
LB73:
    
LB74:
    je LB72
    call set_true
    jne terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LB71:
    
LB75:
    ret
    
DEFINITION:
    call test_for_id
    jne LB76
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    jne terminate_program
    vstack_push 0xFFFF
    call EX1
    call vstack_pop
    jne terminate_program
    test_input_string ";"
    jne terminate_program
    print "ret"
    call newline
    
LB76:
    
LB77:
    ret