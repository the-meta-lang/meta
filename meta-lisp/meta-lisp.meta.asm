
%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .bss
    last_match resb 512
    
section .data
    line dd 0
    
section .bss
    ST resb 65536
    
section .data
    STO dd 12
    
section .bss
    LOCALS resb 65536
    
section .data
    ARG_NUM dd 0
    
section .data
    VAR_IN_BODY dd 0
    
section .bss
    POINTER_VARS resb 65536
    
section .data
    DEFER dd 0
    
section .data
    WAS_LOCAL dd 0
    
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
    print "section .text"
    call newline
    print "global _start"
    call newline
    call label
    print "_start:"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    
LA1:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA2
    
LA2:
    je LA3
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA4
    
LA4:
    
LA3:
    je LA1
    call set_true
    mov edi, 3
    jne terminate_program ; 3
    print "pop ebp"
    call newline
    print "mov eax, 1"
    call newline
    print "mov ebx, 0"
    call newline
    print "int 0x80"
    call newline
    
LA5:
    
LA6:
    ret
    
BRACKET_EXPR_WRAPPER:
    test_input_string "["
    jne LA7
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 8
    jne terminate_program ; 8
    test_input_string "]"
    mov edi, 9
    jne terminate_program ; 9
    
LA7:
    
LA8:
    ret
    
BRACKET_EXPR:
    test_input_string "+"
    jne LA9
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 10
    jne terminate_program ; 10
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 11
    jne terminate_program ; 11
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 13
    jne terminate_program ; 13
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 14
    jne terminate_program ; 14
    print "push ebx"
    call newline
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "add eax, ebx"
    call newline
    
LA9:
    
LA10:
    jne LA11
    
LA11:
    je LA12
    test_input_string "-"
    jne LA13
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 19
    jne terminate_program ; 19
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 20
    jne terminate_program ; 20
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 22
    jne terminate_program ; 22
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 23
    jne terminate_program ; 23
    print "push ebx"
    call newline
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "sub eax, ebx"
    call newline
    
LA13:
    
LA14:
    jne LA15
    
LA15:
    je LA12
    test_input_string "*"
    jne LA16
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 28
    jne terminate_program ; 28
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 29
    jne terminate_program ; 29
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 31
    jne terminate_program ; 31
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 32
    jne terminate_program ; 32
    print "push ebx"
    call newline
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "mul ebx"
    call newline
    
LA16:
    
LA17:
    jne LA18
    
LA18:
    je LA12
    test_input_string "/"
    jne LA19
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 37
    jne terminate_program ; 37
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 38
    jne terminate_program ; 38
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 40
    jne terminate_program ; 40
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 41
    jne terminate_program ; 41
    print "push ebx"
    call newline
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "idiv eax, ebx"
    call newline
    
LA19:
    
LA20:
    jne LA21
    
LA21:
    je LA12
    test_input_string "<"
    jne LA22
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 46
    jne terminate_program ; 46
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 47
    jne terminate_program ; 47
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 49
    jne terminate_program ; 49
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 50
    jne terminate_program ; 50
    print "push ebx"
    call newline
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "cmp eax, ebx"
    call newline
    print "jl "
    call gn1
    call newline
    print "mov eax, 0"
    call newline
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "mov eax, 1"
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA22:
    
LA23:
    jne LA24
    
LA24:
    je LA12
    test_input_string "!="
    jne LA25
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 59
    jne terminate_program ; 59
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 60
    jne terminate_program ; 60
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 62
    jne terminate_program ; 62
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 63
    jne terminate_program ; 63
    print "push ebx"
    call newline
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "cmp eax, ebx"
    call newline
    print "jne "
    call gn1
    call newline
    print "mov eax, 0"
    call newline
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "mov eax, 1"
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA25:
    
LA26:
    jne LA27
    
LA27:
    je LA12
    test_input_string "return"
    jne LA28
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 72
    jne terminate_program ; 72
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 73
    jne terminate_program ; 73
    print "pop ebp"
    call newline
    print "ret"
    call newline
    
LA28:
    
LA29:
    jne LA30
    
LA30:
    je LA12
    test_input_string "set"
    jne LA31
    call test_for_id
    mov edi, 76
    jne terminate_program ; 76
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 77
    jne terminate_program ; 77
    pushfd
    push eax
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    mov dword [WAS_LOCAL], eax
    pop eax
    popfd
    mov edi, 78
    jne terminate_program ; 78
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov dword [DEFER], eax
    pop eax
    popfd
    mov edi, 79
    jne terminate_program ; 79
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 80
    jne terminate_program ; 80
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 81
    jne terminate_program ; 81
    mov eax, dword [WAS_LOCAL]
    cmp eax, 0
    jne LA32
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [DEFER]
    call print_int
    pop eax
    popfd
    print "], eax ; set "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA32:
    je LA33
    print "mov dword [ebp-"
    pushfd
    push eax
    mov edi, dword [DEFER]
    call print_int
    pop eax
    popfd
    print "], eax ; set "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    call set_true
    
LA34:
    
LA33:
    mov edi, 84
    jne terminate_program ; 84
    
LA31:
    
LA35:
    jne LA36
    
LA36:
    je LA12
    test_input_string "if"
    jne LA37
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 85
    jne terminate_program ; 85
    print "cmp eax, 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 88
    jne terminate_program ; 88
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
    mov edi, 90
    jne terminate_program ; 90
    call label
    call gn2
    print ":"
    call newline
    
LA37:
    
LA38:
    jne LA39
    
LA39:
    je LA12
    test_input_string "while"
    jne LA40
    test_input_string "["
    mov edi, 91
    jne terminate_program ; 91
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 92
    jne terminate_program ; 92
    print "cmp eax, 0 ; while"
    call newline
    print "je "
    call gn2
    call newline
    test_input_string "]"
    mov edi, 95
    jne terminate_program ; 95
    
LA41:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA42
    
LA42:
    
LA43:
    je LA41
    call set_true
    mov edi, 96
    jne terminate_program ; 96
    print "jmp "
    call gn1
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA40:
    
LA44:
    jne LA45
    
LA45:
    je LA12
    test_input_string "asm"
    jne LA46
    call test_for_string_raw
    mov edi, 98
    jne terminate_program ; 98
    call copy_last_match
    call newline
    
LA46:
    
LA47:
    jne LA48
    
LA48:
    je LA12
    test_input_string "define"
    jne LA49
    test_input_string "["
    jne LA50
    print "jmp "
    call gn1
    call newline
    call test_for_id
    mov edi, 101
    jne terminate_program ; 101
    call label
    call copy_last_match
    print ":"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    mov edi, 104
    jne terminate_program ; 104
    call vstack_clear
    call DEF_FN_ARGS
    call vstack_restore
    mov edi, 105
    jne terminate_program ; 105
    test_input_string "]"
    mov edi, 106
    jne terminate_program ; 106
    mov edi, 107
    jne terminate_program ; 107
    
LA51:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA52
    
LA52:
    
LA53:
    je LA51
    call set_true
    mov edi, 108
    jne terminate_program ; 108
    print "pop ebp"
    call newline
    print "ret"
    call newline
    call label
    call gn1
    print ":"
    call newline
    pushfd
    push eax
    mov eax, dword [STO]
    mov eax, dword [VAR_IN_BODY]
    mov ebx, 4
    mul ebx
    sub eax, ebx
    mov dword [STO], eax
    pop eax
    popfd
    mov edi, 111
    jne terminate_program ; 111
    pushfd
    push eax
    mov eax, 0
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 112
    jne terminate_program ; 112
    
LA50:
    
LA54:
    jne LA55
    mov edi, 113
    jne terminate_program ; 113
    
LA55:
    je LA56
    call test_for_id
    jne LA57
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 114
    jne terminate_program ; 114
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
    mov edi, 115
    jne terminate_program ; 115
    pushfd
    push eax
    mov edi, LOCALS
    mov esi, last_match
    mov edx, dword [STO]
    call hash_set
    pop eax
    popfd
    mov edi, 116
    jne terminate_program ; 116
    pushfd
    push eax
    mov eax, dword [STO]
    mov dword [DEFER], eax
    pop eax
    popfd
    mov edi, 117
    jne terminate_program ; 117
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    mov ebx, 1
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 118
    jne terminate_program ; 118
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 119
    jne terminate_program ; 119
    print "mov dword [ebp-"
    pushfd
    push eax
    mov edi, dword [DEFER]
    call print_int
    pop eax
    popfd
    print "], eax ; define "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    call set_true
    
LA57:
    
LA56:
    mov edi, 121
    jne terminate_program ; 121
    
LA49:
    
LA58:
    jne LA59
    
LA59:
    je LA12
    call test_for_id
    jne LA60
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 122
    jne terminate_program ; 122
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    mov edi, 123
    jne terminate_program ; 123
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA60:
    
LA61:
    jne LA62
    
LA62:
    
LA12:
    ret
    
DEF_FN_ARGS:
    
LA63:
    call vstack_clear
    call DEF_FN_ARG
    call vstack_restore
    jne LA64
    print "mov dword [ebp-"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], edi ; use "
    call copy_last_match
    call newline
    
LA65:
    call vstack_clear
    call DEF_FN_ARG
    call vstack_restore
    jne LA66
    print "mov dword [ebp-"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], esi ; use "
    call copy_last_match
    call newline
    
LA67:
    call vstack_clear
    call DEF_FN_ARG
    call vstack_restore
    jne LA68
    print "mov dword [ebp-"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], edx ; use "
    call copy_last_match
    call newline
    
LA69:
    call vstack_clear
    call DEF_FN_ARG
    call vstack_restore
    jne LA70
    print "mov dword [ebp-"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], ecx ; use "
    call copy_last_match
    call newline
    
LA70:
    
LA71:
    je LA69
    call set_true
    mov edi, 129
    jne terminate_program ; 129
    
LA68:
    
LA72:
    je LA67
    call set_true
    mov edi, 130
    jne terminate_program ; 130
    
LA66:
    
LA73:
    je LA65
    call set_true
    mov edi, 131
    jne terminate_program ; 131
    
LA64:
    
LA74:
    je LA63
    call set_true
    jne LA75
    
LA75:
    
LA76:
    ret
    
DEF_FN_ARG:
    test_input_string "*"
    jne LA77
    call test_for_id
    mov edi, 132
    jne terminate_program ; 132
    
LA77:
    je LA78
    call test_for_id
    jne LA79
    
LA79:
    
LA78:
    jne LA80
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
    mov edi, 133
    jne terminate_program ; 133
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    mov ebx, 1
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 134
    jne terminate_program ; 134
    
LA80:
    
LA81:
    ret
    
FN_CALL_ARG:
    
LA82:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA83
    print "mov edi, eax"
    call newline
    
LA83:
    
LA84:
    jne LA85
    
LA85:
    je LA86
    call test_for_number
    jne LA87
    print "mov edi, "
    call copy_last_match
    call newline
    
LA87:
    
LA88:
    jne LA89
    
LA89:
    je LA86
    call test_for_id
    jne LA90
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA91
    print "mov edi, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    
LA91:
    je LA92
    print "mov edi, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    call set_true
    
LA93:
    
LA92:
    mov edi, 139
    jne terminate_program ; 139
    
LA90:
    
LA94:
    jne LA95
    
LA95:
    je LA86
    test_input_string "*"
    jne LA96
    call test_for_id
    mov edi, 140
    jne terminate_program ; 140
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA97
    print "mov edi, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    
LA97:
    je LA98
    print "mov edi, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    call set_true
    
LA99:
    
LA98:
    mov edi, 143
    jne terminate_program ; 143
    
LA96:
    
LA100:
    jne LA101
    
LA101:
    je LA86
    call test_for_string
    jne LA102
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
    
LA102:
    
LA103:
    jne LA104
    
LA104:
    
LA86:
    jne LA105
    
LA106:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA107
    print "mov esi, eax"
    call newline
    
LA107:
    
LA108:
    jne LA109
    
LA109:
    je LA110
    call test_for_number
    jne LA111
    print "mov esi, "
    call copy_last_match
    call newline
    
LA111:
    
LA112:
    jne LA113
    
LA113:
    je LA110
    call test_for_id
    jne LA114
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA115
    print "mov esi, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    
LA115:
    je LA116
    print "mov esi, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    call set_true
    
LA117:
    
LA116:
    mov edi, 150
    jne terminate_program ; 150
    
LA114:
    
LA118:
    jne LA119
    
LA119:
    je LA110
    test_input_string "*"
    jne LA120
    call test_for_id
    mov edi, 151
    jne terminate_program ; 151
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA121
    print "mov esi, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    
LA121:
    je LA122
    print "mov esi, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    call set_true
    
LA123:
    
LA122:
    mov edi, 154
    jne terminate_program ; 154
    
LA120:
    
LA124:
    jne LA125
    
LA125:
    je LA110
    call test_for_string
    jne LA126
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
    
LA126:
    
LA127:
    jne LA128
    
LA128:
    
LA110:
    jne LA129
    
LA130:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA131
    print "mov edx, eax"
    call newline
    
LA131:
    
LA132:
    jne LA133
    
LA133:
    je LA134
    call test_for_number
    jne LA135
    print "mov edx, "
    call copy_last_match
    call newline
    
LA135:
    
LA136:
    jne LA137
    
LA137:
    je LA134
    call test_for_id
    jne LA138
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA139
    print "mov edx, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    
LA139:
    je LA140
    print "mov edx, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    call set_true
    
LA141:
    
LA140:
    mov edi, 161
    jne terminate_program ; 161
    
LA138:
    
LA142:
    jne LA143
    
LA143:
    je LA134
    test_input_string "*"
    jne LA144
    call test_for_id
    mov edi, 162
    jne terminate_program ; 162
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA145
    print "mov edx, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    
LA145:
    je LA146
    print "mov edx, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    call set_true
    
LA147:
    
LA146:
    mov edi, 165
    jne terminate_program ; 165
    
LA144:
    
LA148:
    jne LA149
    
LA149:
    je LA134
    call test_for_string
    jne LA150
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
    
LA150:
    
LA151:
    jne LA152
    
LA152:
    
LA134:
    jne LA153
    
LA153:
    
LA154:
    je LA130
    call set_true
    mov edi, 168
    jne terminate_program ; 168
    
LA129:
    
LA155:
    je LA106
    call set_true
    mov edi, 169
    jne terminate_program ; 169
    
LA105:
    
LA156:
    je LA82
    call set_true
    jne LA157
    
LA157:
    
LA158:
    ret
    
BRACKET_ARG:
    test_input_string "&1"
    jne LA159
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    mov edi, 170
    jne terminate_program ; 170
    print "push ebx"
    call newline
    print "mov ebx, eax"
    call newline
    print "xor eax, eax"
    call newline
    print "mov al, byte [ebx]"
    call newline
    print "pop ebx"
    call newline
    
LA159:
    
LA160:
    jne LA161
    
LA161:
    je LA162
    test_input_string "&2"
    jne LA163
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    mov edi, 176
    jne terminate_program ; 176
    print "push ebx"
    call newline
    print "mov ebx, eax"
    call newline
    print "xor eax, eax"
    call newline
    print "mov ax, word [ebx]"
    call newline
    print "pop ebx"
    call newline
    
LA163:
    
LA164:
    jne LA165
    
LA165:
    je LA162
    test_input_string "&"
    jne LA166
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    mov edi, 182
    jne terminate_program ; 182
    print "mov eax, dword [eax]"
    call newline
    
LA166:
    
LA167:
    jne LA168
    
LA168:
    je LA162
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA169
    
LA169:
    je LA162
    call test_for_number
    jne LA170
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA171
    print "mov eax, "
    call copy_last_match
    call newline
    
LA171:
    je LA172
    print "mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA173:
    
LA172:
    mov edi, 186
    jne terminate_program ; 186
    
LA170:
    
LA174:
    jne LA175
    
LA175:
    je LA162
    call test_for_id
    jne LA176
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA177
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA178
    print "mov eax, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    
LA178:
    je LA179
    print "mov eax, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    call set_true
    
LA180:
    
LA179:
    mov edi, 189
    jne terminate_program ; 189
    
LA177:
    je LA181
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA182
    print "mov ebx, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    
LA182:
    je LA183
    print "mov ebx, dword [ebp-"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    call print_int
    pop eax
    popfd
    print "] ; use "
    call copy_last_match
    call newline
    call set_true
    
LA184:
    
LA183:
    jne LA185
    
LA185:
    
LA181:
    mov edi, 192
    jne terminate_program ; 192
    
LA176:
    
LA186:
    jne LA187
    
LA187:
    je LA162
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
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA189
    print "mov eax, "
    call gn3
    call newline
    
LA189:
    je LA190
    print "mov ebx, "
    call gn3
    call newline
    call set_true
    
LA191:
    
LA190:
    mov edi, 196
    jne terminate_program ; 196
    
LA188:
    
LA192:
    jne LA193
    
LA193:
    je LA162
    call vstack_clear
    call DATA_TYPES
    call vstack_restore
    jne LA194
    
LA194:
    
LA162:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA195
    match_not 10
    mov edi, 197
    jne terminate_program ; 197
    
LA195:
    
LA196:
    ret
    
DATA_TYPES:
    call vstack_clear
    call ARRAY
    call vstack_restore
    jne LA197
    
LA197:
    je LA198
    call vstack_clear
    call STRING
    call vstack_restore
    jne LA199
    
LA199:
    je LA198
    call vstack_clear
    call NUMBER
    call vstack_restore
    jne LA200
    
LA200:
    
LA198:
    ret
    
ARRAY:
    test_input_string "#["
    jne LA201
    call label
    print "section .data"
    call newline
    call gn3
    print " dd "
    
LA202:
    call test_for_number
    jne LA203
    call copy_last_match
    print ", "
    
LA203:
    
LA204:
    je LA202
    call set_true
    mov edi, 198
    jne terminate_program ; 198
    print "0x00"
    call newline
    call label
    print "section .text"
    call newline
    print "mov eax, "
    call gn3
    call newline
    test_input_string "]"
    mov edi, 201
    jne terminate_program ; 201
    
LA201:
    
LA205:
    ret
    
NUMBER:
    call test_for_number
    jne LA206
    print "mov eax, "
    call copy_last_match
    call newline
    
LA206:
    
LA207:
    ret
    
STRING:
    call test_for_string
    jne LA208
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
    print "mov eax, "
    call gn3
    call newline
    
LA208:
    
LA209:
    ret
    
