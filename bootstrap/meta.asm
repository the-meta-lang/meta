
%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .data
    line dd 0
    
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
    
LA1:
    test_input_string ".DATA"
    jne LA2
    call label
    print "section .data"
    call newline
    
LA3:
    call vstack_clear
    call DATA_DEFINITION
    call vstack_restore
    jne LA4
    
LA4:
    je LA5
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA6
    
LA6:
    
LA5:
    je LA3
    call set_true
    mov esi, 0
    jne terminate_program ; 0
    
LA2:
    
LA7:
    jne LA8
    
LA8:
    je LA9
    test_input_string ".SYNTAX"
    jne LA10
    call test_for_id
    mov esi, 1
    jne terminate_program ; 1
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
    
LA11:
    call vstack_clear
    call DEFINITION
    call vstack_restore
    jne LA12
    
LA12:
    je LA13
    call vstack_clear
    call INCLUDE_STATEMENT
    call vstack_restore
    jne LA14
    
LA14:
    je LA13
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA15
    
LA15:
    
LA13:
    je LA11
    call set_true
    mov esi, 9
    jne terminate_program ; 9
    test_input_string ".END"
    mov esi, 10
    jne terminate_program ; 10
    
LA10:
    
LA16:
    jne LA17
    
LA17:
    
LA9:
    je LA1
    call set_true
    mov esi, 11
    jne terminate_program ; 11
    
LA18:
    
LA19:
    ret
    
INCLUDE_STATEMENT:
    test_input_string ".INCLUDE"
    jne LA20
    call test_for_string_raw
    mov esi, 12
    jne terminate_program ; 12
    test_input_string ";"
    mov esi, 13
    jne terminate_program ; 13
    mov esi, last_match
    call import_meta_file_mm32
    call set_true
    
LA20:
    
LA21:
    ret
    
DATA_DEFINITION:
    call test_for_id
    jne LA22
    call copy_last_match
    test_input_string "="
    mov esi, 14
    jne terminate_program ; 14
    call vstack_clear
    call DATA_TYPE
    call vstack_restore
    mov esi, 15
    jne terminate_program ; 15
    test_input_string ";"
    mov esi, 16
    jne terminate_program ; 16
    
LA22:
    
LA23:
    ret
    
DATA_TYPE:
    test_input_string "{"
    jne LA24
    call test_for_number
    mov esi, 17
    jne terminate_program ; 17
    print " times "
    call copy_last_match
    print " dd 0x00"
    call newline
    test_input_string "}"
    mov esi, 19
    jne terminate_program ; 19
    
LA24:
    
LA25:
    jne LA26
    
LA26:
    je LA27
    call test_for_string
    jne LA28
    print " db "
    call copy_last_match
    print ", 0x00"
    call newline
    
LA28:
    
LA29:
    jne LA30
    
LA30:
    je LA27
    call test_for_number
    jne LA31
    print " dd "
    call copy_last_match
    call newline
    
LA31:
    
LA32:
    jne LA33
    
LA33:
    
LA27:
    ret
    
OUT1:
    test_input_string "*1"
    jne LA34
    print "call gn1"
    call newline
    
LA34:
    je LA35
    test_input_string "*2"
    jne LA36
    print "call gn2"
    call newline
    
LA36:
    je LA35
    test_input_string "*3"
    jne LA37
    print "call gn3"
    call newline
    
LA37:
    je LA35
    test_input_string "*4"
    jne LA38
    print "call gn4"
    call newline
    
LA38:
    je LA35
    test_input_string "*"
    jne LA39
    print "call copy_last_match"
    call newline
    
LA39:
    je LA35
    test_input_string "%"
    jne LA40
    print "mov edi, str_vector_8192"
    call newline
    print "call vector_pop_string"
    call newline
    print "call print_mm32"
    call newline
    
LA40:
    je LA35
    test_input_string "["
    jne LA41
    print "pushfd"
    call newline
    print "push eax"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 32
    jne terminate_program ; 32
    test_input_string "]"
    mov esi, 33
    jne terminate_program ; 33
    print "pop edi"
    call newline
    print "pop eax"
    call newline
    print "popfd"
    call newline
    print "print_int edi"
    call newline
    
LA41:
    je LA35
    call test_for_string
    jne LA42
    print "print "
    call copy_last_match
    call newline
    
LA42:
    
LA35:
    ret
    
OUT_IMMEDIATE:
    call test_for_string_raw
    jne LA43
    call copy_last_match
    call newline
    
LA43:
    
LA44:
    ret
    
OUTPUT:
    test_input_string "->"
    jne LA45
    test_input_string "("
    mov esi, 40
    jne terminate_program ; 40
    
LA46:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA47
    
LA47:
    
LA48:
    je LA46
    call set_true
    mov esi, 41
    jne terminate_program ; 41
    test_input_string ")"
    mov esi, 42
    jne terminate_program ; 42
    print "call newline"
    call newline
    pushfd
    push eax
    push dword [line]
    push 1
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [line], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 44
    jne terminate_program ; 44
    
LA45:
    je LA49
    test_input_string ".LABEL"
    jne LA50
    print "call label"
    call newline
    test_input_string "("
    mov esi, 46
    jne terminate_program ; 46
    
LA51:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA52
    
LA52:
    
LA53:
    je LA51
    call set_true
    mov esi, 47
    jne terminate_program ; 47
    test_input_string ")"
    mov esi, 48
    jne terminate_program ; 48
    print "call newline"
    call newline
    
LA50:
    je LA49
    test_input_string ".RS"
    jne LA54
    test_input_string "("
    mov esi, 50
    jne terminate_program ; 50
    
LA55:
    call vstack_clear
    call OUT1
    call vstack_restore
    je LA55
    call set_true
    mov esi, 51
    jne terminate_program ; 51
    test_input_string ")"
    mov esi, 52
    jne terminate_program ; 52
    
LA54:
    
LA49:
    jne LA56
    
LA56:
    je LA57
    test_input_string ".DIRECT"
    jne LA58
    test_input_string "("
    mov esi, 53
    jne terminate_program ; 53
    
LA59:
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    je LA59
    call set_true
    mov esi, 54
    jne terminate_program ; 54
    test_input_string ")"
    mov esi, 55
    jne terminate_program ; 55
    
LA58:
    
LA57:
    ret
    
EX3:
    call test_for_id
    jne LA60
    print "call vstack_clear"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_restore"
    call newline
    
LA60:
    je LA61
    call test_for_string
    jne LA62
    print "test_input_string "
    call copy_last_match
    call newline
    
LA62:
    je LA61
    test_input_string ".ID"
    jne LA63
    print "call test_for_id"
    call newline
    
LA63:
    je LA61
    test_input_string ".RET"
    jne LA64
    print "ret"
    call newline
    
LA64:
    je LA61
    test_input_string ".NOT"
    jne LA65
    call test_for_string
    jne LA66
    
LA66:
    je LA67
    call test_for_number
    jne LA68
    
LA68:
    
LA67:
    mov esi, 62
    jne terminate_program ; 62
    print "match_not "
    call copy_last_match
    call newline
    
LA65:
    je LA61
    test_input_string ".NUMBER"
    jne LA69
    print "call test_for_number"
    call newline
    
LA69:
    je LA61
    test_input_string ".STRING_RAW"
    jne LA70
    print "call test_for_string_raw"
    call newline
    
LA70:
    je LA61
    test_input_string ".STRING"
    jne LA71
    print "call test_for_string"
    call newline
    
LA71:
    je LA61
    test_input_string "%>"
    jne LA72
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA72:
    je LA61
    test_input_string "("
    jne LA73
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 70
    jne terminate_program ; 70
    test_input_string ")"
    mov esi, 71
    jne terminate_program ; 71
    
LA73:
    je LA61
    test_input_string "["
    jne LA74
    print "pushfd"
    call newline
    print "push eax"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 74
    jne terminate_program ; 74
    test_input_string "]"
    mov esi, 75
    jne terminate_program ; 75
    print "pop edi"
    call newline
    print "pop eax"
    call newline
    print "popfd"
    call newline
    
LA74:
    je LA61
    test_input_string ".EMPTY"
    jne LA75
    print "call set_true"
    call newline
    
LA75:
    je LA61
    test_input_string "$"
    jne LA76
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call EX3
    call vstack_restore
    mov esi, 80
    jne terminate_program ; 80
    print "je "
    call gn1
    call newline
    print "call set_true"
    call newline
    
LA76:
    je LA61
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA77
    
LA77:
    
LA61:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA78
    print "jne "
    call gn1
    call newline
    
LA78:
    je LA79
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA80
    
LA80:
    
LA79:
    jne LA81
    
LA82:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA83
    print "mov esi, "
    pushfd
    push eax
    push dword [line]
    pop edi
    pop eax
    popfd
    print_int edi
    call newline
    print "jne terminate_program ; "
    pushfd
    push eax
    push dword [line]
    pop edi
    pop eax
    popfd
    print_int edi
    call newline
    pushfd
    push eax
    push dword [line]
    push 1
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [line], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 86
    jne terminate_program ; 86
    
LA83:
    je LA84
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA85
    
LA85:
    
LA84:
    je LA82
    call set_true
    mov esi, 87
    jne terminate_program ; 87
    call label
    call gn1
    print ":"
    call newline
    
LA81:
    
LA86:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    jne LA87
    
LA88:
    test_input_string "|"
    jne LA89
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov esi, 89
    jne terminate_program ; 89
    
LA89:
    
LA90:
    je LA88
    call set_true
    mov esi, 90
    jne terminate_program ; 90
    call label
    call gn1
    print ":"
    call newline
    
LA87:
    
LA91:
    ret
    
BRACKET_EXPR:
    test_input_string "+"
    jne LA92
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 91
    jne terminate_program ; 91
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 92
    jne terminate_program ; 92
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "add eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA92:
    
LA93:
    jne LA94
    
LA94:
    je LA95
    test_input_string "-"
    jne LA96
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 97
    jne terminate_program ; 97
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 98
    jne terminate_program ; 98
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "sub eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA96:
    
LA97:
    jne LA98
    
LA98:
    je LA95
    test_input_string "*"
    jne LA99
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 103
    jne terminate_program ; 103
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 104
    jne terminate_program ; 104
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "mul ebx"
    call newline
    print "push eax"
    call newline
    
LA99:
    
LA100:
    jne LA101
    
LA101:
    je LA95
    test_input_string "/"
    jne LA102
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 109
    jne terminate_program ; 109
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 110
    jne terminate_program ; 110
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "idiv eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA102:
    
LA103:
    jne LA104
    
LA104:
    je LA95
    test_input_string "set"
    jne LA105
    call test_for_id
    mov esi, 115
    jne terminate_program ; 115
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 116
    jne terminate_program ; 116
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 117
    jne terminate_program ; 117
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
    
LA105:
    
LA106:
    jne LA107
    
LA107:
    je LA95
    test_input_string "if"
    jne LA108
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 121
    jne terminate_program ; 121
    print "pop eax"
    call newline
    print "cmp eax, 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 125
    jne terminate_program ; 125
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 127
    jne terminate_program ; 127
    
LA108:
    
LA109:
    jne LA110
    call label
    call gn2
    print ":"
    call newline
    
LA110:
    je LA95
    test_input_string "hash-set"
    jne LA111
    call test_for_id
    mov esi, 128
    jne terminate_program ; 128
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 129
    jne terminate_program ; 129
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 130
    jne terminate_program ; 130
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 131
    jne terminate_program ; 131
    print "mov edi, "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    print "pop edx"
    call newline
    print "pop esi"
    call newline
    print "call hash_set"
    call newline
    print "push edx"
    call newline
    
LA111:
    
LA112:
    jne LA113
    
LA113:
    je LA95
    test_input_string "hash-get"
    jne LA114
    call test_for_id
    mov esi, 137
    jne terminate_program ; 137
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 138
    jne terminate_program ; 138
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 139
    jne terminate_program ; 139
    print "mov edi, "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    print "pop esi"
    call newline
    print "call hash_get"
    call newline
    print "push eax"
    call newline
    
LA114:
    
LA115:
    jne LA116
    
LA116:
    je LA95
    call test_for_id
    jne LA117
    print "push dword ["
    call copy_last_match
    print "]"
    call newline
    
LA117:
    
LA118:
    jne LA119
    
LA119:
    je LA95
    call test_for_id
    jne LA120
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 145
    jne terminate_program ; 145
    
LA121:
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    jne LA122
    
LA122:
    
LA123:
    je LA121
    call set_true
    mov esi, 146
    jne terminate_program ; 146
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA120:
    
LA124:
    jne LA125
    
LA125:
    je LA95
    call test_for_number
    jne LA126
    print "push "
    call copy_last_match
    call newline
    
LA126:
    
LA127:
    jne LA128
    
LA128:
    
LA95:
    ret
    
BRACKET_ARG:
    test_input_string "["
    jne LA129
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 149
    jne terminate_program ; 149
    test_input_string "]"
    mov esi, 150
    jne terminate_program ; 150
    
LA129:
    
LA130:
    jne LA131
    
LA131:
    je LA132
    call test_for_number
    jne LA133
    print "push "
    call copy_last_match
    call newline
    
LA133:
    
LA134:
    jne LA135
    
LA135:
    je LA132
    call test_for_id
    jne LA136
    print "push dword ["
    call copy_last_match
    print "]"
    call newline
    
LA136:
    
LA137:
    jne LA138
    
LA138:
    je LA132
    test_input_string "*"
    jne LA139
    call test_for_id
    mov esi, 153
    jne terminate_program ; 153
    print "push "
    call copy_last_match
    call newline
    
LA139:
    
LA140:
    jne LA141
    
LA141:
    je LA132
    call test_for_string
    jne LA142
    call label
    print "section .data"
    call newline
    call gn3
    print " db "
    call copy_last_match
    print ", 0x00"
    call newline
    call label
    print "section .text"
    call newline
    print "push "
    call gn3
    call newline
    
LA142:
    
LA143:
    jne LA144
    
LA144:
    
LA132:
    ret
    
DEFINITION:
    call test_for_id
    jne LA145
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov esi, 157
    jne terminate_program ; 157
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 158
    jne terminate_program ; 158
    test_input_string ";"
    mov esi, 159
    jne terminate_program ; 159
    print "ret"
    call newline
    
LA145:
    
LA146:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA147
    match_not 10
    mov esi, 161
    jne terminate_program ; 161
    
LA147:
    
LA148:
    ret
    