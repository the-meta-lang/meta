
%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .data
    ST times 65536 dd 0x00
    STO dd 12
    VAR_IN_BODY dd 0
    AEXP_SEC_NUM dd 0
    
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
    call LET_EXPRESSION
    call vstack_restore
    jne LA2
    test_input_string ";"
    mov esi, 3
    jne terminate_program ; 3
    
LA2:
    je LA3
    call vstack_clear
    call FN_EXPRESSION
    call vstack_restore
    jne LA4
    
LA4:
    je LA3
    call vstack_clear
    call FN_CALL
    call vstack_restore
    jne LA5
    test_input_string ";"
    mov esi, 4
    jne terminate_program ; 4
    
LA5:
    je LA3
    call vstack_clear
    call IF_STATEMENT
    call vstack_restore
    jne LA6
    
LA6:
    je LA3
    call vstack_clear
    call WHILE_STATEMENT
    call vstack_restore
    jne LA7
    
LA7:
    
LA3:
    je LA1
    call set_true
    mov esi, 5
    jne terminate_program ; 5
    print "pop ebp"
    call newline
    print "mov eax, 4"
    call newline
    print "mov ebx, 0"
    call newline
    print "int 0x80"
    call newline
    
LA8:
    
LA9:
    ret
    
FN_EXPRESSION:
    test_input_string "fn"
    jne LA10
    print "jmp "
    call gn1
    call newline
    call test_for_id
    mov esi, 11
    jne terminate_program ; 11
    call label
    call copy_last_match
    print ":"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    test_input_string "("
    mov esi, 14
    jne terminate_program ; 14
    
LA11:
    call test_for_id
    jne LA12
    pushfd
    push eax
    push last_match
    push dword [STO]
    push 4
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [STO], eax
    push eax
    mov edi, ST
    pop edx
    pop esi
    call hash_set
    push edx
    pop edi
    pop eax
    popfd
    mov esi, 15
    jne terminate_program ; 15
    pushfd
    push eax
    push dword [VAR_IN_BODY]
    push 1
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [VAR_IN_BODY], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 16
    jne terminate_program ; 16
    print "mov dword [ebp+"
    pushfd
    push eax
    push dword [STO]
    pop edi
    pop eax
    popfd
    print_int edi
    print "], edi"
    call newline
    
LA12:
    
LA13:
    je LA11
    call set_true
    mov esi, 18
    jne terminate_program ; 18
    
LA14:
    test_input_string ","
    jne LA15
    call test_for_id
    mov esi, 19
    jne terminate_program ; 19
    pushfd
    push eax
    push last_match
    push dword [STO]
    push 4
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [STO], eax
    push eax
    mov edi, ST
    pop edx
    pop esi
    call hash_set
    push edx
    pop edi
    pop eax
    popfd
    mov esi, 20
    jne terminate_program ; 20
    pushfd
    push eax
    push dword [VAR_IN_BODY]
    push 1
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [VAR_IN_BODY], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 21
    jne terminate_program ; 21
    print "mov dword [ebp+"
    pushfd
    push eax
    push dword [STO]
    pop edi
    pop eax
    popfd
    print_int edi
    print "], esi"
    call newline
    
LA15:
    
LA16:
    jne LA17
    
LA18:
    test_input_string ","
    jne LA19
    call test_for_id
    mov esi, 23
    jne terminate_program ; 23
    pushfd
    push eax
    push last_match
    push dword [STO]
    push 4
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [STO], eax
    push eax
    mov edi, ST
    pop edx
    pop esi
    call hash_set
    push edx
    pop edi
    pop eax
    popfd
    mov esi, 24
    jne terminate_program ; 24
    pushfd
    push eax
    push dword [VAR_IN_BODY]
    push 1
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [VAR_IN_BODY], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 25
    jne terminate_program ; 25
    print "mov dword [ebp+"
    pushfd
    push eax
    push dword [STO]
    pop edi
    pop eax
    popfd
    print_int edi
    print "], edx"
    call newline
    
LA20:
    test_input_string ","
    jne LA21
    call test_for_id
    mov esi, 27
    jne terminate_program ; 27
    pushfd
    push eax
    push last_match
    push dword [STO]
    push 4
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [STO], eax
    push eax
    mov edi, ST
    pop edx
    pop esi
    call hash_set
    push edx
    pop edi
    pop eax
    popfd
    mov esi, 28
    jne terminate_program ; 28
    pushfd
    push eax
    push dword [VAR_IN_BODY]
    push 1
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [VAR_IN_BODY], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 29
    jne terminate_program ; 29
    print "mov dword [ebp+"
    pushfd
    push eax
    push dword [STO]
    pop edi
    pop eax
    popfd
    print_int edi
    print "], ecx"
    call newline
    
LA22:
    test_input_string ","
    jne LA23
    call test_for_id
    mov esi, 31
    jne terminate_program ; 31
    pushfd
    push eax
    push last_match
    push dword [STO]
    push 4
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [STO], eax
    push eax
    mov edi, ST
    pop edx
    pop esi
    call hash_set
    push edx
    pop edi
    pop eax
    popfd
    mov esi, 32
    jne terminate_program ; 32
    pushfd
    push eax
    push dword [VAR_IN_BODY]
    push 1
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [VAR_IN_BODY], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 33
    jne terminate_program ; 33
    
LA23:
    
LA24:
    je LA22
    call set_true
    mov esi, 34
    jne terminate_program ; 34
    
LA21:
    
LA25:
    je LA20
    call set_true
    mov esi, 35
    jne terminate_program ; 35
    
LA19:
    
LA26:
    je LA18
    call set_true
    mov esi, 36
    jne terminate_program ; 36
    
LA17:
    
LA27:
    je LA14
    call set_true
    mov esi, 37
    jne terminate_program ; 37
    test_input_string ")"
    mov esi, 38
    jne terminate_program ; 38
    test_input_string "{"
    mov esi, 39
    jne terminate_program ; 39
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 40
    jne terminate_program ; 40
    test_input_string "}"
    mov esi, 41
    jne terminate_program ; 41
    pushfd
    push eax
    push dword [STO]
    push dword [VAR_IN_BODY]
    push 4
    pop eax
    pop ebx
    mul ebx
    push eax
    pop ebx
    pop eax
    sub eax, ebx
    push eax
    pop eax
    mov [STO], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 42
    jne terminate_program ; 42
    print "pop ebp"
    call newline
    print "ret"
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA10:
    
LA28:
    ret
    
BODY:
    
LA29:
    call vstack_clear
    call RETURN_EXPRESSION
    call vstack_restore
    jne LA30
    test_input_string ";"
    mov esi, 45
    jne terminate_program ; 45
    
LA30:
    je LA31
    call vstack_clear
    call IF_STATEMENT
    call vstack_restore
    jne LA32
    
LA32:
    je LA31
    call vstack_clear
    call WHILE_STATEMENT
    call vstack_restore
    jne LA33
    
LA33:
    je LA31
    call vstack_clear
    call LET_EXPRESSION
    call vstack_restore
    jne LA34
    test_input_string ";"
    mov esi, 46
    jne terminate_program ; 46
    
LA34:
    je LA31
    call vstack_clear
    call FN_CALL
    call vstack_restore
    jne LA35
    test_input_string ";"
    mov esi, 47
    jne terminate_program ; 47
    
LA35:
    je LA31
    call vstack_clear
    call FN_EXPRESSION
    call vstack_restore
    jne LA36
    
LA36:
    
LA31:
    je LA29
    call set_true
    jne LA37
    
LA37:
    
LA38:
    ret
    
FN_CALL:
    call test_for_id
    jne LA39
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 48
    jne terminate_program ; 48
    test_input_string "("
    mov esi, 49
    jne terminate_program ; 49
    call vstack_clear
    call FN_CALL_ARGUMENTS
    call vstack_restore
    mov esi, 50
    jne terminate_program ; 50
    test_input_string ")"
    mov esi, 51
    jne terminate_program ; 51
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA39:
    
LA40:
    ret
    
FN_CALL_ARGUMENTS:
    
LA41:
    call test_for_number
    jne LA42
    print "mov edi, "
    call copy_last_match
    call newline
    
LA42:
    
LA43:
    je LA41
    call set_true
    jne LA44
    
LA45:
    test_input_string ","
    jne LA46
    call test_for_number
    jne LA47
    print "mov esi, "
    call copy_last_match
    call newline
    
LA47:
    je LA48
    call test_for_id
    jne LA49
    print "mov esi, ["
    call copy_last_match
    print "]"
    call newline
    
LA49:
    je LA48
    test_input_string "*"
    jne LA50
    call test_for_id
    mov esi, 56
    jne terminate_program ; 56
    print "mov esi, "
    call copy_last_match
    call newline
    
LA50:
    je LA48
    call test_for_string
    jne LA51
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
    
LA51:
    
LA48:
    mov esi, 60
    jne terminate_program ; 60
    
LA52:
    test_input_string ","
    jne LA53
    call test_for_number
    jne LA54
    print "mov edx, "
    call copy_last_match
    call newline
    
LA54:
    je LA55
    call test_for_id
    jne LA56
    print "mov edx, ["
    call copy_last_match
    print "]"
    call newline
    
LA56:
    je LA55
    test_input_string "*"
    jne LA57
    call test_for_id
    mov esi, 63
    jne terminate_program ; 63
    print "mov edx, "
    call copy_last_match
    call newline
    
LA57:
    je LA55
    call test_for_string
    jne LA58
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
    
LA58:
    
LA55:
    mov esi, 67
    jne terminate_program ; 67
    
LA59:
    test_input_string ","
    jne LA60
    call test_for_number
    jne LA61
    print "mov ecx, "
    call copy_last_match
    call newline
    
LA61:
    je LA62
    call test_for_id
    jne LA63
    print "mov ecx, ["
    call copy_last_match
    print "]"
    call newline
    
LA63:
    je LA62
    test_input_string "*"
    jne LA64
    call test_for_id
    mov esi, 70
    jne terminate_program ; 70
    print "mov ecx, "
    call copy_last_match
    call newline
    
LA64:
    je LA62
    call test_for_string
    jne LA65
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
    
LA65:
    
LA62:
    mov esi, 74
    jne terminate_program ; 74
    
LA66:
    test_input_string ","
    jne LA67
    call test_for_number
    jne LA68
    print "push "
    call copy_last_match
    call newline
    
LA68:
    je LA69
    call test_for_id
    jne LA70
    print "push ["
    call copy_last_match
    print "]"
    call newline
    
LA70:
    je LA69
    test_input_string "*"
    jne LA71
    print "push "
    call copy_last_match
    call newline
    
LA71:
    je LA69
    call test_for_string
    jne LA72
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
    
LA72:
    
LA69:
    mov esi, 80
    jne terminate_program ; 80
    
LA67:
    
LA73:
    je LA66
    call set_true
    mov esi, 81
    jne terminate_program ; 81
    
LA60:
    
LA74:
    je LA59
    call set_true
    mov esi, 82
    jne terminate_program ; 82
    
LA53:
    
LA75:
    je LA52
    call set_true
    mov esi, 83
    jne terminate_program ; 83
    
LA46:
    
LA76:
    je LA45
    call set_true
    mov esi, 84
    jne terminate_program ; 84
    
LA44:
    
LA77:
    ret
    
AEXP:
    call vstack_clear
    call EX1
    call vstack_restore
    jne LA78
    
LA79:
    test_input_string "="
    jne LA80
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 85
    jne terminate_program ; 85
    print "pop eax"
    call newline
    print "mov dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LA80:
    
LA81:
    jne LA82
    mov esi, 89
    jne terminate_program ; 89
    mov esi, 90
    jne terminate_program ; 90
    mov esi, 91
    jne terminate_program ; 91
    
LA82:
    je LA83
    test_input_string "+="
    jne LA84
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 92
    jne terminate_program ; 92
    print "pop eax"
    call newline
    print "add dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LA84:
    
LA85:
    jne LA86
    
LA86:
    je LA83
    test_input_string "-="
    jne LA87
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 96
    jne terminate_program ; 96
    print "pop eax"
    call newline
    print "sub dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LA87:
    
LA88:
    jne LA89
    mov esi, 100
    jne terminate_program ; 100
    
LA89:
    je LA83
    test_input_string "*="
    jne LA90
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 101
    jne terminate_program ; 101
    print "pop eax"
    call newline
    print "mul dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LA90:
    
LA91:
    jne LA92
    
LA92:
    je LA83
    test_input_string "/="
    jne LA93
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 105
    jne terminate_program ; 105
    print "pop eax"
    call newline
    print "idiv dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LA93:
    
LA94:
    jne LA95
    
LA95:
    je LA83
    test_input_string "%="
    jne LA96
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 109
    jne terminate_program ; 109
    print "pop eax"
    call newline
    print "idiv dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push edx"
    call newline
    
LA96:
    
LA97:
    jne LA98
    mov esi, 113
    jne terminate_program ; 113
    
LA98:
    je LA83
    test_input_string "<<="
    jne LA99
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 114
    jne terminate_program ; 114
    print "pop eax"
    call newline
    print "shl dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LA99:
    
LA100:
    jne LA101
    
LA101:
    je LA83
    test_input_string ">>="
    jne LA102
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 118
    jne terminate_program ; 118
    print "pop eax"
    call newline
    print "shr dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LA102:
    
LA103:
    jne LA104
    mov esi, 122
    jne terminate_program ; 122
    
LA104:
    je LA83
    test_input_string "&="
    jne LA105
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 123
    jne terminate_program ; 123
    print "pop eax"
    call newline
    print "and dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LA105:
    
LA106:
    jne LA107
    
LA107:
    je LA83
    test_input_string "^="
    jne LA108
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 127
    jne terminate_program ; 127
    print "pop eax"
    call newline
    print "xor dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LA108:
    
LA109:
    jne LA110
    
LA110:
    je LA83
    test_input_string "|="
    jne LA111
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 131
    jne terminate_program ; 131
    print "pop eax"
    call newline
    print "or dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LA111:
    
LA112:
    jne LA113
    
LA113:
    
LA83:
    je LA79
    call set_true
    mov esi, 135
    jne terminate_program ; 135
    
LA78:
    
LA114:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    jne LA115
    
LA116:
    test_input_string "?"
    jne LA117
    print "pop eax"
    call newline
    print "cmp eax, 0"
    call newline
    mov esi, 138
    jne terminate_program ; 138
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov esi, 140
    jne terminate_program ; 140
    mov esi, 141
    jne terminate_program ; 141
    print "jmp "
    call gn2
    call newline
    test_input_string ":"
    mov esi, 143
    jne terminate_program ; 143
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov esi, 144
    jne terminate_program ; 144
    call label
    call gn2
    print ":"
    call newline
    
LA117:
    
LA118:
    je LA116
    call set_true
    mov esi, 145
    jne terminate_program ; 145
    
LA115:
    
LA119:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA120
    
LA121:
    test_input_string "||"
    jne LA122
    call vstack_clear
    call EX3
    call vstack_restore
    mov esi, 146
    jne terminate_program ; 146
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "or eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA122:
    
LA123:
    je LA121
    call set_true
    mov esi, 151
    jne terminate_program ; 151
    
LA120:
    
LA124:
    ret
    
EX3:
    call vstack_clear
    call EX4
    call vstack_restore
    jne LA125
    
LA126:
    test_input_string "&&"
    jne LA127
    call vstack_clear
    call EX4
    call vstack_restore
    mov esi, 152
    jne terminate_program ; 152
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "and eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA127:
    
LA128:
    je LA126
    call set_true
    mov esi, 157
    jne terminate_program ; 157
    
LA125:
    
LA129:
    ret
    
EX4:
    call vstack_clear
    call EX5
    call vstack_restore
    jne LA130
    
LA131:
    test_input_string "|"
    jne LA132
    call vstack_clear
    call EX5
    call vstack_restore
    mov esi, 158
    jne terminate_program ; 158
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "or eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA132:
    
LA133:
    je LA131
    call set_true
    mov esi, 163
    jne terminate_program ; 163
    
LA130:
    
LA134:
    ret
    
EX5:
    call vstack_clear
    call EX6
    call vstack_restore
    jne LA135
    
LA136:
    test_input_string "^"
    jne LA137
    call vstack_clear
    call EX6
    call vstack_restore
    mov esi, 164
    jne terminate_program ; 164
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "xor eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA137:
    
LA138:
    je LA136
    call set_true
    mov esi, 169
    jne terminate_program ; 169
    
LA135:
    
LA139:
    ret
    
EX6:
    call vstack_clear
    call EX7
    call vstack_restore
    jne LA140
    
LA141:
    test_input_string "&"
    jne LA142
    call vstack_clear
    call EX7
    call vstack_restore
    mov esi, 170
    jne terminate_program ; 170
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "and eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA142:
    
LA143:
    je LA141
    call set_true
    mov esi, 175
    jne terminate_program ; 175
    
LA140:
    
LA144:
    ret
    
EX7:
    call vstack_clear
    call EX8
    call vstack_restore
    jne LA145
    
LA146:
    test_input_string "=="
    jne LA147
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 176
    jne terminate_program ; 176
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "cmp eax, ebx"
    call newline
    print "je "
    call gn1
    call newline
    print "push 0"
    call newline
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "push 1"
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA147:
    je LA148
    test_input_string "!="
    jne LA149
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 184
    jne terminate_program ; 184
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "cmp eax, ebx"
    call newline
    print "jne "
    call gn1
    call newline
    print "push 0"
    call newline
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "push 1"
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA149:
    
LA148:
    je LA146
    call set_true
    mov esi, 192
    jne terminate_program ; 192
    
LA145:
    
LA150:
    ret
    
EX8:
    call vstack_clear
    call EX9
    call vstack_restore
    jne LA151
    
LA152:
    test_input_string "<="
    jne LA153
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 193
    jne terminate_program ; 193
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "cmp eax, ebx"
    call newline
    print "jle "
    call gn1
    call newline
    print "push 0"
    call newline
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "push 1"
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA153:
    je LA154
    test_input_string ">="
    jne LA155
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 201
    jne terminate_program ; 201
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "cmp eax, ebx"
    call newline
    print "jge "
    call gn1
    call newline
    print "push 0"
    call newline
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "push 1"
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA155:
    je LA154
    test_input_string "<"
    jne LA156
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 209
    jne terminate_program ; 209
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "cmp eax, ebx"
    call newline
    print "jl "
    call gn1
    call newline
    print "push 0"
    call newline
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "push 1"
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA156:
    je LA154
    test_input_string ">"
    jne LA157
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 217
    jne terminate_program ; 217
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "cmp eax, ebx"
    call newline
    print "jg "
    call gn1
    call newline
    print "push 0"
    call newline
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "push 1"
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA157:
    
LA154:
    je LA152
    call set_true
    mov esi, 225
    jne terminate_program ; 225
    
LA151:
    
LA158:
    ret
    
EX9:
    call vstack_clear
    call EX10
    call vstack_restore
    jne LA159
    
LA160:
    test_input_string "<<"
    jne LA161
    call vstack_clear
    call EX10
    call vstack_restore
    mov esi, 226
    jne terminate_program ; 226
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "shl eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA161:
    je LA162
    test_input_string ">>"
    jne LA163
    call vstack_clear
    call EX10
    call vstack_restore
    mov esi, 231
    jne terminate_program ; 231
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "shr eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA163:
    
LA162:
    je LA160
    call set_true
    mov esi, 236
    jne terminate_program ; 236
    
LA159:
    
LA164:
    ret
    
EX10:
    call vstack_clear
    call EX11
    call vstack_restore
    jne LA165
    
LA166:
    test_input_string "+"
    jne LA167
    call vstack_clear
    call EX11
    call vstack_restore
    mov esi, 237
    jne terminate_program ; 237
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "add eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA167:
    je LA168
    test_input_string "-"
    jne LA169
    call vstack_clear
    call EX11
    call vstack_restore
    mov esi, 242
    jne terminate_program ; 242
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "sub eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA169:
    
LA168:
    je LA166
    call set_true
    mov esi, 247
    jne terminate_program ; 247
    
LA165:
    
LA170:
    ret
    
EX11:
    call vstack_clear
    call EX12
    call vstack_restore
    jne LA171
    
LA172:
    test_input_string "*"
    jne LA173
    call vstack_clear
    call EX12
    call vstack_restore
    mov esi, 248
    jne terminate_program ; 248
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "mul eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA173:
    je LA174
    test_input_string "/"
    jne LA175
    call vstack_clear
    call EX12
    call vstack_restore
    mov esi, 253
    jne terminate_program ; 253
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "idiv eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA175:
    je LA174
    test_input_string "%"
    jne LA176
    call vstack_clear
    call EX12
    call vstack_restore
    mov esi, 258
    jne terminate_program ; 258
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "idiv eax, ebx"
    call newline
    print "push edx"
    call newline
    
LA176:
    
LA174:
    je LA172
    call set_true
    mov esi, 263
    jne terminate_program ; 263
    
LA171:
    
LA177:
    ret
    
EX12:
    call vstack_clear
    call EX13
    call vstack_restore
    jne LA178
    
LA179:
    test_input_string "**"
    jne LA180
    call vstack_clear
    call EX12
    call vstack_restore
    mov esi, 264
    jne terminate_program ; 264
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "exp"
    call newline
    
LA180:
    
LA181:
    je LA179
    call set_true
    mov esi, 268
    jne terminate_program ; 268
    
LA178:
    
LA182:
    ret
    
EX13:
    test_input_string "++"
    jne LA183
    call vstack_clear
    call EX14
    call vstack_restore
    mov esi, 269
    jne terminate_program ; 269
    print "mov eax, dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "inc eax"
    call newline
    print "mov dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LA183:
    je LA184
    test_input_string "--"
    jne LA185
    call vstack_clear
    call EX14
    call vstack_restore
    mov esi, 274
    jne terminate_program ; 274
    print "mov eax, dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "dec eax"
    call newline
    print "mov dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    mov esi, 279
    jne terminate_program ; 279
    
LA185:
    je LA184
    test_input_string "*"
    jne LA186
    call test_for_id
    mov esi, 280
    jne terminate_program ; 280
    print "mov eax, dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "mov eax, dword [eax]"
    call newline
    print "push eax"
    call newline
    mov esi, 284
    jne terminate_program ; 284
    
LA186:
    je LA184
    test_input_string "&"
    jne LA187
    call test_for_id
    mov esi, 285
    jne terminate_program ; 285
    print "lea eax, [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "push eax"
    call newline
    
LA187:
    je LA184
    test_input_string "+"
    jne LA188
    call vstack_clear
    call EX14
    call vstack_restore
    mov esi, 288
    jne terminate_program ; 288
    
LA188:
    je LA184
    test_input_string "-"
    jne LA189
    call vstack_clear
    call EX14
    call vstack_restore
    mov esi, 289
    jne terminate_program ; 289
    print "pop eax"
    call newline
    print "neg eax"
    call newline
    print "push eax"
    call newline
    
LA189:
    je LA184
    call vstack_clear
    call EX14
    call vstack_restore
    jne LA190
    
LA190:
    
LA184:
    ret
    
EX14:
    call test_for_id
    jne LA191
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 293
    jne terminate_program ; 293
    test_input_string "("
    jne LA192
    
LA193:
    call vstack_clear
    call FN_CALL_ARGUMENTS
    call vstack_restore
    je LA193
    call set_true
    mov esi, 294
    jne terminate_program ; 294
    test_input_string ")"
    mov esi, 295
    jne terminate_program ; 295
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA192:
    
LA194:
    jne LA195
    mov esi, 297
    jne terminate_program ; 297
    
LA195:
    je LA196
    test_input_string "++"
    jne LA197
    print "mov eax, dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "inc eax"
    call newline
    print "mov dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    mov esi, 302
    jne terminate_program ; 302
    
LA197:
    je LA196
    test_input_string "--"
    jne LA198
    print "mov eax, dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "dec eax"
    call newline
    print "mov dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LA198:
    je LA196
    call set_true
    jne LA199
    print "push dword [ebp+"
    pushfd
    push eax
    push last_match
    mov edi, ST
    pop esi
    call hash_get
    push eax
    pop edi
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA199:
    
LA196:
    mov esi, 308
    jne terminate_program ; 308
    
LA191:
    je LA200
    call test_for_number
    jne LA201
    print "push "
    call copy_last_match
    call newline
    
LA201:
    je LA200
    test_input_string "("
    jne LA202
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 310
    jne terminate_program ; 310
    test_input_string ")"
    mov esi, 311
    jne terminate_program ; 311
    
LA202:
    
LA200:
    ret
    
IF_STATEMENT:
    test_input_string "if"
    jne LA203
    test_input_string "("
    mov esi, 312
    jne terminate_program ; 312
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 313
    jne terminate_program ; 313
    test_input_string ")"
    mov esi, 314
    jne terminate_program ; 314
    print "pop eax"
    call newline
    print "cmp eax, 0"
    call newline
    print "je "
    call gn1
    call newline
    test_input_string "{"
    mov esi, 318
    jne terminate_program ; 318
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 319
    jne terminate_program ; 319
    test_input_string "}"
    mov esi, 320
    jne terminate_program ; 320
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA204:
    call vstack_clear
    call ELIF
    call vstack_restore
    jne LA205
    
LA205:
    
LA206:
    je LA204
    call set_true
    mov esi, 322
    jne terminate_program ; 322
    
LA207:
    call vstack_clear
    call ELSE
    call vstack_restore
    jne LA208
    
LA208:
    
LA209:
    je LA207
    call set_true
    mov esi, 323
    jne terminate_program ; 323
    call label
    call gn2
    print ":"
    call newline
    
LA203:
    
LA210:
    ret
    
ELIF:
    test_input_string "elif"
    jne LA211
    test_input_string "("
    mov esi, 324
    jne terminate_program ; 324
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 325
    jne terminate_program ; 325
    test_input_string ")"
    mov esi, 326
    jne terminate_program ; 326
    print "pop eax"
    call newline
    print "cmp eax, 0"
    call newline
    print "jne "
    call gn1
    call newline
    test_input_string "{"
    mov esi, 330
    jne terminate_program ; 330
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 331
    jne terminate_program ; 331
    test_input_string "}"
    mov esi, 332
    jne terminate_program ; 332
    call label
    call gn1
    print ":"
    call newline
    
LA211:
    
LA212:
    ret
    
ELSE:
    test_input_string "else"
    jne LA213
    test_input_string "{"
    mov esi, 333
    jne terminate_program ; 333
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 334
    jne terminate_program ; 334
    test_input_string "}"
    mov esi, 335
    jne terminate_program ; 335
    
LA213:
    
LA214:
    ret
    
LET_EXPRESSION:
    test_input_string "let"
    jne LA215
    call test_for_id
    mov esi, 336
    jne terminate_program ; 336
    pushfd
    push eax
    push last_match
    push dword [STO]
    push 4
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [STO], eax
    push eax
    mov edi, ST
    pop edx
    pop esi
    call hash_set
    push edx
    pop edi
    pop eax
    popfd
    mov esi, 337
    jne terminate_program ; 337
    pushfd
    push eax
    push dword [VAR_IN_BODY]
    push 1
    pop eax
    pop ebx
    add eax, ebx
    push eax
    pop eax
    mov [VAR_IN_BODY], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 338
    jne terminate_program ; 338
    test_input_string "="
    mov esi, 339
    jne terminate_program ; 339
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 340
    jne terminate_program ; 340
    print "pop eax"
    call newline
    print "mov dword [ebp+"
    pushfd
    push eax
    push dword [STO]
    pop edi
    pop eax
    popfd
    print_int edi
    print "], eax"
    call newline
    
LA215:
    
LA216:
    ret
    
WHILE_STATEMENT:
    test_input_string "while"
    jne LA217
    call label
    call gn2
    print ":"
    call newline
    test_input_string "("
    mov esi, 343
    jne terminate_program ; 343
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 344
    jne terminate_program ; 344
    test_input_string ")"
    mov esi, 345
    jne terminate_program ; 345
    test_input_string "{"
    mov esi, 346
    jne terminate_program ; 346
    print "pop eax"
    call newline
    print "cmp eax, 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 350
    jne terminate_program ; 350
    test_input_string "}"
    mov esi, 351
    jne terminate_program ; 351
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA217:
    
LA218:
    ret
    
RETURN_EXPRESSION:
    test_input_string "return"
    jne LA219
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 353
    jne terminate_program ; 353
    print "pop eax"
    call newline
    
LA219:
    
LA220:
    ret
    
