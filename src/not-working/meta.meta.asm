
%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .text
    push ebp
    mov ebp, esp
    
section .data
    
section .bss
    last_match resb 512
    
section .text
    mov dword [ebp-8], last_match
    
section .data
    line dd 0
    
section .text
    mov dword [ebp-12], line
    
section .data
    
section .bss
    ST resb 65536
    
section .text
    mov dword [ebp-16], ST
    
section .data
    STO dd 4
    
section .text
    mov dword [ebp-20], STO
    
section .data
    ARG_NUM dd 0
    
section .text
    mov dword [ebp-24], ARG_NUM
    
section .data
    VAR_IN_BODY dd 0
    
section .text
    mov dword [ebp-28], VAR_IN_BODY
    
section .data
    
section .text
    
section .text
    global _start
    
_start:
    call _read_file_argument
    call _read_file
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
    call label
    print "section .text"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
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
    mov esi, 2
    jne terminate_program ; 2
    
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
    mov esi, 3
    jne terminate_program ; 3
    
LA10:
    
LA15:
    jne LA16
    
LA16:
    je LA9
    test_input_string ".SYNTAX"
    jne LA17
    call test_for_id
    mov esi, 4
    jne terminate_program ; 4
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
    mov esi, 13
    jne terminate_program ; 13
    test_input_string ".END"
    mov esi, 14
    jne terminate_program ; 14
    
LA17:
    
LA23:
    jne LA24
    
LA24:
    
LA9:
    je LA1
    call set_true
    mov esi, 15
    jne terminate_program ; 15
    
LA25:
    
LA26:
    ret
    
INCLUDE_STATEMENT:
    test_input_string ".INCLUDE"
    jne LA27
    call test_for_string_raw
    mov esi, 16
    jne terminate_program ; 16
    test_input_string ";"
    mov esi, 17
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
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 18
    jne terminate_program ; 18
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 19
    jne terminate_program ; 19
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    mov eax, dword [ebp-20]
    mov eax, dword [eax]
    mov ebx, 4
    add eax, ebx
    mov [STO], eax
    mov edx, eax
    call hash_set
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 20
    jne terminate_program ; 20
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov eax, dword [ebp-28]
    mov eax, dword [eax]
    mov ebx, 1
    add eax, ebx
    mov [VAR_IN_BODY], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 21
    jne terminate_program ; 21
    test_input_string "="
    mov esi, 22
    jne terminate_program ; 22
    call vstack_clear
    call DATA_TYPE
    call vstack_restore
    mov esi, 23
    jne terminate_program ; 23
    test_input_string ";"
    mov esi, 24
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
    mov esi, 25
    jne terminate_program ; 25
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print " resb "
    call copy_last_match
    call newline
    test_input_string "}"
    mov esi, 27
    jne terminate_program ; 27
    
LA31:
    
LA32:
    jne LA33
    
LA33:
    je LA34
    call test_for_string
    jne LA35
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
    call label
    print "section .text"
    call newline
    print "mov dword [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov ebx, dword [ebp-20]
    mov ebx, dword [ebx]
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "], "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    call label
    print "section .data"
    call newline
    
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
    print "print_int edi"
    call newline
    
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
    mov esi, 42
    jne terminate_program ; 42
    
LA55:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA56
    
LA56:
    
LA57:
    je LA55
    call set_true
    mov esi, 43
    jne terminate_program ; 43
    test_input_string ")"
    mov esi, 44
    jne terminate_program ; 44
    print "call newline"
    call newline
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov eax, dword [ebp-12]
    mov eax, dword [eax]
    mov ebx, 1
    add eax, ebx
    mov [line], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 46
    jne terminate_program ; 46
    
LA54:
    je LA58
    test_input_string ".LABEL"
    jne LA59
    print "call label"
    call newline
    test_input_string "("
    mov esi, 48
    jne terminate_program ; 48
    
LA60:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA61
    
LA61:
    
LA62:
    je LA60
    call set_true
    mov esi, 49
    jne terminate_program ; 49
    test_input_string ")"
    mov esi, 50
    jne terminate_program ; 50
    print "call newline"
    call newline
    
LA59:
    je LA58
    test_input_string ".RS"
    jne LA63
    test_input_string "("
    mov esi, 52
    jne terminate_program ; 52
    
LA64:
    call vstack_clear
    call OUT1
    call vstack_restore
    je LA64
    call set_true
    mov esi, 53
    jne terminate_program ; 53
    test_input_string ")"
    mov esi, 54
    jne terminate_program ; 54
    
LA63:
    
LA58:
    jne LA65
    
LA65:
    je LA66
    test_input_string ".DIRECT"
    jne LA67
    test_input_string "("
    mov esi, 55
    jne terminate_program ; 55
    
LA68:
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    je LA68
    call set_true
    mov esi, 56
    jne terminate_program ; 56
    test_input_string ")"
    mov esi, 57
    jne terminate_program ; 57
    
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
    mov esi, 64
    jne terminate_program ; 64
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
    mov esi, 72
    jne terminate_program ; 72
    test_input_string ")"
    mov esi, 73
    jne terminate_program ; 73
    
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
    mov esi, 75
    jne terminate_program ; 75
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
    print "mov esi, "
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov ebx, dword [ebp-12]
    mov ebx, dword [ebx]
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    call newline
    print "jne terminate_program ; "
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov ebx, dword [ebp-12]
    mov ebx, dword [ebx]
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    call newline
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov eax, dword [ebp-12]
    mov eax, dword [eax]
    mov ebx, 1
    add eax, ebx
    mov [line], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 81
    jne terminate_program ; 81
    
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
    mov esi, 82
    jne terminate_program ; 82
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
    mov esi, 84
    jne terminate_program ; 84
    
LA98:
    
LA99:
    je LA97
    call set_true
    mov esi, 85
    jne terminate_program ; 85
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
    push ebp
    mov ebp, esp
    mov ebx, 0
    mov [ARG_NUM], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 86
    jne terminate_program ; 86
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 87
    jne terminate_program ; 87
    print "cmp eax, 0"
    call newline
    
LA102:
    
LA103:
    jne LA104
    mov esi, 89
    jne terminate_program ; 89
    
LA104:
    je LA105
    print "pushfd"
    call newline
    print "push eax"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 94
    jne terminate_program ; 94
    print "mov edi, eax"
    call newline
    print "pop ebp"
    call newline
    print "pop eax"
    call newline
    print "popfd"
    call newline
    
LA106:
    
LA107:
    jne LA108
    
LA108:
    
LA105:
    mov esi, 99
    jne terminate_program ; 99
    test_input_string "]"
    mov esi, 100
    jne terminate_program ; 100
    
LA101:
    
LA109:
    ret
    
BRACKET_EXPR:
    test_input_string "+"
    jne LA110
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov ebx, 0
    mov [ARG_NUM], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 101
    jne terminate_program ; 101
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 102
    jne terminate_program ; 102
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov ebx, 1
    mov [ARG_NUM], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 103
    jne terminate_program ; 103
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 104
    jne terminate_program ; 104
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
    push ebp
    mov ebp, esp
    mov ebx, 0
    mov [ARG_NUM], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 106
    jne terminate_program ; 106
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 107
    jne terminate_program ; 107
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov ebx, 1
    mov [ARG_NUM], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
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
    print "sub eax, ebx"
    call newline
    print "push eax"
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
    push ebp
    mov ebp, esp
    mov ebx, 0
    mov [ARG_NUM], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 114
    jne terminate_program ; 114
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 115
    jne terminate_program ; 115
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov ebx, 1
    mov [ARG_NUM], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 116
    jne terminate_program ; 116
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 117
    jne terminate_program ; 117
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "mul ebx"
    call newline
    print "push eax"
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
    push ebp
    mov ebp, esp
    mov ebx, 0
    mov [ARG_NUM], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 122
    jne terminate_program ; 122
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 123
    jne terminate_program ; 123
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov ebx, 1
    mov [ARG_NUM], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 124
    jne terminate_program ; 124
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 125
    jne terminate_program ; 125
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "idiv eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA120:
    
LA121:
    jne LA122
    
LA122:
    je LA113
    test_input_string "set"
    jne LA123
    call test_for_id
    mov esi, 130
    jne terminate_program ; 130
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 131
    jne terminate_program ; 131
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 132
    jne terminate_program ; 132
    print "mov ["
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
    mov esi, 134
    jne terminate_program ; 134
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
    mov esi, 138
    jne terminate_program ; 138
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
    mov esi, 140
    jne terminate_program ; 140
    
LA126:
    
LA127:
    jne LA128
    call label
    call gn2
    print ":"
    call newline
    
LA128:
    je LA113
    test_input_string "hash-set"
    jne LA129
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    mov esi, 141
    jne terminate_program ; 141
    print "call hash_set"
    call newline
    
LA129:
    
LA130:
    jne LA131
    
LA131:
    je LA113
    test_input_string "hash-get"
    jne LA132
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    mov esi, 143
    jne terminate_program ; 143
    print "call hash_get"
    call newline
    
LA132:
    
LA133:
    jne LA134
    
LA134:
    je LA113
    test_input_string "<>"
    jne LA135
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 145
    jne terminate_program ; 145
    
LA135:
    
LA136:
    jne LA137
    
LA137:
    je LA113
    call test_for_id
    jne LA138
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 146
    jne terminate_program ; 146
    
LA139:
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    jne LA140
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov eax, dword [ebp-24]
    mov eax, dword [eax]
    mov ebx, 1
    add eax, ebx
    mov [ARG_NUM], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 147
    jne terminate_program ; 147
    
LA140:
    
LA141:
    je LA139
    call set_true
    mov esi, 148
    jne terminate_program ; 148
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    print "push eax"
    call newline
    
LA138:
    
LA142:
    jne LA143
    
LA143:
    
LA113:
    ret
    
FN_CALL_ARG:
    
LA144:
    test_input_string "["
    jne LA145
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 151
    jne terminate_program ; 151
    test_input_string "]"
    mov esi, 152
    jne terminate_program ; 152
    print "mov edi, eax"
    call newline
    
LA145:
    
LA146:
    jne LA147
    
LA147:
    je LA148
    call test_for_number
    jne LA149
    print "mov edi, "
    call copy_last_match
    call newline
    
LA149:
    
LA150:
    jne LA151
    
LA151:
    je LA148
    call test_for_id
    jne LA152
    print "mov edi, dword [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    call hash_get
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA152:
    
LA153:
    jne LA154
    
LA154:
    je LA148
    test_input_string "*"
    jne LA155
    call test_for_id
    mov esi, 156
    jne terminate_program ; 156
    print "mov edi, dword [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    call hash_get
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "mov edi, dword [edi]"
    call newline
    
LA155:
    
LA156:
    jne LA157
    
LA157:
    je LA148
    call test_for_string
    jne LA158
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
    
LA158:
    
LA159:
    jne LA160
    
LA160:
    
LA148:
    jne LA161
    
LA162:
    test_input_string "["
    jne LA163
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 161
    jne terminate_program ; 161
    test_input_string "]"
    mov esi, 162
    jne terminate_program ; 162
    print "mov esi, eax"
    call newline
    
LA163:
    
LA164:
    jne LA165
    
LA165:
    je LA166
    call test_for_number
    jne LA167
    print "mov esi, "
    call copy_last_match
    call newline
    
LA167:
    
LA168:
    jne LA169
    
LA169:
    je LA166
    call test_for_id
    jne LA170
    print "mov esi, dword [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    call hash_get
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA170:
    
LA171:
    jne LA172
    
LA172:
    je LA166
    test_input_string "*"
    jne LA173
    call test_for_id
    mov esi, 166
    jne terminate_program ; 166
    print "mov esi, dword [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    call hash_get
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "mov esi, dword [esi]"
    call newline
    
LA173:
    
LA174:
    jne LA175
    
LA175:
    je LA166
    call test_for_string
    jne LA176
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
    
LA176:
    
LA177:
    jne LA178
    
LA178:
    
LA166:
    jne LA179
    
LA180:
    test_input_string "["
    jne LA181
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 171
    jne terminate_program ; 171
    test_input_string "]"
    mov esi, 172
    jne terminate_program ; 172
    print "mov edx, eax"
    call newline
    
LA181:
    
LA182:
    jne LA183
    
LA183:
    je LA184
    call test_for_number
    jne LA185
    print "mov edx, "
    call copy_last_match
    call newline
    
LA185:
    
LA186:
    jne LA187
    
LA187:
    je LA184
    call test_for_id
    jne LA188
    print "mov edx, dword [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    call hash_get
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA188:
    
LA189:
    jne LA190
    
LA190:
    je LA184
    test_input_string "*"
    jne LA191
    call test_for_id
    mov esi, 176
    jne terminate_program ; 176
    print "mov edx, dword [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    call hash_get
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "mov edx, dword [edx]"
    call newline
    
LA191:
    
LA192:
    jne LA193
    
LA193:
    je LA184
    call test_for_string
    jne LA194
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
    
LA194:
    
LA195:
    jne LA196
    
LA196:
    
LA184:
    jne LA197
    
LA197:
    
LA198:
    je LA180
    call set_true
    mov esi, 181
    jne terminate_program ; 181
    
LA179:
    
LA199:
    je LA162
    call set_true
    mov esi, 182
    jne terminate_program ; 182
    
LA161:
    
LA200:
    je LA144
    call set_true
    jne LA201
    
LA201:
    
LA202:
    ret
    
BRACKET_ARG:
    test_input_string "["
    jne LA203
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 183
    jne terminate_program ; 183
    test_input_string "]"
    mov esi, 184
    jne terminate_program ; 184
    
LA203:
    
LA204:
    jne LA205
    
LA205:
    je LA206
    call test_for_number
    jne LA207
    mov eax, dword [ebp-24]
    mov eax, dword [eax]
    cmp eax, 0
    jne LA208
    print "mov eax, "
    call copy_last_match
    call newline
    
LA208:
    je LA209
    print "mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA210:
    
LA209:
    mov esi, 187
    jne terminate_program ; 187
    
LA207:
    
LA211:
    jne LA212
    
LA212:
    je LA206
    call test_for_id
    jne LA213
    mov eax, dword [ebp-24]
    mov eax, dword [eax]
    cmp eax, 0
    jne LA214
    print "mov eax, dword [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    call hash_get
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "mov eax, dword [eax]"
    call newline
    
LA214:
    je LA215
    print "mov ebx, dword [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    call hash_get
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "mov ebx, dword [ebx]"
    call newline
    call set_true
    
LA216:
    
LA215:
    mov esi, 192
    jne terminate_program ; 192
    
LA213:
    
LA217:
    jne LA218
    
LA218:
    je LA206
    test_input_string "*"
    jne LA219
    call test_for_id
    mov esi, 193
    jne terminate_program ; 193
    mov eax, dword [ebp-24]
    mov eax, dword [eax]
    cmp eax, 0
    jne LA220
    print "mov eax, [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    call hash_get
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA220:
    je LA221
    print "mov ebx, [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    call hash_get
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    call set_true
    
LA222:
    
LA221:
    mov esi, 196
    jne terminate_program ; 196
    
LA219:
    
LA223:
    jne LA224
    
LA224:
    je LA206
    call test_for_string
    jne LA225
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
    mov eax, dword [ebp-24]
    mov eax, dword [eax]
    cmp eax, 0
    jne LA226
    print "mov eax, "
    call gn3
    call newline
    
LA226:
    je LA227
    print "mov ebx, "
    call gn3
    call newline
    call set_true
    
LA228:
    
LA227:
    mov esi, 200
    jne terminate_program ; 200
    
LA225:
    
LA229:
    jne LA230
    
LA230:
    
LA206:
    ret
    
CODE_DEFINITION:
    call test_for_id
    jne LA231
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov esi, 201
    jne terminate_program ; 201
    test_input_string "["
    mov esi, 202
    jne terminate_program ; 202
    mov esi, 203
    jne terminate_program ; 203
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    test_input_string "["
    mov esi, 206
    jne terminate_program ; 206
    
LA232:
    call test_for_id
    jne LA233
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    mov eax, dword [ebp-20]
    mov eax, dword [eax]
    mov ebx, 4
    add eax, ebx
    mov [STO], eax
    mov edx, eax
    call hash_set
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 207
    jne terminate_program ; 207
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov eax, dword [ebp-28]
    mov eax, dword [eax]
    mov ebx, 1
    add eax, ebx
    mov [VAR_IN_BODY], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 208
    jne terminate_program ; 208
    print "mov dword [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov ebx, dword [ebp-20]
    mov ebx, dword [ebx]
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "], edi"
    call newline
    
LA234:
    call test_for_id
    jne LA235
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    mov eax, dword [ebp-20]
    mov eax, dword [eax]
    mov ebx, 4
    add eax, ebx
    mov [STO], eax
    mov edx, eax
    call hash_set
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 210
    jne terminate_program ; 210
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov eax, dword [ebp-28]
    mov eax, dword [eax]
    mov ebx, 1
    add eax, ebx
    mov [VAR_IN_BODY], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 211
    jne terminate_program ; 211
    print "mov dword [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov ebx, dword [ebp-20]
    mov ebx, dword [ebx]
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "], esi"
    call newline
    
LA236:
    call test_for_id
    jne LA237
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    mov eax, dword [ebp-20]
    mov eax, dword [eax]
    mov ebx, 4
    add eax, ebx
    mov [STO], eax
    mov edx, eax
    call hash_set
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 213
    jne terminate_program ; 213
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov eax, dword [ebp-28]
    mov eax, dword [eax]
    mov ebx, 1
    add eax, ebx
    mov [VAR_IN_BODY], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 214
    jne terminate_program ; 214
    print "mov dword [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov ebx, dword [ebp-20]
    mov ebx, dword [ebx]
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "], edx"
    call newline
    
LA238:
    call test_for_id
    jne LA239
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    mov eax, dword [ebp-20]
    mov eax, dword [eax]
    mov ebx, 4
    add eax, ebx
    mov [STO], eax
    mov edx, eax
    call hash_set
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 216
    jne terminate_program ; 216
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov eax, dword [ebp-28]
    mov eax, dword [eax]
    mov ebx, 1
    add eax, ebx
    mov [VAR_IN_BODY], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 217
    jne terminate_program ; 217
    print "mov dword [ebp-"
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov ebx, dword [ebp-20]
    mov ebx, dword [ebx]
    mov edi, eax
    pop ebp
    pop eax
    popfd
    print_int edi
    print "], ecx"
    call newline
    
LA240:
    call test_for_id
    jne LA241
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov edi, dword [ebp-16]
    mov esi, dword [ebp-8]
    mov esi, dword [esi]
    mov eax, dword [ebp-20]
    mov eax, dword [eax]
    mov ebx, 4
    add eax, ebx
    mov [STO], eax
    mov edx, eax
    call hash_set
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 219
    jne terminate_program ; 219
    pushfd
    push eax
    push ebp
    mov ebp, esp
    mov eax, dword [ebp-28]
    mov eax, dword [eax]
    mov ebx, 1
    add eax, ebx
    mov [VAR_IN_BODY], eax
    mov edi, eax
    pop ebp
    pop eax
    popfd
    mov esi, 220
    jne terminate_program ; 220
    
LA241:
    
LA242:
    je LA240
    call set_true
    mov esi, 221
    jne terminate_program ; 221
    
LA239:
    
LA243:
    je LA238
    call set_true
    mov esi, 222
    jne terminate_program ; 222
    
LA237:
    
LA244:
    je LA236
    call set_true
    mov esi, 223
    jne terminate_program ; 223
    
LA235:
    
LA245:
    je LA234
    call set_true
    mov esi, 224
    jne terminate_program ; 224
    
LA233:
    
LA246:
    je LA232
    call set_true
    mov esi, 225
    jne terminate_program ; 225
    test_input_string "]"
    mov esi, 226
    jne terminate_program ; 226
    mov esi, 227
    jne terminate_program ; 227
    mov esi, 228
    jne terminate_program ; 228
    
LA247:
    test_input_string "["
    jne LA248
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 229
    jne terminate_program ; 229
    test_input_string "]"
    mov esi, 230
    jne terminate_program ; 230
    
LA248:
    
LA249:
    je LA247
    call set_true
    mov esi, 231
    jne terminate_program ; 231
    print "pop ebp"
    call newline
    print "ret"
    call newline
    test_input_string "]"
    mov esi, 234
    jne terminate_program ; 234
    test_input_string ";"
    mov esi, 235
    jne terminate_program ; 235
    
LA231:
    
LA250:
    ret
    
DEFINITION:
    call test_for_id
    jne LA251
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov esi, 236
    jne terminate_program ; 236
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 237
    jne terminate_program ; 237
    test_input_string ";"
    mov esi, 238
    jne terminate_program ; 238
    print "ret"
    call newline
    
LA251:
    
LA252:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA253
    match_not 10
    mov esi, 240
    jne terminate_program ; 240
    
LA253:
    
LA254:
    ret
    