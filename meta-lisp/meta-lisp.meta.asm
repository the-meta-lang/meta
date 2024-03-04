
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
    
section .data
    IS_FUNC dd 0
    
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
    test_input_string "="
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
    print "push eax"
    call newline
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 113
    jne terminate_program ; 113
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 114
    jne terminate_program ; 114
    print "push ebx"
    call newline
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "cmp eax, ebx"
    call newline
    print "je "
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
    
LA37:
    
LA38:
    jne LA39
    
LA39:
    je LA12
    test_input_string "return"
    jne LA40
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 123
    jne terminate_program ; 123
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 124
    jne terminate_program ; 124
    print "pop ebp"
    call newline
    print "ret"
    call newline
    
LA40:
    
LA41:
    jne LA42
    
LA42:
    je LA12
    test_input_string "set"
    jne LA43
    call test_for_id
    mov edi, 127
    jne terminate_program ; 127
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 128
    jne terminate_program ; 128
    pushfd
    push eax
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    mov dword [WAS_LOCAL], eax
    pop eax
    popfd
    mov edi, 129
    jne terminate_program ; 129
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov dword [DEFER], eax
    pop eax
    popfd
    mov edi, 130
    jne terminate_program ; 130
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 131
    jne terminate_program ; 131
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 132
    jne terminate_program ; 132
    mov eax, dword [WAS_LOCAL]
    cmp eax, 0
    jne LA44
    print "mov dword ["
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print "], eax"
    call newline
    
LA44:
    je LA45
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
    
LA46:
    
LA45:
    mov edi, 135
    jne terminate_program ; 135
    
LA43:
    
LA47:
    jne LA48
    
LA48:
    je LA12
    test_input_string "if/else"
    jne LA49
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 136
    jne terminate_program ; 136
    print "cmp eax, 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call BODY
    call vstack_restore
    mov edi, 139
    jne terminate_program ; 139
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call BODY
    call vstack_restore
    mov edi, 141
    jne terminate_program ; 141
    call label
    call gn2
    print ":"
    call newline
    
LA49:
    
LA50:
    jne LA51
    
LA51:
    je LA12
    test_input_string "if"
    jne LA52
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 142
    jne terminate_program ; 142
    print "cmp eax, 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call BODY
    call vstack_restore
    mov edi, 145
    jne terminate_program ; 145
    call label
    call gn1
    print ":"
    call newline
    
LA52:
    
LA53:
    jne LA54
    
LA54:
    je LA12
    test_input_string "while"
    jne LA55
    test_input_string "["
    mov edi, 146
    jne terminate_program ; 146
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov edi, 147
    jne terminate_program ; 147
    print "cmp eax, 0 ; while"
    call newline
    print "je "
    call gn2
    call newline
    test_input_string "]"
    mov edi, 150
    jne terminate_program ; 150
    call vstack_clear
    call BODY
    call vstack_restore
    mov edi, 151
    jne terminate_program ; 151
    print "jmp "
    call gn1
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA55:
    
LA56:
    jne LA57
    
LA57:
    je LA12
    test_input_string "asm/mov"
    jne LA58
    call test_for_id
    mov edi, 153
    jne terminate_program ; 153
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 154
    jne terminate_program ; 154
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 155
    jne terminate_program ; 155
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 156
    jne terminate_program ; 156
    print "mov "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print ", eax ; asm/mov"
    call newline
    
LA58:
    
LA59:
    jne LA60
    
LA60:
    je LA12
    test_input_string "asm"
    jne LA61
    call test_for_string_raw
    mov edi, 158
    jne terminate_program ; 158
    call copy_last_match
    call newline
    
LA61:
    
LA62:
    jne LA63
    
LA63:
    je LA12
    test_input_string "reserve"
    jne LA64
    call test_for_id
    mov edi, 160
    jne terminate_program ; 160
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 161
    jne terminate_program ; 161
    call test_for_number
    mov edi, 162
    jne terminate_program ; 162
    call label
    print "section .bss"
    call newline
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print " resb "
    call copy_last_match
    call newline
    call label
    print "section .text"
    call newline
    
LA64:
    
LA65:
    jne LA66
    
LA66:
    je LA12
    test_input_string "define"
    jne LA67
    test_input_string "["
    jne LA68
    print "jmp "
    call gn1
    call newline
    call test_for_id
    mov edi, 165
    jne terminate_program ; 165
    call label
    call copy_last_match
    print ":"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    mov edi, 168
    jne terminate_program ; 168
    call vstack_clear
    call DEF_FN_ARGS
    call vstack_restore
    mov edi, 169
    jne terminate_program ; 169
    test_input_string "]"
    mov edi, 170
    jne terminate_program ; 170
    pushfd
    push eax
    mov eax, 1
    mov dword [IS_FUNC], eax
    pop eax
    popfd
    mov edi, 171
    jne terminate_program ; 171
    mov edi, 172
    jne terminate_program ; 172
    
LA69:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA70
    
LA70:
    je LA71
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA72
    
LA72:
    
LA71:
    je LA69
    call set_true
    mov edi, 173
    jne terminate_program ; 173
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
    mov edi, 176
    jne terminate_program ; 176
    pushfd
    push eax
    mov eax, 0
    mov dword [VAR_IN_BODY], eax
    pop eax
    popfd
    mov edi, 177
    jne terminate_program ; 177
    pushfd
    push eax
    mov eax, 0
    mov dword [IS_FUNC], eax
    pop eax
    popfd
    mov edi, 178
    jne terminate_program ; 178
    
LA68:
    
LA73:
    jne LA74
    mov edi, 179
    jne terminate_program ; 179
    
LA74:
    je LA75
    call test_for_id
    jne LA76
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 180
    jne terminate_program ; 180
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 181
    jne terminate_program ; 181
    mov eax, dword [IS_FUNC]
    cmp eax, 0
    jne LA77
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 182
    jne terminate_program ; 182
    call label
    print "section .data"
    call newline
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print " dd 0x00"
    call newline
    call label
    print "section .text"
    call newline
    print "mov ["
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print "], eax"
    call newline
    
LA77:
    je LA78
    call set_true
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
    mov edi, 185
    jne terminate_program ; 185
    pushfd
    push eax
    mov edi, LOCALS
    mov esi, last_match
    mov edx, dword [STO]
    call hash_set
    pop eax
    popfd
    mov edi, 186
    jne terminate_program ; 186
    pushfd
    push eax
    mov eax, dword [STO]
    mov dword [DEFER], eax
    pop eax
    popfd
    mov edi, 187
    jne terminate_program ; 187
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
    mov edi, 188
    jne terminate_program ; 188
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    pop eax
    popfd
    mov edi, 189
    jne terminate_program ; 189
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov edi, 190
    jne terminate_program ; 190
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
    
LA79:
    
LA78:
    mov edi, 192
    jne terminate_program ; 192
    
LA76:
    
LA75:
    mov edi, 193
    jne terminate_program ; 193
    
LA67:
    
LA80:
    jne LA81
    
LA81:
    je LA12
    call test_for_id
    jne LA82
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 194
    jne terminate_program ; 194
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    mov edi, 195
    jne terminate_program ; 195
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA82:
    
LA83:
    jne LA84
    
LA84:
    
LA12:
    ret
    
BODY:
    
LA85:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA86
    
LA86:
    je LA87
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA88
    
LA88:
    
LA87:
    je LA85
    call set_true
    jne LA89
    
LA89:
    
LA90:
    ret
    
DEF_FN_ARGS:
    
LA91:
    call vstack_clear
    call DEF_FN_ARG
    call vstack_restore
    jne LA92
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
    
LA93:
    call vstack_clear
    call DEF_FN_ARG
    call vstack_restore
    jne LA94
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
    
LA95:
    call vstack_clear
    call DEF_FN_ARG
    call vstack_restore
    jne LA96
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
    
LA97:
    call vstack_clear
    call DEF_FN_ARG
    call vstack_restore
    jne LA98
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
    
LA98:
    
LA99:
    je LA97
    call set_true
    mov edi, 201
    jne terminate_program ; 201
    
LA96:
    
LA100:
    je LA95
    call set_true
    mov edi, 202
    jne terminate_program ; 202
    
LA94:
    
LA101:
    je LA93
    call set_true
    mov edi, 203
    jne terminate_program ; 203
    
LA92:
    
LA102:
    je LA91
    call set_true
    jne LA103
    
LA103:
    
LA104:
    ret
    
DEF_FN_ARG:
    test_input_string "*"
    jne LA105
    call test_for_id
    mov edi, 204
    jne terminate_program ; 204
    
LA105:
    je LA106
    call test_for_id
    jne LA107
    
LA107:
    
LA106:
    jne LA108
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
    mov edi, 205
    jne terminate_program ; 205
    pushfd
    push eax
    mov edi, LOCALS
    mov esi, last_match
    mov edx, dword [STO]
    call hash_set
    pop eax
    popfd
    mov edi, 206
    jne terminate_program ; 206
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
    mov edi, 207
    jne terminate_program ; 207
    
LA108:
    
LA109:
    ret
    
FN_CALL_ARG:
    
LA110:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA111
    print "mov edi, eax"
    call newline
    
LA111:
    
LA112:
    jne LA113
    
LA113:
    je LA114
    call test_for_number
    jne LA115
    print "mov edi, "
    call copy_last_match
    call newline
    
LA115:
    
LA116:
    jne LA117
    
LA117:
    je LA114
    call test_for_id
    jne LA118
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA119
    print "mov edi, dword ["
    call copy_last_match
    print "] ; use "
    call copy_last_match
    call newline
    
LA119:
    je LA120
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
    
LA121:
    
LA120:
    mov edi, 212
    jne terminate_program ; 212
    
LA118:
    
LA122:
    jne LA123
    
LA123:
    je LA114
    test_input_string "*"
    jne LA124
    call test_for_id
    mov edi, 213
    jne terminate_program ; 213
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA125
    print "mov edi, dword ["
    call copy_last_match
    print "] ; use "
    call copy_last_match
    call newline
    
LA125:
    je LA126
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
    
LA127:
    
LA126:
    mov edi, 216
    jne terminate_program ; 216
    
LA124:
    
LA128:
    jne LA129
    
LA129:
    je LA114
    call test_for_string
    jne LA130
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
    
LA130:
    
LA131:
    jne LA132
    
LA132:
    je LA114
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    jne LA133
    print "mov edi, eax"
    call newline
    
LA133:
    
LA114:
    jne LA134
    
LA135:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA136
    print "mov esi, eax"
    call newline
    
LA136:
    
LA137:
    jne LA138
    
LA138:
    je LA139
    call test_for_number
    jne LA140
    print "mov esi, "
    call copy_last_match
    call newline
    
LA140:
    
LA141:
    jne LA142
    
LA142:
    je LA139
    call test_for_id
    jne LA143
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA144
    print "mov esi, dword ["
    call copy_last_match
    print "] ; use "
    call copy_last_match
    call newline
    
LA144:
    je LA145
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
    
LA146:
    
LA145:
    mov edi, 224
    jne terminate_program ; 224
    
LA143:
    
LA147:
    jne LA148
    
LA148:
    je LA139
    test_input_string "*"
    jne LA149
    call test_for_id
    mov edi, 225
    jne terminate_program ; 225
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA150
    print "mov esi, dword ["
    call copy_last_match
    print "] ; use "
    call copy_last_match
    call newline
    
LA150:
    je LA151
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
    
LA152:
    
LA151:
    mov edi, 228
    jne terminate_program ; 228
    
LA149:
    
LA153:
    jne LA154
    
LA154:
    je LA139
    call test_for_string
    jne LA155
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
    
LA155:
    
LA156:
    jne LA157
    
LA157:
    je LA139
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    jne LA158
    print "mov esi, eax"
    call newline
    
LA158:
    
LA139:
    jne LA159
    
LA160:
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA161
    print "mov edx, eax"
    call newline
    
LA161:
    
LA162:
    jne LA163
    
LA163:
    je LA164
    call test_for_number
    jne LA165
    print "mov edx, "
    call copy_last_match
    call newline
    
LA165:
    
LA166:
    jne LA167
    
LA167:
    je LA164
    call test_for_id
    jne LA168
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA169
    print "mov edx, dword ["
    call copy_last_match
    print "] ; use "
    call copy_last_match
    call newline
    
LA169:
    je LA170
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
    
LA171:
    
LA170:
    mov edi, 236
    jne terminate_program ; 236
    
LA168:
    
LA172:
    jne LA173
    
LA173:
    je LA164
    test_input_string "*"
    jne LA174
    call test_for_id
    mov edi, 237
    jne terminate_program ; 237
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA175
    print "mov edx, dword ["
    call copy_last_match
    print "] ; use "
    call copy_last_match
    call newline
    
LA175:
    je LA176
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
    
LA177:
    
LA176:
    mov edi, 240
    jne terminate_program ; 240
    
LA174:
    
LA178:
    jne LA179
    
LA179:
    je LA164
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
    
LA181:
    jne LA182
    
LA182:
    je LA164
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    jne LA183
    print "mov edx, eax"
    call newline
    
LA183:
    
LA164:
    jne LA184
    
LA184:
    
LA185:
    je LA160
    call set_true
    mov edi, 244
    jne terminate_program ; 244
    
LA159:
    
LA186:
    je LA135
    call set_true
    mov edi, 245
    jne terminate_program ; 245
    
LA134:
    
LA187:
    je LA110
    call set_true
    jne LA188
    
LA188:
    
LA189:
    ret
    
BRACKET_ARG:
    test_input_string "&1"
    jne LA190
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    mov edi, 246
    jne terminate_program ; 246
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
    
LA190:
    
LA191:
    jne LA192
    
LA192:
    je LA193
    test_input_string "&2"
    jne LA194
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    mov edi, 252
    jne terminate_program ; 252
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
    
LA194:
    
LA195:
    jne LA196
    
LA196:
    je LA193
    test_input_string "&"
    jne LA197
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    mov edi, 258
    jne terminate_program ; 258
    print "mov eax, dword [eax]"
    call newline
    
LA197:
    
LA198:
    jne LA199
    
LA199:
    je LA193
    call vstack_clear
    call BRACKET_EXPR_WRAPPER
    call vstack_restore
    jne LA200
    
LA200:
    je LA193
    call test_for_number
    jne LA201
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA202
    print "mov eax, "
    call copy_last_match
    call newline
    
LA202:
    je LA203
    print "mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA204:
    
LA203:
    mov edi, 262
    jne terminate_program ; 262
    
LA201:
    
LA205:
    jne LA206
    
LA206:
    je LA193
    call test_for_id
    jne LA207
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA208
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA209
    print "mov eax, dword ["
    call copy_last_match
    print "] ; use "
    call copy_last_match
    call newline
    
LA209:
    je LA210
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
    
LA211:
    
LA210:
    mov edi, 265
    jne terminate_program ; 265
    
LA208:
    je LA212
    mov edi, LOCALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA213
    print "mov ebx, dword ["
    call copy_last_match
    print "] ; use "
    call copy_last_match
    call newline
    
LA213:
    je LA214
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
    
LA215:
    
LA214:
    jne LA216
    
LA216:
    
LA212:
    mov edi, 268
    jne terminate_program ; 268
    
LA207:
    
LA217:
    jne LA218
    
LA218:
    je LA193
    call test_for_string
    jne LA219
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
    jne LA220
    print "mov eax, "
    call gn3
    call newline
    
LA220:
    je LA221
    print "mov ebx, "
    call gn3
    call newline
    call set_true
    
LA222:
    
LA221:
    mov edi, 272
    jne terminate_program ; 272
    
LA219:
    
LA223:
    jne LA224
    
LA224:
    je LA193
    call vstack_clear
    call DATA_TYPES
    call vstack_restore
    jne LA225
    
LA225:
    
LA193:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA226
    match_not 10
    mov edi, 273
    jne terminate_program ; 273
    
LA226:
    
LA227:
    ret
    
DATA_TYPES:
    call vstack_clear
    call ARRAY
    call vstack_restore
    jne LA228
    
LA228:
    je LA229
    call vstack_clear
    call STRING
    call vstack_restore
    jne LA230
    
LA230:
    je LA229
    call vstack_clear
    call NUMBER
    call vstack_restore
    jne LA231
    
LA231:
    
LA229:
    ret
    
ARRAY:
    test_input_string "#["
    jne LA232
    call label
    print "section .data"
    call newline
    call gn3
    print " dd "
    
LA233:
    call test_for_number
    jne LA234
    call copy_last_match
    print ", "
    
LA234:
    
LA235:
    je LA233
    call set_true
    mov edi, 274
    jne terminate_program ; 274
    print "0x00"
    call newline
    call label
    print "section .text"
    call newline
    print "mov eax, "
    call gn3
    call newline
    test_input_string "]"
    mov edi, 277
    jne terminate_program ; 277
    
LA232:
    
LA236:
    ret
    
NUMBER:
    call test_for_number
    jne LA237
    print "mov eax, "
    call copy_last_match
    call newline
    
LA237:
    
LA238:
    ret
    
STRING:
    call test_for_string
    jne LA239
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
    
LA239:
    
LA240:
    ret
    
