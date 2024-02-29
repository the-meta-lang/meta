
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
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA41
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
    mov esi, 33
    jne terminate_program ; 33
    
LA46:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA47
    
LA47:
    
LA48:
    je LA46
    call set_true
    mov esi, 34
    jne terminate_program ; 34
    test_input_string ")"
    mov esi, 35
    jne terminate_program ; 35
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
    mov esi, 37
    jne terminate_program ; 37
    
LA45:
    je LA49
    test_input_string ".LABEL"
    jne LA50
    print "call label"
    call newline
    test_input_string "("
    mov esi, 39
    jne terminate_program ; 39
    
LA51:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA52
    
LA52:
    
LA53:
    je LA51
    call set_true
    mov esi, 40
    jne terminate_program ; 40
    test_input_string ")"
    mov esi, 41
    jne terminate_program ; 41
    print "call newline"
    call newline
    
LA50:
    je LA49
    test_input_string ".RS"
    jne LA54
    test_input_string "("
    mov esi, 43
    jne terminate_program ; 43
    
LA55:
    call vstack_clear
    call OUT1
    call vstack_restore
    je LA55
    call set_true
    mov esi, 44
    jne terminate_program ; 44
    test_input_string ")"
    mov esi, 45
    jne terminate_program ; 45
    
LA54:
    
LA49:
    jne LA56
    
LA56:
    je LA57
    test_input_string ".DIRECT"
    jne LA58
    test_input_string "("
    mov esi, 46
    jne terminate_program ; 46
    
LA59:
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    je LA59
    call set_true
    mov esi, 47
    jne terminate_program ; 47
    test_input_string ")"
    mov esi, 48
    jne terminate_program ; 48
    
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
    mov esi, 55
    jne terminate_program ; 55
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
    mov esi, 63
    jne terminate_program ; 63
    test_input_string ")"
    mov esi, 64
    jne terminate_program ; 64
    
LA73:
    je LA61
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA74
    
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
    mov esi, 66
    jne terminate_program ; 66
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
    mov esi, 72
    jne terminate_program ; 72
    
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
    mov esi, 73
    jne terminate_program ; 73
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
    mov esi, 75
    jne terminate_program ; 75
    
LA89:
    
LA90:
    je LA88
    call set_true
    mov esi, 76
    jne terminate_program ; 76
    call label
    call gn1
    print ":"
    call newline
    
LA87:
    
LA91:
    ret
    
BRACKET_EXPR_WRAPPER:
    test_input_string "["
    jne LA92
    test_input_string "<<"
    jne LA93
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 77
    jne terminate_program ; 77
    print "pop eax"
    call newline
    print "cmp eax, 0"
    call newline
    
LA93:
    
LA94:
    jne LA95
    mov esi, 80
    jne terminate_program ; 80
    
LA95:
    je LA96
    print "pushfd"
    call newline
    print "push eax"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 83
    jne terminate_program ; 83
    print "pop edi"
    call newline
    print "pop eax"
    call newline
    print "popfd"
    call newline
    
LA97:
    
LA98:
    jne LA99
    
LA99:
    
LA96:
    mov esi, 87
    jne terminate_program ; 87
    test_input_string "]"
    mov esi, 88
    jne terminate_program ; 88
    
LA92:
    
LA100:
    ret
    
BRACKET_EXPR:
    test_input_string "+"
    jne LA101
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 89
    jne terminate_program ; 89
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 90
    jne terminate_program ; 90
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "add eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA101:
    
LA102:
    jne LA103
    
LA103:
    je LA104
    test_input_string "-"
    jne LA105
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 95
    jne terminate_program ; 95
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 96
    jne terminate_program ; 96
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "sub eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA105:
    
LA106:
    jne LA107
    
LA107:
    je LA104
    test_input_string "*"
    jne LA108
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 101
    jne terminate_program ; 101
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 102
    jne terminate_program ; 102
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "mul ebx"
    call newline
    print "push eax"
    call newline
    
LA108:
    
LA109:
    jne LA110
    
LA110:
    je LA104
    test_input_string "/"
    jne LA111
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 107
    jne terminate_program ; 107
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 108
    jne terminate_program ; 108
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "idiv eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA111:
    
LA112:
    jne LA113
    
LA113:
    je LA104
    test_input_string "set"
    jne LA114
    call test_for_id
    mov esi, 113
    jne terminate_program ; 113
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 114
    jne terminate_program ; 114
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 115
    jne terminate_program ; 115
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
    
LA114:
    
LA115:
    jne LA116
    
LA116:
    je LA104
    test_input_string "if"
    jne LA117
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 119
    jne terminate_program ; 119
    print "pop eax"
    call newline
    print "cmp eax, 0"
    call newline
    print "jne "
    call gn1
    call newline
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 123
    jne terminate_program ; 123
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
    mov esi, 125
    jne terminate_program ; 125
    
LA117:
    
LA118:
    jne LA119
    call label
    call gn2
    print ":"
    call newline
    
LA119:
    je LA104
    test_input_string "hash-set"
    jne LA120
    call test_for_id
    mov esi, 126
    jne terminate_program ; 126
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 127
    jne terminate_program ; 127
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 128
    jne terminate_program ; 128
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 129
    jne terminate_program ; 129
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
    
LA120:
    
LA121:
    jne LA122
    
LA122:
    je LA104
    test_input_string "hash-get"
    jne LA123
    call test_for_id
    mov esi, 135
    jne terminate_program ; 135
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 136
    jne terminate_program ; 136
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 137
    jne terminate_program ; 137
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
    
LA123:
    
LA124:
    jne LA125
    
LA125:
    je LA104
    test_input_string "to-int"
    jne LA126
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 142
    jne terminate_program ; 142
    print "pop esi"
    call newline
    print "call string_to_int"
    call newline
    print "push eax"
    call newline
    
LA126:
    
LA127:
    jne LA128
    
LA128:
    je LA104
    call test_for_id
    jne LA129
    print "push dword ["
    call copy_last_match
    print "]"
    call newline
    
LA129:
    
LA130:
    jne LA131
    
LA131:
    je LA104
    call test_for_id
    jne LA132
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 147
    jne terminate_program ; 147
    
LA133:
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    jne LA134
    
LA134:
    
LA135:
    je LA133
    call set_true
    mov esi, 148
    jne terminate_program ; 148
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA132:
    
LA136:
    jne LA137
    
LA137:
    je LA104
    call test_for_number
    jne LA138
    print "push "
    call copy_last_match
    call newline
    
LA138:
    
LA139:
    jne LA140
    
LA140:
    
LA104:
    ret
    
BRACKET_ARG:
    test_input_string "["
    jne LA141
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 151
    jne terminate_program ; 151
    test_input_string "]"
    mov esi, 152
    jne terminate_program ; 152
    
LA141:
    
LA142:
    jne LA143
    
LA143:
    je LA144
    call test_for_number
    jne LA145
    print "push "
    call copy_last_match
    call newline
    
LA145:
    
LA146:
    jne LA147
    
LA147:
    je LA144
    call test_for_id
    jne LA148
    print "push dword ["
    call copy_last_match
    print "]"
    call newline
    
LA148:
    
LA149:
    jne LA150
    
LA150:
    je LA144
    test_input_string "*"
    jne LA151
    call test_for_id
    mov esi, 155
    jne terminate_program ; 155
    print "push "
    call copy_last_match
    call newline
    
LA151:
    
LA152:
    jne LA153
    
LA153:
    je LA144
    call test_for_string
    jne LA154
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
    
LA154:
    
LA155:
    jne LA156
    
LA156:
    
LA144:
    ret
    
DEFINITION:
    call test_for_id
    jne LA157
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov esi, 159
    jne terminate_program ; 159
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 160
    jne terminate_program ; 160
    test_input_string ";"
    mov esi, 161
    jne terminate_program ; 161
    print "ret"
    call newline
    
LA157:
    
LA158:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA159
    match_not 10
    mov esi, 163
    jne terminate_program ; 163
    
LA159:
    
LA160:
    ret
    