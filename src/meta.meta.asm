
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
    
LA21:
    
LA22:
    ret
    
DATA_TYPE:
    call test_for_string
    jne LA23
    print " db "
    call copy_last_match
    print ", 0x00"
    call newline
    
LA23:
    
LA24:
    jne LA25
    
LA25:
    je LA26
    call test_for_number
    jne LA27
    print " dd "
    call copy_last_match
    call newline
    
LA27:
    
LA28:
    jne LA29
    
LA29:
    
LA26:
    ret
    
OUT1:
    test_input_string "*1"
    jne LA30
    print "call gn1"
    call newline
    
LA30:
    je LA31
    test_input_string "*2"
    jne LA32
    print "call gn2"
    call newline
    
LA32:
    je LA31
    test_input_string "*3"
    jne LA33
    print "call gn3"
    call newline
    
LA33:
    je LA31
    test_input_string "*4"
    jne LA34
    print "call gn4"
    call newline
    
LA34:
    je LA31
    test_input_string "*"
    jne LA35
    print "call copy_last_match"
    call newline
    
LA35:
    je LA31
    test_input_string "%"
    jne LA36
    print "mov edi, str_vector_8192"
    call newline
    print "call vector_pop_string"
    call newline
    print "call print_mm32"
    call newline
    
LA36:
    je LA31
    test_input_string "["
    jne LA37
    print "pushfd"
    call newline
    print "push eax"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 29
    jne terminate_program ; 29
    test_input_string "]"
    mov esi, 30
    jne terminate_program ; 30
    print "pop edi"
    call newline
    print "pop eax"
    call newline
    print "popfd"
    call newline
    print "print_int edi"
    call newline
    
LA37:
    je LA31
    call test_for_string
    jne LA38
    print "print "
    call copy_last_match
    call newline
    
LA38:
    
LA31:
    ret
    
OUT_IMMEDIATE:
    call test_for_string_raw
    jne LA39
    call copy_last_match
    call newline
    
LA39:
    
LA40:
    ret
    
OUTPUT:
    test_input_string "->"
    jne LA41
    test_input_string "("
    mov esi, 37
    jne terminate_program ; 37
    
LA42:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA43
    
LA43:
    
LA44:
    je LA42
    call set_true
    mov esi, 38
    jne terminate_program ; 38
    test_input_string ")"
    mov esi, 39
    jne terminate_program ; 39
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
    mov esi, 41
    jne terminate_program ; 41
    
LA41:
    je LA45
    test_input_string ".LABEL"
    jne LA46
    print "call label"
    call newline
    test_input_string "("
    mov esi, 43
    jne terminate_program ; 43
    
LA47:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA48
    
LA48:
    
LA49:
    je LA47
    call set_true
    mov esi, 44
    jne terminate_program ; 44
    test_input_string ")"
    mov esi, 45
    jne terminate_program ; 45
    print "call newline"
    call newline
    
LA46:
    je LA45
    test_input_string ".RS"
    jne LA50
    test_input_string "("
    mov esi, 47
    jne terminate_program ; 47
    
LA51:
    call vstack_clear
    call OUT1
    call vstack_restore
    je LA51
    call set_true
    mov esi, 48
    jne terminate_program ; 48
    test_input_string ")"
    mov esi, 49
    jne terminate_program ; 49
    
LA50:
    
LA45:
    jne LA52
    
LA52:
    je LA53
    test_input_string ".DIRECT"
    jne LA54
    test_input_string "("
    mov esi, 50
    jne terminate_program ; 50
    
LA55:
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    je LA55
    call set_true
    mov esi, 51
    jne terminate_program ; 51
    test_input_string ")"
    mov esi, 52
    jne terminate_program ; 52
    
LA54:
    
LA53:
    ret
    
EX3:
    call test_for_id
    jne LA56
    print "call vstack_clear"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_restore"
    call newline
    
LA56:
    je LA57
    call test_for_string
    jne LA58
    print "test_input_string "
    call copy_last_match
    call newline
    
LA58:
    je LA57
    test_input_string ".ID"
    jne LA59
    print "call test_for_id"
    call newline
    
LA59:
    je LA57
    test_input_string ".RET"
    jne LA60
    print "ret"
    call newline
    
LA60:
    je LA57
    test_input_string ".NOT"
    jne LA61
    call test_for_string
    jne LA62
    
LA62:
    je LA63
    call test_for_number
    jne LA64
    
LA64:
    
LA63:
    mov esi, 59
    jne terminate_program ; 59
    print "match_not "
    call copy_last_match
    call newline
    
LA61:
    je LA57
    test_input_string ".NUMBER"
    jne LA65
    print "call test_for_number"
    call newline
    
LA65:
    je LA57
    test_input_string ".STRING_RAW"
    jne LA66
    print "call test_for_string_raw"
    call newline
    
LA66:
    je LA57
    test_input_string ".STRING"
    jne LA67
    print "call test_for_string"
    call newline
    
LA67:
    je LA57
    test_input_string "%>"
    jne LA68
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA68:
    je LA57
    test_input_string "("
    jne LA69
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 67
    jne terminate_program ; 67
    test_input_string ")"
    mov esi, 68
    jne terminate_program ; 68
    
LA69:
    je LA57
    test_input_string "["
    jne LA70
    print "pushfd"
    call newline
    print "push eax"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 71
    jne terminate_program ; 71
    test_input_string "]"
    mov esi, 72
    jne terminate_program ; 72
    print "pop edi"
    call newline
    print "pop eax"
    call newline
    print "popfd"
    call newline
    
LA70:
    je LA57
    test_input_string ".EMPTY"
    jne LA71
    print "call set_true"
    call newline
    
LA71:
    je LA57
    test_input_string "$"
    jne LA72
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call EX3
    call vstack_restore
    mov esi, 77
    jne terminate_program ; 77
    print "je "
    call gn1
    call newline
    print "call set_true"
    call newline
    
LA72:
    je LA57
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA73
    
LA73:
    
LA57:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA74
    print "jne "
    call gn1
    call newline
    
LA74:
    je LA75
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA76
    
LA76:
    
LA75:
    jne LA77
    
LA78:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA79
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
    mov esi, 83
    jne terminate_program ; 83
    
LA79:
    je LA80
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA81
    
LA81:
    
LA80:
    je LA78
    call set_true
    mov esi, 84
    jne terminate_program ; 84
    call label
    call gn1
    print ":"
    call newline
    
LA77:
    
LA82:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    jne LA83
    
LA84:
    test_input_string "|"
    jne LA85
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov esi, 86
    jne terminate_program ; 86
    
LA85:
    
LA86:
    je LA84
    call set_true
    mov esi, 87
    jne terminate_program ; 87
    call label
    call gn1
    print ":"
    call newline
    
LA83:
    
LA87:
    ret
    
BRACKET_EXPR:
    test_input_string "+"
    jne LA88
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 88
    jne terminate_program ; 88
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 89
    jne terminate_program ; 89
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "add eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA88:
    
LA89:
    jne LA90
    
LA90:
    je LA91
    test_input_string "-"
    jne LA92
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 94
    jne terminate_program ; 94
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 95
    jne terminate_program ; 95
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "sub eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA92:
    
LA93:
    jne LA94
    
LA94:
    je LA91
    test_input_string "*"
    jne LA95
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 100
    jne terminate_program ; 100
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 101
    jne terminate_program ; 101
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "mul eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA95:
    
LA96:
    jne LA97
    
LA97:
    je LA91
    test_input_string "/"
    jne LA98
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 106
    jne terminate_program ; 106
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 107
    jne terminate_program ; 107
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "idiv eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA98:
    
LA99:
    jne LA100
    
LA100:
    je LA91
    test_input_string "set"
    jne LA101
    call test_for_id
    mov esi, 112
    jne terminate_program ; 112
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 113
    jne terminate_program ; 113
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 114
    jne terminate_program ; 114
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
    
LA101:
    
LA102:
    jne LA103
    
LA103:
    je LA91
    test_input_string "if"
    jne LA104
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 118
    jne terminate_program ; 118
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
    mov esi, 122
    jne terminate_program ; 122
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
    mov esi, 124
    jne terminate_program ; 124
    
LA104:
    
LA105:
    jne LA106
    call label
    call gn2
    print ":"
    call newline
    
LA106:
    je LA91
    test_input_string "hash-set"
    jne LA107
    call test_for_string
    mov esi, 125
    jne terminate_program ; 125
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
    mov esi, 127
    jne terminate_program ; 127
    print "mov edi, hashmap"
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
    
LA107:
    
LA108:
    jne LA109
    
LA109:
    je LA91
    test_input_string "hash-get"
    jne LA110
    call test_for_string
    mov esi, 133
    jne terminate_program ; 133
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
    print "mov edi, hashmap"
    call newline
    print "mov esi, "
    call gn3
    call newline
    print "call hash_get"
    call newline
    print "push eax"
    call newline
    
LA110:
    
LA111:
    jne LA112
    
LA112:
    je LA91
    call test_for_id
    jne LA113
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 139
    jne terminate_program ; 139
    
LA114:
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    jne LA115
    
LA115:
    
LA116:
    je LA114
    call set_true
    mov esi, 140
    jne terminate_program ; 140
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA113:
    
LA117:
    jne LA118
    
LA118:
    je LA91
    call test_for_id
    jne LA119
    print "push dword ["
    call copy_last_match
    print "]"
    call newline
    
LA119:
    
LA120:
    jne LA121
    
LA121:
    je LA91
    call test_for_number
    jne LA122
    print "push "
    call copy_last_match
    call newline
    
LA122:
    
LA123:
    jne LA124
    
LA124:
    
LA91:
    ret
    
BRACKET_ARG:
    test_input_string "["
    jne LA125
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 144
    jne terminate_program ; 144
    test_input_string "]"
    mov esi, 145
    jne terminate_program ; 145
    
LA125:
    
LA126:
    jne LA127
    
LA127:
    je LA128
    call test_for_number
    jne LA129
    print "push "
    call copy_last_match
    call newline
    
LA129:
    
LA130:
    jne LA131
    
LA131:
    je LA128
    call test_for_id
    jne LA132
    print "push dword ["
    call copy_last_match
    print "]"
    call newline
    
LA132:
    
LA133:
    jne LA134
    
LA134:
    
LA128:
    ret
    
DEFINITION:
    call test_for_id
    jne LA135
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov esi, 148
    jne terminate_program ; 148
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 149
    jne terminate_program ; 149
    test_input_string ";"
    mov esi, 150
    jne terminate_program ; 150
    print "ret"
    call newline
    
LA135:
    
LA136:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA137
    match_not 10
    mov esi, 152
    jne terminate_program ; 152
    
LA137:
    
LA138:
    ret
    
