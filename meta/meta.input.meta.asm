
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
    
OUT1:
    test_input_string "*1"
    cmp byte [eswitch], 1
    je LA22
    print "call gn1"
    call newline
    
LA22:
    cmp byte [eswitch], 0
    je LA23
    test_input_string "*2"
    cmp byte [eswitch], 1
    je LA24
    print "call gn2"
    call newline
    
LA24:
    cmp byte [eswitch], 0
    je LA23
    test_input_string "*3"
    cmp byte [eswitch], 1
    je LA25
    print "call gn3"
    call newline
    
LA25:
    cmp byte [eswitch], 0
    je LA23
    test_input_string "*4"
    cmp byte [eswitch], 1
    je LA26
    print "call gn4"
    call newline
    
LA26:
    cmp byte [eswitch], 0
    je LA23
    test_input_string "*"
    cmp byte [eswitch], 1
    je LA27
    print "call copy_last_match"
    call newline
    
LA27:
    cmp byte [eswitch], 0
    je LA23
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA28
    print "mov edi, str_vector_8192"
    call newline
    print "call vector_pop_string"
    call newline
    print "call print_mm32"
    call newline
    
LA28:
    cmp byte [eswitch], 0
    je LA23
    call vstack_clear
    call STRING
    call vstack_restore
    cmp byte [eswitch], 1
    je LA29
    print "print "
    call copy_last_match
    call newline
    
LA29:
    
LA23:
    ret
    
OUT_IMMEDIATE:
    call test_for_string_raw
    cmp byte [eswitch], 1
    je LA30
    call copy_last_match
    call newline
    
LA30:
    
LA31:
    ret
    
OUTPUT:
    test_input_string "->"
    cmp byte [eswitch], 1
    je LA32
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA33:
    call vstack_clear
    call OUT1
    call vstack_restore
    cmp byte [eswitch], 1
    je LA34
    
LA34:
    
LA35:
    cmp byte [eswitch], 0
    je LA33
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "call newline"
    call newline
    
LA32:
    cmp byte [eswitch], 0
    je LA36
    test_input_string ".LABEL"
    cmp byte [eswitch], 1
    je LA37
    print "call label"
    call newline
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA38:
    call vstack_clear
    call OUT1
    call vstack_restore
    cmp byte [eswitch], 1
    je LA39
    
LA39:
    
LA40:
    cmp byte [eswitch], 0
    je LA38
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "call newline"
    call newline
    
LA37:
    cmp byte [eswitch], 0
    je LA36
    test_input_string ".RS"
    cmp byte [eswitch], 1
    je LA41
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA42:
    call vstack_clear
    call OUT1
    call vstack_restore
    cmp byte [eswitch], 0
    je LA42
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA41:
    
LA36:
    cmp byte [eswitch], 1
    je LA43
    
LA43:
    cmp byte [eswitch], 0
    je LA44
    test_input_string ".DIRECT"
    cmp byte [eswitch], 1
    je LA45
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA46:
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    cmp byte [eswitch], 0
    je LA46
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA45:
    
LA44:
    ret
    
EX3:
    call test_for_id
    cmp byte [eswitch], 1
    je LA47
    print "call vstack_clear"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_restore"
    call newline
    
LA47:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".ID"
    cmp byte [eswitch], 1
    je LA49
    print "call test_for_id"
    call newline
    
LA49:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".RET"
    cmp byte [eswitch], 1
    je LA50
    print "ret"
    call newline
    
LA50:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".NOT"
    cmp byte [eswitch], 1
    je LA51
    call vstack_clear
    call STRING
    call vstack_restore
    cmp byte [eswitch], 1
    je LA52
    
LA52:
    cmp byte [eswitch], 0
    je LA53
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je LA54
    
LA54:
    
LA53:
    cmp byte [eswitch], 1
    je terminate_program
    print "match_not "
    call copy_last_match
    call newline
    
LA51:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".STRING_RAW"
    cmp byte [eswitch], 1
    je LA55
    print "call test_for_string_raw"
    call newline
    
LA55:
    cmp byte [eswitch], 0
    je LA48
    test_input_string "%>"
    cmp byte [eswitch], 1
    je LA56
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA56:
    cmp byte [eswitch], 0
    je LA48
    test_input_string "("
    cmp byte [eswitch], 1
    je LA57
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA57:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".EMPTY"
    cmp byte [eswitch], 1
    je LA58
    print "mov byte [eswitch], 0"
    call newline
    
LA58:
    cmp byte [eswitch], 0
    je LA48
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA59
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
    
LA59:
    cmp byte [eswitch], 0
    je LA48
    test_input_string "{"
    cmp byte [eswitch], 1
    je LA60
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA61:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA62
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA62:
    
LA63:
    cmp byte [eswitch], 0
    je LA61
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "}"
    cmp byte [eswitch], 1
    je terminate_program
    
LA60:
    cmp byte [eswitch], 0
    je LA48
    call vstack_clear
    call COMMENT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA64
    
LA64:
    
LA48:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA65
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    
LA65:
    cmp byte [eswitch], 0
    je LA66
    call vstack_clear
    call OUTPUT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA67
    
LA67:
    
LA66:
    cmp byte [eswitch], 1
    je LA68
    
LA69:
    call vstack_clear
    call EX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA70
    print "cmp byte [eswitch], 1"
    call newline
    print "je terminate_program"
    call newline
    
LA70:
    cmp byte [eswitch], 0
    je LA71
    call vstack_clear
    call OUTPUT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA72
    
LA72:
    
LA71:
    cmp byte [eswitch], 0
    je LA69
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA68:
    
LA73:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA74
    
LA75:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA76
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
    
LA76:
    
LA77:
    cmp byte [eswitch], 0
    je LA75
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA74:
    
LA78:
    ret
    
DEFINITION:
    call test_for_id
    cmp byte [eswitch], 1
    je LA79
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
    
LA79:
    
LA80:
    ret
    
TOKEN_DEFINITION:
    call test_for_id
    cmp byte [eswitch], 1
    je LA81
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
    
LA81:
    
LA82:
    ret
    
TX1:
    call vstack_clear
    call TX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA83
    
LA84:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA85
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call TX2
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA85:
    
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
    
LA87:
    ret
    
TX2:
    call vstack_clear
    call TX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA88
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    
LA89:
    call vstack_clear
    call TX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA90
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    
LA90:
    
LA91:
    cmp byte [eswitch], 0
    je LA89
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA88:
    
LA92:
    ret
    
TX3:
    test_input_string ".TOKEN"
    cmp byte [eswitch], 1
    je LA93
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 1"
    call newline
    print "call clear_token"
    call newline
    
LA93:
    cmp byte [eswitch], 0
    je LA94
    test_input_string ".DELTOK"
    cmp byte [eswitch], 1
    je LA95
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 0"
    call newline
    
LA95:
    cmp byte [eswitch], 0
    je LA94
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA96
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call TX3
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    
LA96:
    
LA94:
    cmp byte [eswitch], 1
    je LA97
    print "mov byte [eswitch], 0"
    call newline
    
LA97:
    cmp byte [eswitch], 0
    je LA98
    test_input_string ".ANYBUT("
    cmp byte [eswitch], 1
    je LA99
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
    
LA99:
    cmp byte [eswitch], 0
    je LA98
    test_input_string ".ANY("
    cmp byte [eswitch], 1
    je LA100
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
    
LA100:
    cmp byte [eswitch], 0
    je LA98
    call test_for_id
    cmp byte [eswitch], 1
    je LA101
    print "call "
    call copy_last_match
    call newline
    
LA101:
    cmp byte [eswitch], 0
    je LA98
    test_input_string "("
    cmp byte [eswitch], 1
    je LA102
    call vstack_clear
    call TX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA102:
    
LA98:
    ret
    
CX1:
    call vstack_clear
    call CX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA103
    
LA104:
    test_input_string "!"
    cmp byte [eswitch], 1
    je LA105
    print "je "
    call gn1
    call newline
    call vstack_clear
    call CX2
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA105:
    
LA106:
    cmp byte [eswitch], 0
    je LA104
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA103:
    
LA107:
    ret
    
CX2:
    call vstack_clear
    call CX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA108
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA109
    print "mov edi, "
    call copy_last_match
    call newline
    print "call test_char_greater_equal"
    call newline
    print "cmp byte [eswitch], 0"
    call newline
    print "jne "
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
    call gn1
    print ":"
    call newline
    
LA109:
    cmp byte [eswitch], 0
    je LA110
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA111
    print "mov edi, "
    call copy_last_match
    call newline
    print "call test_char_equal"
    call newline
    
LA111:
    
LA110:
    cmp byte [eswitch], 1
    je terminate_program
    
LA108:
    
LA112:
    ret
    
CX3:
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je LA113
    
LA113:
    
LA114:
    ret
    
COMMENT:
    test_input_string "//"
    cmp byte [eswitch], 1
    je LA115
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA115:
    
LA116:
    ret
    
; -- Tokens --
    
PREFIX:
    
LA117:
    mov edi, 32
    call test_char_equal
    je LA118
    mov edi, 9
    call test_char_equal
    je LA118
    mov edi, 13
    call test_char_equal
    je LA118
    mov edi, 10
    call test_char_equal
    
LA118:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA117
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA119
    
LA119:
    
LA120:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA121
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA121
    call DIGIT
    cmp byte [eswitch], 1
    je LA121
    
LA122:
    call DIGIT
    cmp byte [eswitch], 0
    je LA122
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA121
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA121
    
LA121:
    
LA123:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA124
    mov edi, 57
    call test_char_less_equal
    
LA124:
    
LA125:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA126
    
LA126:
    
LA127:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA128
    mov edi, 34
    call test_char_equal
    
LA129:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA128
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA128
    
LA130:
    mov edi, 13
    call test_char_equal
    je LA131
    mov edi, 10
    call test_char_equal
    je LA131
    mov edi, 34
    call test_char_equal
    
LA131:
    test byte [eswitch], 0
    setz [eswitch]
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA130
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA128
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA128
    mov edi, 34
    call test_char_equal
    
LA132:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA128
    
LA128:
    
LA133:
    ret
    