
%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .data
    line dd 0
    ST times 65536 dd 0x00
    STO dd 12
    ARG_NUM dd 0
    
section .text
    
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
    ; mov eax, dword [ebp+0]
    push 1
    ; mov ebx, 1
    pop eax ; REMOVE
    pop ebx ; REMOVE
    add eax, ebx
    push eax ; REMOVE
    pop eax ; REMOVE
    mov [line], eax
    push eax ; REMOVE
    pop edi ; mov edi, eax
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
    ; mov ebx, dword [ebp+0]
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    call newline
    print "jne terminate_program ; "
    pushfd
    push eax
    push dword [line]
    ; mov ebx, dword [ebp+0]
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    call newline
    pushfd
    push eax
    push dword [line]
    ; mov eax, dword [ebp+0]
    push 1
    ; mov ebx, 1
    pop eax ; REMOVE
    pop ebx ; REMOVE
    add eax, ebx
    push eax ; REMOVE
    pop eax ; REMOVE
    mov [line], eax
    push eax ; REMOVE
    pop edi ; mov edi, eax
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
    pushfd
    push eax
    push 0
    ; mov ebx, 0
    pop eax ; REMOVE
    mov [ARG_NUM], eax
    push eax ; REMOVE
    pop edi ; mov edi, eax
    pop eax
    popfd
    mov esi, 78
    jne terminate_program ; 78
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 79
    jne terminate_program ; 79
    print "pop eax ; REMOVE"
    call newline
    print "cmp eax, 0"
    call newline
    
LA100:
    
LA101:
    jne LA102
    mov esi, 82
    jne terminate_program ; 82
    
LA102:
    je LA103
    print "pushfd"
    call newline
    print "push eax"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 85
    jne terminate_program ; 85
    print "pop edi ; mov edi, eax"
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
    mov esi, 89
    jne terminate_program ; 89
    test_input_string "]"
    mov esi, 90
    jne terminate_program ; 90
    
LA99:
    
LA107:
    ret
    
BRACKET_EXPR:
    test_input_string "+"
    jne LA108
    pushfd
    push eax
    push 0
    ; mov ebx, 0
    pop eax ; REMOVE
    mov [ARG_NUM], eax
    push eax ; REMOVE
    pop edi ; mov edi, eax
    pop eax
    popfd
    mov esi, 91
    jne terminate_program ; 91
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 92
    jne terminate_program ; 92
    pushfd
    push eax
    push 1
    ; mov ebx, 1
    pop eax ; REMOVE
    mov [ARG_NUM], eax
    push eax ; REMOVE
    pop edi ; mov edi, eax
    pop eax
    popfd
    mov esi, 93
    jne terminate_program ; 93
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 94
    jne terminate_program ; 94
    print "pop eax ; REMOVE"
    call newline
    print "pop ebx ; REMOVE"
    call newline
    print "add eax, ebx"
    call newline
    print "push eax ; REMOVE"
    call newline
    
LA108:
    
LA109:
    jne LA110
    
LA110:
    je LA111
    test_input_string "-"
    jne LA112
    pushfd
    push eax
    push 0
    ; mov ebx, 0
    pop eax ; REMOVE
    mov [ARG_NUM], eax
    push eax ; REMOVE
    pop edi ; mov edi, eax
    pop eax
    popfd
    mov esi, 99
    jne terminate_program ; 99
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 100
    jne terminate_program ; 100
    pushfd
    push eax
    push 1
    ; mov ebx, 1
    pop eax ; REMOVE
    mov [ARG_NUM], eax
    push eax ; REMOVE
    pop edi ; mov edi, eax
    pop eax
    popfd
    mov esi, 101
    jne terminate_program ; 101
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 102
    jne terminate_program ; 102
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
    pushfd
    push eax
    push 0
    ; mov ebx, 0
    pop eax ; REMOVE
    mov [ARG_NUM], eax
    push eax ; REMOVE
    pop edi ; mov edi, eax
    pop eax
    popfd
    mov esi, 107
    jne terminate_program ; 107
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 108
    jne terminate_program ; 108
    pushfd
    push eax
    push 1
    ; mov ebx, 1
    pop eax ; REMOVE
    mov [ARG_NUM], eax
    push eax ; REMOVE
    pop edi ; mov edi, eax
    pop eax
    popfd
    mov esi, 109
    jne terminate_program ; 109
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 110
    jne terminate_program ; 110
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
    pushfd
    push eax
    push 0
    ; mov ebx, 0
    pop eax ; REMOVE
    mov [ARG_NUM], eax
    push eax ; REMOVE
    pop edi ; mov edi, eax
    pop eax
    popfd
    mov esi, 115
    jne terminate_program ; 115
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 116
    jne terminate_program ; 116
    pushfd
    push eax
    push 1
    ; mov ebx, 1
    pop eax ; REMOVE
    mov [ARG_NUM], eax
    push eax ; REMOVE
    pop edi ; mov edi, eax
    pop eax
    popfd
    mov esi, 117
    jne terminate_program ; 117
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 118
    jne terminate_program ; 118
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
    mov esi, 123
    jne terminate_program ; 123
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 124
    jne terminate_program ; 124
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 125
    jne terminate_program ; 125
    print "pop eax ; REMOVE"
    call newline
    print "mov ["
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print "], eax"
    call newline
    print "push eax ; REMOVE"
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
    mov esi, 129
    jne terminate_program ; 129
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
    mov esi, 133
    jne terminate_program ; 133
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
    mov esi, 135
    jne terminate_program ; 135
    
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
    mov esi, 145
    jne terminate_program ; 145
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 146
    jne terminate_program ; 146
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 147
    jne terminate_program ; 147
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
    test_input_string "<>"
    jne LA133
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 152
    jne terminate_program ; 152
    
LA133:
    
LA134:
    jne LA135
    
LA135:
    je LA111
    call test_for_id
    jne LA136
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 153
    jne terminate_program ; 153
    
LA137:
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    jne LA138
    pushfd
    push eax
    push dword [ARG_NUM]
    ; mov eax, dword [ebp+0]
    push 1
    ; mov ebx, 1
    pop eax ; REMOVE
    pop ebx ; REMOVE
    add eax, ebx
    push eax ; REMOVE
    pop eax ; REMOVE
    mov [ARG_NUM], eax
    push eax ; REMOVE
    pop edi ; mov edi, eax
    pop eax
    popfd
    mov esi, 154
    jne terminate_program ; 154
    
LA138:
    
LA139:
    je LA137
    call set_true
    mov esi, 155
    jne terminate_program ; 155
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    print "push eax"
    call newline
    
LA136:
    
LA140:
    jne LA141
    
LA141:
    
LA111:
    ret
    
FN_CALL_ARG:
    
LA142:
    test_input_string "["
    jne LA143
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 158
    jne terminate_program ; 158
    test_input_string "]"
    mov esi, 159
    jne terminate_program ; 159
    print "mov edi, eax"
    call newline
    
LA143:
    
LA144:
    jne LA145
    
LA145:
    je LA146
    call test_for_number
    jne LA147
    print "mov edi, "
    call copy_last_match
    call newline
    
LA147:
    
LA148:
    jne LA149
    
LA149:
    je LA146
    call test_for_id
    jne LA150
    print "mov edi, dword [ebp+"
    pushfd
    push eax
    push last_match
    ; mov ebx, ebp+0
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA150:
    
LA151:
    jne LA152
    
LA152:
    je LA146
    test_input_string "*"
    jne LA153
    call test_for_id
    mov esi, 163
    jne terminate_program ; 163
    print "mov edi, dword ebp+"
    pushfd
    push eax
    push last_match
    ; mov ebx, ebp+0
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    call newline
    
LA153:
    
LA154:
    jne LA155
    
LA155:
    je LA146
    call test_for_string
    jne LA156
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
    print "mov edi, "
    call gn3
    call newline
    
LA156:
    
LA157:
    jne LA158
    
LA158:
    
LA146:
    je LA142
    call set_true
    jne LA159
    
LA160:
    test_input_string "["
    jne LA161
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 167
    jne terminate_program ; 167
    test_input_string "]"
    mov esi, 168
    jne terminate_program ; 168
    print "mov esi, eax"
    call newline
    
LA161:
    
LA162:
    jne LA163
    
LA163:
    je LA164
    call test_for_number
    jne LA165
    print "mov esi, "
    call copy_last_match
    call newline
    
LA165:
    je LA166
    call test_for_id
    jne LA167
    print "mov esi, dword [ebp+"
    pushfd
    push eax
    push last_match
    ; mov ebx, ebp+0
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA167:
    je LA166
    test_input_string "*"
    jne LA168
    call test_for_id
    mov esi, 172
    jne terminate_program ; 172
    print "mov esi, dword ebp+"
    pushfd
    push eax
    push last_match
    ; mov ebx, ebp+0
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    call newline
    
LA168:
    je LA166
    call test_for_string
    jne LA169
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
    print "mov esi, "
    call gn3
    call newline
    
LA169:
    
LA166:
    jne LA170
    
LA171:
    test_input_string "["
    jne LA172
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 176
    jne terminate_program ; 176
    test_input_string "]"
    mov esi, 177
    jne terminate_program ; 177
    print "mov edx, eax"
    call newline
    
LA172:
    
LA173:
    jne LA174
    
LA174:
    je LA175
    call test_for_number
    jne LA176
    print "mov edx, "
    call copy_last_match
    call newline
    
LA176:
    je LA177
    call test_for_id
    jne LA178
    print "mov edx, dword [ebp+"
    pushfd
    push eax
    push last_match
    ; mov ebx, ebp+0
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA178:
    je LA177
    test_input_string "*"
    jne LA179
    call test_for_id
    mov esi, 181
    jne terminate_program ; 181
    print "mov edx, dword ebp+"
    pushfd
    push eax
    push last_match
    ; mov ebx, ebp+0
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    call newline
    
LA179:
    je LA177
    call test_for_string
    jne LA180
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
    print "mov edx, "
    call gn3
    call newline
    
LA180:
    
LA177:
    jne LA181
    
LA182:
    test_input_string "["
    jne LA183
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 185
    jne terminate_program ; 185
    test_input_string "]"
    mov esi, 186
    jne terminate_program ; 186
    print "mov ecx, eax"
    call newline
    
LA183:
    
LA184:
    jne LA185
    
LA185:
    je LA186
    call test_for_number
    jne LA187
    print "mov ecx, "
    call copy_last_match
    call newline
    
LA187:
    je LA188
    call test_for_id
    jne LA189
    print "mov ecx, dword [ebp+"
    pushfd
    push eax
    push last_match
    ; mov ebx, ebp+0
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA189:
    je LA188
    test_input_string "*"
    jne LA190
    call test_for_id
    mov esi, 190
    jne terminate_program ; 190
    print "mov ecx, dword ebp+"
    pushfd
    push eax
    push last_match
    ; mov ebx, ebp+0
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    call newline
    
LA190:
    je LA188
    call test_for_string
    jne LA191
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
    print "mov ecx, "
    call gn3
    call newline
    
LA191:
    
LA188:
    jne LA192
    
LA193:
    call test_for_number
    jne LA194
    print "push "
    call copy_last_match
    call newline
    
LA194:
    je LA195
    call test_for_id
    jne LA196
    print "push ["
    call copy_last_match
    print "]"
    call newline
    
LA196:
    je LA195
    test_input_string "*"
    jne LA197
    print "push "
    call copy_last_match
    call newline
    
LA197:
    je LA195
    call test_for_string
    jne LA198
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
    
LA198:
    
LA195:
    jne LA199
    
LA199:
    
LA200:
    je LA193
    call set_true
    mov esi, 199
    jne terminate_program ; 199
    
LA192:
    
LA186:
    je LA182
    call set_true
    mov esi, 200
    jne terminate_program ; 200
    
LA181:
    
LA175:
    je LA171
    call set_true
    mov esi, 201
    jne terminate_program ; 201
    
LA170:
    
LA164:
    je LA160
    call set_true
    mov esi, 202
    jne terminate_program ; 202
    
LA159:
    
LA201:
    ret
    
BRACKET_ARG:
    test_input_string "["
    jne LA202
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 203
    jne terminate_program ; 203
    test_input_string "]"
    mov esi, 204
    jne terminate_program ; 204
    
LA202:
    
LA203:
    jne LA204
    
LA204:
    je LA205
    call test_for_number
    jne LA206
    print "push "
    call copy_last_match
    call newline
    push dword [ARG_NUM]
    ; mov eax, dword [ebp+0]
    pop eax ; REMOVE
    cmp eax, 0
    jne LA207
    print "; mov eax, "
    call copy_last_match
    call newline
    
LA207:
    je LA208
    print "; mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA209:
    
LA208:
    mov esi, 208
    jne terminate_program ; 208
    
LA206:
    
LA210:
    jne LA211
    
LA211:
    je LA205
    call test_for_id
    jne LA212
    print "push dword ["
    call copy_last_match
    print "]"
    call newline
    push dword [ARG_NUM]
    ; mov eax, dword [ebp+0]
    pop eax ; REMOVE
    cmp eax, 0
    jne LA213
    print "; mov eax, dword [ebp+"
    pushfd
    push eax
    push last_match
    ; mov eax, ebp+0
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA213:
    je LA214
    print "; mov ebx, dword [ebp+"
    pushfd
    push eax
    push last_match
    ; mov eax, ebp+0
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    call set_true
    
LA215:
    
LA214:
    mov esi, 212
    jne terminate_program ; 212
    
LA212:
    
LA216:
    jne LA217
    
LA217:
    je LA205
    test_input_string "*"
    jne LA218
    call test_for_id
    mov esi, 213
    jne terminate_program ; 213
    print "push "
    call copy_last_match
    call newline
    push dword [ARG_NUM]
    ; mov eax, dword [ebp+0]
    pop eax ; REMOVE
    cmp eax, 0
    jne LA219
    print "; mov eax, ebp+"
    pushfd
    push eax
    push last_match
    ; mov eax, ebp+0
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    call newline
    
LA219:
    je LA220
    print "; mov ebx, ebp+"
    pushfd
    push eax
    push last_match
    ; mov eax, ebp+0
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    call newline
    call set_true
    
LA221:
    
LA220:
    mov esi, 217
    jne terminate_program ; 217
    
LA218:
    
LA222:
    jne LA223
    
LA223:
    je LA205
    call test_for_string
    jne LA224
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
    
LA224:
    
LA225:
    jne LA226
    
LA226:
    
LA205:
    ret
    
CODE_DEFINITION:
    call test_for_id
    jne LA227
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov esi, 220
    jne terminate_program ; 220
    test_input_string "["
    mov esi, 221
    jne terminate_program ; 221
    mov esi, 222
    jne terminate_program ; 222
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    test_input_string "["
    mov esi, 225
    jne terminate_program ; 225
    
LA228:
    call test_for_id
    jne LA229
    pushfd
    push eax
    push last_match
    ; mov eax, ebp+0
    push dword [STO]
    ; mov eax, dword [ebp+0]
    push 4
    ; mov ebx, 4
    pop eax ; REMOVE
    pop ebx ; REMOVE
    add eax, ebx
    push eax ; REMOVE
    pop eax ; REMOVE
    mov [STO], eax
    push eax ; REMOVE
    mov edi, ST
    pop edx
    pop esi
    call hash_set
    push edx
    pop edi ; mov edi, eax
    pop eax
    popfd
    mov esi, 226
    jne terminate_program ; 226
    print "pop ["
    call copy_last_match
    print "]"
    print "; "
    pushfd
    push eax
    push last_match
    ; mov ebx, ebp+0
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi ; mov edi, eax
    pop eax
    popfd
    print_int edi
    call newline
    
LA229:
    
LA230:
    je LA228
    call set_true
    mov esi, 228
    jne terminate_program ; 228
    test_input_string "]"
    mov esi, 229
    jne terminate_program ; 229
    mov esi, 230
    jne terminate_program ; 230
    mov esi, 231
    jne terminate_program ; 231
    
LA231:
    test_input_string "["
    jne LA232
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 232
    jne terminate_program ; 232
    test_input_string "]"
    mov esi, 233
    jne terminate_program ; 233
    
LA232:
    
LA233:
    je LA231
    call set_true
    mov esi, 234
    jne terminate_program ; 234
    print "pop ebp"
    call newline
    print "ret"
    call newline
    test_input_string "]"
    mov esi, 237
    jne terminate_program ; 237
    test_input_string ";"
    mov esi, 238
    jne terminate_program ; 238
    
LA227:
    
LA234:
    ret
    
DEFINITION:
    call test_for_id
    jne LA235
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov esi, 239
    jne terminate_program ; 239
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 240
    jne terminate_program ; 240
    test_input_string ";"
    mov esi, 241
    jne terminate_program ; 241
    print "ret"
    call newline
    
LA235:
    
LA236:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA237
    match_not 10
    mov esi, 243
    jne terminate_program ; 243
    
LA237:
    
LA238:
    ret
    