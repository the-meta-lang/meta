
%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .bss
    last_match resb 512
    
section .data
    line dd 0
    
section .bss
    ST resb 65536
    
section .data
    STO dd 4
    
section .bss
    GLOBALS resb 65536
    
section .data
    ARG_NUM dd 0
    
section .data
    VAR_IN_BODY dd 0
    
section .text
    global _start
    
_start:
    call _read_file_argument
    call _read_file
    push ebp
    mov ebp, esp
    call PROGRAM
    pop ebp
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
    mov edi, 0
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
    call BRACKET_EXPR_WRAPPER
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
    mov edi, 1
    jne terminate_program ; 1
    
LA10:
    
LA15:
    jne LA16
    
LA16:
    je LA9
    test_input_string ".SYNTAX"
    jne LA17
    call test_for_id
    mov edi, 2
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
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "pop ebp"
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
    mov edi, 13
    jne terminate_program ; 13
    test_input_string ".END"
    mov edi, 14
    jne terminate_program ; 14
    
LA17:
    
LA23:
    jne LA24
    
LA24:
    
LA9:
    je LA1
    call set_true
    mov edi, 15
    jne terminate_program ; 15
    
LA25:
    
LA26:
    ret
    
INCLUDE_STATEMENT:
    test_input_string ".INCLUDE"
    jne LA27
    call test_for_string_raw
    mov edi, 16
    jne terminate_program ; 16
    test_input_string ";"
    mov edi, 17
    jne terminate_program ; 17
    mov esi, last_match
    call import_meta_file_mm32
    call set_true
    
LA27:
    
LA28:
    ret
    
DATA_DEFINITION:
    call test_for_id
    jne LA29
    pushfd
    push eax
    mov edi, GLOBALS
    mov esi, last_match
    mov edx, 1
    call hash_set
    pop eax
    popfd
    mov edi, 18
    jne terminate_program ; 18
    pushfd
    push eax
    mov eax, dword [STO]
    mov ebx, 4
    add eax, ebx
    mov dword [STO], eax
    pop eax
    popfd
    mov edi, 19
    jne terminate_program ; 19
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 20
    jne terminate_program ; 20
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 21
    jne terminate_program ; 21
    test_input_string "="
    mov edi, 22
    jne terminate_program ; 22
    call vstack_clear
    call DATA_TYPE
    call vstack_restore
    mov edi, 23
    jne terminate_program ; 23
    test_input_string ";"
    mov edi, 24
    jne terminate_program ; 24
    
LA29:
    
LA30:
    ret
    
DATA_TYPE:
    test_input_string "{"
    jne LA31
    call label
    print "section .bss"
    call newline
    call test_for_number
    mov edi, 25
    jne terminate_program ; 25
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print " resb "
    call copy_last_match
    call newline
    test_input_string "}"
    mov edi, 27
    jne terminate_program ; 27
    
LA31:
    
LA32:
    jne LA33
    
LA33:
    je LA34
    call test_for_string
    jne LA35
    call label
    print "section .data"
    call newline
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
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
    call label
    print "section .data"
    call newline
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print " dd "
    call copy_last_match
    call newline
    
LA38:
    
LA39:
    jne LA40
    
LA40:
    
LA34:
    jne LA41
    
LA41:
    
LA42:
    ret
    
OUT1:
    test_input_string "*1"
    jne LA43
    print "call gn1"
    call newline
    
LA43:
    je LA44
    test_input_string "*2"
    jne LA45
    print "call gn2"
    call newline
    
LA45:
    je LA44
    test_input_string "*3"
    jne LA46
    print "call gn3"
    call newline
    
LA46:
    je LA44
    test_input_string "*4"
    jne LA47
    print "call gn4"
    call newline
    
LA47:
    je LA44
    test_input_string "*"
    jne LA48
    print "call copy_last_match"
    call newline
    
LA48:
    je LA44
    test_input_string "%"
    jne LA49
    print "mov edi, str_vector_8192"
    call newline
    print "call vector_pop_string"
    call newline
    print "call print_mm32"
    call newline
    
LA49:
    je LA44
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA50
    
LA50:
    je LA44
    call test_for_string
    jne LA51
    print "print "
    call copy_last_match
    call newline
    
LA51:
    
LA44:
    ret
    
OUT_IMMEDIATE:
    call test_for_string_raw
    jne LA52
    call copy_last_match
    call newline
    
LA52:
    
LA53:
    ret
    
OUTPUT:
    test_input_string "->"
    jne LA54
    test_input_string "("
    mov edi, 40
    jne terminate_program ; 40
    
LA55:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA56
    
LA56:
    
LA57:
    je LA55
    call set_true
    mov edi, 41
    jne terminate_program ; 41
    test_input_string ")"
    mov edi, 42
    jne terminate_program ; 42
    print "call newline"
    call newline
    pushfd
    push eax
    mov eax, dword [line]
    mov ebx, 1
    add eax, ebx
    mov dword [line], eax
    pop eax
    popfd
    mov edi, 44
    jne terminate_program ; 44
    
LA54:
    je LA58
    test_input_string ".LABEL"
    jne LA59
    print "call label"
    call newline
    test_input_string "("
    mov edi, 46
    jne terminate_program ; 46
    
LA60:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA61
    
LA61:
    
LA62:
    je LA60
    call set_true
    mov edi, 47
    jne terminate_program ; 47
    test_input_string ")"
    mov edi, 48
    jne terminate_program ; 48
    print "call newline"
    call newline
    
LA59:
    je LA58
    test_input_string ".RS"
    jne LA63
    test_input_string "("
    mov edi, 50
    jne terminate_program ; 50
    
LA64:
    call vstack_clear
    call OUT1
    call vstack_restore
    je LA64
    call set_true
    mov edi, 51
    jne terminate_program ; 51
    test_input_string ")"
    mov edi, 52
    jne terminate_program ; 52
    
LA63:
    
LA58:
    jne LA65
    
LA65:
    je LA66
    test_input_string ".DIRECT"
    jne LA67
    test_input_string "("
    mov edi, 53
    jne terminate_program ; 53
    
LA68:
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    je LA68
    call set_true
    mov edi, 54
    jne terminate_program ; 54
    test_input_string ")"
    mov edi, 55
    jne terminate_program ; 55
    
LA67:
    
LA66:
    ret
    
EX3:
    call test_for_id
    jne LA69
    print "call vstack_clear"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_restore"
    call newline
    
LA69:
    je LA70
    call test_for_string
    jne LA71
    print "test_input_string "
    call copy_last_match
    call newline
    
LA71:
    je LA70
    test_input_string ".ID"
    jne LA72
    print "call test_for_id"
    call newline
    
LA72:
    je LA70
    test_input_string ".RET"
    jne LA73
    print "ret"
    call newline
    
LA73:
    je LA70
    test_input_string ".NOT"
    jne LA74
    call test_for_string
    jne LA75
    
LA75:
    je LA76
    call test_for_number
    jne LA77
    
LA77:
    
LA76:
    mov edi, 62
    jne terminate_program ; 62
    print "match_not "
    call copy_last_match
    call newline
    
LA74:
    je LA70
    test_input_string ".NUMBER"
    jne LA78
    print "call test_for_number"
    call newline
    
LA78:
    je LA70
    test_input_string ".STRING_RAW"
    jne LA79
    print "call test_for_string_raw"
    call newline
    
LA79:
    je LA70
    test_input_string ".STRING"
    jne LA80
    print "call test_for_string"
    call newline
    
LA80:
    je LA70
    test_input_string "%>"
    jne LA81
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA81:
    je LA70
    test_input_string "("
    jne LA82
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 70
    jne terminate_program ; 70
    test_input_string ")"
    mov edi, 71
    jne terminate_program ; 71
    
LA82:
    je LA70
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA83
    
LA83:
    je LA70
    test_input_string ".EMPTY"
    jne LA84
    print "call set_true"
    call newline
    
LA84:
    je LA70
    test_input_string "$"
    jne LA85
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call EX3
    call vstack_restore
    mov edi, 73
    jne terminate_program ; 73
    print "je "
    call gn1
    call newline
    print "call set_true"
    call newline
    
LA85:
    je LA70
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA86
    
LA86:
    
LA70:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA87
    print "jne "
    call gn1
    call newline
    
LA87:
    je LA88
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA89
    
LA89:
    
LA88:
    jne LA90
    
LA91:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA92
    print "mov edi, "
    pushfd
    push eax
    mov edi, dword [line]
    call print_int
    pop eax
    popfd
    call newline
    print "jne terminate_program ; "
    pushfd
    push eax
    mov edi, dword [line]
    call print_int
    pop eax
    popfd
    call newline
    pushfd
    push eax
    mov eax, dword [line]
    mov ebx, 1
    add eax, ebx
    mov dword [line], eax
    pop eax
    popfd
    mov edi, 79
    jne terminate_program ; 79
    
LA92:
    je LA93
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA94
    
LA94:
    
LA93:
    je LA91
    call set_true
    mov edi, 80
    jne terminate_program ; 80
    call label
    call gn1
    print ":"
    call newline
    
LA90:
    
LA95:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    jne LA96
    
LA97:
    test_input_string "|"
    jne LA98
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov edi, 82
    jne terminate_program ; 82
    
LA98:
    
LA99:
    je LA97
    call set_true
    mov edi, 83
    jne terminate_program ; 83
    call label
    call gn1
    print ":"
    call newline
    
LA96:
    
LA100:
    ret
    
BRACKET_EXPR_WRAPPER:
    test_input_string "["
    jne LA101
    test_input_string "<<"
    jne LA102
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 84
    jne terminate_program ; 84
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 85
    jne terminate_program ; 85
    print "cmp eax, 0"
    call newline
    
LA102:
    
LA103:
    jne LA104
    mov edi, 87
    jne terminate_program ; 87
    
LA104:
    je LA105
    print "pushfd"
    call newline
    print "push eax"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 90
    jne terminate_program ; 90
    print "pop eax"
    call newline
    print "popfd"
    call newline
    
LA106:
    
LA107:
    jne LA108
    
LA108:
    
LA105:
    mov edi, 93
    jne terminate_program ; 93
    test_input_string "]"
    mov edi, 94
    jne terminate_program ; 94
    
LA101:
    
LA109:
    ret
    
BRACKET_EXPR:
    test_input_string "+"
    jne LA110
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 95
    jne terminate_program ; 95
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 96
    jne terminate_program ; 96
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 97
    jne terminate_program ; 97
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 98
    jne terminate_program ; 98
    print "add eax, ebx"
    call newline
    
LA110:
    
LA111:
    jne LA112
    
LA112:
    je LA113
    test_input_string "-"
    jne LA114
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 100
    jne terminate_program ; 100
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 101
    jne terminate_program ; 101
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 102
    jne terminate_program ; 102
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 103
    jne terminate_program ; 103
    print "sub eax, ebx"
    call newline
    
LA114:
    
LA115:
    jne LA116
    
LA116:
    je LA113
    test_input_string "*"
    jne LA117
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 105
    jne terminate_program ; 105
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 106
    jne terminate_program ; 106
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 107
    jne terminate_program ; 107
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 108
    jne terminate_program ; 108
    print "mul ebx"
    call newline
    
LA117:
    
LA118:
    jne LA119
    
LA119:
    je LA113
    test_input_string "/"
    jne LA120
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 110
    jne terminate_program ; 110
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 111
    jne terminate_program ; 111
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 112
    jne terminate_program ; 112
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 113
    jne terminate_program ; 113
    print "idiv eax, ebx"
    call newline
    
LA120:
    
LA121:
    jne LA122
    
LA122:
    je LA113
    test_input_string "set"
    jne LA123
    call test_for_id
    mov edi, 115
    jne terminate_program ; 115
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 116
    jne terminate_program ; 116
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 117
    jne terminate_program ; 117
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 118
    jne terminate_program ; 118
    print "mov dword ["
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print "], eax"
    call newline
    
LA123:
    
LA124:
    jne LA125
    
LA125:
    je LA113
    test_input_string "if"
    jne LA126
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 120
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
    mov edi, 124
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
    mov edi, 126
    jne terminate_program ; 126
    
LA126:
    
LA127:
    jne LA128
    call label
    call gn2
    print ":"
    call newline
    
LA128:
    je LA113
    test_input_string "asm"
    jne LA129
    call test_for_string_raw
    mov edi, 127
    jne terminate_program ; 127
    call copy_last_match
    call newline
    
LA129:
    
LA130:
    jne LA131
    
LA131:
    je LA113
    test_input_string "define"
    jne LA132
    test_input_string "["
    mov edi, 129
    jne terminate_program ; 129
    call test_for_id
    mov edi, 130
    jne terminate_program ; 130
    call label
    call copy_last_match
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    mov edi, 133
    jne terminate_program ; 133
    
LA133:
    call test_for_id
    jne LA134
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    mov eax, dword [STO]
    mov ebx, 4
    add eax, ebx
    mov dword [STO], eax
    mov edx, eax
    call hash_set
    pop eax
    popfd
    mov edi, 134
    jne terminate_program ; 134
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    mov ebx, 1
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 135
    jne terminate_program ; 135
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], edi"
    call newline
    
LA135:
    call test_for_id
    jne LA136
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    mov eax, dword [STO]
    mov ebx, 4
    add eax, ebx
    mov dword [STO], eax
    mov edx, eax
    call hash_set
    pop eax
    popfd
    mov edi, 137
    jne terminate_program ; 137
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    mov ebx, 1
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 138
    jne terminate_program ; 138
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], esi"
    call newline
    
LA137:
    call test_for_id
    jne LA138
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    mov eax, dword [STO]
    mov ebx, 4
    add eax, ebx
    mov dword [STO], eax
    mov edx, eax
    call hash_set
    pop eax
    popfd
    mov edi, 140
    jne terminate_program ; 140
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    mov ebx, 1
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 141
    jne terminate_program ; 141
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], edx"
    call newline
    
LA139:
    call test_for_id
    jne LA140
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    mov eax, dword [STO]
    mov ebx, 4
    add eax, ebx
    mov dword [STO], eax
    mov edx, eax
    call hash_set
    pop eax
    popfd
    mov edi, 143
    jne terminate_program ; 143
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    mov ebx, 1
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 144
    jne terminate_program ; 144
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], ecx"
    call newline
    
LA141:
    call test_for_id
    jne LA142
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    mov eax, dword [STO]
    mov ebx, 4
    add eax, ebx
    mov dword [STO], eax
    mov edx, eax
    call hash_set
    pop eax
    popfd
    mov edi, 146
    jne terminate_program ; 146
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    mov ebx, 1
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 147
    jne terminate_program ; 147
    
LA142:
    
LA143:
    je LA141
    call set_true
    mov edi, 148
    jne terminate_program ; 148
    
LA140:
    
LA144:
    je LA139
    call set_true
    mov edi, 149
    jne terminate_program ; 149
    
LA138:
    
LA145:
    je LA137
    call set_true
    mov edi, 150
    jne terminate_program ; 150
    
LA136:
    
LA146:
    je LA135
    call set_true
    mov edi, 151
    jne terminate_program ; 151
    
LA134:
    
LA147:
    je LA133
    call set_true
    mov edi, 152
    jne terminate_program ; 152
    test_input_string "]"
    mov edi, 153
    jne terminate_program ; 153
    mov edi, 154
    jne terminate_program ; 154
    
LA148:
    test_input_string "["
    jne LA149
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 155
    jne terminate_program ; 155
    test_input_string "]"
    mov edi, 156
    jne terminate_program ; 156
    
LA149:
    
LA150:
    je LA148
    call set_true
    mov edi, 157
    jne terminate_program ; 157
    print "pop ebp"
    call newline
    print "ret"
    call newline
    pushfd
    push eax
    mov eax, dword [STO]
    mov eax, 4
    mov ebx, dword [VAR_IN_BODY]
    mul ebx
    sub eax, ebx
    mov dword [STO], eax
    pop eax
    popfd
    mov edi, 160
    jne terminate_program ; 160
    pushfd
    push eax
    mov eax, 0
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 161
    jne terminate_program ; 161
    
LA132:
    
LA151:
    jne LA152
    
LA152:
    je LA113
    test_input_string "hash-set"
    jne LA153
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    mov edi, 162
    jne terminate_program ; 162
    print "call hash_set"
    call newline
    
LA153:
    
LA154:
    jne LA155
    
LA155:
    je LA113
    test_input_string "hash-get"
    jne LA156
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    mov edi, 164
    jne terminate_program ; 164
    print "call hash_get"
    call newline
    
LA156:
    
LA157:
    jne LA158
    mov edi, 166
    jne terminate_program ; 166
    
LA158:
    je LA113
    test_input_string ">>"
    jne LA159
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 167
    jne terminate_program ; 167
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    mov edi, 168
    jne terminate_program ; 168
    print "call print_int"
    call newline
    
LA159:
    
LA160:
    jne LA161
    
LA161:
    je LA113
    test_input_string "<>"
    jne LA162
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 170
    jne terminate_program ; 170
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 171
    jne terminate_program ; 171
    
LA162:
    
LA163:
    jne LA164
    
LA164:
    je LA113
    call test_for_id
    jne LA165
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 172
    jne terminate_program ; 172
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    mov edi, 173
    jne terminate_program ; 173
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA165:
    
LA166:
    jne LA167
    
LA167:
    
LA113:
    ret
    
FN_CALL_ARG:
    
LA168:
    test_input_string "["
    jne LA169
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 175
    jne terminate_program ; 175
    test_input_string "]"
    mov edi, 176
    jne terminate_program ; 176
    print "mov edi, eax"
    call newline
    
LA169:
    
LA170:
    jne LA171
    
LA171:
    je LA172
    call test_for_number
    jne LA173
    print "mov edi, "
    call copy_last_match
    call newline
    
LA173:
    
LA174:
    jne LA175
    
LA175:
    je LA172
    call test_for_id
    jne LA176
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA177
    print "mov edi, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "]"
    call newline
    print "mov edi, dword [edi]"
    call newline
    
LA177:
    je LA178
    print "mov edi, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA179:
    
LA178:
    mov edi, 182
    jne terminate_program ; 182
    
LA176:
    
LA180:
    jne LA181
    
LA181:
    je LA172
    test_input_string "*"
    jne LA182
    call test_for_id
    mov edi, 183
    jne terminate_program ; 183
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA183
    print "mov edi, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "]"
    call newline
    
LA183:
    je LA184
    print "mov edi, "
    call copy_last_match
    call newline
    call set_true
    
LA185:
    
LA184:
    mov edi, 186
    jne terminate_program ; 186
    
LA182:
    
LA186:
    jne LA187
    
LA187:
    je LA172
    call test_for_string
    jne LA188
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
    
LA188:
    
LA189:
    jne LA190
    
LA190:
    
LA172:
    jne LA191
    
LA192:
    test_input_string "["
    jne LA193
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 189
    jne terminate_program ; 189
    test_input_string "]"
    mov edi, 190
    jne terminate_program ; 190
    print "mov esi, eax"
    call newline
    
LA193:
    
LA194:
    jne LA195
    
LA195:
    je LA196
    call test_for_number
    jne LA197
    print "mov esi, "
    call copy_last_match
    call newline
    
LA197:
    
LA198:
    jne LA199
    
LA199:
    je LA196
    call test_for_id
    jne LA200
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA201
    print "mov esi, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "]"
    call newline
    print "mov esi, dword [esi]"
    call newline
    
LA201:
    je LA202
    print "mov esi, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA203:
    
LA202:
    mov edi, 196
    jne terminate_program ; 196
    
LA200:
    
LA204:
    jne LA205
    
LA205:
    je LA196
    test_input_string "*"
    jne LA206
    call test_for_id
    mov edi, 197
    jne terminate_program ; 197
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA207
    print "mov esi, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "]"
    call newline
    
LA207:
    je LA208
    print "mov esi, "
    call copy_last_match
    call newline
    call set_true
    
LA209:
    
LA208:
    mov edi, 200
    jne terminate_program ; 200
    
LA206:
    
LA210:
    jne LA211
    
LA211:
    je LA196
    call test_for_string
    jne LA212
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
    
LA212:
    
LA213:
    jne LA214
    
LA214:
    
LA196:
    jne LA215
    
LA216:
    test_input_string "["
    jne LA217
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 203
    jne terminate_program ; 203
    test_input_string "]"
    mov edi, 204
    jne terminate_program ; 204
    print "mov edx, eax"
    call newline
    
LA217:
    
LA218:
    jne LA219
    
LA219:
    je LA220
    call test_for_number
    jne LA221
    print "mov edx, "
    call copy_last_match
    call newline
    
LA221:
    
LA222:
    jne LA223
    
LA223:
    je LA220
    call test_for_id
    jne LA224
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA225
    print "mov edx, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "]"
    call newline
    print "mov edx, dword [edx]"
    call newline
    
LA225:
    je LA226
    print "mov edx, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA227:
    
LA226:
    mov edi, 210
    jne terminate_program ; 210
    
LA224:
    
LA228:
    jne LA229
    
LA229:
    je LA220
    test_input_string "*"
    jne LA230
    call test_for_id
    mov edi, 211
    jne terminate_program ; 211
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA231
    print "mov edx, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "]"
    call newline
    
LA231:
    je LA232
    print "mov edx, "
    call copy_last_match
    call newline
    call set_true
    
LA233:
    
LA232:
    mov edi, 214
    jne terminate_program ; 214
    
LA230:
    
LA234:
    jne LA235
    
LA235:
    je LA220
    call test_for_string
    jne LA236
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
    
LA236:
    
LA237:
    jne LA238
    
LA238:
    
LA220:
    jne LA239
    
LA239:
    
LA240:
    je LA216
    call set_true
    mov edi, 217
    jne terminate_program ; 217
    
LA215:
    
LA241:
    je LA192
    call set_true
    mov edi, 218
    jne terminate_program ; 218
    
LA191:
    
LA242:
    je LA168
    call set_true
    jne LA243
    
LA243:
    
LA244:
    ret
    
BRACKET_ARG:
    test_input_string "["
    jne LA245
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 219
    jne terminate_program ; 219
    test_input_string "]"
    mov edi, 220
    jne terminate_program ; 220
    
LA245:
    
LA246:
    jne LA247
    
LA247:
    je LA248
    call test_for_number
    jne LA249
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA250
    print "mov eax, "
    call copy_last_match
    call newline
    
LA250:
    je LA251
    print "mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA252:
    
LA251:
    mov edi, 223
    jne terminate_program ; 223
    
LA249:
    
LA253:
    jne LA254
    
LA254:
    je LA248
    call test_for_id
    jne LA255
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA256
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA257
    print "mov eax, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "]"
    call newline
    print "mov eax, dword [eax]"
    call newline
    
LA257:
    je LA258
    print "mov eax, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA259:
    
LA258:
    mov edi, 227
    jne terminate_program ; 227
    
LA256:
    je LA260
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA261
    print "mov ebx, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "]"
    call newline
    print "mov ebx, dword [eax]"
    call newline
    
LA261:
    je LA262
    print "mov ebx, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA263:
    
LA262:
    jne LA264
    
LA264:
    
LA260:
    mov edi, 231
    jne terminate_program ; 231
    
LA255:
    
LA265:
    jne LA266
    
LA266:
    je LA248
    test_input_string "*"
    jne LA267
    call test_for_id
    mov edi, 232
    jne terminate_program ; 232
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA268
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA269
    print "mov eax, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "]"
    call newline
    
LA269:
    je LA270
    print "mov eax, "
    call copy_last_match
    call newline
    call set_true
    
LA271:
    
LA270:
    mov edi, 235
    jne terminate_program ; 235
    
LA268:
    je LA272
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA273
    print "mov ebx, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "]"
    call newline
    
LA273:
    je LA274
    print "mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA275:
    
LA274:
    jne LA276
    
LA276:
    
LA272:
    mov edi, 238
    jne terminate_program ; 238
    
LA267:
    
LA277:
    jne LA278
    
LA278:
    je LA248
    call test_for_string
    jne LA279
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
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA280
    print "mov eax, "
    call gn3
    call newline
    
LA280:
    je LA281
    print "mov ebx, "
    call gn3
    call newline
    call set_true
    
LA282:
    
LA281:
    mov edi, 242
    jne terminate_program ; 242
    
LA279:
    
LA283:
    jne LA284
    
LA284:
    
LA248:
    ret
    
DEFINITION:
    call test_for_id
    jne LA285
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov edi, 243
    jne terminate_program ; 243
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 244
    jne terminate_program ; 244
    test_input_string ";"
    mov edi, 245
    jne terminate_program ; 245
    print "ret"
    call newline
    
LA285:
    
LA286:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA287
    match_not 10
    mov edi, 247
    jne terminate_program ; 247
    
LA287:
    
LA288:
    ret
    
