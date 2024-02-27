%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .data
    x dd 5
    
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
    test_input_string ".SYNTAX"
    jne LB9
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
    
LB10:
    vstack_push 0xFFFF
    call DEFINITION
    call vstack_pop
    jne LB11
    
LB11:
    je LB12
    vstack_push 0xFFFF
    call IMPORT_STATEMENT
    call vstack_pop
    jne LB13
    
LB13:
    je LB12
    vstack_push 0xFFFF
    call COMMENT
    call vstack_pop
    jne LB14
    
LB14:
    
LB12:
    je LB10
    call set_true
    jne terminate_program
    test_input_string ".END"
    jne terminate_program
    
LB9:
    
LB15:
    jne LB16
    
LB16:
    
LB8:
    je LB1
    call set_true
    jne terminate_program
    
LB17:
    
LB18:
    ret
    
IMPORT_STATEMENT:
    test_input_string ".IMPORT"
    jne LB19
    call test_for_string_raw
    jne terminate_program
    test_input_string ";"
    jne terminate_program
    mov esi, last_match
    call import_meta_file_mm32
    
LB19:
    
LB20:
    ret
    
DATA_DEFINITION:
    call test_for_id
    jne LB21
    call copy_last_match
    test_input_string "="
    jne terminate_program
    vstack_push 0xFFFF
    call DATA_TYPE
    call vstack_pop
    jne terminate_program
    test_input_string ";"
    jne terminate_program
    
LB21:
    
LB22:
    ret
    
DATA_TYPE:
    call test_for_string
    jne LB23
    print " db "
    call copy_last_match
    print ", 0x00"
    call newline
    
LB23:
    
LB24:
    jne LB25
    
LB25:
    je LB26
    call test_for_number
    jne LB27
    print " dd "
    call copy_last_match
    call newline
    
LB27:
    
LB28:
    jne LB29
    
LB29:
    
LB26:
    ret
    
OUT1:
    test_input_string "*1"
    jne LB30
    print "call gn1"
    call newline
    
LB30:
    je LB31
    test_input_string "*2"
    jne LB32
    print "call gn2"
    call newline
    
LB32:
    je LB31
    test_input_string "*"
    jne LB33
    print "call copy_last_match"
    call newline
    
LB33:
    je LB31
    test_input_string "%"
    jne LB34
    print "mov edi, str_vector_8192"
    call newline
    print "call vector_pop_string"
    call newline
    print "call print_mm32"
    call newline
    
LB34:
    je LB31
    test_input_string "["
    jne LB35
    print "pushfd"
    call newline
    print "push eax"
    call newline
    vstack_push 0xFFFF
    call BRACKET_EXPR
    call vstack_pop
    jne terminate_program
    test_input_string "]"
    jne terminate_program
    print "pop edi"
    call newline
    print "pop eax"
    call newline
    print "popfd"
    call newline
    print "print_int edi"
    call newline
    
LB35:
    je LB31
    call test_for_string
    jne LB36
    print "print "
    call copy_last_match
    call newline
    
LB36:
    
LB31:
    ret
    
OUT_IMMEDIATE:
    call test_for_string_raw
    jne LB37
    call copy_last_match
    call newline
    
LB37:
    
LB38:
    ret
    
OUTPUT:
    test_input_string "->"
    jne LB39
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
    je LB41
    test_input_string ".LABEL"
    jne LB42
    print "call label"
    call newline
    test_input_string "("
    jne terminate_program
    
LB43:
    vstack_push 0xFFFF
    call OUT1
    call vstack_pop
    je LB43
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    print "call newline"
    call newline
    
LB42:
    je LB41
    test_input_string ".RS"
    jne LB44
    test_input_string "("
    jne terminate_program
    
LB45:
    vstack_push 0xFFFF
    call OUT1
    call vstack_pop
    je LB45
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB44:
    
LB41:
    jne LB46
    
LB46:
    je LB47
    test_input_string ".DIRECT"
    jne LB48
    test_input_string "("
    jne terminate_program
    
LB49:
    vstack_push 0xFFFF
    call OUT_IMMEDIATE
    call vstack_pop
    je LB49
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB48:
    je LB47
    test_input_string ".OUT"
    jne LB50
    test_input_string "("
    jne terminate_program
    
LB51:
    vstack_push 0xFFFF
    call OUT1
    call vstack_pop
    je LB51
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB50:
    
LB47:
    ret
    
EX3:
    call test_for_id
    jne LB52
    print "vstack_push 0xFFFF"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_pop"
    call newline
    
LB52:
    je LB53
    call test_for_string
    jne LB54
    print "test_input_string "
    call copy_last_match
    call newline
    
LB54:
    je LB53
    test_input_string ".ID"
    jne LB55
    print "call test_for_id"
    call newline
    
LB55:
    je LB53
    test_input_string ".RET"
    jne LB56
    print "ret"
    call newline
    
LB56:
    je LB53
    test_input_string ".NOT"
    jne LB57
    call test_for_string
    jne LB58
    
LB58:
    je LB59
    call test_for_number
    jne LB60
    
LB60:
    
LB59:
    jne terminate_program
    print "match_not "
    call copy_last_match
    call newline
    
LB57:
    je LB53
    test_input_string ".NUMBER"
    jne LB61
    print "call test_for_number"
    call newline
    
LB61:
    je LB53
    test_input_string ".STRING_RAW"
    jne LB62
    print "call test_for_string_raw"
    call newline
    
LB62:
    je LB53
    test_input_string ".STRING"
    jne LB63
    print "call test_for_string"
    call newline
    
LB63:
    je LB53
    test_input_string "%>"
    jne LB64
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LB64:
    je LB53
    test_input_string "("
    jne LB65
    vstack_push 0xFFFF
    call EX1
    call vstack_pop
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB65:
    je LB53
    test_input_string "["
    jne LB66
    print "pushfd"
    call newline
    print "push eax"
    call newline
    vstack_push 0xFFFF
    call BRACKET_EXPR
    call vstack_pop
    jne terminate_program
    test_input_string "]"
    jne terminate_program
    print "pop edi"
    call newline
    print "pop eax"
    call newline
    print "popfd"
    call newline
    
LB66:
    je LB53
    test_input_string ".EMPTY"
    jne LB67
    print "call set_true"
    call newline
    
LB67:
    je LB53
    test_input_string "$"
    jne LB68
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
    
LB68:
    
LB53:
    ret
    
EX2:
    vstack_push 0xFFFF
    call EX3
    call vstack_pop
    jne LB69
    print "jne "
    call gn1
    call newline
    
LB69:
    je LB70
    vstack_push 0xFFFF
    call OUTPUT
    call vstack_pop
    jne LB71
    
LB71:
    
LB70:
    jne LB72
    
LB73:
    vstack_push 0xFFFF
    call EX3
    call vstack_pop
    jne LB74
    print "jne terminate_program"
    call newline
    
LB74:
    je LB75
    vstack_push 0xFFFF
    call OUTPUT
    call vstack_pop
    jne LB76
    
LB76:
    
LB75:
    je LB73
    call set_true
    jne terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LB72:
    
LB77:
    ret
    
EX1:
    vstack_push 0xFFFF
    call EX2
    call vstack_pop
    jne LB78
    
LB79:
    test_input_string "|"
    jne LB80
    print "je "
    call gn1
    call newline
    vstack_push 0xFFFF
    call EX2
    call vstack_pop
    jne terminate_program
    
LB80:
    
LB81:
    je LB79
    call set_true
    jne terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LB78:
    
LB82:
    ret
    
BRACKET_EXPR:
    test_input_string "+"
    jne LB83
    vstack_push 0xFFFF
    call BRACKET_ARG
    call vstack_pop
    jne terminate_program
    vstack_push 0xFFFF
    call BRACKET_ARG
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
    
LB83:
    
LB84:
    jne LB85
    
LB85:
    je LB86
    test_input_string "-"
    jne LB87
    vstack_push 0xFFFF
    call BRACKET_ARG
    call vstack_pop
    jne terminate_program
    vstack_push 0xFFFF
    call BRACKET_ARG
    call vstack_pop
    jne terminate_program
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "sub eax, ebx"
    call newline
    print "push eax"
    call newline
    
LB87:
    
LB88:
    jne LB89
    
LB89:
    je LB86
    test_input_string "*"
    jne LB90
    vstack_push 0xFFFF
    call BRACKET_ARG
    call vstack_pop
    jne terminate_program
    vstack_push 0xFFFF
    call BRACKET_ARG
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
    
LB90:
    
LB91:
    jne LB92
    
LB92:
    je LB86
    test_input_string "/"
    jne LB93
    vstack_push 0xFFFF
    call BRACKET_ARG
    call vstack_pop
    jne terminate_program
    vstack_push 0xFFFF
    call BRACKET_ARG
    call vstack_pop
    jne terminate_program
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "idiv eax, ebx"
    call newline
    print "push eax"
    call newline
    
LB93:
    
LB94:
    jne LB95
    
LB95:
    je LB86
    test_input_string "set"
    jne LB96
    call test_for_id
    jne terminate_program
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    jne terminate_program
    vstack_push 0xFFFF
    call BRACKET_ARG
    call vstack_pop
    jne terminate_program
    print "pop eax"
    call newline
    print "mov ["
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LB96:
    
LB97:
    jne LB98
    
LB98:
    je LB86
    call test_for_id
    jne LB99
    print "push dword ["
    call copy_last_match
    print "]"
    call newline
    
LB99:
    
LB100:
    jne LB101
    
LB101:
    je LB86
    call test_for_number
    jne LB102
    print "push "
    call copy_last_match
    call newline
    
LB102:
    
LB103:
    jne LB104
    
LB104:
    
LB86:
    ret
    
BRACKET_ARG:
    test_input_string "["
    jne LB105
    vstack_push 0xFFFF
    call BRACKET_EXPR
    call vstack_pop
    jne terminate_program
    test_input_string "]"
    jne terminate_program
    
LB105:
    
LB106:
    jne LB107
    
LB107:
    je LB108
    call test_for_number
    jne LB109
    print "push "
    call copy_last_match
    call newline
    
LB109:
    
LB110:
    jne LB111
    
LB111:
    je LB108
    call test_for_id
    jne LB112
    print "push dword ["
    call copy_last_match
    print "]"
    call newline
    
LB112:
    
LB113:
    jne LB114
    
LB114:
    
LB108:
    ret
    
DEFINITION:
    call test_for_id
    jne LB115
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
    
LB115:
    
LB116:
    ret
    
COMMENT:
    test_input_string "//"
    jne LB117
    match_not 10
    jne terminate_program
    
LB117:
    
LB118:
    ret