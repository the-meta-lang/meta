
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
    push eax
    mov ebx, 4
    push ebx
    pop ebx
    pop eax
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
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
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
    mov edi, 76
    jne terminate_program ; 76
    
LA85:
    je LA70
    test_input_string ".PASS"
    jne LA86
    mov byte [input_string_offset], 0
    mov edi, 77
    jne terminate_program ; 77
    mov edi, 78
    jne terminate_program ; 78
    mov edi, 79
    jne terminate_program ; 79
    
LA86:
    je LA70
    test_input_string "{"
    jne LA87
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 80
    jne terminate_program ; 80
    
LA88:
    test_input_string "|"
    jne LA89
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 81
    jne terminate_program ; 81
    
LA89:
    
LA90:
    je LA88
    call set_true
    mov edi, 82
    jne terminate_program ; 82
    test_input_string "}"
    mov edi, 83
    jne terminate_program ; 83
    
LA87:
    je LA70
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA91
    
LA91:
    
LA70:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA92
    print "jne "
    call gn1
    call newline
    
LA92:
    je LA93
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA94
    
LA94:
    
LA93:
    jne LA95
    
LA96:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA97
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
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [line], eax
    pop eax
    popfd
    mov edi, 87
    jne terminate_program ; 87
    
LA97:
    je LA98
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA99
    
LA99:
    
LA98:
    je LA96
    call set_true
    mov edi, 88
    jne terminate_program ; 88
    call label
    call gn1
    print ":"
    call newline
    
LA95:
    
LA100:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    jne LA101
    
LA102:
    test_input_string "|"
    jne LA103
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov edi, 90
    jne terminate_program ; 90
    
LA103:
    
LA104:
    je LA102
    call set_true
    mov edi, 91
    jne terminate_program ; 91
    call label
    call gn1
    print ":"
    call newline
    
LA101:
    
LA105:
    ret
    
BRACKET_EXPR_WRAPPER:
    test_input_string "["
    jne LA106
    test_input_string "<<"
    jne LA107
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 92
    jne terminate_program ; 92
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 93
    jne terminate_program ; 93
    print "cmp eax, 0"
    call newline
    
LA107:
    
LA108:
    jne LA109
    mov edi, 95
    jne terminate_program ; 95
    
LA109:
    je LA110
    print "pushfd"
    call newline
    print "push eax"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 98
    jne terminate_program ; 98
    print "pop eax"
    call newline
    print "popfd"
    call newline
    
LA111:
    
LA112:
    jne LA113
    
LA113:
    
LA110:
    mov edi, 101
    jne terminate_program ; 101
    test_input_string "]"
    mov edi, 102
    jne terminate_program ; 102
    
LA106:
    
LA114:
    ret
    
BRACKET_EXPR:
    test_input_string "+"
    jne LA115
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 103
    jne terminate_program ; 103
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 104
    jne terminate_program ; 104
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 106
    jne terminate_program ; 106
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 107
    jne terminate_program ; 107
    print "push ebx"
    call newline
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "add eax, ebx"
    call newline
    
LA115:
    
LA116:
    jne LA117
    
LA117:
    je LA118
    test_input_string "-"
    jne LA119
    pushfd
    push eax
    mov eax, 0
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
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 115
    jne terminate_program ; 115
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 116
    jne terminate_program ; 116
    print "push ebx"
    call newline
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "sub eax, ebx"
    call newline
    
LA119:
    
LA120:
    jne LA121
    
LA121:
    je LA118
    test_input_string "*"
    jne LA122
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 121
    jne terminate_program ; 121
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 122
    jne terminate_program ; 122
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 124
    jne terminate_program ; 124
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 125
    jne terminate_program ; 125
    print "push ebx"
    call newline
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "mul ebx"
    call newline
    
LA122:
    
LA123:
    jne LA124
    
LA124:
    je LA118
    test_input_string "/"
    jne LA125
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 130
    jne terminate_program ; 130
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 131
    jne terminate_program ; 131
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 132
    jne terminate_program ; 132
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 133
    jne terminate_program ; 133
    print "idiv eax, ebx"
    call newline
    
LA125:
    
LA126:
    jne LA127
    
LA127:
    je LA118
    test_input_string "set"
    jne LA128
    call test_for_id
    mov edi, 135
    jne terminate_program ; 135
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 136
    jne terminate_program ; 136
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 137
    jne terminate_program ; 137
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 138
    jne terminate_program ; 138
    print "mov dword ["
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print "], eax"
    call newline
    
LA128:
    
LA129:
    jne LA130
    
LA130:
    je LA118
    test_input_string "if"
    jne LA131
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 140
    jne terminate_program ; 140
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
    mov edi, 144
    jne terminate_program ; 144
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
    mov edi, 146
    jne terminate_program ; 146
    
LA131:
    
LA132:
    jne LA133
    call label
    call gn2
    print ":"
    call newline
    
LA133:
    je LA118
    test_input_string "asm"
    jne LA134
    call test_for_string_raw
    mov edi, 147
    jne terminate_program ; 147
    call copy_last_match
    call newline
    
LA134:
    
LA135:
    jne LA136
    
LA136:
    je LA118
    test_input_string "define"
    jne LA137
    test_input_string "["
    mov edi, 149
    jne terminate_program ; 149
    call test_for_id
    mov edi, 150
    jne terminate_program ; 150
    call label
    call copy_last_match
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    mov edi, 153
    jne terminate_program ; 153
    
LA138:
    call test_for_id
    jne LA139
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    mov eax, dword [STO]
    push eax
    mov ebx, 4
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [STO], eax
    mov edx, eax
    call hash_set
    pop eax
    popfd
    mov edi, 154
    jne terminate_program ; 154
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 155
    jne terminate_program ; 155
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], edi"
    call newline
    
LA140:
    call test_for_id
    jne LA141
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    mov eax, dword [STO]
    push eax
    mov ebx, 4
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [STO], eax
    mov edx, eax
    call hash_set
    pop eax
    popfd
    mov edi, 157
    jne terminate_program ; 157
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 158
    jne terminate_program ; 158
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], esi"
    call newline
    
LA142:
    call test_for_id
    jne LA143
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    mov eax, dword [STO]
    push eax
    mov ebx, 4
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [STO], eax
    mov edx, eax
    call hash_set
    pop eax
    popfd
    mov edi, 160
    jne terminate_program ; 160
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 161
    jne terminate_program ; 161
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], edx"
    call newline
    
LA144:
    call test_for_id
    jne LA145
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    mov eax, dword [STO]
    push eax
    mov ebx, 4
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [STO], eax
    mov edx, eax
    call hash_set
    pop eax
    popfd
    mov edi, 163
    jne terminate_program ; 163
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 164
    jne terminate_program ; 164
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], ecx"
    call newline
    
LA146:
    call test_for_id
    jne LA147
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    mov eax, dword [STO]
    push eax
    mov ebx, 4
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [STO], eax
    mov edx, eax
    call hash_set
    pop eax
    popfd
    mov edi, 166
    jne terminate_program ; 166
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    push eax
    mov ebx, 1
    push ebx
    pop ebx
    pop eax
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 167
    jne terminate_program ; 167
    
LA147:
    
LA148:
    je LA146
    call set_true
    mov edi, 168
    jne terminate_program ; 168
    
LA145:
    
LA149:
    je LA144
    call set_true
    mov edi, 169
    jne terminate_program ; 169
    
LA143:
    
LA150:
    je LA142
    call set_true
    mov edi, 170
    jne terminate_program ; 170
    
LA141:
    
LA151:
    je LA140
    call set_true
    mov edi, 171
    jne terminate_program ; 171
    
LA139:
    
LA152:
    je LA138
    call set_true
    mov edi, 172
    jne terminate_program ; 172
    test_input_string "]"
    mov edi, 173
    jne terminate_program ; 173
    mov edi, 174
    jne terminate_program ; 174
    
LA153:
    test_input_string "["
    jne LA154
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 175
    jne terminate_program ; 175
    test_input_string "]"
    mov edi, 176
    jne terminate_program ; 176
    
LA154:
    
LA155:
    je LA153
    call set_true
    mov edi, 177
    jne terminate_program ; 177
    print "pop ebp"
    call newline
    print "ret"
    call newline
    pushfd
    push eax
    mov eax, dword [STO]
    push eax
    mov eax, 4
    push eax
    mov ebx, dword [VAR_IN_BODY]
    push ebx
    pop ebx
    pop eax
    mul ebx
    push ebx
    pop ebx
    pop eax
    sub eax, ebx
    mov dword [STO], eax
    pop eax
    popfd
    mov edi, 180
    jne terminate_program ; 180
    pushfd
    push eax
    mov eax, 0
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 181
    jne terminate_program ; 181
    
LA137:
    
LA156:
    jne LA157
    
LA157:
    je LA118
    test_input_string "hash-set"
    jne LA158
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    mov edi, 182
    jne terminate_program ; 182
    print "call hash_set"
    call newline
    
LA158:
    
LA159:
    jne LA160
    
LA160:
    je LA118
    test_input_string "hash-get"
    jne LA161
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    mov edi, 184
    jne terminate_program ; 184
    print "call hash_get"
    call newline
    
LA161:
    
LA162:
    jne LA163
    mov edi, 186
    jne terminate_program ; 186
    
LA163:
    je LA118
    test_input_string ">>"
    jne LA164
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 187
    jne terminate_program ; 187
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    mov edi, 188
    jne terminate_program ; 188
    print "call print_int"
    call newline
    
LA164:
    
LA165:
    jne LA166
    
LA166:
    je LA118
    test_input_string "<>"
    jne LA167
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 190
    jne terminate_program ; 190
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 191
    jne terminate_program ; 191
    
LA167:
    
LA168:
    jne LA169
    
LA169:
    je LA118
    call test_for_id
    jne LA170
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 192
    jne terminate_program ; 192
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    mov edi, 193
    jne terminate_program ; 193
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA170:
    
LA171:
    jne LA172
    
LA172:
    
LA118:
    ret
    
FN_CALL_ARG:
    
LA173:
    test_input_string "["
    jne LA174
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 195
    jne terminate_program ; 195
    test_input_string "]"
    mov edi, 196
    jne terminate_program ; 196
    print "mov edi, eax"
    call newline
    
LA174:
    
LA175:
    jne LA176
    
LA176:
    je LA177
    call test_for_number
    jne LA178
    print "mov edi, "
    call copy_last_match
    call newline
    
LA178:
    
LA179:
    jne LA180
    
LA180:
    je LA177
    call test_for_id
    jne LA181
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA182
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
    
LA182:
    je LA183
    print "mov edi, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA184:
    
LA183:
    mov edi, 202
    jne terminate_program ; 202
    
LA181:
    
LA185:
    jne LA186
    
LA186:
    je LA177
    test_input_string "*"
    jne LA187
    call test_for_id
    mov edi, 203
    jne terminate_program ; 203
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA188
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
    
LA188:
    je LA189
    print "mov edi, "
    call copy_last_match
    call newline
    call set_true
    
LA190:
    
LA189:
    mov edi, 206
    jne terminate_program ; 206
    
LA187:
    
LA191:
    jne LA192
    
LA192:
    je LA177
    call test_for_string
    jne LA193
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
    
LA193:
    
LA194:
    jne LA195
    
LA195:
    
LA177:
    jne LA196
    
LA197:
    test_input_string "["
    jne LA198
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 209
    jne terminate_program ; 209
    test_input_string "]"
    mov edi, 210
    jne terminate_program ; 210
    print "mov esi, eax"
    call newline
    
LA198:
    
LA199:
    jne LA200
    
LA200:
    je LA201
    call test_for_number
    jne LA202
    print "mov esi, "
    call copy_last_match
    call newline
    
LA202:
    
LA203:
    jne LA204
    
LA204:
    je LA201
    call test_for_id
    jne LA205
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA206
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
    
LA206:
    je LA207
    print "mov esi, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA208:
    
LA207:
    mov edi, 216
    jne terminate_program ; 216
    
LA205:
    
LA209:
    jne LA210
    
LA210:
    je LA201
    test_input_string "*"
    jne LA211
    call test_for_id
    mov edi, 217
    jne terminate_program ; 217
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA212
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
    
LA212:
    je LA213
    print "mov esi, "
    call copy_last_match
    call newline
    call set_true
    
LA214:
    
LA213:
    mov edi, 220
    jne terminate_program ; 220
    
LA211:
    
LA215:
    jne LA216
    
LA216:
    je LA201
    call test_for_string
    jne LA217
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
    
LA217:
    
LA218:
    jne LA219
    
LA219:
    
LA201:
    jne LA220
    
LA221:
    test_input_string "["
    jne LA222
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 223
    jne terminate_program ; 223
    test_input_string "]"
    mov edi, 224
    jne terminate_program ; 224
    print "mov edx, eax"
    call newline
    
LA222:
    
LA223:
    jne LA224
    
LA224:
    je LA225
    call test_for_number
    jne LA226
    print "mov edx, "
    call copy_last_match
    call newline
    
LA226:
    
LA227:
    jne LA228
    
LA228:
    je LA225
    call test_for_id
    jne LA229
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA230
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
    
LA230:
    je LA231
    print "mov edx, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA232:
    
LA231:
    mov edi, 230
    jne terminate_program ; 230
    
LA229:
    
LA233:
    jne LA234
    
LA234:
    je LA225
    test_input_string "*"
    jne LA235
    call test_for_id
    mov edi, 231
    jne terminate_program ; 231
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA236
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
    
LA236:
    je LA237
    print "mov edx, "
    call copy_last_match
    call newline
    call set_true
    
LA238:
    
LA237:
    mov edi, 234
    jne terminate_program ; 234
    
LA235:
    
LA239:
    jne LA240
    
LA240:
    je LA225
    call test_for_string
    jne LA241
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
    
LA241:
    
LA242:
    jne LA243
    
LA243:
    
LA225:
    jne LA244
    
LA244:
    
LA245:
    je LA221
    call set_true
    mov edi, 237
    jne terminate_program ; 237
    
LA220:
    
LA246:
    je LA197
    call set_true
    mov edi, 238
    jne terminate_program ; 238
    
LA196:
    
LA247:
    je LA173
    call set_true
    jne LA248
    
LA248:
    
LA249:
    ret
    
BRACKET_ARG:
    test_input_string "["
    jne LA250
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 239
    jne terminate_program ; 239
    test_input_string "]"
    mov edi, 240
    jne terminate_program ; 240
    
LA250:
    
LA251:
    jne LA252
    
LA252:
    je LA253
    call test_for_number
    jne LA254
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA255
    print "mov eax, "
    call copy_last_match
    call newline
    
LA255:
    je LA256
    print "mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA257:
    
LA256:
    mov edi, 243
    jne terminate_program ; 243
    
LA254:
    
LA258:
    jne LA259
    
LA259:
    je LA253
    call test_for_id
    jne LA260
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA261
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA262
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
    
LA262:
    je LA263
    print "mov eax, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA264:
    
LA263:
    mov edi, 247
    jne terminate_program ; 247
    
LA261:
    je LA265
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA266
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
    
LA266:
    je LA267
    print "mov ebx, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA268:
    
LA267:
    jne LA269
    
LA269:
    
LA265:
    mov edi, 251
    jne terminate_program ; 251
    
LA260:
    
LA270:
    jne LA271
    
LA271:
    je LA253
    test_input_string "*"
    jne LA272
    call test_for_id
    mov edi, 252
    jne terminate_program ; 252
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA273
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA274
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
    
LA274:
    je LA275
    print "mov eax, "
    call copy_last_match
    call newline
    call set_true
    
LA276:
    
LA275:
    mov edi, 255
    jne terminate_program ; 255
    
LA273:
    je LA277
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA278
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
    
LA278:
    je LA279
    print "mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA280:
    
LA279:
    jne LA281
    
LA281:
    
LA277:
    mov edi, 258
    jne terminate_program ; 258
    
LA272:
    
LA282:
    jne LA283
    
LA283:
    je LA253
    call test_for_string
    jne LA284
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
    jne LA285
    print "mov eax, "
    call gn3
    call newline
    
LA285:
    je LA286
    print "mov ebx, "
    call gn3
    call newline
    call set_true
    
LA287:
    
LA286:
    mov edi, 262
    jne terminate_program ; 262
    
LA284:
    
LA288:
    jne LA289
    
LA289:
    
LA253:
    ret
    
DEFINITION:
    call test_for_id
    jne LA290
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov edi, 263
    jne terminate_program ; 263
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 264
    jne terminate_program ; 264
    test_input_string ";"
    mov edi, 265
    jne terminate_program ; 265
    print "ret"
    call newline
    
LA290:
    
LA291:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA292
    match_not 10
    mov edi, 267
    jne terminate_program ; 267
    
LA292:
    
LA293:
    ret
    
