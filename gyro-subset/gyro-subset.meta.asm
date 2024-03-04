
%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .bss
    last_match resb 512
    
section .bss
    ST resb 65536
    
section .data
    STO dd 12
    
section .data
    VAR_IN_BODY dd 0
    
section .data
    AEXP_SEC_NUM dd 0
    
section .data
    EAX_WAS_NUMBER dd 0
    
section .data
    EBX_WAS_NUMBER dd 0
    
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
    call LET_EXPRESSION
    call vstack_restore
    jne LA2
    test_input_string ";"
    mov edi, 3
    jne terminate_program ; 3
    
LA2:
    je LA3
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA4
    
LA4:
    je LA3
    call vstack_clear
    call FN_EXPRESSION
    call vstack_restore
    jne LA5
    
LA5:
    je LA3
    call vstack_clear
    call DIRECT_ASSEMBLY_EXPRESSION
    call vstack_restore
    jne LA6
    test_input_string ";"
    mov edi, 4
    jne terminate_program ; 4
    
LA6:
    je LA3
    call vstack_clear
    call FN_CALL
    call vstack_restore
    jne LA7
    test_input_string ";"
    mov edi, 5
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
    je LA3
    call vstack_clear
    call ASSIGNMENT_EXPRESSION
    call vstack_restore
    jne LA10
    
LA10:
    
LA3:
    je LA1
    call set_true
    mov edi, 6
    jne terminate_program ; 6
    print "pop ebp"
    call newline
    print "mov eax, 1"
    call newline
    print "mov ebx, 0"
    call newline
    print "int 0x80"
    call newline
    
LA11:
    
LA12:
    ret
    
FN_EXPRESSION:
    test_input_string "fn"
    jne LA13
    print "jmp "
    call gn1
    call newline
    call test_for_id
    mov edi, 12
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
    mov edi, 15
    jne terminate_program ; 15
    
LA14:
    call test_for_id
    jne LA15
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
    mov edi, 16
    jne terminate_program ; 16
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
    mov edi, 17
    jne terminate_program ; 17
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], edi"
    call newline
    
LA15:
    
LA16:
    je LA14
    call set_true
    mov edi, 19
    jne terminate_program ; 19
    
LA17:
    test_input_string ","
    jne LA18
    call test_for_id
    mov edi, 20
    jne terminate_program ; 20
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
    mov edi, 21
    jne terminate_program ; 21
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
    mov edi, 22
    jne terminate_program ; 22
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], esi"
    call newline
    
LA18:
    
LA19:
    jne LA20
    
LA21:
    test_input_string ","
    jne LA22
    call test_for_id
    mov edi, 24
    jne terminate_program ; 24
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
    mov edi, 25
    jne terminate_program ; 25
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
    mov edi, 26
    jne terminate_program ; 26
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], edx"
    call newline
    
LA23:
    test_input_string ","
    jne LA24
    call test_for_id
    mov edi, 28
    jne terminate_program ; 28
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
    mov edi, 29
    jne terminate_program ; 29
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
    mov edi, 30
    jne terminate_program ; 30
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], ecx"
    call newline
    
LA25:
    test_input_string ","
    jne LA26
    call test_for_id
    mov edi, 32
    jne terminate_program ; 32
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
    mov edi, 33
    jne terminate_program ; 33
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
    mov edi, 34
    jne terminate_program ; 34
    
LA26:
    
LA27:
    je LA25
    call set_true
    mov edi, 35
    jne terminate_program ; 35
    
LA24:
    
LA28:
    je LA23
    call set_true
    mov edi, 36
    jne terminate_program ; 36
    
LA22:
    
LA29:
    je LA21
    call set_true
    mov edi, 37
    jne terminate_program ; 37
    
LA20:
    
LA30:
    je LA17
    call set_true
    mov edi, 38
    jne terminate_program ; 38
    test_input_string ")"
    mov edi, 39
    jne terminate_program ; 39
    test_input_string "{"
    mov edi, 40
    jne terminate_program ; 40
    call vstack_clear
    call BODY
    call vstack_restore
    mov edi, 41
    jne terminate_program ; 41
    test_input_string "}"
    mov edi, 42
    jne terminate_program ; 42
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
    mov edi, 43
    jne terminate_program ; 43
    print "pop ebp"
    call newline
    print "ret"
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA13:
    
LA31:
    ret
    
BODY:
    
LA32:
    call vstack_clear
    call RETURN_EXPRESSION
    call vstack_restore
    jne LA33
    test_input_string ";"
    mov edi, 46
    jne terminate_program ; 46
    
LA33:
    je LA34
    call vstack_clear
    call IF_STATEMENT
    call vstack_restore
    jne LA35
    
LA35:
    je LA34
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA36
    
LA36:
    je LA34
    call vstack_clear
    call WHILE_STATEMENT
    call vstack_restore
    jne LA37
    
LA37:
    je LA34
    call vstack_clear
    call LET_EXPRESSION
    call vstack_restore
    jne LA38
    test_input_string ";"
    mov edi, 47
    jne terminate_program ; 47
    
LA38:
    je LA34
    call vstack_clear
    call DIRECT_ASSEMBLY_EXPRESSION
    call vstack_restore
    jne LA39
    test_input_string ";"
    mov edi, 48
    jne terminate_program ; 48
    
LA39:
    je LA34
    call vstack_clear
    call FN_CALL
    call vstack_restore
    jne LA40
    test_input_string ";"
    mov edi, 49
    jne terminate_program ; 49
    
LA40:
    je LA34
    call vstack_clear
    call FN_EXPRESSION
    call vstack_restore
    jne LA41
    
LA41:
    je LA34
    call vstack_clear
    call ASSIGNMENT_EXPRESSION
    call vstack_restore
    jne LA42
    
LA42:
    
LA34:
    je LA32
    call set_true
    jne LA43
    
LA43:
    
LA44:
    ret
    
FN_CALL:
    call test_for_id
    jne LA45
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 50
    jne terminate_program ; 50
    test_input_string "("
    mov edi, 51
    jne terminate_program ; 51
    call vstack_clear
    call FN_CALL_ARGUMENTS
    call vstack_restore
    mov edi, 52
    jne terminate_program ; 52
    test_input_string ")"
    mov edi, 53
    jne terminate_program ; 53
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA45:
    
LA46:
    ret
    
FN_CALL_ARGUMENTS:
    
LA47:
    call test_for_number
    jne LA48
    print "mov edi, "
    call copy_last_match
    call newline
    
LA48:
    je LA49
    call test_for_id
    jne LA50
    print "mov edi, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "]"
    call newline
    
LA50:
    je LA49
    test_input_string "*"
    jne LA51
    call test_for_id
    mov edi, 57
    jne terminate_program ; 57
    print "mov edi, dword ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    call newline
    
LA51:
    je LA49
    call test_for_string
    jne LA52
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
    
LA52:
    
LA49:
    je LA47
    call set_true
    jne LA53
    
LA54:
    test_input_string ","
    jne LA55
    call test_for_number
    jne LA56
    print "mov esi, "
    call copy_last_match
    call newline
    
LA56:
    je LA57
    call test_for_id
    jne LA58
    print "mov esi, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "]"
    call newline
    
LA58:
    je LA57
    test_input_string "*"
    jne LA59
    call test_for_id
    mov edi, 63
    jne terminate_program ; 63
    print "mov esi, dword ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    call newline
    
LA59:
    je LA57
    call test_for_string
    jne LA60
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
    
LA60:
    
LA57:
    mov edi, 67
    jne terminate_program ; 67
    
LA61:
    test_input_string ","
    jne LA62
    call test_for_number
    jne LA63
    print "mov edx, "
    call copy_last_match
    call newline
    
LA63:
    je LA64
    call test_for_id
    jne LA65
    print "mov edx, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "]"
    call newline
    
LA65:
    je LA64
    test_input_string "*"
    jne LA66
    call test_for_id
    mov edi, 70
    jne terminate_program ; 70
    print "mov edx, dword ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    call newline
    
LA66:
    je LA64
    call test_for_string
    jne LA67
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
    
LA67:
    
LA64:
    mov edi, 74
    jne terminate_program ; 74
    
LA68:
    test_input_string ","
    jne LA69
    call test_for_number
    jne LA70
    print "mov ecx, "
    call copy_last_match
    call newline
    
LA70:
    je LA71
    call test_for_id
    jne LA72
    print "mov ecx, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "]"
    call newline
    
LA72:
    je LA71
    test_input_string "*"
    jne LA73
    call test_for_id
    mov edi, 77
    jne terminate_program ; 77
    print "mov ecx, dword ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    call newline
    
LA73:
    je LA71
    call test_for_string
    jne LA74
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
    
LA74:
    
LA71:
    mov edi, 81
    jne terminate_program ; 81
    
LA75:
    test_input_string ","
    jne LA76
    call test_for_number
    jne LA77
    print "push "
    call copy_last_match
    call newline
    
LA77:
    je LA78
    call test_for_id
    jne LA79
    print "push ["
    call copy_last_match
    print "]"
    call newline
    
LA79:
    je LA78
    test_input_string "*"
    jne LA80
    print "push "
    call copy_last_match
    call newline
    
LA80:
    je LA78
    call test_for_string
    jne LA81
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
    
LA81:
    
LA78:
    mov edi, 87
    jne terminate_program ; 87
    
LA76:
    
LA82:
    je LA75
    call set_true
    mov edi, 88
    jne terminate_program ; 88
    
LA69:
    
LA83:
    je LA68
    call set_true
    mov edi, 89
    jne terminate_program ; 89
    
LA62:
    
LA84:
    je LA61
    call set_true
    mov edi, 90
    jne terminate_program ; 90
    
LA55:
    
LA85:
    je LA54
    call set_true
    mov edi, 91
    jne terminate_program ; 91
    
LA53:
    
LA86:
    ret
    
AEXP:
    call vstack_clear
    call EX1
    call vstack_restore
    jne LA87
    pushfd
    push eax
    mov eax, 0
    mov dword [AEXP_SEC_NUM], eax
    pop eax
    popfd
    mov edi, 92
    jne terminate_program ; 92
    
LA88:
    test_input_string "="
    jne LA89
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 93
    jne terminate_program ; 93
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "], eax"
    call newline
    
LA89:
    
LA90:
    jne LA91
    mov edi, 95
    jne terminate_program ; 95
    mov edi, 96
    jne terminate_program ; 96
    mov edi, 97
    jne terminate_program ; 97
    
LA91:
    je LA92
    test_input_string "+="
    jne LA93
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 98
    jne terminate_program ; 98
    print "add dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "], eax"
    call newline
    
LA93:
    
LA94:
    jne LA95
    
LA95:
    je LA92
    test_input_string "-="
    jne LA96
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 100
    jne terminate_program ; 100
    print "sub dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "], eax"
    call newline
    
LA96:
    
LA97:
    jne LA98
    mov edi, 102
    jne terminate_program ; 102
    
LA98:
    je LA92
    test_input_string "*="
    jne LA99
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 103
    jne terminate_program ; 103
    print "imul dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "]"
    call newline
    
LA99:
    
LA100:
    jne LA101
    
LA101:
    je LA92
    test_input_string "/="
    jne LA102
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 105
    jne terminate_program ; 105
    print "idiv dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "], eax"
    call newline
    
LA102:
    
LA103:
    jne LA104
    
LA104:
    je LA92
    test_input_string "%="
    jne LA105
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 107
    jne terminate_program ; 107
    print "idiv dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "], eax"
    call newline
    print "push edx"
    call newline
    
LA105:
    
LA106:
    jne LA107
    mov edi, 110
    jne terminate_program ; 110
    
LA107:
    je LA92
    test_input_string "<<="
    jne LA108
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 111
    jne terminate_program ; 111
    print "shl dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "], eax"
    call newline
    
LA108:
    
LA109:
    jne LA110
    
LA110:
    je LA92
    test_input_string ">>="
    jne LA111
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 113
    jne terminate_program ; 113
    print "shr dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "], eax"
    call newline
    
LA111:
    
LA112:
    jne LA113
    mov edi, 115
    jne terminate_program ; 115
    
LA113:
    je LA92
    test_input_string "&="
    jne LA114
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 116
    jne terminate_program ; 116
    print "and dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "], eax"
    call newline
    
LA114:
    
LA115:
    jne LA116
    
LA116:
    je LA92
    test_input_string "^="
    jne LA117
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 118
    jne terminate_program ; 118
    print "xor dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "], eax"
    call newline
    
LA117:
    
LA118:
    jne LA119
    
LA119:
    je LA92
    test_input_string "|="
    jne LA120
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 120
    jne terminate_program ; 120
    print "or dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "], eax"
    call newline
    
LA120:
    
LA121:
    jne LA122
    
LA122:
    
LA92:
    je LA88
    call set_true
    mov edi, 122
    jne terminate_program ; 122
    
LA87:
    
LA123:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    jne LA124
    
LA125:
    test_input_string "?"
    jne LA126
    print "cmp eax, 0"
    call newline
    mov edi, 124
    jne terminate_program ; 124
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov edi, 126
    jne terminate_program ; 126
    mov edi, 127
    jne terminate_program ; 127
    print "jmp "
    call gn2
    call newline
    test_input_string ":"
    mov edi, 129
    jne terminate_program ; 129
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov edi, 130
    jne terminate_program ; 130
    call label
    call gn2
    print ":"
    call newline
    
LA126:
    
LA127:
    je LA125
    call set_true
    mov edi, 131
    jne terminate_program ; 131
    
LA124:
    
LA128:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA129
    
LA130:
    test_input_string "||"
    jne LA131
    call vstack_clear
    call EX3
    call vstack_restore
    mov edi, 132
    jne terminate_program ; 132
    print "or eax, ebx"
    call newline
    
LA131:
    
LA132:
    je LA130
    call set_true
    mov edi, 134
    jne terminate_program ; 134
    
LA129:
    
LA133:
    ret
    
EX3:
    call vstack_clear
    call EX4
    call vstack_restore
    jne LA134
    
LA135:
    test_input_string "&&"
    jne LA136
    call vstack_clear
    call EX4
    call vstack_restore
    mov edi, 135
    jne terminate_program ; 135
    print "and eax, ebx"
    call newline
    
LA136:
    
LA137:
    je LA135
    call set_true
    mov edi, 137
    jne terminate_program ; 137
    
LA134:
    
LA138:
    ret
    
EX4:
    call vstack_clear
    call EX5
    call vstack_restore
    jne LA139
    
LA140:
    test_input_string "|"
    jne LA141
    call vstack_clear
    call EX5
    call vstack_restore
    mov edi, 138
    jne terminate_program ; 138
    print "or eax, ebx"
    call newline
    
LA141:
    
LA142:
    je LA140
    call set_true
    mov edi, 140
    jne terminate_program ; 140
    
LA139:
    
LA143:
    ret
    
EX5:
    call vstack_clear
    call EX6
    call vstack_restore
    jne LA144
    
LA145:
    test_input_string "^"
    jne LA146
    call vstack_clear
    call EX6
    call vstack_restore
    mov edi, 141
    jne terminate_program ; 141
    print "xor eax, ebx"
    call newline
    
LA146:
    
LA147:
    je LA145
    call set_true
    mov edi, 143
    jne terminate_program ; 143
    
LA144:
    
LA148:
    ret
    
EX6:
    call vstack_clear
    call EX7
    call vstack_restore
    jne LA149
    
LA150:
    test_input_string "&"
    jne LA151
    call vstack_clear
    call EX7
    call vstack_restore
    mov edi, 144
    jne terminate_program ; 144
    print "and eax, ebx"
    call newline
    
LA151:
    
LA152:
    je LA150
    call set_true
    mov edi, 146
    jne terminate_program ; 146
    
LA149:
    
LA153:
    ret
    
EX7:
    call vstack_clear
    call EX8
    call vstack_restore
    jne LA154
    pushfd
    push eax
    mov eax, 0
    mov dword [AEXP_SEC_NUM], eax
    pop eax
    popfd
    mov edi, 147
    jne terminate_program ; 147
    
LA155:
    test_input_string "=="
    jne LA156
    pushfd
    push eax
    mov eax, 1
    mov dword [AEXP_SEC_NUM], eax
    pop eax
    popfd
    mov edi, 148
    jne terminate_program ; 148
    call vstack_clear
    call EX9
    call vstack_restore
    mov edi, 149
    jne terminate_program ; 149
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
    
LA156:
    je LA157
    test_input_string "!="
    jne LA158
    call vstack_clear
    call EX9
    call vstack_restore
    mov edi, 155
    jne terminate_program ; 155
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
    
LA158:
    
LA157:
    je LA155
    call set_true
    mov edi, 161
    jne terminate_program ; 161
    
LA154:
    
LA159:
    ret
    
EX8:
    call vstack_clear
    call EX9
    call vstack_restore
    jne LA160
    
LA161:
    test_input_string "<="
    jne LA162
    call vstack_clear
    call EX9
    call vstack_restore
    mov edi, 162
    jne terminate_program ; 162
    print "cmp eax, ebx"
    call newline
    print "jle "
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
    
LA162:
    je LA163
    test_input_string ">="
    jne LA164
    call vstack_clear
    call EX9
    call vstack_restore
    mov edi, 168
    jne terminate_program ; 168
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
    
LA164:
    je LA163
    test_input_string "<"
    jne LA165
    call vstack_clear
    call EX9
    call vstack_restore
    mov edi, 174
    jne terminate_program ; 174
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
    
LA165:
    je LA163
    test_input_string ">"
    jne LA166
    call vstack_clear
    call EX9
    call vstack_restore
    mov edi, 180
    jne terminate_program ; 180
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
    
LA166:
    
LA163:
    je LA161
    call set_true
    mov edi, 186
    jne terminate_program ; 186
    
LA160:
    
LA167:
    ret
    
EX9:
    call vstack_clear
    call EX10
    call vstack_restore
    jne LA168
    
LA169:
    test_input_string "<<"
    jne LA170
    call vstack_clear
    call EX10
    call vstack_restore
    mov edi, 187
    jne terminate_program ; 187
    print "shl eax, ebx"
    call newline
    
LA170:
    je LA171
    test_input_string ">>"
    jne LA172
    call vstack_clear
    call EX10
    call vstack_restore
    mov edi, 189
    jne terminate_program ; 189
    print "shr eax, ebx"
    call newline
    
LA172:
    
LA171:
    je LA169
    call set_true
    mov edi, 191
    jne terminate_program ; 191
    
LA168:
    
LA173:
    ret
    
EX10:
    call vstack_clear
    call EX11
    call vstack_restore
    jne LA174
    pushfd
    push eax
    mov eax, 0
    mov dword [AEXP_SEC_NUM], eax
    pop eax
    popfd
    mov edi, 192
    jne terminate_program ; 192
    
LA175:
    test_input_string "+"
    jne LA176
    pushfd
    push eax
    mov eax, 1
    mov dword [AEXP_SEC_NUM], eax
    pop eax
    popfd
    mov edi, 193
    jne terminate_program ; 193
    call vstack_clear
    call EX11
    call vstack_restore
    mov edi, 194
    jne terminate_program ; 194
    print "add eax, ebx"
    call newline
    
LA176:
    je LA177
    test_input_string "-"
    jne LA178
    call vstack_clear
    call EX11
    call vstack_restore
    mov edi, 196
    jne terminate_program ; 196
    print "sub eax, ebx"
    call newline
    
LA178:
    
LA177:
    je LA175
    call set_true
    mov edi, 198
    jne terminate_program ; 198
    
LA174:
    
LA179:
    ret
    
EX11:
    call vstack_clear
    call EX12
    call vstack_restore
    jne LA180
    pushfd
    push eax
    mov eax, 0
    mov dword [AEXP_SEC_NUM], eax
    pop eax
    popfd
    mov edi, 199
    jne terminate_program ; 199
    
LA181:
    test_input_string "*"
    jne LA182
    pushfd
    push eax
    mov eax, 1
    mov dword [AEXP_SEC_NUM], eax
    pop eax
    popfd
    mov edi, 200
    jne terminate_program ; 200
    call vstack_clear
    call EX12
    call vstack_restore
    mov edi, 201
    jne terminate_program ; 201
    print "imul ebx"
    call newline
    
LA182:
    je LA183
    test_input_string "/"
    jne LA184
    pushfd
    push eax
    mov eax, 1
    mov dword [AEXP_SEC_NUM], eax
    pop eax
    popfd
    mov edi, 203
    jne terminate_program ; 203
    call vstack_clear
    call EX12
    call vstack_restore
    mov edi, 204
    jne terminate_program ; 204
    print "idiv eax, ebx"
    call newline
    
LA184:
    je LA183
    test_input_string "%"
    jne LA185
    pushfd
    push eax
    mov eax, 1
    mov dword [AEXP_SEC_NUM], eax
    pop eax
    popfd
    mov edi, 206
    jne terminate_program ; 206
    call vstack_clear
    call EX12
    call vstack_restore
    mov edi, 207
    jne terminate_program ; 207
    print "idiv eax, ebx"
    call newline
    print "push edx"
    call newline
    
LA185:
    
LA183:
    je LA181
    call set_true
    mov edi, 210
    jne terminate_program ; 210
    
LA180:
    
LA186:
    ret
    
EX12:
    call vstack_clear
    call EX13
    call vstack_restore
    jne LA187
    pushfd
    push eax
    mov eax, 0
    mov dword [AEXP_SEC_NUM], eax
    pop eax
    popfd
    mov edi, 211
    jne terminate_program ; 211
    
LA188:
    test_input_string "**"
    jne LA189
    pushfd
    push eax
    mov eax, 1
    mov dword [AEXP_SEC_NUM], eax
    pop eax
    popfd
    mov edi, 212
    jne terminate_program ; 212
    call vstack_clear
    call EX12
    call vstack_restore
    mov edi, 213
    jne terminate_program ; 213
    print "exp"
    call newline
    
LA189:
    
LA190:
    je LA188
    call set_true
    mov edi, 215
    jne terminate_program ; 215
    
LA187:
    
LA191:
    ret
    
EX13:
    test_input_string "++"
    jne LA192
    call vstack_clear
    call EX14
    call vstack_restore
    mov edi, 216
    jne terminate_program ; 216
    print "mov eax, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "]"
    call newline
    print "inc eax"
    call newline
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "], eax"
    call newline
    
LA192:
    je LA193
    test_input_string "--"
    jne LA194
    call vstack_clear
    call EX14
    call vstack_restore
    mov edi, 220
    jne terminate_program ; 220
    print "mov eax, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "]"
    call newline
    print "dec eax"
    call newline
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "], eax"
    call newline
    mov edi, 224
    jne terminate_program ; 224
    
LA194:
    je LA193
    test_input_string "*"
    jne LA195
    call test_for_id
    mov edi, 225
    jne terminate_program ; 225
    print "mov eax, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "]"
    call newline
    print "mov eax, dword [eax]"
    call newline
    mov edi, 228
    jne terminate_program ; 228
    
LA195:
    je LA193
    test_input_string "&"
    jne LA196
    call test_for_id
    mov edi, 229
    jne terminate_program ; 229
    print "lea eax, [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "]"
    call newline
    
LA196:
    je LA193
    test_input_string "+"
    jne LA197
    call vstack_clear
    call EX14
    call vstack_restore
    mov edi, 231
    jne terminate_program ; 231
    
LA197:
    je LA193
    test_input_string "-"
    jne LA198
    call vstack_clear
    call EX14
    call vstack_restore
    mov edi, 232
    jne terminate_program ; 232
    print "neg eax"
    call newline
    
LA198:
    je LA193
    call vstack_clear
    call EX14
    call vstack_restore
    jne LA199
    
LA199:
    
LA193:
    ret
    
EX14:
    call test_for_id
    jne LA200
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov edi, 234
    jne terminate_program ; 234
    test_input_string "("
    jne LA201
    
LA202:
    call vstack_clear
    call FN_CALL_ARGUMENTS
    call vstack_restore
    je LA202
    call set_true
    mov edi, 235
    jne terminate_program ; 235
    test_input_string ")"
    mov edi, 236
    jne terminate_program ; 236
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    call newline
    
LA201:
    
LA203:
    jne LA204
    mov edi, 238
    jne terminate_program ; 238
    
LA204:
    je LA205
    test_input_string "++"
    jne LA206
    print "inc dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "]"
    call newline
    mov edi, 240
    jne terminate_program ; 240
    
LA206:
    je LA205
    test_input_string "--"
    jne LA207
    print "dec dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "]"
    call newline
    
LA207:
    je LA205
    call set_true
    jne LA208
    mov eax, dword [AEXP_SEC_NUM]
    cmp eax, 0
    jne LA209
    print "mov eax, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "]"
    call newline
    
LA209:
    je LA210
    print "mov ebx, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "]"
    call newline
    call set_true
    
LA211:
    
LA210:
    mov edi, 244
    jne terminate_program ; 244
    
LA208:
    
LA205:
    mov edi, 245
    jne terminate_program ; 245
    
LA200:
    je LA212
    call test_for_number
    jne LA213
    mov eax, dword [AEXP_SEC_NUM]
    cmp eax, 0
    jne LA214
    print "mov eax, "
    call copy_last_match
    call newline
    
LA214:
    je LA215
    print "mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA216:
    
LA215:
    mov edi, 248
    jne terminate_program ; 248
    
LA213:
    je LA212
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
    mov eax, dword [AEXP_SEC_NUM]
    cmp eax, 0
    jne LA218
    print "mov eax, "
    call gn3
    call newline
    
LA218:
    je LA219
    print "mov ebx, "
    call gn3
    call newline
    call set_true
    
LA220:
    
LA219:
    mov edi, 252
    jne terminate_program ; 252
    
LA221:
    
LA222:
    mov edi, 253
    jne terminate_program ; 253
    
LA217:
    je LA212
    test_input_string "("
    jne LA223
    call vstack_clear
    call AEXP
    call vstack_restore
    mov edi, 254
    jne terminate_program ; 254
    test_input_string ")"
    mov edi, 255
    jne terminate_program ; 255
    
LA223:
    
LA212:
    ret
    
DIRECT_ASSEMBLY_EXPRESSION:
    test_input_string "asm"
    jne LA224
    call test_for_string_raw
    mov edi, 256
    jne terminate_program ; 256
    call copy_last_match
    call newline
    
LA224:
    
LA225:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA226
    match_not 10
    mov edi, 258
    jne terminate_program ; 258
    
LA226:
    
LA227:
    ret
    
IF_STATEMENT:
    test_input_string "if"
    jne LA228
    test_input_string "("
    mov edi, 259
    jne terminate_program ; 259
    call vstack_clear
    call AEXP
    call vstack_restore
    mov edi, 260
    jne terminate_program ; 260
    test_input_string ")"
    mov edi, 261
    jne terminate_program ; 261
    print "cmp eax, 0"
    call newline
    print "je "
    call gn1
    call newline
    test_input_string "{"
    mov edi, 264
    jne terminate_program ; 264
    call vstack_clear
    call BODY
    call vstack_restore
    mov edi, 265
    jne terminate_program ; 265
    test_input_string "}"
    mov edi, 266
    jne terminate_program ; 266
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA229:
    call vstack_clear
    call ELIF
    call vstack_restore
    jne LA230
    
LA230:
    
LA231:
    je LA229
    call set_true
    mov edi, 268
    jne terminate_program ; 268
    
LA232:
    call vstack_clear
    call ELSE
    call vstack_restore
    jne LA233
    
LA233:
    
LA234:
    je LA232
    call set_true
    mov edi, 269
    jne terminate_program ; 269
    call label
    call gn2
    print ":"
    call newline
    
LA228:
    
LA235:
    ret
    
ELIF:
    test_input_string "elif"
    jne LA236
    test_input_string "("
    mov edi, 270
    jne terminate_program ; 270
    call vstack_clear
    call AEXP
    call vstack_restore
    mov edi, 271
    jne terminate_program ; 271
    test_input_string ")"
    mov edi, 272
    jne terminate_program ; 272
    print "cmp eax, 0"
    call newline
    print "jne "
    call gn1
    call newline
    test_input_string "{"
    mov edi, 275
    jne terminate_program ; 275
    call vstack_clear
    call BODY
    call vstack_restore
    mov edi, 276
    jne terminate_program ; 276
    test_input_string "}"
    mov edi, 277
    jne terminate_program ; 277
    call label
    call gn1
    print ":"
    call newline
    
LA236:
    
LA237:
    ret
    
ELSE:
    test_input_string "else"
    jne LA238
    test_input_string "{"
    mov edi, 278
    jne terminate_program ; 278
    call vstack_clear
    call BODY
    call vstack_restore
    mov edi, 279
    jne terminate_program ; 279
    test_input_string "}"
    mov edi, 280
    jne terminate_program ; 280
    
LA238:
    
LA239:
    ret
    
LET_EXPRESSION:
    test_input_string "let"
    jne LA240
    call test_for_id
    mov edi, 281
    jne terminate_program ; 281
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
    mov edi, 282
    jne terminate_program ; 282
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
    mov edi, 283
    jne terminate_program ; 283
    test_input_string "="
    mov edi, 284
    jne terminate_program ; 284
    call vstack_clear
    call AEXP
    call vstack_restore
    mov edi, 285
    jne terminate_program ; 285
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, dword [STO]
    call print_int
    pop eax
    popfd
    print "], eax"
    call newline
    
LA240:
    
LA241:
    ret
    
ASSIGNMENT_EXPRESSION:
    call test_for_id
    jne LA242
    test_input_string "="
    mov edi, 287
    jne terminate_program ; 287
    call vstack_clear
    call AEXP
    call vstack_restore
    mov edi, 288
    jne terminate_program ; 288
    print "mov dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    pop eax
    popfd
    print "], eax"
    call newline
    
LA242:
    
LA243:
    ret
    
WHILE_STATEMENT:
    test_input_string "while"
    jne LA244
    call label
    call gn2
    print ":"
    call newline
    test_input_string "("
    mov edi, 290
    jne terminate_program ; 290
    call vstack_clear
    call AEXP
    call vstack_restore
    mov edi, 291
    jne terminate_program ; 291
    test_input_string ")"
    mov edi, 292
    jne terminate_program ; 292
    test_input_string "{"
    mov edi, 293
    jne terminate_program ; 293
    print "cmp eax, 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call BODY
    call vstack_restore
    mov edi, 296
    jne terminate_program ; 296
    test_input_string "}"
    mov edi, 297
    jne terminate_program ; 297
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA244:
    
LA245:
    ret
    
RETURN_EXPRESSION:
    test_input_string "return"
    jne LA246
    pushfd
    push eax
    mov eax, 0
    mov dword [AEXP_SEC_NUM], eax
    pop eax
    popfd
    mov edi, 299
    jne terminate_program ; 299
    call vstack_clear
    call AEXP
    call vstack_restore
    mov edi, 300
    jne terminate_program ; 300
    
LA246:
    
LA247:
    ret
    
