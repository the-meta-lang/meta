
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
    print "xor edx, edx"
    call newline
    print "div ebx"
    call newline
    
LA19:
    
LA20:
    jne LA21
    
LA21:
    je LA12
    test_input_string "%"
    jne LA22
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 47
    jne terminate_program ; 47
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 48
    jne terminate_program ; 48
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 50
    jne terminate_program ; 50
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 51
    jne terminate_program ; 51
    print "push ebx"
    call newline
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "xor edx, edx"
    call newline
    print "div ebx"
    call newline
    print "mov eax, edx"
    call newline
    
LA22:
    
LA23:
    jne LA24
    
LA24:
    je LA12
    test_input_string ">="
    jne LA25
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 58
    jne terminate_program ; 58
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 59
    jne terminate_program ; 59
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 61
    jne terminate_program ; 61
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 62
    jne terminate_program ; 62
    print "push ebx"
    call newline
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "cmp eax, ebx"
    call newline
    print "jge "
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
    test_input_string "<"
    jne LA28
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 71
    jne terminate_program ; 71
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 72
    jne terminate_program ; 72
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 74
    jne terminate_program ; 74
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 75
    jne terminate_program ; 75
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
    
LA28:
    
LA29:
    jne LA30
    
LA30:
    je LA12
    test_input_string ">"
    jne LA31
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
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 87
    jne terminate_program ; 87
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 88
    jne terminate_program ; 88
    print "push ebx"
    call newline
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "cmp eax, ebx"
    call newline
    print "jg "
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
    
LA31:
    
LA32:
    jne LA33
    
LA33:
    je LA12
    test_input_string "!="
    jne LA34
    pushfd
    push eax
    mov eax, 0
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
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
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
    
LA34:
    
LA35:
    jne LA36
    
LA36:
    je LA12
    test_input_string "return"
    jne LA37
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
    print "pop ebp"
    call newline
    print "ret"
    call newline
    
LA37:
    
LA38:
    jne LA39
    
LA39:
    je LA12
    test_input_string "set"
    jne LA40
    call test_for_id
    mov edi, 114
    jne terminate_program ; 114
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 115
    jne terminate_program ; 115
    pushfd
    push eax
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    mov dword [WAS_LOCAL], eax
    pop eax
    popfd
    mov edi, 116
    jne terminate_program ; 116
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov dword [DEFER], eax
    pop eax
    popfd
    mov edi, 117
    jne terminate_program ; 117
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 118
    jne terminate_program ; 118
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 119
    jne terminate_program ; 119
    mov eax, dword [WAS_LOCAL]
    cmp eax, 0
    jne LA41
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
    
LA41:
    je LA42
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
    
LA43:
    
LA42:
    mov edi, 122
    jne terminate_program ; 122
    
LA40:
    
LA44:
    jne LA45
    
LA45:
    je LA12
    test_input_string "if"
    jne LA46
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 123
    jne terminate_program ; 123
    print "cmp eax, 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 126
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
    mov edi, 128
    jne terminate_program ; 128
    call label
    call gn2
    print ":"
    call newline
    
LA46:
    
LA47:
    jne LA48
    
LA48:
    je LA12
    test_input_string "while"
    jne LA49
    test_input_string "["
    mov edi, 129
    jne terminate_program ; 129
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 130
    jne terminate_program ; 130
    print "cmp eax, 0 ; while"
    call newline
    print "je "
    call gn2
    call newline
    test_input_string "]"
    mov edi, 133
    jne terminate_program ; 133
    
LA50:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA51
    
LA51:
    
LA52:
    je LA50
    call set_true
    mov edi, 134
    jne terminate_program ; 134
    print "jmp "
    call gn1
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA49:
    
LA53:
    jne LA54
    
LA54:
    je LA12
    test_input_string "asm"
    jne LA55
    call test_for_string_raw
    mov edi, 136
    jne terminate_program ; 136
    call copy_last_match
    call newline
    
LA55:
    
LA56:
    jne LA57
    
LA57:
    je LA12
    test_input_string "reserve"
    jne LA58
    call test_for_number
    mov edi, 138
    jne terminate_program ; 138
    call label
    print "section .bss"
    call newline
    call gn3
    print " resb "
    call copy_last_match
    call newline
    call label
    print "section .text"
    call newline
    print "mov eax, "
    call gn3
    call newline
    
LA58:
    
LA59:
    jne LA60
    
LA60:
    je LA12
    test_input_string "define"
    jne LA61
    test_input_string "["
    jne LA62
    print "jmp "
    call gn1
    call newline
    call test_for_id
    mov edi, 142
    jne terminate_program ; 142
    call label
    call copy_last_match
    print ":"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    mov edi, 145
    jne terminate_program ; 145
    call vstack_clear
    call DEF_FN_ARGS
    call vstack_restore
    mov edi, 146
    jne terminate_program ; 146
    test_input_string "]"
    mov edi, 147
    jne terminate_program ; 147
    mov edi, 148
    jne terminate_program ; 148
    
LA63:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA64
    
LA64:
    
LA65:
    je LA63
    call set_true
    mov edi, 149
    jne terminate_program ; 149
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
    push eax
    mov eax, dword [VAR_IN_BODY]
    push eax
    mov ebx, 4
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
    mov edi, 152
    jne terminate_program ; 152
    pushfd
    push eax
    mov eax, 0
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 153
    jne terminate_program ; 153
    
LA62:
    
LA66:
    jne LA67
    mov edi, 154
    jne terminate_program ; 154
    
LA67:
    je LA68
    call test_for_id
    jne LA69
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 155
    jne terminate_program ; 155
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
    mov edi, 156
    jne terminate_program ; 156
    pushfd
    push eax
    mov edi, LOCALS
    mov esi, last_match
    mov edx, dword [STO]
    call hash_set
    pop eax
    popfd
    mov edi, 157
    jne terminate_program ; 157
    pushfd
    push eax
    mov eax, dword [STO]
    mov dword [DEFER], eax
    pop eax
    popfd
    mov edi, 158
    jne terminate_program ; 158
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
    mov edi, 159
    jne terminate_program ; 159
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 160
    jne terminate_program ; 160
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
    
LA69:
    
LA68:
    mov edi, 162
    jne terminate_program ; 162
    
LA61:
    
LA70:
    jne LA71
    
LA71:
    je LA12
    call test_for_id
    jne LA72
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 163
    jne terminate_program ; 163
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    mov edi, 164
    jne terminate_program ; 164
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA72:
    
LA73:
    jne LA74
    
LA74:
    
LA12:
    ret
    
DEF_FN_ARGS:
    
LA75:
    call vstack_clear
    call DEF_FN_ARG
    call vstack_restore
    jne LA76
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
    
LA77:
    call vstack_clear
    call DEF_FN_ARG
    call vstack_restore
    jne LA78
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
    
LA79:
    call vstack_clear
    call DEF_FN_ARG
    call vstack_restore
    jne LA80
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
    
LA81:
    call vstack_clear
    call DEF_FN_ARG
    call vstack_restore
    jne LA82
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
    
LA82:
    
LA83:
    je LA81
    call set_true
    mov edi, 170
    jne terminate_program ; 170
    
LA80:
    
LA84:
    je LA79
    call set_true
    mov edi, 171
    jne terminate_program ; 171
    
LA78:
    
LA85:
    je LA77
    call set_true
    mov edi, 172
    jne terminate_program ; 172
    
LA76:
    
LA86:
    je LA75
    call set_true
    jne LA87
    
LA87:
    
LA88:
    ret
    
DEF_FN_ARG:
    test_input_string "*"
    jne LA89
    call test_for_id
    mov edi, 173
    jne terminate_program ; 173
    
LA89:
    je LA90
    call test_for_id
    jne LA91
    
LA91:
    
LA90:
    jne LA92
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
    mov edi, 174
    jne terminate_program ; 174
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
    mov edi, 175
    jne terminate_program ; 175
    
LA92:
    
LA93:
    ret
    
FN_CALL_ARG:
    
LA94:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA95
    print "mov edi, eax"
    call newline
    
LA95:
    
LA96:
    jne LA97
    
LA97:
    je LA98
    call test_for_number
    jne LA99
    print "mov edi, "
    call copy_last_match
    call newline
    
LA99:
    
LA100:
    jne LA101
    
LA101:
    je LA98
    call test_for_id
    jne LA102
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA103
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
    
LA103:
    je LA104
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
    
LA105:
    
LA104:
    mov edi, 180
    jne terminate_program ; 180
    
LA102:
    
LA106:
    jne LA107
    
LA107:
    je LA98
    test_input_string "*"
    jne LA108
    call test_for_id
    mov edi, 181
    jne terminate_program ; 181
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA109
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
    
LA109:
    je LA110
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
    
LA111:
    
LA110:
    mov edi, 184
    jne terminate_program ; 184
    
LA108:
    
LA112:
    jne LA113
    
LA113:
    je LA98
    call test_for_string
    jne LA114
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
    
LA114:
    
LA115:
    jne LA116
    
LA116:
    
LA98:
    jne LA117
    
LA118:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA119
    print "mov esi, eax"
    call newline
    
LA119:
    
LA120:
    jne LA121
    
LA121:
    je LA122
    call test_for_number
    jne LA123
    print "mov esi, "
    call copy_last_match
    call newline
    
LA123:
    
LA124:
    jne LA125
    
LA125:
    je LA122
    call test_for_id
    jne LA126
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA127
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
    
LA127:
    je LA128
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
    
LA129:
    
LA128:
    mov edi, 191
    jne terminate_program ; 191
    
LA126:
    
LA130:
    jne LA131
    
LA131:
    je LA122
    test_input_string "*"
    jne LA132
    call test_for_id
    mov edi, 192
    jne terminate_program ; 192
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA133
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
    
LA133:
    je LA134
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
    
LA135:
    
LA134:
    mov edi, 195
    jne terminate_program ; 195
    
LA132:
    
LA136:
    jne LA137
    
LA137:
    je LA122
    call test_for_string
    jne LA138
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
    
LA138:
    
LA139:
    jne LA140
    
LA140:
    
LA122:
    jne LA141
    
LA142:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA143
    print "mov edx, eax"
    call newline
    
LA143:
    
LA144:
    jne LA145
    
LA145:
    je LA146
    call test_for_number
    jne LA147
    print "mov edx, "
    call copy_last_match
    call newline
    
LA147:
    
LA148:
    jne LA149
    
LA149:
    je LA146
    call test_for_id
    jne LA150
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA151
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
    
LA151:
    je LA152
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
    
LA153:
    
LA152:
    mov edi, 202
    jne terminate_program ; 202
    
LA150:
    
LA154:
    jne LA155
    
LA155:
    je LA146
    test_input_string "*"
    jne LA156
    call test_for_id
    mov edi, 203
    jne terminate_program ; 203
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA157
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
    
LA157:
    je LA158
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
    
LA159:
    
LA158:
    mov edi, 206
    jne terminate_program ; 206
    
LA156:
    
LA160:
    jne LA161
    
LA161:
    je LA146
    call test_for_string
    jne LA162
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
    
LA162:
    
LA163:
    jne LA164
    
LA164:
    
LA146:
    jne LA165
    
LA165:
    
LA166:
    je LA142
    call set_true
    mov edi, 209
    jne terminate_program ; 209
    
LA141:
    
LA167:
    je LA118
    call set_true
    mov edi, 210
    jne terminate_program ; 210
    
LA117:
    
LA168:
    je LA94
    call set_true
    jne LA169
    
LA169:
    
LA170:
    ret
    
BRACKET_ARG:
    test_input_string "&1"
    jne LA171
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    mov edi, 211
    jne terminate_program ; 211
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
    
LA171:
    
LA172:
    jne LA173
    
LA173:
    je LA174
    test_input_string "&2"
    jne LA175
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    mov edi, 217
    jne terminate_program ; 217
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
    
LA175:
    
LA176:
    jne LA177
    
LA177:
    je LA174
    test_input_string "&"
    jne LA178
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    mov edi, 223
    jne terminate_program ; 223
    print "mov eax, dword [eax]"
    call newline
    
LA178:
    
LA179:
    jne LA180
    
LA180:
    je LA174
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA181
    
LA181:
    je LA174
    call test_for_number
    jne LA182
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA183
    print "mov eax, "
    call copy_last_match
    call newline
    
LA183:
    je LA184
    print "mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA185:
    
LA184:
    mov edi, 227
    jne terminate_program ; 227
    
LA182:
    
LA186:
    jne LA187
    
LA187:
    je LA174
    call test_for_id
    jne LA188
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA189
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA190
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
    
LA190:
    je LA191
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
    
LA192:
    
LA191:
    mov edi, 230
    jne terminate_program ; 230
    
LA189:
    je LA193
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA194
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
    
LA194:
    je LA195
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
    
LA196:
    
LA195:
    jne LA197
    
LA197:
    
LA193:
    mov edi, 233
    jne terminate_program ; 233
    
LA188:
    
LA198:
    jne LA199
    
LA199:
    je LA174
    call test_for_string
    jne LA200
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
    jne LA201
    print "mov eax, "
    call gn3
    call newline
    
LA201:
    je LA202
    print "mov ebx, "
    call gn3
    call newline
    call set_true
    
LA203:
    
LA202:
    mov edi, 237
    jne terminate_program ; 237
    
LA200:
    
LA204:
    jne LA205
    
LA205:
    je LA174
    call vstack_clear
    call DATA_TYPES
    call vstack_restore
    jne LA206
    
LA206:
    
LA174:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA207
    match_not 10
    mov edi, 238
    jne terminate_program ; 238
    
LA207:
    
LA208:
    ret
    
DATA_TYPES:
    call vstack_clear
    call ARRAY
    call vstack_restore
    jne LA209
    
LA209:
    je LA210
    call vstack_clear
    call STRING
    call vstack_restore
    jne LA211
    
LA211:
    je LA210
    call vstack_clear
    call NUMBER
    call vstack_restore
    jne LA212
    
LA212:
    
LA210:
    ret
    
ARRAY:
    test_input_string "#["
    jne LA213
    call label
    print "section .data"
    call newline
    call gn3
    print " dd "
    
LA214:
    call test_for_number
    jne LA215
    call copy_last_match
    print ", "
    
LA215:
    
LA216:
    je LA214
    call set_true
    mov edi, 239
    jne terminate_program ; 239
    print "0x00"
    call newline
    call label
    print "section .text"
    call newline
    print "mov eax, "
    call gn3
    call newline
    test_input_string "]"
    mov edi, 242
    jne terminate_program ; 242
    
LA213:
    
LA217:
    ret
    
NUMBER:
    call test_for_number
    jne LA218
    print "mov eax, "
    call copy_last_match
    call newline
    
LA218:
    
LA219:
    ret
    
STRING:
    call test_for_string
    jne LA220
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
    
LA220:
    
LA221:
    ret
    
