
%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .data
    ST times 65536 dd 0x00
    STO dd 12
    VAR_IN_BODY dd 0
    AEXP_SEC_NUM dd 0
    EAX_WAS_NUMBER dd 0
    EBX_WAS_NUMBER dd 0
    
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
    call TYPE_EXPRESSION
    call vstack_restore
    jne LA4
    test_input_string ";"
    mov esi, 4
    jne terminate_program ; 4
    
LA4:
    je LA3
    call vstack_clear
    call ENUM_EXPRESSION
    call vstack_restore
    jne LA5
    
LA5:
    je LA3
    call vstack_clear
    call FN_EXPRESSION
    call vstack_restore
    jne LA6
    
LA6:
    je LA3
    call vstack_clear
    call FN_CALL
    call vstack_restore
    jne LA7
    test_input_string ";"
    mov esi, 5
    jne terminate_program ; 5
    
LA7:
    je LA3
    call vstack_clear
    call IF_STATEMENT
    call vstack_restore
    jne LA8
    
LA8:
    je LA3
    call vstack_clear
    call WHILE_STATEMENT
    call vstack_restore
    jne LA9
    
LA9:
    
LA3:
    je LA1
    call set_true
    mov esi, 6
    jne terminate_program ; 6
    print "pop ebp"
    call newline
    print "mov eax, 4"
    call newline
    print "mov ebx, 0"
    call newline
    print "int 0x80"
    call newline
    
LA10:
    
LA11:
    ret
    
FN_EXPRESSION:
    test_input_string "fn"
    jne LA12
    print "jmp "
    call gn1
    call newline
    call test_for_id
    mov esi, 12
    jne terminate_program ; 12
    call label
    call copy_last_match
    print ":"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    test_input_string "("
    mov esi, 15
    jne terminate_program ; 15
    
LA13:
    call test_for_id
    jne LA14
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
    mov esi, 16
    jne terminate_program ; 16
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
    mov esi, 17
    jne terminate_program ; 17
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
    
LA14:
    
LA15:
    je LA13
    call set_true
    mov esi, 19
    jne terminate_program ; 19
    
LA16:
    test_input_string ","
    jne LA17
    call test_for_id
    mov esi, 20
    jne terminate_program ; 20
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
    mov esi, 21
    jne terminate_program ; 21
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
    mov esi, 22
    jne terminate_program ; 22
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
    
LA17:
    
LA18:
    jne LA19
    
LA20:
    test_input_string ","
    jne LA21
    call test_for_id
    mov esi, 24
    jne terminate_program ; 24
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
    mov esi, 25
    jne terminate_program ; 25
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
    mov esi, 26
    jne terminate_program ; 26
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
    
LA22:
    test_input_string ","
    jne LA23
    call test_for_id
    mov esi, 28
    jne terminate_program ; 28
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
    mov esi, 29
    jne terminate_program ; 29
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
    mov esi, 30
    jne terminate_program ; 30
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
    
LA24:
    test_input_string ","
    jne LA25
    call test_for_id
    mov esi, 32
    jne terminate_program ; 32
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
    mov esi, 33
    jne terminate_program ; 33
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
    mov esi, 34
    jne terminate_program ; 34
    
LA25:
    
LA26:
    je LA24
    call set_true
    mov esi, 35
    jne terminate_program ; 35
    
LA23:
    
LA27:
    je LA22
    call set_true
    mov esi, 36
    jne terminate_program ; 36
    
LA21:
    
LA28:
    je LA20
    call set_true
    mov esi, 37
    jne terminate_program ; 37
    
LA19:
    
LA29:
    je LA16
    call set_true
    mov esi, 38
    jne terminate_program ; 38
    test_input_string ")"
    mov esi, 39
    jne terminate_program ; 39
    test_input_string "{"
    mov esi, 40
    jne terminate_program ; 40
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 41
    jne terminate_program ; 41
    test_input_string "}"
    mov esi, 42
    jne terminate_program ; 42
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
    mov esi, 43
    jne terminate_program ; 43
    print "pop ebp"
    call newline
    print "ret"
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA12:
    
LA30:
    ret
    
BODY:
    
LA31:
    call vstack_clear
    call RETURN_EXPRESSION
    call vstack_restore
    jne LA32
    test_input_string ";"
    mov esi, 46
    jne terminate_program ; 46
    
LA32:
    je LA33
    call vstack_clear
    call IF_STATEMENT
    call vstack_restore
    jne LA34
    
LA34:
    je LA33
    call vstack_clear
    call WHILE_STATEMENT
    call vstack_restore
    jne LA35
    
LA35:
    je LA33
    call vstack_clear
    call LET_EXPRESSION
    call vstack_restore
    jne LA36
    test_input_string ";"
    mov esi, 47
    jne terminate_program ; 47
    
LA36:
    je LA33
    call vstack_clear
    call TYPE_EXPRESSION
    call vstack_restore
    jne LA37
    test_input_string ";"
    mov esi, 48
    jne terminate_program ; 48
    
LA37:
    je LA33
    call vstack_clear
    call ENUM_EXPRESSION
    call vstack_restore
    jne LA38
    
LA38:
    je LA33
    call vstack_clear
    call FN_CALL
    call vstack_restore
    jne LA39
    test_input_string ";"
    mov esi, 49
    jne terminate_program ; 49
    
LA39:
    je LA33
    call vstack_clear
    call FN_EXPRESSION
    call vstack_restore
    jne LA40
    
LA40:
    
LA33:
    je LA31
    call set_true
    jne LA41
    
LA41:
    
LA42:
    ret
    
FN_CALL:
    call test_for_id
    jne LA43
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 50
    jne terminate_program ; 50
    test_input_string "("
    mov esi, 51
    jne terminate_program ; 51
    call vstack_clear
    call FN_CALL_ARGUMENTS
    call vstack_restore
    mov esi, 52
    jne terminate_program ; 52
    test_input_string ")"
    mov esi, 53
    jne terminate_program ; 53
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA43:
    
LA44:
    ret
    
FN_CALL_ARGUMENTS:
    
LA45:
    call test_for_number
    jne LA46
    print "mov edi, "
    call copy_last_match
    call newline
    
LA46:
    
LA47:
    je LA45
    call set_true
    jne LA48
    
LA49:
    test_input_string ","
    jne LA50
    call test_for_number
    jne LA51
    print "mov esi, "
    call copy_last_match
    call newline
    
LA51:
    je LA52
    call test_for_id
    jne LA53
    print "mov esi, ["
    call copy_last_match
    print "]"
    call newline
    
LA53:
    je LA52
    test_input_string "*"
    jne LA54
    call test_for_id
    mov esi, 58
    jne terminate_program ; 58
    print "mov esi, "
    call copy_last_match
    call newline
    
LA54:
    je LA52
    call test_for_string
    jne LA55
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
    
LA55:
    
LA52:
    mov esi, 62
    jne terminate_program ; 62
    
LA56:
    test_input_string ","
    jne LA57
    call test_for_number
    jne LA58
    print "mov edx, "
    call copy_last_match
    call newline
    
LA58:
    je LA59
    call test_for_id
    jne LA60
    print "mov edx, ["
    call copy_last_match
    print "]"
    call newline
    
LA60:
    je LA59
    test_input_string "*"
    jne LA61
    call test_for_id
    mov esi, 65
    jne terminate_program ; 65
    print "mov edx, "
    call copy_last_match
    call newline
    
LA61:
    je LA59
    call test_for_string
    jne LA62
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
    
LA62:
    
LA59:
    mov esi, 69
    jne terminate_program ; 69
    
LA63:
    test_input_string ","
    jne LA64
    call test_for_number
    jne LA65
    print "mov ecx, "
    call copy_last_match
    call newline
    
LA65:
    je LA66
    call test_for_id
    jne LA67
    print "mov ecx, ["
    call copy_last_match
    print "]"
    call newline
    
LA67:
    je LA66
    test_input_string "*"
    jne LA68
    call test_for_id
    mov esi, 72
    jne terminate_program ; 72
    print "mov ecx, "
    call copy_last_match
    call newline
    
LA68:
    je LA66
    call test_for_string
    jne LA69
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
    
LA69:
    
LA66:
    mov esi, 76
    jne terminate_program ; 76
    
LA70:
    test_input_string ","
    jne LA71
    call test_for_number
    jne LA72
    print "push "
    call copy_last_match
    call newline
    
LA72:
    je LA73
    call test_for_id
    jne LA74
    print "push ["
    call copy_last_match
    print "]"
    call newline
    
LA74:
    je LA73
    test_input_string "*"
    jne LA75
    print "push "
    call copy_last_match
    call newline
    
LA75:
    je LA73
    call test_for_string
    jne LA76
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
    
LA76:
    
LA73:
    mov esi, 82
    jne terminate_program ; 82
    
LA71:
    
LA77:
    je LA70
    call set_true
    mov esi, 83
    jne terminate_program ; 83
    
LA64:
    
LA78:
    je LA63
    call set_true
    mov esi, 84
    jne terminate_program ; 84
    
LA57:
    
LA79:
    je LA56
    call set_true
    mov esi, 85
    jne terminate_program ; 85
    
LA50:
    
LA80:
    je LA49
    call set_true
    mov esi, 86
    jne terminate_program ; 86
    
LA48:
    
LA81:
    ret
    
AEXP:
    call vstack_clear
    call EX1
    call vstack_restore
    jne LA82
    pushfd
    push eax
    push 0
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 87
    jne terminate_program ; 87
    
LA83:
    test_input_string "="
    jne LA84
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 88
    jne terminate_program ; 88
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
    
LA84:
    
LA85:
    jne LA86
    mov esi, 90
    jne terminate_program ; 90
    mov esi, 91
    jne terminate_program ; 91
    mov esi, 92
    jne terminate_program ; 92
    
LA86:
    je LA87
    test_input_string "+="
    jne LA88
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 93
    jne terminate_program ; 93
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
    
LA88:
    
LA89:
    jne LA90
    
LA90:
    je LA87
    test_input_string "-="
    jne LA91
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 95
    jne terminate_program ; 95
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
    
LA91:
    
LA92:
    jne LA93
    mov esi, 97
    jne terminate_program ; 97
    
LA93:
    je LA87
    test_input_string "*="
    jne LA94
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 98
    jne terminate_program ; 98
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
    
LA94:
    
LA95:
    jne LA96
    
LA96:
    je LA87
    test_input_string "/="
    jne LA97
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 100
    jne terminate_program ; 100
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
    
LA97:
    
LA98:
    jne LA99
    
LA99:
    je LA87
    test_input_string "%="
    jne LA100
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 102
    jne terminate_program ; 102
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
    
LA100:
    
LA101:
    jne LA102
    mov esi, 105
    jne terminate_program ; 105
    
LA102:
    je LA87
    test_input_string "<<="
    jne LA103
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 106
    jne terminate_program ; 106
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
    
LA103:
    
LA104:
    jne LA105
    
LA105:
    je LA87
    test_input_string ">>="
    jne LA106
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 108
    jne terminate_program ; 108
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
    
LA106:
    
LA107:
    jne LA108
    mov esi, 110
    jne terminate_program ; 110
    
LA108:
    je LA87
    test_input_string "&="
    jne LA109
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 111
    jne terminate_program ; 111
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
    
LA109:
    
LA110:
    jne LA111
    
LA111:
    je LA87
    test_input_string "^="
    jne LA112
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 113
    jne terminate_program ; 113
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
    
LA112:
    
LA113:
    jne LA114
    
LA114:
    je LA87
    test_input_string "|="
    jne LA115
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 115
    jne terminate_program ; 115
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
    
LA115:
    
LA116:
    jne LA117
    
LA117:
    
LA87:
    je LA83
    call set_true
    mov esi, 117
    jne terminate_program ; 117
    
LA82:
    
LA118:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    jne LA119
    
LA120:
    test_input_string "?"
    jne LA121
    print "cmp eax, 0"
    call newline
    mov esi, 119
    jne terminate_program ; 119
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov esi, 121
    jne terminate_program ; 121
    mov esi, 122
    jne terminate_program ; 122
    print "jmp "
    call gn2
    call newline
    test_input_string ":"
    mov esi, 124
    jne terminate_program ; 124
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov esi, 125
    jne terminate_program ; 125
    call label
    call gn2
    print ":"
    call newline
    
LA121:
    
LA122:
    je LA120
    call set_true
    mov esi, 126
    jne terminate_program ; 126
    
LA119:
    
LA123:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA124
    
LA125:
    test_input_string "||"
    jne LA126
    call vstack_clear
    call EX3
    call vstack_restore
    mov esi, 127
    jne terminate_program ; 127
    print "or eax, ebx"
    call newline
    
LA126:
    
LA127:
    je LA125
    call set_true
    mov esi, 129
    jne terminate_program ; 129
    
LA124:
    
LA128:
    ret
    
EX3:
    call vstack_clear
    call EX4
    call vstack_restore
    jne LA129
    
LA130:
    test_input_string "&&"
    jne LA131
    call vstack_clear
    call EX4
    call vstack_restore
    mov esi, 130
    jne terminate_program ; 130
    print "and eax, ebx"
    call newline
    
LA131:
    
LA132:
    je LA130
    call set_true
    mov esi, 132
    jne terminate_program ; 132
    
LA129:
    
LA133:
    ret
    
EX4:
    call vstack_clear
    call EX5
    call vstack_restore
    jne LA134
    
LA135:
    test_input_string "|"
    jne LA136
    call vstack_clear
    call EX5
    call vstack_restore
    mov esi, 133
    jne terminate_program ; 133
    print "or eax, ebx"
    call newline
    
LA136:
    
LA137:
    je LA135
    call set_true
    mov esi, 135
    jne terminate_program ; 135
    
LA134:
    
LA138:
    ret
    
EX5:
    call vstack_clear
    call EX6
    call vstack_restore
    jne LA139
    
LA140:
    test_input_string "^"
    jne LA141
    call vstack_clear
    call EX6
    call vstack_restore
    mov esi, 136
    jne terminate_program ; 136
    print "xor eax, ebx"
    call newline
    
LA141:
    
LA142:
    je LA140
    call set_true
    mov esi, 138
    jne terminate_program ; 138
    
LA139:
    
LA143:
    ret
    
EX6:
    call vstack_clear
    call EX7
    call vstack_restore
    jne LA144
    
LA145:
    test_input_string "&"
    jne LA146
    call vstack_clear
    call EX7
    call vstack_restore
    mov esi, 139
    jne terminate_program ; 139
    print "and eax, ebx"
    call newline
    
LA146:
    
LA147:
    je LA145
    call set_true
    mov esi, 141
    jne terminate_program ; 141
    
LA144:
    
LA148:
    ret
    
EX7:
    call vstack_clear
    call EX8
    call vstack_restore
    jne LA149
    
LA150:
    test_input_string "=="
    jne LA151
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 142
    jne terminate_program ; 142
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
    
LA151:
    je LA152
    test_input_string "!="
    jne LA153
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 148
    jne terminate_program ; 148
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
    
LA153:
    
LA152:
    je LA150
    call set_true
    mov esi, 154
    jne terminate_program ; 154
    
LA149:
    
LA154:
    ret
    
EX8:
    call vstack_clear
    call EX9
    call vstack_restore
    jne LA155
    
LA156:
    test_input_string "<="
    jne LA157
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 155
    jne terminate_program ; 155
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
    
LA157:
    je LA158
    test_input_string ">="
    jne LA159
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 161
    jne terminate_program ; 161
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
    
LA159:
    je LA158
    test_input_string "<"
    jne LA160
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 167
    jne terminate_program ; 167
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
    
LA160:
    je LA158
    test_input_string ">"
    jne LA161
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 173
    jne terminate_program ; 173
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
    
LA161:
    
LA158:
    je LA156
    call set_true
    mov esi, 179
    jne terminate_program ; 179
    
LA155:
    
LA162:
    ret
    
EX9:
    call vstack_clear
    call EX10
    call vstack_restore
    jne LA163
    
LA164:
    test_input_string "<<"
    jne LA165
    call vstack_clear
    call EX10
    call vstack_restore
    mov esi, 180
    jne terminate_program ; 180
    print "shl eax, ebx"
    call newline
    
LA165:
    je LA166
    test_input_string ">>"
    jne LA167
    call vstack_clear
    call EX10
    call vstack_restore
    mov esi, 182
    jne terminate_program ; 182
    print "shr eax, ebx"
    call newline
    
LA167:
    
LA166:
    je LA164
    call set_true
    mov esi, 184
    jne terminate_program ; 184
    
LA163:
    
LA168:
    ret
    
EX10:
    call vstack_clear
    call EX11
    call vstack_restore
    jne LA169
    pushfd
    push eax
    push 0
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 185
    jne terminate_program ; 185
    
LA170:
    test_input_string "+"
    jne LA171
    pushfd
    push eax
    push 1
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 186
    jne terminate_program ; 186
    call vstack_clear
    call EX11
    call vstack_restore
    mov esi, 187
    jne terminate_program ; 187
    print "add eax, ebx"
    call newline
    
LA171:
    je LA172
    test_input_string "-"
    jne LA173
    call vstack_clear
    call EX11
    call vstack_restore
    mov esi, 189
    jne terminate_program ; 189
    print "sub eax, ebx"
    call newline
    
LA173:
    
LA172:
    je LA170
    call set_true
    mov esi, 191
    jne terminate_program ; 191
    
LA169:
    
LA174:
    ret
    
EX11:
    call vstack_clear
    call EX12
    call vstack_restore
    jne LA175
    pushfd
    push eax
    push 0
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 192
    jne terminate_program ; 192
    
LA176:
    test_input_string "*"
    jne LA177
    pushfd
    push eax
    push 1
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 193
    jne terminate_program ; 193
    call vstack_clear
    call EX12
    call vstack_restore
    mov esi, 194
    jne terminate_program ; 194
    print "mul eax, ebx"
    call newline
    
LA177:
    je LA178
    test_input_string "/"
    jne LA179
    pushfd
    push eax
    push 1
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 196
    jne terminate_program ; 196
    call vstack_clear
    call EX12
    call vstack_restore
    mov esi, 197
    jne terminate_program ; 197
    print "idiv eax, ebx"
    call newline
    
LA179:
    je LA178
    test_input_string "%"
    jne LA180
    pushfd
    push eax
    push 1
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 199
    jne terminate_program ; 199
    call vstack_clear
    call EX12
    call vstack_restore
    mov esi, 200
    jne terminate_program ; 200
    print "idiv eax, ebx"
    call newline
    print "push edx"
    call newline
    
LA180:
    
LA178:
    je LA176
    call set_true
    mov esi, 203
    jne terminate_program ; 203
    
LA175:
    
LA181:
    ret
    
EX12:
    call vstack_clear
    call EX13
    call vstack_restore
    jne LA182
    pushfd
    push eax
    push 0
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 204
    jne terminate_program ; 204
    
LA183:
    test_input_string "**"
    jne LA184
    pushfd
    push eax
    push 1
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 205
    jne terminate_program ; 205
    call vstack_clear
    call EX12
    call vstack_restore
    mov esi, 206
    jne terminate_program ; 206
    print "exp"
    call newline
    
LA184:
    
LA185:
    je LA183
    call set_true
    mov esi, 208
    jne terminate_program ; 208
    
LA182:
    
LA186:
    ret
    
EX13:
    test_input_string "++"
    jne LA187
    call vstack_clear
    call EX14
    call vstack_restore
    mov esi, 209
    jne terminate_program ; 209
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
    
LA187:
    je LA188
    test_input_string "--"
    jne LA189
    call vstack_clear
    call EX14
    call vstack_restore
    mov esi, 213
    jne terminate_program ; 213
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
    mov esi, 217
    jne terminate_program ; 217
    
LA189:
    je LA188
    test_input_string "*"
    jne LA190
    call test_for_id
    mov esi, 218
    jne terminate_program ; 218
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
    mov esi, 221
    jne terminate_program ; 221
    
LA190:
    je LA188
    test_input_string "&"
    jne LA191
    call test_for_id
    mov esi, 222
    jne terminate_program ; 222
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
    
LA191:
    je LA188
    test_input_string "+"
    jne LA192
    call vstack_clear
    call EX14
    call vstack_restore
    mov esi, 224
    jne terminate_program ; 224
    
LA192:
    je LA188
    test_input_string "-"
    jne LA193
    call vstack_clear
    call EX14
    call vstack_restore
    mov esi, 225
    jne terminate_program ; 225
    print "neg eax"
    call newline
    
LA193:
    je LA188
    call vstack_clear
    call EX14
    call vstack_restore
    jne LA194
    
LA194:
    
LA188:
    ret
    
EX14:
    call test_for_id
    jne LA195
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 227
    jne terminate_program ; 227
    test_input_string "("
    jne LA196
    
LA197:
    call vstack_clear
    call FN_CALL_ARGUMENTS
    call vstack_restore
    je LA197
    call set_true
    mov esi, 228
    jne terminate_program ; 228
    test_input_string ")"
    mov esi, 229
    jne terminate_program ; 229
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA196:
    
LA198:
    jne LA199
    mov esi, 231
    jne terminate_program ; 231
    
LA199:
    je LA200
    test_input_string "++"
    jne LA201
    print "inc dword [ebp+"
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
    mov esi, 233
    jne terminate_program ; 233
    
LA201:
    je LA200
    test_input_string "--"
    jne LA202
    print "dec dword [ebp+"
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
    
LA202:
    je LA200
    call set_true
    jne LA203
    push dword [AEXP_SEC_NUM]
    pop eax
    cmp eax, 0
    jne LA204
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
    
LA204:
    je LA205
    print "mov ebx, dword [ebp+"
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
    call set_true
    
LA206:
    
LA205:
    mov esi, 237
    jne terminate_program ; 237
    
LA203:
    
LA200:
    mov esi, 238
    jne terminate_program ; 238
    
LA195:
    je LA207
    call test_for_number
    jne LA208
    push dword [AEXP_SEC_NUM]
    pop eax
    cmp eax, 0
    jne LA209
    print "mov eax, "
    call copy_last_match
    call newline
    
LA209:
    je LA210
    print "mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA211:
    
LA210:
    mov esi, 241
    jne terminate_program ; 241
    
LA208:
    je LA207
    test_input_string "("
    jne LA212
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 242
    jne terminate_program ; 242
    test_input_string ")"
    mov esi, 243
    jne terminate_program ; 243
    
LA212:
    
LA207:
    ret
    
BASIC_TYPE:
    test_input_string "i8"
    jne LA213
    print "; type: i8"
    call newline
    
LA213:
    je LA214
    test_input_string "i16"
    jne LA215
    print "; type: i16"
    call newline
    
LA215:
    je LA214
    test_input_string "i32"
    jne LA216
    print "; type: i32"
    call newline
    
LA216:
    je LA214
    test_input_string "i64"
    jne LA217
    print "; type: i64"
    call newline
    
LA217:
    je LA214
    test_input_string "u8"
    jne LA218
    print "; type: u8"
    call newline
    
LA218:
    je LA214
    test_input_string "u16"
    jne LA219
    print "; type: u16"
    call newline
    
LA219:
    je LA214
    test_input_string "u32"
    jne LA220
    print "; type: u32"
    call newline
    
LA220:
    je LA214
    test_input_string "u64"
    jne LA221
    print "; type: u64"
    call newline
    
LA221:
    je LA214
    test_input_string "f32"
    jne LA222
    print "; type: f32"
    call newline
    
LA222:
    je LA214
    test_input_string "f64"
    jne LA223
    print "; type: f64"
    call newline
    
LA223:
    je LA214
    test_input_string "bool"
    jne LA224
    print "; type: bool"
    call newline
    
LA224:
    je LA214
    test_input_string "char"
    jne LA225
    print "; type: char"
    call newline
    
LA225:
    
LA214:
    ret
    
UNION_TYPE:
    call vstack_clear
    call BASIC_TYPE
    call vstack_restore
    jne LA226
    
LA226:
    je LA227
    call vstack_clear
    call POINTER_TYPE
    call vstack_restore
    jne LA228
    
LA228:
    je LA227
    call vstack_clear
    call DEREFERENCE_TYPE
    call vstack_restore
    jne LA229
    
LA229:
    je LA227
    call vstack_clear
    call FN_TYPE
    call vstack_restore
    jne LA230
    
LA230:
    je LA227
    test_input_string "("
    jne LA231
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 256
    jne terminate_program ; 256
    test_input_string ")"
    mov esi, 257
    jne terminate_program ; 257
    
LA231:
    
LA232:
    jne LA233
    
LA233:
    je LA227
    call test_for_id
    jne LA234
    print "; type: "
    call copy_last_match
    print " (alias)"
    call newline
    
LA234:
    
LA235:
    jne LA236
    
LA236:
    je LA227
    call vstack_clear
    call ARRAY_TYPE
    call vstack_restore
    jne LA237
    
LA237:
    
LA227:
    jne LA238
    
LA239:
    test_input_string "|"
    jne LA240
    print "; or"
    call newline
    call vstack_clear
    call BASIC_TYPE
    call vstack_restore
    jne LA241
    
LA241:
    je LA242
    call vstack_clear
    call POINTER_TYPE
    call vstack_restore
    jne LA243
    
LA243:
    je LA242
    call vstack_clear
    call DEREFERENCE_TYPE
    call vstack_restore
    jne LA244
    
LA244:
    je LA242
    call vstack_clear
    call FN_TYPE
    call vstack_restore
    jne LA245
    
LA245:
    je LA242
    test_input_string "("
    jne LA246
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 260
    jne terminate_program ; 260
    test_input_string ")"
    mov esi, 261
    jne terminate_program ; 261
    
LA246:
    
LA247:
    jne LA248
    
LA248:
    je LA242
    call test_for_id
    jne LA249
    print "; type: "
    call copy_last_match
    print " (alias)"
    call newline
    
LA249:
    
LA250:
    jne LA251
    
LA251:
    je LA242
    call vstack_clear
    call ARRAY_TYPE
    call vstack_restore
    jne LA252
    
LA252:
    
LA242:
    mov esi, 263
    jne terminate_program ; 263
    
LA240:
    
LA253:
    je LA239
    call set_true
    mov esi, 264
    jne terminate_program ; 264
    
LA238:
    
LA254:
    ret
    
POINTER_TYPE:
    test_input_string "*"
    jne LA255
    print "; pointer"
    call newline
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 266
    jne terminate_program ; 266
    
LA255:
    
LA256:
    ret
    
DEREFERENCE_TYPE:
    test_input_string "&"
    jne LA257
    print "; dereference"
    call newline
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 268
    jne terminate_program ; 268
    
LA257:
    
LA258:
    ret
    
FN_TYPE:
    test_input_string "fn"
    jne LA259
    print "; fn type"
    call newline
    test_input_string "<"
    jne LA260
    print "; is generic"
    call newline
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 271
    jne terminate_program ; 271
    test_input_string ">"
    mov esi, 272
    jne terminate_program ; 272
    
LA260:
    je LA261
    call set_true
    jne LA262
    
LA262:
    
LA261:
    mov esi, 273
    jne terminate_program ; 273
    test_input_string "("
    mov esi, 274
    jne terminate_program ; 274
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    jne LA263
    print "; input"
    call newline
    
LA264:
    test_input_string ","
    jne LA265
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 276
    jne terminate_program ; 276
    print "; input"
    call newline
    
LA265:
    
LA266:
    je LA264
    call set_true
    mov esi, 278
    jne terminate_program ; 278
    
LA263:
    je LA267
    call set_true
    jne LA268
    
LA268:
    
LA267:
    mov esi, 279
    jne terminate_program ; 279
    test_input_string ")"
    mov esi, 280
    jne terminate_program ; 280
    test_input_string "->"
    mov esi, 281
    jne terminate_program ; 281
    print "; output"
    call newline
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 283
    jne terminate_program ; 283
    
LA259:
    
LA269:
    ret
    
ARRAY_TYPE:
    test_input_string "["
    jne LA270
    call vstack_clear
    call UNION_TYPE
    call vstack_restore
    jne LA271
    
LA271:
    je LA272
    call vstack_clear
    call POINTER_TYPE
    call vstack_restore
    jne LA273
    
LA273:
    je LA272
    call vstack_clear
    call DEREFERENCE_TYPE
    call vstack_restore
    jne LA274
    
LA274:
    je LA272
    call vstack_clear
    call BASIC_TYPE
    call vstack_restore
    jne LA275
    
LA275:
    je LA272
    call vstack_clear
    call FN_TYPE
    call vstack_restore
    jne LA276
    
LA276:
    
LA272:
    mov esi, 284
    jne terminate_program ; 284
    test_input_string ";"
    mov esi, 285
    jne terminate_program ; 285
    call test_for_number
    jne LA277
    
LA277:
    je LA278
    test_input_string "*"
    jne LA279
    
LA279:
    
LA278:
    mov esi, 286
    jne terminate_program ; 286
    test_input_string "]"
    mov esi, 287
    jne terminate_program ; 287
    
LA270:
    
LA280:
    jne LA281
    
LA281:
    je LA282
    call vstack_clear
    call UNION_TYPE
    call vstack_restore
    jne LA283
    
LA283:
    je LA284
    call vstack_clear
    call BASIC_TYPE
    call vstack_restore
    jne LA285
    
LA285:
    je LA284
    call vstack_clear
    call FN_TYPE
    call vstack_restore
    jne LA286
    
LA286:
    
LA284:
    jne LA287
    test_input_string "["
    mov esi, 288
    jne terminate_program ; 288
    call test_for_number
    jne LA288
    
LA288:
    je LA289
    test_input_string "*"
    jne LA290
    
LA290:
    je LA289
    call set_true
    jne LA291
    
LA291:
    
LA289:
    mov esi, 289
    jne terminate_program ; 289
    test_input_string "]"
    mov esi, 290
    jne terminate_program ; 290
    
LA287:
    
LA292:
    jne LA293
    
LA293:
    
LA282:
    ret
    
COMPLEX_TYPE:
    call vstack_clear
    call UNION_TYPE
    call vstack_restore
    jne LA294
    
LA294:
    je LA295
    call vstack_clear
    call POINTER_TYPE
    call vstack_restore
    jne LA296
    
LA296:
    je LA295
    call vstack_clear
    call DEREFERENCE_TYPE
    call vstack_restore
    jne LA297
    
LA297:
    je LA295
    call vstack_clear
    call BASIC_TYPE
    call vstack_restore
    jne LA298
    
LA298:
    je LA295
    call vstack_clear
    call FN_TYPE
    call vstack_restore
    jne LA299
    
LA299:
    je LA295
    test_input_string "("
    jne LA300
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 291
    jne terminate_program ; 291
    test_input_string ")"
    mov esi, 292
    jne terminate_program ; 292
    
LA300:
    
LA301:
    jne LA302
    
LA302:
    je LA295
    call test_for_id
    jne LA303
    print "; type: "
    call copy_last_match
    print " (alias)"
    call newline
    
LA303:
    
LA304:
    jne LA305
    
LA305:
    je LA295
    call vstack_clear
    call ARRAY_TYPE
    call vstack_restore
    jne LA306
    
LA306:
    
LA295:
    ret
    
TYPE_ANNOTATION:
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    jne LA307
    
LA307:
    
LA308:
    ret
    
TYPE_EXPRESSION:
    test_input_string "type"
    jne LA309
    call test_for_id
    mov esi, 294
    jne terminate_program ; 294
    print "; define type "
    call copy_last_match
    call newline
    test_input_string "="
    mov esi, 296
    jne terminate_program ; 296
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 297
    jne terminate_program ; 297
    
LA309:
    
LA310:
    ret
    
ENUM_EXPRESSION:
    test_input_string "enum"
    jne LA311
    call test_for_id
    mov esi, 298
    jne terminate_program ; 298
    print "; define enum "
    call copy_last_match
    call newline
    test_input_string "{"
    mov esi, 300
    jne terminate_program ; 300
    call test_for_id
    jne LA312
    print "; enum value "
    call copy_last_match
    call newline
    
LA312:
    je LA313
    call set_true
    jne LA314
    
LA314:
    
LA313:
    mov esi, 302
    jne terminate_program ; 302
    
LA315:
    test_input_string ","
    jne LA316
    call test_for_id
    mov esi, 303
    jne terminate_program ; 303
    print "; enum value "
    call copy_last_match
    call newline
    
LA316:
    
LA317:
    je LA315
    call set_true
    mov esi, 305
    jne terminate_program ; 305
    test_input_string "}"
    mov esi, 306
    jne terminate_program ; 306
    
LA311:
    
LA318:
    ret
    
IF_STATEMENT:
    test_input_string "if"
    jne LA319
    test_input_string "("
    mov esi, 307
    jne terminate_program ; 307
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 308
    jne terminate_program ; 308
    test_input_string ")"
    mov esi, 309
    jne terminate_program ; 309
    print "cmp eax, 0"
    call newline
    print "je "
    call gn1
    call newline
    test_input_string "{"
    mov esi, 312
    jne terminate_program ; 312
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 313
    jne terminate_program ; 313
    test_input_string "}"
    mov esi, 314
    jne terminate_program ; 314
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA320:
    call vstack_clear
    call ELIF
    call vstack_restore
    jne LA321
    
LA321:
    
LA322:
    je LA320
    call set_true
    mov esi, 316
    jne terminate_program ; 316
    
LA323:
    call vstack_clear
    call ELSE
    call vstack_restore
    jne LA324
    
LA324:
    
LA325:
    je LA323
    call set_true
    mov esi, 317
    jne terminate_program ; 317
    call label
    call gn2
    print ":"
    call newline
    
LA319:
    
LA326:
    ret
    
ELIF:
    test_input_string "elif"
    jne LA327
    test_input_string "("
    mov esi, 318
    jne terminate_program ; 318
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 319
    jne terminate_program ; 319
    test_input_string ")"
    mov esi, 320
    jne terminate_program ; 320
    print "cmp eax, 0"
    call newline
    print "jne "
    call gn1
    call newline
    test_input_string "{"
    mov esi, 323
    jne terminate_program ; 323
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 324
    jne terminate_program ; 324
    test_input_string "}"
    mov esi, 325
    jne terminate_program ; 325
    call label
    call gn1
    print ":"
    call newline
    
LA327:
    
LA328:
    ret
    
ELSE:
    test_input_string "else"
    jne LA329
    test_input_string "{"
    mov esi, 326
    jne terminate_program ; 326
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 327
    jne terminate_program ; 327
    test_input_string "}"
    mov esi, 328
    jne terminate_program ; 328
    
LA329:
    
LA330:
    ret
    
LET_EXPRESSION:
    test_input_string "let"
    jne LA331
    call test_for_id
    mov esi, 329
    jne terminate_program ; 329
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
    mov esi, 330
    jne terminate_program ; 330
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
    mov esi, 331
    jne terminate_program ; 331
    test_input_string ":"
    jne LA332
    call vstack_clear
    call TYPE_ANNOTATION
    call vstack_restore
    mov esi, 332
    jne terminate_program ; 332
    
LA332:
    je LA333
    call set_true
    jne LA334
    
LA334:
    
LA333:
    mov esi, 333
    jne terminate_program ; 333
    test_input_string "="
    mov esi, 334
    jne terminate_program ; 334
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 335
    jne terminate_program ; 335
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
    
LA331:
    
LA335:
    ret
    
WHILE_STATEMENT:
    test_input_string "while"
    jne LA336
    call label
    call gn2
    print ":"
    call newline
    test_input_string "("
    mov esi, 337
    jne terminate_program ; 337
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 338
    jne terminate_program ; 338
    test_input_string ")"
    mov esi, 339
    jne terminate_program ; 339
    test_input_string "{"
    mov esi, 340
    jne terminate_program ; 340
    print "cmp eax, 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 343
    jne terminate_program ; 343
    test_input_string "}"
    mov esi, 344
    jne terminate_program ; 344
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA336:
    
LA337:
    ret
    
RETURN_EXPRESSION:
    test_input_string "return"
    jne LA338
    pushfd
    push eax
    push 0
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 346
    jne terminate_program ; 346
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 347
    jne terminate_program ; 347
    
LA338:
    
LA339:
    ret
    
