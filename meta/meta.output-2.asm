
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
    mov esi, 1
    jne terminate_program ; 1
    
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
    mov esi, 1
    jne terminate_program ; 1
    
LA10:
    
LA15:
    jne LA16
    
LA16:
    je LA9
    test_input_string ".SYNTAX"
    jne LA17
    call test_for_id
    mov esi, 1
    jne terminate_program ; 1
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
    mov esi, 1
    jne terminate_program ; 1
    test_input_string ".END"
    mov esi, 1
    jne terminate_program ; 1
    
LA17:
    
LA23:
    jne LA24
    
LA24:
    
LA9:
    je LA1
    call set_true
    mov esi, 1
    jne terminate_program ; 1
    
LA25:
    
LA26:
    ret
    
INCLUDE_STATEMENT:
    test_input_string ".INCLUDE"
    jne LA27
    call test_for_string_raw
    mov esi, 1
    jne terminate_program ; 1
    test_input_string ";"
    mov esi, 1
    jne terminate_program ; 1
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
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    pushfd
    push eax
    mov eax, dword [STO]
    mov ebx, 4
    add eax, ebx
    mov dword [STO], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 1
    jne terminate_program ; 1
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 1
    jne terminate_program ; 1
    test_input_string "="
    mov esi, 1
    jne terminate_program ; 1
    call vstack_clear
    call DATA_TYPE
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
    test_input_string ";"
    mov esi, 1
    jne terminate_program ; 1
    
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
    mov esi, 1
    jne terminate_program ; 1
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print " resb "
    call copy_last_match
    call newline
    test_input_string "}"
    mov esi, 1
    jne terminate_program ; 1
    
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
    mov esi, 1
    jne terminate_program ; 1
    
LA55:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA56
    
LA56:
    
LA57:
    je LA55
    call set_true
    mov esi, 1
    jne terminate_program ; 1
    test_input_string ")"
    mov esi, 1
    jne terminate_program ; 1
    print "call newline"
    call newline
    pushfd
    push eax
    mov eax, dword [line]
    mov ebx, 1
    add eax, ebx
    mov dword [line], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    
LA54:
    je LA58
    test_input_string ".LABEL"
    jne LA59
    print "call label"
    call newline
    test_input_string "("
    mov esi, 1
    jne terminate_program ; 1
    
LA60:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA61
    
LA61:
    
LA62:
    je LA60
    call set_true
    mov esi, 1
    jne terminate_program ; 1
    test_input_string ")"
    mov esi, 1
    jne terminate_program ; 1
    print "call newline"
    call newline
    
LA59:
    je LA58
    test_input_string ".RS"
    jne LA63
    test_input_string "("
    mov esi, 1
    jne terminate_program ; 1
    
LA64:
    call vstack_clear
    call OUT1
    call vstack_restore
    je LA64
    call set_true
    mov esi, 1
    jne terminate_program ; 1
    test_input_string ")"
    mov esi, 1
    jne terminate_program ; 1
    
LA63:
    
LA58:
    jne LA65
    
LA65:
    je LA66
    test_input_string ".DIRECT"
    jne LA67
    test_input_string "("
    mov esi, 1
    jne terminate_program ; 1
    
LA68:
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    je LA68
    call set_true
    mov esi, 1
    jne terminate_program ; 1
    test_input_string ")"
    mov esi, 1
    jne terminate_program ; 1
    
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
    mov esi, 1
    jne terminate_program ; 1
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
    mov esi, 1
    jne terminate_program ; 1
    test_input_string ")"
    mov esi, 1
    jne terminate_program ; 1
    
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
    mov esi, 1
    jne terminate_program ; 1
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
    mov eax, dword [line]
    mov edi, eax
    pop eax
    popfd
    print_int edi
    call newline
    print "jne terminate_program ; "
    pushfd
    push eax
    mov eax, dword [line]
    mov edi, eax
    pop eax
    popfd
    print_int edi
    call newline
    pushfd
    push eax
    mov eax, dword [line]
    mov ebx, 1
    add eax, ebx
    mov dword [line], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    
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
    mov esi, 1
    jne terminate_program ; 1
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
    mov esi, 1
    jne terminate_program ; 1
    
LA98:
    
LA99:
    je LA97
    call set_true
    mov esi, 1
    jne terminate_program ; 1
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
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
    print "cmp eax, 0"
    call newline
    
LA102:
    
LA103:
    jne LA104
    mov esi, 1
    jne terminate_program ; 1
    
LA104:
    je LA105
    print "pushfd"
    call newline
    print "push eax"
    call newline
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
    print "mov edi, eax"
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
    mov esi, 1
    jne terminate_program ; 1
    test_input_string "]"
    mov esi, 1
    jne terminate_program ; 1
    
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
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
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
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
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
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
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
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
    pushfd
    push eax
    mov eax, 1
    mov dword [ARG_NUM], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
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
    mov esi, 1
    jne terminate_program ; 1
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    mov esi, 1
    jne terminate_program ; 1
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
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
    mov esi, 1
    jne terminate_program ; 1
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
    mov esi, 1
    jne terminate_program ; 1
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
    mov esi, 1
    jne terminate_program ; 1
    
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
    mov esi, 1
    jne terminate_program ; 1
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
    mov esi, 1
    jne terminate_program ; 1
    print "call hash_get"
    call newline
    
LA132:
    
LA133:
    jne LA134
    
LA134:
    je LA113
    test_input_string "<>"
    jne LA135
    pushfd
    push eax
    mov eax, 0
    mov dword [ARG_NUM], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    call vstack_clear
    call BRACKET_ARG
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
    
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
    mov esi, 1
    jne terminate_program ; 1
    
LA139:
    call vstack_clear
    call FN_CALL_ARG
    call vstack_restore
    jne LA140
    pushfd
    push eax
    mov eax, dword [ARG_NUM]
    mov ebx, 1
    add eax, ebx
    mov dword [ARG_NUM], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    
LA140:
    
LA141:
    je LA139
    call set_true
    mov esi, 1
    jne terminate_program ; 1
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
    mov esi, 1
    jne terminate_program ; 1
    test_input_string "]"
    mov esi, 1
    jne terminate_program ; 1
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
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA153
    print "mov edi, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "mov edi, dword [edi]"
    call newline
    
LA153:
    je LA154
    print "mov edi, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA155:
    
LA154:
    mov esi, 1
    jne terminate_program ; 1
    
LA152:
    
LA156:
    jne LA157
    
LA157:
    je LA148
    test_input_string "*"
    jne LA158
    call test_for_id
    mov esi, 1
    jne terminate_program ; 1
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA159
    print "mov edi, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA159:
    je LA160
    print "mov edi, "
    call copy_last_match
    call newline
    call set_true
    
LA161:
    
LA160:
    mov esi, 1
    jne terminate_program ; 1
    
LA158:
    
LA162:
    jne LA163
    
LA163:
    je LA148
    call test_for_string
    jne LA164
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
    
LA164:
    
LA165:
    jne LA166
    
LA166:
    
LA148:
    jne LA167
    
LA168:
    test_input_string "["
    jne LA169
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
    test_input_string "]"
    mov esi, 1
    jne terminate_program ; 1
    print "mov esi, eax"
    call newline
    
LA169:
    
LA170:
    jne LA171
    
LA171:
    je LA172
    call test_for_number
    jne LA173
    print "mov esi, "
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
    print "mov esi, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "mov esi, dword [esi]"
    call newline
    
LA177:
    je LA178
    print "mov esi, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA179:
    
LA178:
    mov esi, 1
    jne terminate_program ; 1
    
LA176:
    
LA180:
    jne LA181
    
LA181:
    je LA172
    test_input_string "*"
    jne LA182
    call test_for_id
    mov esi, 1
    jne terminate_program ; 1
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA183
    print "mov esi, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA183:
    je LA184
    print "mov esi, "
    call copy_last_match
    call newline
    call set_true
    
LA185:
    
LA184:
    mov esi, 1
    jne terminate_program ; 1
    
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
    print "mov esi, "
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
    mov esi, 1
    jne terminate_program ; 1
    test_input_string "]"
    mov esi, 1
    jne terminate_program ; 1
    print "mov edx, eax"
    call newline
    
LA193:
    
LA194:
    jne LA195
    
LA195:
    je LA196
    call test_for_number
    jne LA197
    print "mov edx, "
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
    print "mov edx, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "mov edx, dword [edx]"
    call newline
    
LA201:
    je LA202
    print "mov edx, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA203:
    
LA202:
    mov esi, 1
    jne terminate_program ; 1
    
LA200:
    
LA204:
    jne LA205
    
LA205:
    je LA196
    test_input_string "*"
    jne LA206
    call test_for_id
    mov esi, 1
    jne terminate_program ; 1
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA207
    print "mov edx, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA207:
    je LA208
    print "mov edx, "
    call copy_last_match
    call newline
    call set_true
    
LA209:
    
LA208:
    mov esi, 1
    jne terminate_program ; 1
    
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
    print "mov edx, "
    call gn3
    call newline
    
LA212:
    
LA213:
    jne LA214
    
LA214:
    
LA196:
    jne LA215
    
LA215:
    
LA216:
    je LA192
    call set_true
    mov esi, 1
    jne terminate_program ; 1
    
LA191:
    
LA217:
    je LA168
    call set_true
    mov esi, 1
    jne terminate_program ; 1
    
LA167:
    
LA218:
    je LA144
    call set_true
    jne LA219
    
LA219:
    
LA220:
    ret
    
BRACKET_ARG:
    test_input_string "["
    jne LA221
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
    test_input_string "]"
    mov esi, 1
    jne terminate_program ; 1
    
LA221:
    
LA222:
    jne LA223
    
LA223:
    je LA224
    call test_for_number
    jne LA225
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA226
    print "mov eax, "
    call copy_last_match
    call newline
    
LA226:
    je LA227
    print "mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA228:
    
LA227:
    mov esi, 1
    jne terminate_program ; 1
    
LA225:
    
LA229:
    jne LA230
    
LA230:
    je LA224
    call test_for_id
    jne LA231
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA232
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA233
    print "mov eax, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "mov eax, dword [eax]"
    call newline
    
LA233:
    je LA234
    print "mov eax, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA235:
    
LA234:
    mov esi, 1
    jne terminate_program ; 1
    
LA232:
    je LA236
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA237
    print "mov ebx, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    print "mov ebx, dword [eax]"
    call newline
    
LA237:
    je LA238
    print "mov ebx, dword ["
    call copy_last_match
    print "]"
    call newline
    call set_true
    
LA239:
    
LA238:
    jne LA240
    
LA240:
    
LA236:
    mov esi, 1
    jne terminate_program ; 1
    
LA231:
    
LA241:
    jne LA242
    
LA242:
    je LA224
    test_input_string "*"
    jne LA243
    call test_for_id
    mov esi, 1
    jne terminate_program ; 1
    mov eax, dword [ARG_NUM]
    cmp eax, 0
    jne LA244
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA245
    print "mov eax, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA245:
    je LA246
    print "mov eax, "
    call copy_last_match
    call newline
    call set_true
    
LA247:
    
LA246:
    mov esi, 1
    jne terminate_program ; 1
    
LA244:
    je LA248
    mov edi, GLOBALS
    mov esi, last_match
    call hash_get
    cmp eax, 0
    jne LA249
    print "mov ebx, dword [ebp+"
    pushfd
    push eax
    mov edi, ST
    mov esi, last_match
    call hash_get
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "]"
    call newline
    
LA249:
    je LA250
    print "mov ebx, "
    call copy_last_match
    call newline
    call set_true
    
LA251:
    
LA250:
    jne LA252
    
LA252:
    
LA248:
    mov esi, 1
    jne terminate_program ; 1
    
LA243:
    
LA253:
    jne LA254
    
LA254:
    je LA224
    call test_for_string
    jne LA255
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
    jne LA256
    print "mov eax, "
    call gn3
    call newline
    
LA256:
    je LA257
    print "mov ebx, "
    call gn3
    call newline
    call set_true
    
LA258:
    
LA257:
    mov esi, 1
    jne terminate_program ; 1
    
LA255:
    
LA259:
    jne LA260
    
LA260:
    
LA224:
    ret
    
CODE_DEFINITION:
    call test_for_id
    jne LA261
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov esi, 1
    jne terminate_program ; 1
    test_input_string "["
    mov esi, 1
    jne terminate_program ; 1
    mov esi, 1
    jne terminate_program ; 1
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    test_input_string "["
    mov esi, 1
    jne terminate_program ; 1
    
LA262:
    call test_for_id
    jne LA263
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
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    mov ebx, 1
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    print "mov dword [ebp+"
    pushfd
    push eax
    mov eax, dword [STO]
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "], edi"
    call newline
    
LA264:
    call test_for_id
    jne LA265
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
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    mov ebx, 1
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    print "mov dword [ebp+"
    pushfd
    push eax
    mov eax, dword [STO]
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "], esi"
    call newline
    
LA266:
    call test_for_id
    jne LA267
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
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    mov ebx, 1
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    print "mov dword [ebp+"
    pushfd
    push eax
    mov eax, dword [STO]
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "], edx"
    call newline
    
LA268:
    call test_for_id
    jne LA269
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
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    mov ebx, 1
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    print "mov dword [ebp+"
    pushfd
    push eax
    mov eax, dword [STO]
    mov edi, eax
    pop eax
    popfd
    print_int edi
    print "], ecx"
    call newline
    
LA270:
    call test_for_id
    jne LA271
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
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    pushfd
    push eax
    mov eax, dword [VAR_IN_BODY]
    mov ebx, 1
    add eax, ebx
    mov dword [VAR_IN_BODY], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    
LA271:
    
LA272:
    je LA270
    call set_true
    mov esi, 1
    jne terminate_program ; 1
    
LA269:
    
LA273:
    je LA268
    call set_true
    mov esi, 1
    jne terminate_program ; 1
    
LA267:
    
LA274:
    je LA266
    call set_true
    mov esi, 1
    jne terminate_program ; 1
    
LA265:
    
LA275:
    je LA264
    call set_true
    mov esi, 1
    jne terminate_program ; 1
    
LA263:
    
LA276:
    je LA262
    call set_true
    mov esi, 1
    jne terminate_program ; 1
    test_input_string "]"
    mov esi, 1
    jne terminate_program ; 1
    mov esi, 1
    jne terminate_program ; 1
    mov esi, 1
    jne terminate_program ; 1
    
LA277:
    test_input_string "["
    jne LA278
    call vstack_clear
    call BRACKET_EXPR
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
    test_input_string "]"
    mov esi, 1
    jne terminate_program ; 1
    
LA278:
    
LA279:
    je LA277
    call set_true
    mov esi, 1
    jne terminate_program ; 1
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
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    pushfd
    push eax
    mov eax, 0
    mov dword [VAR_IN_BODY], eax
    mov edi, eax
    pop eax
    popfd
    mov esi, 1
    jne terminate_program ; 1
    test_input_string "]"
    mov esi, 1
    jne terminate_program ; 1
    
LA261:
    
LA280:
    ret
    
DEFINITION:
    call test_for_id
    jne LA281
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov esi, 1
    jne terminate_program ; 1
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 1
    jne terminate_program ; 1
    test_input_string ";"
    mov esi, 1
    jne terminate_program ; 1
    print "ret"
    call newline
    
LA281:
    
LA282:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA283
    match_not 10
    mov esi, 1
    jne terminate_program ; 1
    
LA283:
    
LA284:
    ret
    