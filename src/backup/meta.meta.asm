
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
    test_input_string ".CODE"
    jne LA10
    call label
    print "section .text"
    call newline
    
LA11:
    call vstack_clear
    call CODE_DEFINITION
    call vstack_restore
    jne LA12
    
LA12:
    je LA13
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA14
    
LA14:
    
LA13:
    je LA11
    call set_true
    mov esi, 1
    jne terminate_program ; 1
    
LA10:
    
LA15:
    jne LA16
    
LA16:
    je LA9
    test_input_string ".SYNTAX"
    jne LA17
    call test_for_id
    mov esi, 2
    jne terminate_program ; 2
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
    
LA18:
    call vstack_clear
    call DEFINITION
    call vstack_restore
    jne LA19
    
LA19:
    je LA20
    call vstack_clear
    call INCLUDE_STATEMENT
    call vstack_restore
    jne LA21
    
LA21:
    je LA20
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA22
    
LA22:
    
LA20:
    je LA18
    call set_true
    mov esi, 10
    jne terminate_program ; 10
    test_input_string ".END"
    mov esi, 11
    jne terminate_program ; 11
    
LA17:
    
LA23:
    jne LA24
    
LA24:
    
LA9:
    je LA1
    call set_true
    mov esi, 12
    jne terminate_program ; 12
    
LA25:
    
LA26:
    ret
    
INCLUDE_STATEMENT:
    test_input_string ".INCLUDE"
    jne LA27
    call test_for_string_raw
    mov esi, 13
    jne terminate_program ; 13
    test_input_string ";"
    mov esi, 14
    jne terminate_program ; 14
    mov esi, last_match
    call import_meta_file_mm32
    call set_true
    
LA27:
    
LA28:
    ret
    
DATA_DEFINITION:
    call test_for_id
    jne LA29
    call copy_last_match
    test_input_string "="
    mov esi, 15
    jne terminate_program ; 15
    call vstack_clear
    call DATA_TYPE
    call vstack_restore
    mov esi, 16
    jne terminate_program ; 16
    test_input_string ";"
    mov esi, 17
    jne terminate_program ; 17
    
LA29:
    
LA30:
    ret
    
DATA_TYPE:
    test_input_string "{"
    jne LA31
    call test_for_number
    mov esi, 18
    jne terminate_program ; 18
    print " times "
    call copy_last_match
    print " dd 0x00"
    call newline
    test_input_string "}"
    mov esi, 20
    jne terminate_program ; 20
    
LA31:
    
LA32:
    jne LA33
    
LA33:
    je LA34
    call test_for_string
    jne LA35
    print " db "
    call copy_last_match
    print ", 0x00"
    call newline
    
LA35:
    
LA36:
    jne LA37
    
LA37:
    je LA34
    call test_for_number
    jne LA38
    print " dd "
    call copy_last_match
    call newline
    
LA38:
    
LA39:
    jne LA40
    
LA40:
    
LA34:
    ret
    
OUT1:
    test_input_string "*1"
    jne LA41
    print "call gn1"
    call newline
    
LA41:
    je LA42
    test_input_string "*2"
    jne LA43
    print "call gn2"
    call newline
    
LA43:
    je LA42
    test_input_string "*3"
    jne LA44
    print "call gn3"
    call newline
    
LA44:
    je LA42
    test_input_string "*4"
    jne LA45
    print "call gn4"
    call newline
    
LA45:
    je LA42
    test_input_string "*"
    jne LA46
    print "call copy_last_match"
    call newline
    
LA46:
    je LA42
    test_input_string "%"
    jne LA47
    print "mov edi, str_vector_8192"
    call newline
    print "call vector_pop_string"
    call newline
    print "call print_mm32"
    call newline
    
LA47:
    je LA42
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA48
    print "print_int edi"
    call newline
    
LA48:
    je LA42
    call test_for_string
    jne LA49
    print "print "
    call copy_last_match
    call newline
    
LA49:
    
LA42:
    ret
    
OUT_IMMEDIATE:
    call test_for_string_raw
    jne LA50
    call copy_last_match
    call newline
    
LA50:
    
LA51:
    ret
    
OUTPUT:
    test_input_string "->"
    jne LA52
    test_input_string "("
    mov esi, 34
    jne terminate_program ; 34
    
LA53:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA54
    
LA54:
    
LA55:
    je LA53
    call set_true
    mov esi, 35
    jne terminate_program ; 35
    test_input_string ")"
    mov esi, 36
    jne terminate_program ; 36
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
    mov esi, 38
    jne terminate_program ; 38
    
LA52:
    je LA56
    test_input_string ".LABEL"
    jne LA57
    print "call label"
    call newline
    test_input_string "("
    mov esi, 40
    jne terminate_program ; 40
    
LA58:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA59
    
LA59:
    
LA60:
    je LA58
    call set_true
    mov esi, 41
    jne terminate_program ; 41
    test_input_string ")"
    mov esi, 42
    jne terminate_program ; 42
    print "call newline"
    call newline
    
LA57:
    je LA56
    test_input_string ".RS"
    jne LA61
    test_input_string "("
    mov esi, 44
    jne terminate_program ; 44
    
LA62:
    call vstack_clear
    call OUT1
    call vstack_restore
    je LA62
    call set_true
    mov esi, 45
    jne terminate_program ; 45
    test_input_string ")"
    mov esi, 46
    jne terminate_program ; 46
    
LA61:
    
LA56:
    jne LA63
    
LA63:
    je LA64
    test_input_string ".DIRECT"
    jne LA65
    test_input_string "("
    mov esi, 47
    jne terminate_program ; 47
    
LA66:
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    je LA66
    call set_true
    mov esi, 48
    jne terminate_program ; 48
    test_input_string ")"
    mov esi, 49
    jne terminate_program ; 49
    
LA65:
    
LA64:
    ret
    
EX3:
    call test_for_id
    jne LA67
    print "call vstack_clear"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_restore"
    call newline
    
LA67:
    je LA68
    call test_for_string
    jne LA69
    print "test_input_string "
    call copy_last_match
    call newline
    
LA69:
    je LA68
    test_input_string ".ID"
    jne LA70
    print "call test_for_id"
    call newline
    
LA70:
    je LA68
    test_input_string ".RET"
    jne LA71
    print "ret"
    call newline
    
LA71:
    je LA68
    test_input_string ".NOT"
    jne LA72
    call test_for_string
    jne LA73
    
LA73:
    je LA74
    call test_for_number
    jne LA75
    
LA75:
    
LA74:
    mov esi, 56
    jne terminate_program ; 56
    print "match_not "
    call copy_last_match
    call newline
    
LA72:
    je LA68
    test_input_string ".NUMBER"
    jne LA76
    print "call test_for_number"
    call newline
    
LA76:
    je LA68
    test_input_string ".STRING_RAW"
    jne LA77
    print "call test_for_string_raw"
    call newline
    
LA77:
    je LA68
    test_input_string ".STRING"
    jne LA78
    print "call test_for_string"
    call newline
    
LA78:
    je LA68
    test_input_string "%>"
    jne LA79
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA79:
    je LA68
    test_input_string "("
    jne LA80
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 64
    jne terminate_program ; 64
    test_input_string ")"
    mov esi, 65
    jne terminate_program ; 65
    
LA80:
    je LA68
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA81
    
LA81:
    je LA68
    test_input_string ".EMPTY"
    jne LA82
    print "call set_true"
    call newline
    
LA82:
    je LA68
    test_input_string "$"
    jne LA83
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call EX3
    call vstack_restore
    mov esi, 67
    jne terminate_program ; 67
    print "je "
    call gn1
    call newline
    print "call set_true"
    call newline
    
LA83:
    je LA68
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA84
    
LA84:
    
LA68:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA85
    print "jne "
    call gn1
    call newline
    
LA85:
    je LA86
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA87
    
LA87:
    
LA86:
    jne LA88
    
LA89:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA90
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
    mov esi, 73
    jne terminate_program ; 73
    
LA90:
    je LA91
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA92
    
LA92:
    
LA91:
    je LA89
    call set_true
    mov esi, 74
    jne terminate_program ; 74
    call label
    call gn1
    print ":"
    call newline
    
LA88:
    
LA93:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    jne LA94
    
LA95:
    test_input_string "|"
    jne LA96
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov esi, 76
    jne terminate_program ; 76
    
LA96:
    
LA97:
    je LA95
    call set_true
    mov esi, 77
    jne terminate_program ; 77
    call label
    call gn1
    print ":"
    call newline
    
LA94:
    
LA98:
    ret
    
BRACKET_EXPR_WRAPPER:
    test_input_string "["
    jne LA99
    test_input_string "<<"
    jne LA100
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 78
    jne terminate_program ; 78
    print "pop eax"
    call newline
    print "cmp eax, 0"
    call newline
    
LA100:
    
LA101:
    jne LA102
    mov esi, 81
    jne terminate_program ; 81
    
LA102:
    je LA103
    print "pushfd"
    call newline
    print "push eax"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 84
    jne terminate_program ; 84
    print "pop edi"
    call newline
    print "pop eax"
    call newline
    print "popfd"
    call newline
    
LA104:
    
LA105:
    jne LA106
    
LA106:
    
LA103:
    mov esi, 88
    jne terminate_program ; 88
    test_input_string "]"
    mov esi, 89
    jne terminate_program ; 89
    
LA99:
    
LA107:
    ret
    
BRACKET_EXPR:
    test_input_string "+"
    jne LA108
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 90
    jne terminate_program ; 90
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 91
    jne terminate_program ; 91
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "add eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA108:
    
LA109:
    jne LA110
    
LA110:
    je LA111
    test_input_string "-"
    jne LA112
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 96
    jne terminate_program ; 96
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 97
    jne terminate_program ; 97
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "sub eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA112:
    
LA113:
    jne LA114
    
LA114:
    je LA111
    test_input_string "*"
    jne LA115
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 102
    jne terminate_program ; 102
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 103
    jne terminate_program ; 103
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "mul ebx"
    call newline
    print "push eax"
    call newline
    
LA115:
    
LA116:
    jne LA117
    
LA117:
    je LA111
    test_input_string "/"
    jne LA118
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 108
    jne terminate_program ; 108
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 109
    jne terminate_program ; 109
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "idiv eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA118:
    
LA119:
    jne LA120
    
LA120:
    je LA111
    test_input_string "set"
    jne LA121
    call test_for_id
    mov esi, 114
    jne terminate_program ; 114
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 115
    jne terminate_program ; 115
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 116
    jne terminate_program ; 116
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
    
LA121:
    
LA122:
    jne LA123
    
LA123:
    je LA111
    test_input_string "if"
    jne LA124
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 120
    jne terminate_program ; 120
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
    mov esi, 124
    jne terminate_program ; 124
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
    mov esi, 126
    jne terminate_program ; 126
    
LA124:
    
LA125:
    jne LA126
    call label
    call gn2
    print ":"
    call newline
    
LA126:
    je LA111
    test_input_string "hash-set"
    jne LA127
    call test_for_id
    mov esi, 127
    jne terminate_program ; 127
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 128
    jne terminate_program ; 128
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 129
    jne terminate_program ; 129
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 130
    jne terminate_program ; 130
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
    
LA127:
    
LA128:
    jne LA129
    
LA129:
    je LA111
    test_input_string "hash-get"
    jne LA130
    call test_for_id
    mov esi, 136
    jne terminate_program ; 136
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 137
    jne terminate_program ; 137
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 138
    jne terminate_program ; 138
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
    
LA130:
    
LA131:
    jne LA132
    
LA132:
    je LA111
    test_input_string "to-int"
    jne LA133
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 143
    jne terminate_program ; 143
    print "pop esi"
    call newline
    print "call string_to_int"
    call newline
    print "push eax"
    call newline
    
LA133:
    
LA134:
    jne LA135
    
LA135:
    je LA111
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
    je LA111
    call test_for_id
    jne LA139
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 148
    jne terminate_program ; 148
    
LA140:
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    jne LA141
    
LA141:
    
LA142:
    je LA140
    call set_true
    mov esi, 149
    jne terminate_program ; 149
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA139:
    
LA143:
    jne LA144
    
LA144:
    je LA111
    call test_for_number
    jne LA145
    print "push "
    call copy_last_match
    call newline
    
LA145:
    
LA146:
    jne LA147
    
LA147:
    
LA111:
    ret
    
BRACKET_ARG:
    test_input_string "["
    jne LA148
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 152
    jne terminate_program ; 152
    test_input_string "]"
    mov esi, 153
    jne terminate_program ; 153
    
LA148:
    
LA149:
    jne LA150
    
LA150:
    je LA151
    call test_for_number
    jne LA152
    print "push "
    call copy_last_match
    call newline
    
LA152:
    
LA153:
    jne LA154
    
LA154:
    je LA151
    call test_for_id
    jne LA155
    print "push dword ["
    call copy_last_match
    print "]"
    call newline
    
LA155:
    
LA156:
    jne LA157
    
LA157:
    je LA151
    test_input_string "*"
    jne LA158
    call test_for_id
    mov esi, 156
    jne terminate_program ; 156
    print "push "
    call copy_last_match
    call newline
    
LA158:
    
LA159:
    jne LA160
    
LA160:
    je LA151
    call test_for_string
    jne LA161
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
    
LA161:
    
LA162:
    jne LA163
    
LA163:
    
LA151:
    ret
    
CODE_DEFINITION:
    call test_for_id
    jne LA164
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov esi, 160
    jne terminate_program ; 160
    test_input_string "["
    mov esi, 161
    jne terminate_program ; 161
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 164
    jne terminate_program ; 164
    mov esi, 165
    jne terminate_program ; 165
    print "pop edi"
    call newline
    print "pop ebp"
    call newline
    print "ret"
    call newline
    test_input_string "]"
    mov esi, 169
    jne terminate_program ; 169
    
LA164:
    
LA165:
    ret
    
DEFINITION:
    call test_for_id
    jne LA166
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov esi, 170
    jne terminate_program ; 170
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 171
    jne terminate_program ; 171
    test_input_string ";"
    mov esi, 172
    jne terminate_program ; 172
    print "ret"
    call newline
    
LA166:
    
LA167:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA168
    match_not 10
    mov esi, 174
    jne terminate_program ; 174
    
LA168:
    
LA169:
    ret
    
