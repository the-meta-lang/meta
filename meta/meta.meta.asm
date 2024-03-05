
%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
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
    test_input_string ".TOKENS"
    cmp byte [eswitch], 1
    je LA2
    call label
    print "; -- Tokens --"
    call newline
    
LA3:
    call vstack_clear
    call TOKEN_DEFINITION
    call vstack_restore
    cmp byte [eswitch], 1
    je LA4
    
LA4:
    cmp byte [eswitch], 0
    je LA5
    call vstack_clear
    call COMMENT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA6
    
LA6:
    
LA5:
    cmp byte [eswitch], 0
    je LA3
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA2:
    
LA7:
    cmp byte [eswitch], 1
    je LA8
    
LA8:
    cmp byte [eswitch], 0
    je LA9
    test_input_string ".SYNTAX"
    cmp byte [eswitch], 1
    je LA10
    call test_for_id
    cmp byte [eswitch], 1
    je terminate_program
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
    cmp byte [eswitch], 1
    je LA12
    
LA12:
    cmp byte [eswitch], 0
    je LA13
    call vstack_clear
    call INCLUDE_STATEMENT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA14
    
LA14:
    cmp byte [eswitch], 0
    je LA13
    call vstack_clear
    call COMMENT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA15
    
LA15:
    
LA13:
    cmp byte [eswitch], 0
    je LA11
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA10:
    
LA16:
    cmp byte [eswitch], 1
    je LA17
    
LA17:
    
LA9:
    cmp byte [eswitch], 0
    je LA1
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ".END"
    cmp byte [eswitch], 1
    je terminate_program
    
LA18:
    
LA19:
    ret
    
INCLUDE_STATEMENT:
    test_input_string ".INCLUDE"
    cmp byte [eswitch], 1
    je LA20
    call test_for_string_raw
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ";"
    cmp byte [eswitch], 1
    je terminate_program
    mov esi, last_match
    call import_meta_file_mm32
    mov byte [eswitch], 0
    
LA20:
    
LA21:
    ret
    
DATA_TYPE:
    test_input_string "{"
    cmp byte [eswitch], 1
    je LA22
    call label
    print "section .bss"
    call newline
    call test_for_number
    cmp byte [eswitch], 1
    je terminate_program
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print " resb "
    call copy_last_match
    call newline
    test_input_string "}"
    cmp byte [eswitch], 1
    je terminate_program
    
LA22:
    
LA23:
    cmp byte [eswitch], 1
    je LA24
    
LA24:
    cmp byte [eswitch], 0
    je LA25
    call test_for_string
    cmp byte [eswitch], 1
    je LA26
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
    cmp byte [eswitch], 1
    je LA28
    
LA28:
    cmp byte [eswitch], 0
    je LA25
    call test_for_number
    cmp byte [eswitch], 1
    je LA29
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
    cmp byte [eswitch], 1
    je LA31
    
LA31:
    
LA25:
    cmp byte [eswitch], 1
    je LA32
    
LA32:
    
LA33:
    ret
    
OUT1:
    test_input_string "*1"
    cmp byte [eswitch], 1
    je LA34
    print "call gn1"
    call newline
    
LA34:
    cmp byte [eswitch], 0
    je LA35
    test_input_string "*2"
    cmp byte [eswitch], 1
    je LA36
    print "call gn2"
    call newline
    
LA36:
    cmp byte [eswitch], 0
    je LA35
    test_input_string "*3"
    cmp byte [eswitch], 1
    je LA37
    print "call gn3"
    call newline
    
LA37:
    cmp byte [eswitch], 0
    je LA35
    test_input_string "*4"
    cmp byte [eswitch], 1
    je LA38
    print "call gn4"
    call newline
    
LA38:
    cmp byte [eswitch], 0
    je LA35
    test_input_string "*"
    cmp byte [eswitch], 1
    je LA39
    print "call copy_last_match"
    call newline
    
LA39:
    cmp byte [eswitch], 0
    je LA35
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA40
    print "mov edi, str_vector_8192"
    call newline
    print "call vector_pop_string"
    call newline
    print "call print_mm32"
    call newline
    
LA40:
    cmp byte [eswitch], 0
    je LA35
    call test_for_string
    cmp byte [eswitch], 1
    je LA41
    print "print "
    call copy_last_match
    call newline
    
LA41:
    
LA35:
    ret
    
OUT_IMMEDIATE:
    call test_for_string_raw
    cmp byte [eswitch], 1
    je LA42
    call copy_last_match
    call newline
    
LA42:
    
LA43:
    ret
    
OUTPUT:
    test_input_string "->"
    cmp byte [eswitch], 1
    je LA44
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA45:
    call vstack_clear
    call OUT1
    call vstack_restore
    cmp byte [eswitch], 1
    je LA46
    
LA46:
    
LA47:
    cmp byte [eswitch], 0
    je LA45
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "call newline"
    call newline
    
LA44:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".LABEL"
    cmp byte [eswitch], 1
    je LA49
    print "call label"
    call newline
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA50:
    call vstack_clear
    call OUT1
    call vstack_restore
    cmp byte [eswitch], 1
    je LA51
    
LA51:
    
LA52:
    cmp byte [eswitch], 0
    je LA50
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "call newline"
    call newline
    
LA49:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".RS"
    cmp byte [eswitch], 1
    je LA53
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA54:
    call vstack_clear
    call OUT1
    call vstack_restore
    cmp byte [eswitch], 0
    je LA54
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA53:
    
LA48:
    cmp byte [eswitch], 1
    je LA55
    
LA55:
    cmp byte [eswitch], 0
    je LA56
    test_input_string ".DIRECT"
    cmp byte [eswitch], 1
    je LA57
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA58:
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    cmp byte [eswitch], 0
    je LA58
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA57:
    
LA56:
    ret
    
EX3:
    call test_for_id
    cmp byte [eswitch], 1
    je LA59
    print "call vstack_clear"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_restore"
    call newline
    
LA59:
    cmp byte [eswitch], 0
    je LA60
    call test_for_string
    cmp byte [eswitch], 1
    je LA61
    print "test_input_string "
    call copy_last_match
    call newline
    
LA61:
    cmp byte [eswitch], 0
    je LA60
    test_input_string ".ID"
    cmp byte [eswitch], 1
    je LA62
    print "call test_for_id"
    call newline
    
LA62:
    cmp byte [eswitch], 0
    je LA60
    test_input_string ".RET"
    cmp byte [eswitch], 1
    je LA63
    print "ret"
    call newline
    
LA63:
    cmp byte [eswitch], 0
    je LA60
    test_input_string ".NOT"
    cmp byte [eswitch], 1
    je LA64
    call test_for_string
    cmp byte [eswitch], 1
    je LA65
    
LA65:
    cmp byte [eswitch], 0
    je LA66
    call test_for_number
    cmp byte [eswitch], 1
    je LA67
    
LA67:
    
LA66:
    cmp byte [eswitch], 1
    je terminate_program
    print "match_not "
    call copy_last_match
    call newline
    
LA64:
    cmp byte [eswitch], 0
    je LA60
    test_input_string ".NUMBER"
    cmp byte [eswitch], 1
    je LA68
    print "call test_for_number"
    call newline
    
LA68:
    cmp byte [eswitch], 0
    je LA60
    test_input_string ".STRING_RAW"
    cmp byte [eswitch], 1
    je LA69
    print "call test_for_string_raw"
    call newline
    
LA69:
    cmp byte [eswitch], 0
    je LA60
    test_input_string ".STRING"
    cmp byte [eswitch], 1
    je LA70
    print "call test_for_string"
    call newline
    
LA70:
    cmp byte [eswitch], 0
    je LA60
    test_input_string "%>"
    cmp byte [eswitch], 1
    je LA71
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA71:
    cmp byte [eswitch], 0
    je LA60
    test_input_string "("
    cmp byte [eswitch], 1
    je LA72
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA72:
    cmp byte [eswitch], 0
    je LA60
    test_input_string ".EMPTY"
    cmp byte [eswitch], 1
    je LA73
    print "mov byte [eswitch], 0"
    call newline
    
LA73:
    cmp byte [eswitch], 0
    je LA60
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA74
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call EX3
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    print "mov byte [eswitch], 0"
    call newline
    
LA74:
    cmp byte [eswitch], 0
    je LA60
    test_input_string "{"
    cmp byte [eswitch], 1
    je LA75
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA76:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA77
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA77:
    
LA78:
    cmp byte [eswitch], 0
    je LA76
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "}"
    cmp byte [eswitch], 1
    je terminate_program
    
LA75:
    cmp byte [eswitch], 0
    je LA60
    call vstack_clear
    call COMMENT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA79
    
LA79:
    
LA60:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA80
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    
LA80:
    cmp byte [eswitch], 0
    je LA81
    call vstack_clear
    call OUTPUT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA82
    
LA82:
    
LA81:
    cmp byte [eswitch], 1
    je LA83
    
LA84:
    call vstack_clear
    call EX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA85
    print "cmp byte [eswitch], 1"
    call newline
    print "je terminate_program"
    call newline
    
LA85:
    cmp byte [eswitch], 0
    je LA86
    call vstack_clear
    call OUTPUT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA87
    
LA87:
    
LA86:
    cmp byte [eswitch], 0
    je LA84
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
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
    cmp byte [eswitch], 1
    je LA89
    
LA90:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA91
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA91:
    
LA92:
    cmp byte [eswitch], 0
    je LA90
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA89:
    
LA93:
    ret
    
DEFINITION:
    call test_for_id
    cmp byte [eswitch], 1
    je LA94
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    cmp byte [eswitch], 1
    je terminate_program
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ";"
    cmp byte [eswitch], 1
    je terminate_program
    print "ret"
    call newline
    
LA94:
    
LA95:
    ret
    
TOKEN_DEFINITION:
    call test_for_id
    cmp byte [eswitch], 1
    je LA96
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string ":"
    cmp byte [eswitch], 1
    je terminate_program
    call vstack_clear
    call TX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ";"
    cmp byte [eswitch], 1
    je terminate_program
    print "ret"
    call newline
    
LA96:
    
LA97:
    ret
    
TX1:
    call vstack_clear
    call TX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA98
    
LA99:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA100
    print "je T"
    call gn1
    call newline
    call vstack_clear
    call TX2
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA100:
    
LA101:
    cmp byte [eswitch], 0
    je LA99
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
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
    cmp byte [eswitch], 1
    je LA103
    print "cmp byte [eswitch], 1"
    call newline
    print "je T"
    call gn1
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    
LA104:
    call vstack_clear
    call TX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA105
    print "cmp byte [pflag], 0"
    call newline
    print "jne T"
    call gn1
    call newline
    
LA105:
    
LA106:
    cmp byte [eswitch], 0
    je LA104
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
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
    cmp byte [eswitch], 1
    je LA108
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 1"
    call newline
    
LA108:
    cmp byte [eswitch], 0
    je LA109
    test_input_string ".DELTOK"
    cmp byte [eswitch], 1
    je LA110
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 0"
    call newline
    
LA110:
    cmp byte [eswitch], 0
    je LA109
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA111
    call label
    print "T"
    call gn1
    print ":"
    call newline
    call vstack_clear
    call TX3
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "je T"
    call gn1
    call newline
    
LA111:
    
LA109:
    cmp byte [eswitch], 1
    je LA112
    print "mov byte [eswitch], 0"
    call newline
    
LA112:
    cmp byte [eswitch], 0
    je LA113
    test_input_string ".ANYBUT("
    cmp byte [eswitch], 1
    je LA114
    call vstack_clear
    call CX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "NOT"
    print "scan_or_parse"
    call newline
    
LA114:
    cmp byte [eswitch], 0
    je LA113
    test_input_string ".ANY("
    cmp byte [eswitch], 1
    je LA115
    call vstack_clear
    call CX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "call scan_or_parse"
    call newline
    
LA115:
    cmp byte [eswitch], 0
    je LA113
    call test_for_id
    cmp byte [eswitch], 1
    je LA116
    print "CLL "
    call copy_last_match
    call newline
    
LA116:
    cmp byte [eswitch], 0
    je LA113
    test_input_string "("
    cmp byte [eswitch], 1
    je LA117
    call vstack_clear
    call TX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA117:
    
LA113:
    ret
    
CX1:
    call vstack_clear
    call CX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA118
    
LA119:
    test_input_string "!"
    cmp byte [eswitch], 1
    je LA120
    print "je C"
    call gn1
    call newline
    call vstack_clear
    call CX2
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA120:
    
LA121:
    cmp byte [eswitch], 0
    je LA119
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
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
    cmp byte [eswitch], 1
    je LA123
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA124
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
    cmp byte [eswitch], 1
    je terminate_program
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
    cmp byte [eswitch], 0
    je LA125
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA126
    print "CE "
    call copy_last_match
    call newline
    
LA126:
    
LA125:
    cmp byte [eswitch], 1
    je terminate_program
    
LA123:
    
LA127:
    ret
    
CX3:
    call test_for_number
    cmp byte [eswitch], 1
    je LA128
    
LA128:
    
LA129:
    ret
    
COMMENT:
    test_input_string "//"
    cmp byte [eswitch], 1
    je LA130
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA130:
    
LA131:
    ret
    