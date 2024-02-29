
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
    call COMMENT
    call vstack_restore
    jne LA5
    
LA5:
    je LA3
    call vstack_clear
    call ENUM_EXPRESSION
    call vstack_restore
    jne LA6
    
LA6:
    je LA3
    call vstack_clear
    call FN_EXPRESSION
    call vstack_restore
    jne LA7
    
LA7:
    je LA3
    call vstack_clear
    call DIRECT_ASSEMBLY_EXPRESSION
    call vstack_restore
    jne LA8
    test_input_string ";"
    mov esi, 5
    jne terminate_program ; 5
    
LA8:
    je LA3
    call vstack_clear
    call FN_CALL
    call vstack_restore
    jne LA9
    test_input_string ";"
    mov esi, 6
    jne terminate_program ; 6
    
LA9:
    je LA3
    call vstack_clear
    call IF_STATEMENT
    call vstack_restore
    jne LA10
    
LA10:
    je LA3
    call vstack_clear
    call WHILE_STATEMENT
    call vstack_restore
    jne LA11
    
LA11:
    
LA3:
    je LA1
    call set_true
    mov esi, 7
    jne terminate_program ; 7
    print "pop ebp"
    call newline
    print "mov eax, 1"
    call newline
    print "mov ebx, 0"
    call newline
    print "int 0x80"
    call newline
    
LA12:
    
LA13:
    ret
    
FN_EXPRESSION:
    test_input_string "fn"
    jne LA14
    print "jmp "
    call gn1
    call newline
    call test_for_id
    mov esi, 13
    jne terminate_program ; 13
    call label
    call copy_last_match
    print ":"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    test_input_string "("
    mov esi, 16
    jne terminate_program ; 16
    
LA15:
    call test_for_id
    jne LA16
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
    mov esi, 17
    jne terminate_program ; 17
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
    mov esi, 18
    jne terminate_program ; 18
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
    
LA16:
    
LA17:
    je LA15
    call set_true
    mov esi, 20
    jne terminate_program ; 20
    
LA18:
    test_input_string ","
    jne LA19
    call test_for_id
    mov esi, 21
    jne terminate_program ; 21
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
    mov esi, 22
    jne terminate_program ; 22
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
    mov esi, 23
    jne terminate_program ; 23
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
    
LA19:
    
LA20:
    jne LA21
    
LA22:
    test_input_string ","
    jne LA23
    call test_for_id
    mov esi, 25
    jne terminate_program ; 25
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
    mov esi, 26
    jne terminate_program ; 26
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
    mov esi, 27
    jne terminate_program ; 27
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
    
LA24:
    test_input_string ","
    jne LA25
    call test_for_id
    mov esi, 29
    jne terminate_program ; 29
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
    mov esi, 30
    jne terminate_program ; 30
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
    mov esi, 31
    jne terminate_program ; 31
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
    
LA26:
    test_input_string ","
    jne LA27
    call test_for_id
    mov esi, 33
    jne terminate_program ; 33
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
    mov esi, 34
    jne terminate_program ; 34
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
    mov esi, 35
    jne terminate_program ; 35
    
LA27:
    
LA28:
    je LA26
    call set_true
    mov esi, 36
    jne terminate_program ; 36
    
LA25:
    
LA29:
    je LA24
    call set_true
    mov esi, 37
    jne terminate_program ; 37
    
LA23:
    
LA30:
    je LA22
    call set_true
    mov esi, 38
    jne terminate_program ; 38
    
LA21:
    
LA31:
    je LA18
    call set_true
    mov esi, 39
    jne terminate_program ; 39
    test_input_string ")"
    mov esi, 40
    jne terminate_program ; 40
    test_input_string "{"
    mov esi, 41
    jne terminate_program ; 41
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 42
    jne terminate_program ; 42
    test_input_string "}"
    mov esi, 43
    jne terminate_program ; 43
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
    mov esi, 44
    jne terminate_program ; 44
    print "pop ebp"
    call newline
    print "ret"
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA14:
    
LA32:
    ret
    
BODY:
    
LA33:
    call vstack_clear
    call RETURN_EXPRESSION
    call vstack_restore
    jne LA34
    test_input_string ";"
    mov esi, 47
    jne terminate_program ; 47
    
LA34:
    je LA35
    call vstack_clear
    call IF_STATEMENT
    call vstack_restore
    jne LA36
    
LA36:
    je LA35
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA37
    
LA37:
    je LA35
    call vstack_clear
    call WHILE_STATEMENT
    call vstack_restore
    jne LA38
    
LA38:
    je LA35
    call vstack_clear
    call LET_EXPRESSION
    call vstack_restore
    jne LA39
    test_input_string ";"
    mov esi, 48
    jne terminate_program ; 48
    
LA39:
    je LA35
    call vstack_clear
    call DIRECT_ASSEMBLY_EXPRESSION
    call vstack_restore
    jne LA40
    test_input_string ";"
    mov esi, 49
    jne terminate_program ; 49
    
LA40:
    je LA35
    call vstack_clear
    call TYPE_EXPRESSION
    call vstack_restore
    jne LA41
    test_input_string ";"
    mov esi, 50
    jne terminate_program ; 50
    
LA41:
    je LA35
    call vstack_clear
    call ENUM_EXPRESSION
    call vstack_restore
    jne LA42
    
LA42:
    je LA35
    call vstack_clear
    call FN_CALL
    call vstack_restore
    jne LA43
    test_input_string ";"
    mov esi, 51
    jne terminate_program ; 51
    
LA43:
    je LA35
    call vstack_clear
    call FN_EXPRESSION
    call vstack_restore
    jne LA44
    
LA44:
    
LA35:
    je LA33
    call set_true
    jne LA45
    
LA45:
    
LA46:
    ret
    
FN_CALL:
    call test_for_id
    jne LA47
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 52
    jne terminate_program ; 52
    test_input_string "("
    mov esi, 53
    jne terminate_program ; 53
    call vstack_clear
    call FN_CALL_ARGUMENTS
    call vstack_restore
    mov esi, 54
    jne terminate_program ; 54
    test_input_string ")"
    mov esi, 55
    jne terminate_program ; 55
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA47:
    
LA48:
    ret
    
FN_CALL_ARGUMENTS:
    
LA49:
    call test_for_number
    jne LA50
    print "mov edi, "
    call copy_last_match
    call newline
    
LA50:
    je LA51
    call test_for_id
    jne LA52
    print "mov edi, dword [ebp+"
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
    
LA52:
    je LA51
    test_input_string "*"
    jne LA53
    call test_for_id
    mov esi, 59
    jne terminate_program ; 59
    print "mov edi, dword ebp+"
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
    call newline
    
LA53:
    je LA51
    call test_for_string
    jne LA54
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
    
LA54:
    
LA51:
    je LA49
    call set_true
    jne LA55
    
LA56:
    test_input_string ","
    jne LA57
    call test_for_number
    jne LA58
    print "mov esi, "
    call copy_last_match
    call newline
    
LA58:
    je LA59
    call test_for_id
    jne LA60
    print "mov esi, dword [ebp+"
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
    
LA60:
    je LA59
    test_input_string "*"
    jne LA61
    call test_for_id
    mov esi, 65
    jne terminate_program ; 65
    print "mov esi, dword ebp+"
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
    print "mov esi, "
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
    print "mov edx, "
    call copy_last_match
    call newline
    
LA65:
    je LA66
    call test_for_id
    jne LA67
    print "mov edx, dword [ebp+"
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
    
LA67:
    je LA66
    test_input_string "*"
    jne LA68
    call test_for_id
    mov esi, 72
    jne terminate_program ; 72
    print "mov edx, dword ebp+"
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
    print "mov edx, "
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
    print "mov ecx, "
    call copy_last_match
    call newline
    
LA72:
    je LA73
    call test_for_id
    jne LA74
    print "mov ecx, dword [ebp+"
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
    
LA74:
    je LA73
    test_input_string "*"
    jne LA75
    call test_for_id
    mov esi, 79
    jne terminate_program ; 79
    print "mov ecx, dword ebp+"
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
    print "mov ecx, "
    call gn3
    call newline
    
LA76:
    
LA73:
    mov esi, 83
    jne terminate_program ; 83
    
LA77:
    test_input_string ","
    jne LA78
    call test_for_number
    jne LA79
    print "push "
    call copy_last_match
    call newline
    
LA79:
    je LA80
    call test_for_id
    jne LA81
    print "push ["
    call copy_last_match
    print "]"
    call newline
    
LA81:
    je LA80
    test_input_string "*"
    jne LA82
    print "push "
    call copy_last_match
    call newline
    
LA82:
    je LA80
    call test_for_string
    jne LA83
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
    
LA83:
    
LA80:
    mov esi, 89
    jne terminate_program ; 89
    
LA78:
    
LA84:
    je LA77
    call set_true
    mov esi, 90
    jne terminate_program ; 90
    
LA71:
    
LA85:
    je LA70
    call set_true
    mov esi, 91
    jne terminate_program ; 91
    
LA64:
    
LA86:
    je LA63
    call set_true
    mov esi, 92
    jne terminate_program ; 92
    
LA57:
    
LA87:
    je LA56
    call set_true
    mov esi, 93
    jne terminate_program ; 93
    
LA55:
    
LA88:
    ret
    
AEXP:
    call vstack_clear
    call EX1
    call vstack_restore
    jne LA89
    pushfd
    push eax
    push 0
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 94
    jne terminate_program ; 94
    
LA90:
    test_input_string "="
    jne LA91
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 95
    jne terminate_program ; 95
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
    
LA91:
    
LA92:
    jne LA93
    mov esi, 97
    jne terminate_program ; 97
    mov esi, 98
    jne terminate_program ; 98
    mov esi, 99
    jne terminate_program ; 99
    
LA93:
    je LA94
    test_input_string "+="
    jne LA95
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 100
    jne terminate_program ; 100
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
    
LA95:
    
LA96:
    jne LA97
    
LA97:
    je LA94
    test_input_string "-="
    jne LA98
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 102
    jne terminate_program ; 102
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
    
LA98:
    
LA99:
    jne LA100
    mov esi, 104
    jne terminate_program ; 104
    
LA100:
    je LA94
    test_input_string "*="
    jne LA101
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 105
    jne terminate_program ; 105
    print "imul dword [ebp+"
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
    
LA101:
    
LA102:
    jne LA103
    
LA103:
    je LA94
    test_input_string "/="
    jne LA104
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 107
    jne terminate_program ; 107
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
    
LA104:
    
LA105:
    jne LA106
    
LA106:
    je LA94
    test_input_string "%="
    jne LA107
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 109
    jne terminate_program ; 109
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
    
LA107:
    
LA108:
    jne LA109
    mov esi, 112
    jne terminate_program ; 112
    
LA109:
    je LA94
    test_input_string "<<="
    jne LA110
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 113
    jne terminate_program ; 113
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
    
LA110:
    
LA111:
    jne LA112
    
LA112:
    je LA94
    test_input_string ">>="
    jne LA113
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 115
    jne terminate_program ; 115
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
    
LA113:
    
LA114:
    jne LA115
    mov esi, 117
    jne terminate_program ; 117
    
LA115:
    je LA94
    test_input_string "&="
    jne LA116
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 118
    jne terminate_program ; 118
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
    
LA116:
    
LA117:
    jne LA118
    
LA118:
    je LA94
    test_input_string "^="
    jne LA119
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 120
    jne terminate_program ; 120
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
    
LA119:
    
LA120:
    jne LA121
    
LA121:
    je LA94
    test_input_string "|="
    jne LA122
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 122
    jne terminate_program ; 122
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
    
LA122:
    
LA123:
    jne LA124
    
LA124:
    
LA94:
    je LA90
    call set_true
    mov esi, 124
    jne terminate_program ; 124
    
LA89:
    
LA125:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    jne LA126
    
LA127:
    test_input_string "?"
    jne LA128
    print "cmp eax, 0"
    call newline
    mov esi, 126
    jne terminate_program ; 126
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov esi, 128
    jne terminate_program ; 128
    mov esi, 129
    jne terminate_program ; 129
    print "jmp "
    call gn2
    call newline
    test_input_string ":"
    mov esi, 131
    jne terminate_program ; 131
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov esi, 132
    jne terminate_program ; 132
    call label
    call gn2
    print ":"
    call newline
    
LA128:
    
LA129:
    je LA127
    call set_true
    mov esi, 133
    jne terminate_program ; 133
    
LA126:
    
LA130:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA131
    
LA132:
    test_input_string "||"
    jne LA133
    call vstack_clear
    call EX3
    call vstack_restore
    mov esi, 134
    jne terminate_program ; 134
    print "or eax, ebx"
    call newline
    
LA133:
    
LA134:
    je LA132
    call set_true
    mov esi, 136
    jne terminate_program ; 136
    
LA131:
    
LA135:
    ret
    
EX3:
    call vstack_clear
    call EX4
    call vstack_restore
    jne LA136
    
LA137:
    test_input_string "&&"
    jne LA138
    call vstack_clear
    call EX4
    call vstack_restore
    mov esi, 137
    jne terminate_program ; 137
    print "and eax, ebx"
    call newline
    
LA138:
    
LA139:
    je LA137
    call set_true
    mov esi, 139
    jne terminate_program ; 139
    
LA136:
    
LA140:
    ret
    
EX4:
    call vstack_clear
    call EX5
    call vstack_restore
    jne LA141
    
LA142:
    test_input_string "|"
    jne LA143
    call vstack_clear
    call EX5
    call vstack_restore
    mov esi, 140
    jne terminate_program ; 140
    print "or eax, ebx"
    call newline
    
LA143:
    
LA144:
    je LA142
    call set_true
    mov esi, 142
    jne terminate_program ; 142
    
LA141:
    
LA145:
    ret
    
EX5:
    call vstack_clear
    call EX6
    call vstack_restore
    jne LA146
    
LA147:
    test_input_string "^"
    jne LA148
    call vstack_clear
    call EX6
    call vstack_restore
    mov esi, 143
    jne terminate_program ; 143
    print "xor eax, ebx"
    call newline
    
LA148:
    
LA149:
    je LA147
    call set_true
    mov esi, 145
    jne terminate_program ; 145
    
LA146:
    
LA150:
    ret
    
EX6:
    call vstack_clear
    call EX7
    call vstack_restore
    jne LA151
    
LA152:
    test_input_string "&"
    jne LA153
    call vstack_clear
    call EX7
    call vstack_restore
    mov esi, 146
    jne terminate_program ; 146
    print "and eax, ebx"
    call newline
    
LA153:
    
LA154:
    je LA152
    call set_true
    mov esi, 148
    jne terminate_program ; 148
    
LA151:
    
LA155:
    ret
    
EX7:
    call vstack_clear
    call EX8
    call vstack_restore
    jne LA156
    pushfd
    push eax
    push 0
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 149
    jne terminate_program ; 149
    
LA157:
    test_input_string "=="
    jne LA158
    pushfd
    push eax
    push 1
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 150
    jne terminate_program ; 150
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 151
    jne terminate_program ; 151
    print "cmp eax, ebx"
    call newline
    print "je "
    call gn1
    call newline
    print "mov eax, 1"
    call newline
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "mov eax, 0"
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA158:
    je LA159
    test_input_string "!="
    jne LA160
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 157
    jne terminate_program ; 157
    print "cmp eax, ebx"
    call newline
    print "jne "
    call gn1
    call newline
    print "mov eax, 1"
    call newline
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "mov eax, 0"
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA160:
    
LA159:
    je LA157
    call set_true
    mov esi, 163
    jne terminate_program ; 163
    
LA156:
    
LA161:
    ret
    
EX8:
    call vstack_clear
    call EX9
    call vstack_restore
    jne LA162
    
LA163:
    test_input_string "<="
    jne LA164
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 164
    jne terminate_program ; 164
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
    
LA164:
    je LA165
    test_input_string ">="
    jne LA166
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 170
    jne terminate_program ; 170
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
    
LA166:
    je LA165
    test_input_string "<"
    jne LA167
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 176
    jne terminate_program ; 176
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
    
LA167:
    je LA165
    test_input_string ">"
    jne LA168
    call vstack_clear
    call EX9
    call vstack_restore
    mov esi, 182
    jne terminate_program ; 182
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
    
LA168:
    
LA165:
    je LA163
    call set_true
    mov esi, 188
    jne terminate_program ; 188
    
LA162:
    
LA169:
    ret
    
EX9:
    call vstack_clear
    call EX10
    call vstack_restore
    jne LA170
    
LA171:
    test_input_string "<<"
    jne LA172
    call vstack_clear
    call EX10
    call vstack_restore
    mov esi, 189
    jne terminate_program ; 189
    print "shl eax, ebx"
    call newline
    
LA172:
    je LA173
    test_input_string ">>"
    jne LA174
    call vstack_clear
    call EX10
    call vstack_restore
    mov esi, 191
    jne terminate_program ; 191
    print "shr eax, ebx"
    call newline
    
LA174:
    
LA173:
    je LA171
    call set_true
    mov esi, 193
    jne terminate_program ; 193
    
LA170:
    
LA175:
    ret
    
EX10:
    call vstack_clear
    call EX11
    call vstack_restore
    jne LA176
    pushfd
    push eax
    push 0
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 194
    jne terminate_program ; 194
    
LA177:
    test_input_string "+"
    jne LA178
    pushfd
    push eax
    push 1
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 195
    jne terminate_program ; 195
    call vstack_clear
    call EX11
    call vstack_restore
    mov esi, 196
    jne terminate_program ; 196
    print "add eax, ebx"
    call newline
    
LA178:
    je LA179
    test_input_string "-"
    jne LA180
    call vstack_clear
    call EX11
    call vstack_restore
    mov esi, 198
    jne terminate_program ; 198
    print "sub eax, ebx"
    call newline
    
LA180:
    
LA179:
    je LA177
    call set_true
    mov esi, 200
    jne terminate_program ; 200
    
LA176:
    
LA181:
    ret
    
EX11:
    call vstack_clear
    call EX12
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
    mov esi, 201
    jne terminate_program ; 201
    
LA183:
    test_input_string "*"
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
    mov esi, 202
    jne terminate_program ; 202
    call vstack_clear
    call EX12
    call vstack_restore
    mov esi, 203
    jne terminate_program ; 203
    print "imul ebx"
    call newline
    
LA184:
    je LA185
    test_input_string "/"
    jne LA186
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
    print "idiv eax, ebx"
    call newline
    
LA186:
    je LA185
    test_input_string "%"
    jne LA187
    pushfd
    push eax
    push 1
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 208
    jne terminate_program ; 208
    call vstack_clear
    call EX12
    call vstack_restore
    mov esi, 209
    jne terminate_program ; 209
    print "idiv eax, ebx"
    call newline
    print "push edx"
    call newline
    
LA187:
    
LA185:
    je LA183
    call set_true
    mov esi, 212
    jne terminate_program ; 212
    
LA182:
    
LA188:
    ret
    
EX12:
    call vstack_clear
    call EX13
    call vstack_restore
    jne LA189
    pushfd
    push eax
    push 0
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 213
    jne terminate_program ; 213
    
LA190:
    test_input_string "**"
    jne LA191
    pushfd
    push eax
    push 1
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 214
    jne terminate_program ; 214
    call vstack_clear
    call EX12
    call vstack_restore
    mov esi, 215
    jne terminate_program ; 215
    print "exp"
    call newline
    
LA191:
    
LA192:
    je LA190
    call set_true
    mov esi, 217
    jne terminate_program ; 217
    
LA189:
    
LA193:
    ret
    
EX13:
    test_input_string "++"
    jne LA194
    call vstack_clear
    call EX14
    call vstack_restore
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
    
LA194:
    je LA195
    test_input_string "--"
    jne LA196
    call vstack_clear
    call EX14
    call vstack_restore
    mov esi, 222
    jne terminate_program ; 222
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
    mov esi, 226
    jne terminate_program ; 226
    
LA196:
    je LA195
    test_input_string "*"
    jne LA197
    call test_for_id
    mov esi, 227
    jne terminate_program ; 227
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
    mov esi, 230
    jne terminate_program ; 230
    
LA197:
    je LA195
    test_input_string "&"
    jne LA198
    call test_for_id
    mov esi, 231
    jne terminate_program ; 231
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
    
LA198:
    je LA195
    test_input_string "+"
    jne LA199
    call vstack_clear
    call EX14
    call vstack_restore
    mov esi, 233
    jne terminate_program ; 233
    
LA199:
    je LA195
    test_input_string "-"
    jne LA200
    call vstack_clear
    call EX14
    call vstack_restore
    mov esi, 234
    jne terminate_program ; 234
    print "neg eax"
    call newline
    
LA200:
    je LA195
    call vstack_clear
    call EX14
    call vstack_restore
    jne LA201
    
LA201:
    
LA195:
    ret
    
EX14:
    call test_for_id
    jne LA202
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 236
    jne terminate_program ; 236
    test_input_string "("
    jne LA203
    
LA204:
    call vstack_clear
    call FN_CALL_ARGUMENTS
    call vstack_restore
    je LA204
    call set_true
    mov esi, 237
    jne terminate_program ; 237
    test_input_string ")"
    mov esi, 238
    jne terminate_program ; 238
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA203:
    
LA205:
    jne LA206
    mov esi, 240
    jne terminate_program ; 240
    
LA206:
    je LA207
    test_input_string "++"
    jne LA208
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
    mov esi, 242
    jne terminate_program ; 242
    
LA208:
    je LA207
    test_input_string "--"
    jne LA209
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
    
LA209:
    je LA207
    call set_true
    jne LA210
    push dword [AEXP_SEC_NUM]
    pop eax
    cmp eax, 0
    jne LA211
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
    
LA211:
    je LA212
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
    
LA213:
    
LA212:
    mov esi, 246
    jne terminate_program ; 246
    
LA210:
    
LA207:
    mov esi, 247
    jne terminate_program ; 247
    
LA202:
    je LA214
    call test_for_number
    jne LA215
    push dword [AEXP_SEC_NUM]
    pop eax
    cmp eax, 0
    jne LA216
    print "mov eax, "
    call copy_last_match
    call newline
    
LA216:
    je LA217
    print "mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA218:
    
LA217:
    mov esi, 250
    jne terminate_program ; 250
    
LA215:
    je LA214
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
    push dword [AEXP_SEC_NUM]
    pop eax
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
    mov esi, 254
    jne terminate_program ; 254
    
LA223:
    
LA224:
    mov esi, 255
    jne terminate_program ; 255
    
LA219:
    je LA214
    test_input_string "("
    jne LA225
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 256
    jne terminate_program ; 256
    test_input_string ")"
    mov esi, 257
    jne terminate_program ; 257
    
LA225:
    
LA214:
    ret
    
BASIC_TYPE:
    test_input_string "i8"
    jne LA226
    print "; type: i8"
    call newline
    
LA226:
    je LA227
    test_input_string "i16"
    jne LA228
    print "; type: i16"
    call newline
    
LA228:
    je LA227
    test_input_string "i32"
    jne LA229
    print "; type: i32"
    call newline
    
LA229:
    je LA227
    test_input_string "i64"
    jne LA230
    print "; type: i64"
    call newline
    
LA230:
    je LA227
    test_input_string "u8"
    jne LA231
    print "; type: u8"
    call newline
    
LA231:
    je LA227
    test_input_string "u16"
    jne LA232
    print "; type: u16"
    call newline
    
LA232:
    je LA227
    test_input_string "u32"
    jne LA233
    print "; type: u32"
    call newline
    
LA233:
    je LA227
    test_input_string "u64"
    jne LA234
    print "; type: u64"
    call newline
    
LA234:
    je LA227
    test_input_string "f32"
    jne LA235
    print "; type: f32"
    call newline
    
LA235:
    je LA227
    test_input_string "f64"
    jne LA236
    print "; type: f64"
    call newline
    
LA236:
    je LA227
    test_input_string "bool"
    jne LA237
    print "; type: bool"
    call newline
    
LA237:
    je LA227
    test_input_string "char"
    jne LA238
    print "; type: char"
    call newline
    
LA238:
    
LA227:
    ret
    
UNION_TYPE:
    call vstack_clear
    call BASIC_TYPE
    call vstack_restore
    jne LA239
    
LA239:
    je LA240
    call vstack_clear
    call POINTER_TYPE
    call vstack_restore
    jne LA241
    
LA241:
    je LA240
    call vstack_clear
    call DEREFERENCE_TYPE
    call vstack_restore
    jne LA242
    
LA242:
    je LA240
    call vstack_clear
    call FN_TYPE
    call vstack_restore
    jne LA243
    
LA243:
    je LA240
    test_input_string "("
    jne LA244
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 270
    jne terminate_program ; 270
    test_input_string ")"
    mov esi, 271
    jne terminate_program ; 271
    
LA244:
    
LA245:
    jne LA246
    
LA246:
    je LA240
    call test_for_id
    jne LA247
    print "; type: "
    call copy_last_match
    print " (alias)"
    call newline
    
LA247:
    
LA248:
    jne LA249
    
LA249:
    je LA240
    call vstack_clear
    call ARRAY_TYPE
    call vstack_restore
    jne LA250
    
LA250:
    
LA240:
    jne LA251
    
LA252:
    test_input_string "|"
    jne LA253
    print "; or"
    call newline
    call vstack_clear
    call BASIC_TYPE
    call vstack_restore
    jne LA254
    
LA254:
    je LA255
    call vstack_clear
    call POINTER_TYPE
    call vstack_restore
    jne LA256
    
LA256:
    je LA255
    call vstack_clear
    call DEREFERENCE_TYPE
    call vstack_restore
    jne LA257
    
LA257:
    je LA255
    call vstack_clear
    call FN_TYPE
    call vstack_restore
    jne LA258
    
LA258:
    je LA255
    test_input_string "("
    jne LA259
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 274
    jne terminate_program ; 274
    test_input_string ")"
    mov esi, 275
    jne terminate_program ; 275
    
LA259:
    
LA260:
    jne LA261
    
LA261:
    je LA255
    call test_for_id
    jne LA262
    print "; type: "
    call copy_last_match
    print " (alias)"
    call newline
    
LA262:
    
LA263:
    jne LA264
    
LA264:
    je LA255
    call vstack_clear
    call ARRAY_TYPE
    call vstack_restore
    jne LA265
    
LA265:
    
LA255:
    mov esi, 277
    jne terminate_program ; 277
    
LA253:
    
LA266:
    je LA252
    call set_true
    mov esi, 278
    jne terminate_program ; 278
    
LA251:
    
LA267:
    ret
    
POINTER_TYPE:
    test_input_string "*"
    jne LA268
    print "; pointer"
    call newline
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 280
    jne terminate_program ; 280
    
LA268:
    
LA269:
    ret
    
DEREFERENCE_TYPE:
    test_input_string "&"
    jne LA270
    print "; dereference"
    call newline
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 282
    jne terminate_program ; 282
    
LA270:
    
LA271:
    ret
    
FN_TYPE:
    test_input_string "fn"
    jne LA272
    print "; fn type"
    call newline
    test_input_string "<"
    jne LA273
    print "; is generic"
    call newline
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 285
    jne terminate_program ; 285
    test_input_string ">"
    mov esi, 286
    jne terminate_program ; 286
    
LA273:
    je LA274
    call set_true
    jne LA275
    
LA275:
    
LA274:
    mov esi, 287
    jne terminate_program ; 287
    test_input_string "("
    mov esi, 288
    jne terminate_program ; 288
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    jne LA276
    print "; input"
    call newline
    
LA277:
    test_input_string ","
    jne LA278
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 290
    jne terminate_program ; 290
    print "; input"
    call newline
    
LA278:
    
LA279:
    je LA277
    call set_true
    mov esi, 292
    jne terminate_program ; 292
    
LA276:
    je LA280
    call set_true
    jne LA281
    
LA281:
    
LA280:
    mov esi, 293
    jne terminate_program ; 293
    test_input_string ")"
    mov esi, 294
    jne terminate_program ; 294
    test_input_string "->"
    mov esi, 295
    jne terminate_program ; 295
    print "; output"
    call newline
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 297
    jne terminate_program ; 297
    
LA272:
    
LA282:
    ret
    
ARRAY_TYPE:
    test_input_string "["
    jne LA283
    call vstack_clear
    call UNION_TYPE
    call vstack_restore
    jne LA284
    
LA284:
    je LA285
    call vstack_clear
    call POINTER_TYPE
    call vstack_restore
    jne LA286
    
LA286:
    je LA285
    call vstack_clear
    call DEREFERENCE_TYPE
    call vstack_restore
    jne LA287
    
LA287:
    je LA285
    call vstack_clear
    call BASIC_TYPE
    call vstack_restore
    jne LA288
    
LA288:
    je LA285
    call vstack_clear
    call FN_TYPE
    call vstack_restore
    jne LA289
    
LA289:
    
LA285:
    mov esi, 298
    jne terminate_program ; 298
    test_input_string ";"
    mov esi, 299
    jne terminate_program ; 299
    call test_for_number
    jne LA290
    
LA290:
    je LA291
    test_input_string "*"
    jne LA292
    
LA292:
    
LA291:
    mov esi, 300
    jne terminate_program ; 300
    test_input_string "]"
    mov esi, 301
    jne terminate_program ; 301
    
LA283:
    
LA293:
    jne LA294
    
LA294:
    je LA295
    call vstack_clear
    call UNION_TYPE
    call vstack_restore
    jne LA296
    
LA296:
    je LA297
    call vstack_clear
    call BASIC_TYPE
    call vstack_restore
    jne LA298
    
LA298:
    je LA297
    call vstack_clear
    call FN_TYPE
    call vstack_restore
    jne LA299
    
LA299:
    
LA297:
    jne LA300
    test_input_string "["
    mov esi, 302
    jne terminate_program ; 302
    call test_for_number
    jne LA301
    
LA301:
    je LA302
    test_input_string "*"
    jne LA303
    
LA303:
    je LA302
    call set_true
    jne LA304
    
LA304:
    
LA302:
    mov esi, 303
    jne terminate_program ; 303
    test_input_string "]"
    mov esi, 304
    jne terminate_program ; 304
    
LA300:
    
LA305:
    jne LA306
    
LA306:
    
LA295:
    ret
    
COMPLEX_TYPE:
    call vstack_clear
    call UNION_TYPE
    call vstack_restore
    jne LA307
    
LA307:
    je LA308
    call vstack_clear
    call POINTER_TYPE
    call vstack_restore
    jne LA309
    
LA309:
    je LA308
    call vstack_clear
    call DEREFERENCE_TYPE
    call vstack_restore
    jne LA310
    
LA310:
    je LA308
    call vstack_clear
    call BASIC_TYPE
    call vstack_restore
    jne LA311
    
LA311:
    je LA308
    call vstack_clear
    call FN_TYPE
    call vstack_restore
    jne LA312
    
LA312:
    je LA308
    test_input_string "("
    jne LA313
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 305
    jne terminate_program ; 305
    test_input_string ")"
    mov esi, 306
    jne terminate_program ; 306
    
LA313:
    
LA314:
    jne LA315
    
LA315:
    je LA308
    call test_for_id
    jne LA316
    print "; type: "
    call copy_last_match
    print " (alias)"
    call newline
    
LA316:
    
LA317:
    jne LA318
    
LA318:
    je LA308
    call vstack_clear
    call ARRAY_TYPE
    call vstack_restore
    jne LA319
    
LA319:
    
LA308:
    ret
    
TYPE_ANNOTATION:
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    jne LA320
    
LA320:
    
LA321:
    ret
    
TYPE_EXPRESSION:
    test_input_string "type"
    jne LA322
    call test_for_id
    mov esi, 308
    jne terminate_program ; 308
    print "; define type "
    call copy_last_match
    call newline
    test_input_string "="
    mov esi, 310
    jne terminate_program ; 310
    call vstack_clear
    call COMPLEX_TYPE
    call vstack_restore
    mov esi, 311
    jne terminate_program ; 311
    
LA322:
    
LA323:
    ret
    
ENUM_EXPRESSION:
    test_input_string "enum"
    jne LA324
    call test_for_id
    mov esi, 312
    jne terminate_program ; 312
    print "; define enum "
    call copy_last_match
    call newline
    test_input_string "{"
    mov esi, 314
    jne terminate_program ; 314
    call test_for_id
    jne LA325
    print "; enum value "
    call copy_last_match
    call newline
    
LA325:
    je LA326
    call set_true
    jne LA327
    
LA327:
    
LA326:
    mov esi, 316
    jne terminate_program ; 316
    
LA328:
    test_input_string ","
    jne LA329
    call test_for_id
    mov esi, 317
    jne terminate_program ; 317
    print "; enum value "
    call copy_last_match
    call newline
    
LA329:
    
LA330:
    je LA328
    call set_true
    mov esi, 319
    jne terminate_program ; 319
    test_input_string "}"
    mov esi, 320
    jne terminate_program ; 320
    
LA324:
    
LA331:
    ret
    
DIRECT_ASSEMBLY_EXPRESSION:
    test_input_string "asm"
    jne LA332
    call test_for_string_raw
    mov esi, 321
    jne terminate_program ; 321
    call copy_last_match
    call newline
    
LA332:
    
LA333:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA334
    match_not 10
    mov esi, 323
    jne terminate_program ; 323
    
LA334:
    
LA335:
    ret
    
IF_STATEMENT:
    test_input_string "if"
    jne LA336
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
    print "cmp eax, 0"
    call newline
    print "je "
    call gn1
    call newline
    test_input_string "{"
    mov esi, 329
    jne terminate_program ; 329
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 330
    jne terminate_program ; 330
    test_input_string "}"
    mov esi, 331
    jne terminate_program ; 331
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA337:
    call vstack_clear
    call ELIF
    call vstack_restore
    jne LA338
    
LA338:
    
LA339:
    je LA337
    call set_true
    mov esi, 333
    jne terminate_program ; 333
    
LA340:
    call vstack_clear
    call ELSE
    call vstack_restore
    jne LA341
    
LA341:
    
LA342:
    je LA340
    call set_true
    mov esi, 334
    jne terminate_program ; 334
    call label
    call gn2
    print ":"
    call newline
    
LA336:
    
LA343:
    ret
    
ELIF:
    test_input_string "elif"
    jne LA344
    test_input_string "("
    mov esi, 335
    jne terminate_program ; 335
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 336
    jne terminate_program ; 336
    test_input_string ")"
    mov esi, 337
    jne terminate_program ; 337
    print "cmp eax, 0"
    call newline
    print "jne "
    call gn1
    call newline
    test_input_string "{"
    mov esi, 340
    jne terminate_program ; 340
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 341
    jne terminate_program ; 341
    test_input_string "}"
    mov esi, 342
    jne terminate_program ; 342
    call label
    call gn1
    print ":"
    call newline
    
LA344:
    
LA345:
    ret
    
ELSE:
    test_input_string "else"
    jne LA346
    test_input_string "{"
    mov esi, 343
    jne terminate_program ; 343
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 344
    jne terminate_program ; 344
    test_input_string "}"
    mov esi, 345
    jne terminate_program ; 345
    
LA346:
    
LA347:
    ret
    
LET_EXPRESSION:
    test_input_string "let"
    jne LA348
    call test_for_id
    mov esi, 346
    jne terminate_program ; 346
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
    mov esi, 347
    jne terminate_program ; 347
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
    mov esi, 348
    jne terminate_program ; 348
    test_input_string ":"
    jne LA349
    call vstack_clear
    call TYPE_ANNOTATION
    call vstack_restore
    mov esi, 349
    jne terminate_program ; 349
    
LA349:
    je LA350
    call set_true
    jne LA351
    
LA351:
    
LA350:
    mov esi, 350
    jne terminate_program ; 350
    test_input_string "="
    mov esi, 351
    jne terminate_program ; 351
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 352
    jne terminate_program ; 352
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
    
LA348:
    
LA352:
    ret
    
WHILE_STATEMENT:
    test_input_string "while"
    jne LA353
    call label
    call gn2
    print ":"
    call newline
    test_input_string "("
    mov esi, 354
    jne terminate_program ; 354
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 355
    jne terminate_program ; 355
    test_input_string ")"
    mov esi, 356
    jne terminate_program ; 356
    test_input_string "{"
    mov esi, 357
    jne terminate_program ; 357
    print "cmp eax, 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call BODY
    call vstack_restore
    mov esi, 360
    jne terminate_program ; 360
    test_input_string "}"
    mov esi, 361
    jne terminate_program ; 361
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA353:
    
LA354:
    ret
    
RETURN_EXPRESSION:
    test_input_string "return"
    jne LA355
    pushfd
    push eax
    push 0
    pop eax
    mov [AEXP_SEC_NUM], eax
    push eax
    pop edi
    pop eax
    popfd
    mov esi, 363
    jne terminate_program ; 363
    call vstack_clear
    call AEXP
    call vstack_restore
    mov esi, 364
    jne terminate_program ; 364
    
LA355:
    
LA356:
    ret
    
