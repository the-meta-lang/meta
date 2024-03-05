
%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
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
    print "%define MAX_INPUT_LENGTH 65536"
    call newline
    call label
    print "%include './lib/asm_macros.asm'"
    call newline
    
LA1:
    test_input_string ".TOKENS"
    jne LA2
    call label
    print "; -- Tokens --"
    call newline
    
LA3:
    call vstack_clear
    call TOKEN_DEFINITION
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
    mov esi, 0
    jne terminate_program ; 0
    
LA2:
    
LA7:
    jne LA8
    
LA8:
    je LA9
    test_input_string ".SYNTAX"
    jne LA10
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
    
LA11:
    call vstack_clear
    call DEFINITION
    call vstack_restore
    jne LA12
    
LA12:
    je LA13
    call vstack_clear
    call INCLUDE_STATEMENT
    call vstack_restore
    jne LA14
    
LA14:
    je LA13
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA15
    
LA15:
    
LA13:
    je LA11
    call set_true
    mov esi, 12
    jne terminate_program ; 12
    
LA10:
    
LA16:
    jne LA17
    
LA17:
    
LA9:
    je LA1
    call set_true
    mov esi, 13
    jne terminate_program ; 13
    test_input_string ".END"
    mov esi, 14
    jne terminate_program ; 14
    
LA18:
    
LA19:
    ret
    
INCLUDE_STATEMENT:
    test_input_string ".INCLUDE"
    jne LA20
    call test_for_string_raw
    mov esi, 15
    jne terminate_program ; 15
    test_input_string ";"
    mov esi, 16
    jne terminate_program ; 16
    mov esi, last_match
    call import_meta_file_mm32
    mov byte [eswitch], 0
    
LA20:
    
LA21:
    ret
    
DATA_TYPE:
    test_input_string "{"
    jne LA22
    call label
    print "section .bss"
    call newline
    call test_for_number
    mov esi, 17
    jne terminate_program ; 17
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print " resb "
    call copy_last_match
    call newline
    test_input_string "}"
    mov esi, 19
    jne terminate_program ; 19
    
LA22:
    
LA23:
    jne LA24
    
LA24:
    je LA25
    call test_for_string
    jne LA26
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
    
LA26:
    
LA27:
    jne LA28
    
LA28:
    je LA25
    call test_for_number
    jne LA29
    call label
    print "section .data"
    call newline
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print " dd "
    call copy_last_match
    call newline
    
LA29:
    
LA30:
    jne LA31
    
LA31:
    
LA25:
    jne LA32
    
LA32:
    
LA33:
    ret
    
OUT1:
    test_input_string "*1"
    jne LA34
    print "call gn1"
    call newline
    
LA34:
    je LA35
    test_input_string "*2"
    jne LA36
    print "call gn2"
    call newline
    
LA36:
    je LA35
    test_input_string "*3"
    jne LA37
    print "call gn3"
    call newline
    
LA37:
    je LA35
    test_input_string "*4"
    jne LA38
    print "call gn4"
    call newline
    
LA38:
    je LA35
    test_input_string "*"
    jne LA39
    print "call copy_last_match"
    call newline
    
LA39:
    je LA35
    test_input_string "%"
    jne LA40
    print "mov edi, str_vector_8192"
    call newline
    print "call vector_pop_string"
    call newline
    print "call print_mm32"
    call newline
    
LA40:
    je LA35
    call test_for_string
    jne LA41
    print "print "
    call copy_last_match
    call newline
    
LA41:
    
LA35:
    ret
    
OUT_IMMEDIATE:
    call test_for_string_raw
    jne LA42
    call copy_last_match
    call newline
    
LA42:
    
LA43:
    ret
    
OUTPUT:
    test_input_string "->"
    jne LA44
    test_input_string "("
    mov esi, 32
    jne terminate_program ; 32
    
LA45:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA46
    
LA46:
    
LA47:
    je LA45
    call set_true
    mov esi, 33
    jne terminate_program ; 33
    test_input_string ")"
    mov esi, 34
    jne terminate_program ; 34
    print "call newline"
    call newline
    
LA44:
    je LA48
    test_input_string ".LABEL"
    jne LA49
    print "call label"
    call newline
    test_input_string "("
    mov esi, 37
    jne terminate_program ; 37
    
LA50:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA51
    
LA51:
    
LA52:
    je LA50
    call set_true
    mov esi, 38
    jne terminate_program ; 38
    test_input_string ")"
    mov esi, 39
    jne terminate_program ; 39
    print "call newline"
    call newline
    
LA49:
    je LA48
    test_input_string ".RS"
    jne LA53
    test_input_string "("
    mov esi, 41
    jne terminate_program ; 41
    
LA54:
    call vstack_clear
    call OUT1
    call vstack_restore
    je LA54
    call set_true
    mov esi, 42
    jne terminate_program ; 42
    test_input_string ")"
    mov esi, 43
    jne terminate_program ; 43
    
LA53:
    
LA48:
    jne LA55
    
LA55:
    je LA56
    test_input_string ".DIRECT"
    jne LA57
    test_input_string "("
    mov esi, 44
    jne terminate_program ; 44
    
LA58:
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    je LA58
    call set_true
    mov esi, 45
    jne terminate_program ; 45
    test_input_string ")"
    mov esi, 46
    jne terminate_program ; 46
    
LA57:
    
LA56:
    ret
    
EX3:
    call test_for_id
    jne LA59
    print "call vstack_clear"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_restore"
    call newline
    
LA59:
    je LA60
    call test_for_string
    jne LA61
    print "test_input_string "
    call copy_last_match
    call newline
    
LA61:
    je LA60
    test_input_string ".ID"
    jne LA62
    print "call test_for_id"
    call newline
    
LA62:
    je LA60
    test_input_string ".RET"
    jne LA63
    print "ret"
    call newline
    
LA63:
    je LA60
    test_input_string ".NOT"
    jne LA64
    call test_for_string
    jne LA65
    
LA65:
    je LA66
    call test_for_number
    jne LA67
    
LA67:
    
LA66:
    mov esi, 53
    jne terminate_program ; 53
    print "match_not "
    call copy_last_match
    call newline
    
LA64:
    je LA60
    test_input_string ".NUMBER"
    jne LA68
    print "call test_for_number"
    call newline
    
LA68:
    je LA60
    test_input_string ".STRING_RAW"
    jne LA69
    print "call test_for_string_raw"
    call newline
    
LA69:
    je LA60
    test_input_string ".STRING"
    jne LA70
    print "call test_for_string"
    call newline
    
LA70:
    je LA60
    test_input_string "%>"
    jne LA71
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA71:
    je LA60
    test_input_string "("
    jne LA72
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 61
    jne terminate_program ; 61
    test_input_string ")"
    mov esi, 62
    jne terminate_program ; 62
    
LA72:
    je LA60
    test_input_string ".EMPTY"
    jne LA73
    print "mov byte [eswitch], 0"
    call newline
    
LA73:
    je LA60
    test_input_string "$"
    jne LA74
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call EX3
    call vstack_restore
    mov esi, 64
    jne terminate_program ; 64
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    print "mov byte [eswitch], 0"
    call newline
    
LA74:
    je LA60
    test_input_string "{"
    jne LA75
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 68
    jne terminate_program ; 68
    
LA76:
    test_input_string "|"
    jne LA77
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 69
    jne terminate_program ; 69
    
LA77:
    
LA78:
    je LA76
    call set_true
    mov esi, 70
    jne terminate_program ; 70
    test_input_string "}"
    mov esi, 71
    jne terminate_program ; 71
    
LA75:
    je LA60
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA79
    
LA79:
    
LA60:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA80
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    
LA80:
    je LA81
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA82
    
LA82:
    
LA81:
    jne LA83
    
LA84:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA85
    print "cmp byte [eswitch], 1"
    call newline
    print "je terminate_program"
    call newline
    
LA85:
    je LA86
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA87
    
LA87:
    
LA86:
    je LA84
    call set_true
    mov esi, 76
    jne terminate_program ; 76
    call label
    call gn1
    print ":"
    call newline
    
LA83:
    
LA88:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    jne LA89
    
LA90:
    test_input_string "|"
    jne LA91
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov esi, 79
    jne terminate_program ; 79
    
LA91:
    
LA92:
    je LA90
    call set_true
    mov esi, 80
    jne terminate_program ; 80
    call label
    call gn1
    print ":"
    call newline
    
LA89:
    
LA93:
    ret
    
DEFINITION:
    call test_for_id
    jne LA94
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov esi, 81
    jne terminate_program ; 81
    call vstack_clear
    call EX1
    call vstack_restore
    mov esi, 82
    jne terminate_program ; 82
    test_input_string ";"
    mov esi, 83
    jne terminate_program ; 83
    print "ret"
    call newline
    
LA94:
    
LA95:
    ret
    
TOKEN_DEFINITION:
    call test_for_id
    jne LA96
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string ":"
    mov esi, 85
    jne terminate_program ; 85
    call vstack_clear
    call TX1
    call vstack_restore
    mov esi, 86
    jne terminate_program ; 86
    test_input_string ";"
    mov esi, 87
    jne terminate_program ; 87
    print "ret"
    call newline
    
LA96:
    
LA97:
    ret
    
TX1:
    call vstack_clear
    call TX2
    call vstack_restore
    jne LA98
    
LA99:
    test_input_string "|"
    jne LA100
    print "je T"
    call gn1
    call newline
    call vstack_clear
    call TX2
    call vstack_restore
    mov esi, 90
    jne terminate_program ; 90
    
LA100:
    
LA101:
    je LA99
    call set_true
    mov esi, 91
    jne terminate_program ; 91
    call label
    print "T"
    call gn1
    print ":"
    call newline
    
LA98:
    
LA102:
    ret
    
TX2:
    call vstack_clear
    call TX3
    call vstack_restore
    jne LA103
    print "cmp byte [eswitch], 1"
    call newline
    print "je T"
    call gn1
    call newline
    mov esi, 94
    jne terminate_program ; 94
    
LA104:
    call vstack_clear
    call TX3
    call vstack_restore
    jne LA105
    print "cmp byte [pflag], 0"
    call newline
    print "jne T"
    call gn1
    call newline
    
LA105:
    
LA106:
    je LA104
    call set_true
    mov esi, 97
    jne terminate_program ; 97
    call label
    print "T"
    call gn1
    print ":"
    call newline
    
LA103:
    
LA107:
    ret
    
TX3:
    test_input_string ".TOKEN"
    jne LA108
    mov esi, 98
    jne terminate_program ; 98
    print "mov byte [tflag], 1"
    call newline
    
LA108:
    je LA109
    test_input_string ".DELTOK"
    jne LA110
    mov esi, 100
    jne terminate_program ; 100
    print "mov byte [tflag], 0"
    call newline
    
LA110:
    je LA109
    test_input_string "$"
    jne LA111
    call label
    print "T"
    call gn1
    print ":"
    call newline
    call vstack_clear
    call TX3
    call vstack_restore
    mov esi, 102
    jne terminate_program ; 102
    print "je T"
    call gn1
    call newline
    
LA111:
    
LA109:
    jne LA112
    print "mov byte [eswitch], 0"
    call newline
    
LA112:
    je LA113
    test_input_string ".ANYBUT("
    jne LA114
    call vstack_clear
    call CX1
    call vstack_restore
    mov esi, 105
    jne terminate_program ; 105
    test_input_string ")"
    mov esi, 106
    jne terminate_program ; 106
    print "NOT"
    print "scan_or_parse"
    call newline
    
LA114:
    je LA113
    test_input_string ".ANY("
    jne LA115
    call vstack_clear
    call CX1
    call vstack_restore
    mov esi, 108
    jne terminate_program ; 108
    test_input_string ")"
    mov esi, 109
    jne terminate_program ; 109
    print "call scan_or_parse"
    call newline
    
LA115:
    je LA113
    call test_for_id
    jne LA116
    print "CLL "
    call copy_last_match
    call newline
    
LA116:
    je LA113
    test_input_string "("
    jne LA117
    call vstack_clear
    call TX1
    call vstack_restore
    mov esi, 112
    jne terminate_program ; 112
    test_input_string ")"
    mov esi, 113
    jne terminate_program ; 113
    
LA117:
    
LA113:
    ret
    
CX1:
    call vstack_clear
    call CX2
    call vstack_restore
    jne LA118
    
LA119:
    test_input_string "!"
    jne LA120
    print "je C"
    call gn1
    call newline
    call vstack_clear
    call CX2
    call vstack_restore
    mov esi, 115
    jne terminate_program ; 115
    
LA120:
    
LA121:
    je LA119
    call set_true
    mov esi, 116
    jne terminate_program ; 116
    call label
    print "C"
    call gn1
    print ":"
    call newline
    
LA118:
    
LA122:
    ret
    
CX2:
    call vstack_clear
    call CX3
    call vstack_restore
    jne LA123
    test_input_string ":"
    jne LA124
    print "mov edi, "
    call copy_last_match
    call newline
    print "call test_char_greater_equal"
    call newline
    print "cmp byte [pflag], 1"
    call newline
    print "jne D"
    call gn1
    call newline
    call vstack_clear
    call CX3
    call vstack_restore
    mov esi, 121
    jne terminate_program ; 121
    print "mov edi, "
    call copy_last_match
    call newline
    print "call test_char_less_equal"
    call newline
    call label
    print "D"
    call gn1
    print ":"
    call newline
    
LA124:
    je LA125
    call set_true
    jne LA126
    print "CE "
    call copy_last_match
    call newline
    
LA126:
    
LA125:
    mov esi, 125
    jne terminate_program ; 125
    
LA123:
    
LA127:
    ret
    
CX3:
    call test_for_number
    jne LA128
    
LA128:
    
LA129:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA130
    match_not 10
    mov esi, 126
    jne terminate_program ; 126
    
LA130:
    
LA131:
    ret
    