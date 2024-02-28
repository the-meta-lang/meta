
%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .data
    line dd 0
    hashmap times 4096 dd 0x00
    
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
    
LA5:
    je LA3
    call set_true
    mov esi, 0
    jne terminate_program ; 0
    
LA2:
    
LA6:
    jne LA7
    
LA7:
    je LA8
    test_input_string ".SYNTAX"
    jne LA9
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
    
LA10:
    call vstack_clear
    call DEFINITION
    call vstack_restore
    jne LA11
    
LA11:
    je LA12
    call vstack_clear
    call IMPORT_STATEMENT
    call vstack_restore
    jne LA13
    
LA13:
    je LA12
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA14
    
LA14:
    
LA12:
    je LA10
    call set_true
    mov esi, 9
    jne terminate_program ; 9
    test_input_string ".END"
    mov esi, 10
    jne terminate_program ; 10
    
LA9:
    
LA15:
    jne LA16
    
LA16:
    
LA8:
    je LA1
    call set_true
    mov esi, 11
    jne terminate_program ; 11
    
LA17:
    
LA18:
    ret
    
IMPORT_STATEMENT:
    test_input_string ".IMPORT"
    jne LA19
    call test_for_string_raw
    mov esi, 12
    jne terminate_program ; 12
    test_input_string ";"
    mov esi, 13
    jne terminate_program ; 13
    mov esi, last_match
    call import_meta_file_mm32
    
LA19:
    
LA20:
    ret
    
DATA_DEFINITION:
    call test_for_id
    jne LA21
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
    pushfd
    push eax
    
section .data
    LC1 db "Hello", 0x00
    
section .text
    push 5
    mov edi, hashmap
    mov esi, LC1
    pop edx
    call hash_set
    push edx
    pop edi
    pop eax
    popfd
    mov esi, 17
    jne terminate_program ; 17
    
LA21:
    
LA22:
    ret
    
DATA_TYPE:
    test_input_string "{"
    jne LA23
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
    
LA23:
    
LA24:
    jne LA25
    
LA25:
    je LA26
    call test_for_string
    jne LA27
    print " db "
    call copy_last_match
    print ", 0x00"
    call newline
    
LA27:
    
LA28:
    jne LA29
    
LA29:
    je LA26
    call test_for_number
    jne LA30
    print " dd "
    call copy_last_match
    call newline
    
LA30:
    
LA31:
    jne LA32
    
LA32:
    
LA26:
    ret
    
OUT1:
    test_input_string "*1"
    jne LA33
    print "call gn1"
    call newline
    
LA33:
    je LA34
    test_input_string "*2"
    jne LA35
    print "call gn2"
    call newline
    
LA35:
    je LA34
    test_input_string "*3"
    jne LA36
    print "call gn3"
    call newline
    
LA36:
    je LA34
    test_input_string "*4"
    jne LA37
    print "call gn4"
    call newline
    
LA37:
    je LA34
    test_input_string "*"
    jne LA38
    print "call copy_last_match"
    call newline
    
LA38:
    je LA34
    test_input_string "%"
    jne LA39
    print "mov edi, str_vector_8192"
    call newline
    print "call vector_pop_string"
    call newline
    print "call print_mm32"
    call newline
    
LA39:
    je LA34
    test_input_string "["
    jne LA40
    print "pushfd"
    call newline
    print "push eax"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 33
    jne terminate_program ; 33
    test_input_string "]"
    mov esi, 34
    jne terminate_program ; 34
    print "pop edi"
    call newline
    print "pop eax"
    call newline
    print "popfd"
    call newline
    print "print_int edi"
    call newline
    
LA40:
    je LA34
    call test_for_string
    jne LA41
    print "print "
    call copy_last_match
    call newline
    
LA41:
    
LA34:
    ret
    
OUT_IMMEDIATE:
    call test_for_string_raw
    jne LA42
    call copy_last_match
    call newline
    
LA42:
    
LA43:
    ret
    
OUTPUT:
    test_input_string "->"
    jne LA44
    test_input_string "("
    mov esi, 41
    jne terminate_program ; 41
    
LA45:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA46
    
LA46:
    
LA47:
    je LA45
    call set_true
    mov esi, 42
    jne terminate_program ; 42
    test_input_string ")"
    mov esi, 43
    jne terminate_program ; 43
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
    mov esi, 45
    jne terminate_program ; 45
    
LA44:
    je LA48
    test_input_string ".LABEL"
    jne LA49
    print "call label"
    call newline
    test_input_string "("
    mov esi, 47
    jne terminate_program ; 47
    
LA50:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA51
    
LA51:
    
LA52:
    je LA50
    call set_true
    mov esi, 48
    jne terminate_program ; 48
    test_input_string ")"
    mov esi, 49
    jne terminate_program ; 49
    print "call newline"
    call newline
    
LA49:
    je LA48
    test_input_string ".RS"
    jne LA53
    test_input_string "("
    mov esi, 51
    jne terminate_program ; 51
    
LA54:
    call vstack_clear
    call OUT1
    call vstack_restore
    je LA54
    call set_true
    mov esi, 52
    jne terminate_program ; 52
    test_input_string ")"
    mov esi, 53
    jne terminate_program ; 53
    
LA53:
    
LA48:
    jne LA55
    
LA55:
    je LA56
    test_input_string ".DIRECT"
    jne LA57
    test_input_string "("
    mov esi, 54
    jne terminate_program ; 54
    
LA58:
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    je LA58
    call set_true
    mov esi, 55
    jne terminate_program ; 55
    test_input_string ")"
    mov esi, 56
    jne terminate_program ; 56
    
LA57:
    
LA56:
    ret
    
EX3:
    call test_for_id
    jne LA59
    print "call vstack_clear"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_restore"
    call newline
    
LA59:
    je LA60
    call test_for_string
    jne LA61
    print "test_input_string "
    call copy_last_match
    call newline
    
LA61:
    je LA60
    test_input_string ".ID"
    jne LA62
    print "call test_for_id"
    call newline
    
LA62:
    je LA60
    test_input_string ".RET"
    jne LA63
    print "ret"
    call newline
    
LA63:
    je LA60
    test_input_string ".NOT"
    jne LA64
    call test_for_string
    jne LA65
    
LA65:
    je LA66
    call test_for_number
    jne LA67
    
LA67:
    
LA66:
    mov esi, 63
    jne terminate_program ; 63
    print "match_not "
    call copy_last_match
    call newline
    
LA64:
    je LA60
    test_input_string ".NUMBER"
    jne LA68
    print "call test_for_number"
    call newline
    
LA68:
    je LA60
    test_input_string ".STRING_RAW"
    jne LA69
    print "call test_for_string_raw"
    call newline
    
LA69:
    je LA60
    test_input_string ".STRING"
    jne LA70
    print "call test_for_string"
    call newline
    
LA70:
    je LA60
    test_input_string "%>"
    jne LA71
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA71:
    je LA60
    test_input_string "("
    jne LA72
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 71
    jne terminate_program ; 71
    test_input_string ")"
    mov esi, 72
    jne terminate_program ; 72
    
LA72:
    je LA60
    test_input_string "["
    jne LA73
    print "pushfd"
    call newline
    print "push eax"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 75
    jne terminate_program ; 75
    test_input_string "]"
    mov esi, 76
    jne terminate_program ; 76
    print "pop edi"
    call newline
    print "pop eax"
    call newline
    print "popfd"
    call newline
    
LA73:
    je LA60
    test_input_string ".EMPTY"
    jne LA74
    print "call set_true"
    call newline
    
LA74:
    je LA60
    test_input_string "$"
    jne LA75
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call EX3
    call vstack_restore
    mov esi, 81
    jne terminate_program ; 81
    print "je "
    call gn1
    call newline
    print "call set_true"
    call newline
    
LA75:
    je LA60
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA76
    
LA76:
    
LA60:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA77
    print "jne "
    call gn1
    call newline
    
LA77:
    je LA78
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA79
    
LA79:
    
LA78:
    jne LA80
    
LA81:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA82
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
    mov esi, 87
    jne terminate_program ; 87
    
LA82:
    je LA83
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA84
    
LA84:
    
LA83:
    je LA81
    call set_true
    mov esi, 88
    jne terminate_program ; 88
    call label
    call gn1
    print ":"
    call newline
    
LA80:
    
LA85:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    jne LA86
    
LA87:
    test_input_string "|"
    jne LA88
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov esi, 90
    jne terminate_program ; 90
    
LA88:
    
LA89:
    je LA87
    call set_true
    mov esi, 91
    jne terminate_program ; 91
    call label
    call gn1
    print ":"
    call newline
    
LA86:
    
LA90:
    ret
    
BRACKET_EXPR:
    test_input_string "+"
    jne LA91
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 92
    jne terminate_program ; 92
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 93
    jne terminate_program ; 93
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "add eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA91:
    
LA92:
    jne LA93
    
LA93:
    je LA94
    test_input_string "-"
    jne LA95
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 98
    jne terminate_program ; 98
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 99
    jne terminate_program ; 99
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "sub eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA95:
    
LA96:
    jne LA97
    
LA97:
    je LA94
    test_input_string "*"
    jne LA98
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 104
    jne terminate_program ; 104
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 105
    jne terminate_program ; 105
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "mul eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA98:
    
LA99:
    jne LA100
    
LA100:
    je LA94
    test_input_string "/"
    jne LA101
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 110
    jne terminate_program ; 110
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 111
    jne terminate_program ; 111
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "idiv eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA101:
    
LA102:
    jne LA103
    
LA103:
    je LA94
    test_input_string "set"
    jne LA104
    call test_for_id
    mov esi, 116
    jne terminate_program ; 116
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 117
    jne terminate_program ; 117
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 118
    jne terminate_program ; 118
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
    
LA104:
    
LA105:
    jne LA106
    
LA106:
    je LA94
    test_input_string "if"
    jne LA107
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 122
    jne terminate_program ; 122
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
    mov esi, 126
    jne terminate_program ; 126
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
    mov esi, 128
    jne terminate_program ; 128
    
LA107:
    
LA108:
    jne LA109
    call label
    call gn2
    print ":"
    call newline
    
LA109:
    je LA94
    test_input_string "hash-set"
    jne LA110
    call test_for_id
    mov esi, 129
    jne terminate_program ; 129
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 130
    jne terminate_program ; 130
    call test_for_string
    mov esi, 131
    jne terminate_program ; 131
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
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 133
    jne terminate_program ; 133
    print "mov edi, "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    print "mov esi, "
    call gn3
    call newline
    print "pop edx"
    call newline
    print "call hash_set"
    call newline
    print "push edx"
    call newline
    
LA110:
    
LA111:
    jne LA112
    
LA112:
    je LA94
    test_input_string "hash-get"
    jne LA113
    call test_for_id
    mov esi, 139
    jne terminate_program ; 139
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 140
    jne terminate_program ; 140
    call test_for_string
    mov esi, 141
    jne terminate_program ; 141
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
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    print "mov esi, "
    call gn3
    call newline
    print "call hash_get"
    call newline
    print "push eax"
    call newline
    
LA113:
    
LA114:
    jne LA115
    
LA115:
    je LA94
    call test_for_id
    jne LA116
    print "push dword ["
    call copy_last_match
    print "]"
    call newline
    
LA116:
    
LA117:
    jne LA118
    
LA118:
    je LA94
    call test_for_id
    jne LA119
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 148
    jne terminate_program ; 148
    
LA120:
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    jne LA121
    
LA121:
    
LA122:
    je LA120
    call set_true
    mov esi, 149
    jne terminate_program ; 149
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA119:
    
LA123:
    jne LA124
    
LA124:
    je LA94
    call test_for_number
    jne LA125
    print "push "
    call copy_last_match
    call newline
    
LA125:
    
LA126:
    jne LA127
    
LA127:
    
LA94:
    ret
    
BRACKET_ARG:
    test_input_string "["
    jne LA128
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 152
    jne terminate_program ; 152
    test_input_string "]"
    mov esi, 153
    jne terminate_program ; 153
    
LA128:
    
LA129:
    jne LA130
    
LA130:
    je LA131
    call test_for_number
    jne LA132
    print "push "
    call copy_last_match
    call newline
    
LA132:
    
LA133:
    jne LA134
    
LA134:
    je LA131
    call test_for_id
    jne LA135
    print "push dword ["
    call copy_last_match
    print "]"
    call newline
    
LA135:
    
LA136:
    jne LA137
    
LA137:
    
LA131:
    ret
    
DEFINITION:
    call test_for_id
    jne LA138
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov esi, 156
    jne terminate_program ; 156
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 157
    jne terminate_program ; 157
    test_input_string ";"
    mov esi, 158
    jne terminate_program ; 158
    print "ret"
    call newline
    
LA138:
    
LA139:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA140
    match_not 10
    mov esi, 160
    jne terminate_program ; 160
    
LA140:
    
LA141:
    ret
    