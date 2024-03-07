
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
    call vstack_clear
    call ID
    call vstack_restore
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
    call vstack_clear
    call RAW
    call vstack_restore
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
    call vstack_clear
    call RAW
    call vstack_restore
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
    call vstack_clear
    call ID
    call vstack_restore
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
    test_input_string ".RET"
    cmp byte [eswitch], 1
    je LA49
    print "ret"
    call newline
    
LA49:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".NOT"
    cmp byte [eswitch], 1
    je LA50
    call vstack_clear
    call STRING
    call vstack_restore
    cmp byte [eswitch], 1
    je LA51
    
LA51:
    cmp byte [eswitch], 0
    je LA52
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je LA53
    
LA53:
    
LA52:
    cmp byte [eswitch], 1
    je terminate_program
    print "match_not "
    call copy_last_match
    call newline
    
LA50:
    cmp byte [eswitch], 0
    je LA48
    test_input_string "%>"
    cmp byte [eswitch], 1
    je LA54
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA54:
    cmp byte [eswitch], 0
    je LA48
    test_input_string "("
    cmp byte [eswitch], 1
    je LA55
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA55:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".EMPTY"
    cmp byte [eswitch], 1
    je LA56
    print "mov byte [eswitch], 0"
    call newline
    
LA56:
    cmp byte [eswitch], 0
    je LA48
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA57
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
    
LA57:
    cmp byte [eswitch], 0
    je LA48
    test_input_string "{"
    cmp byte [eswitch], 1
    je LA58
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA59:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA60
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA60:
    
LA61:
    cmp byte [eswitch], 0
    je LA59
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "}"
    cmp byte [eswitch], 1
    je terminate_program
    
LA58:
    cmp byte [eswitch], 0
    je LA48
    call vstack_clear
    call COMMENT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA62
    
LA62:
    
LA48:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA63
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    
LA63:
    cmp byte [eswitch], 0
    je LA64
    call vstack_clear
    call OUTPUT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA65
    
LA65:
    
LA64:
    cmp byte [eswitch], 1
    je LA66
    
LA67:
    call vstack_clear
    call EX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA68
    print "cmp byte [eswitch], 1"
    call newline
    print "je terminate_program"
    call newline
    
LA68:
    cmp byte [eswitch], 0
    je LA69
    call vstack_clear
    call OUTPUT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA70
    
LA70:
    
LA69:
    cmp byte [eswitch], 0
    je LA67
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA66:
    
LA71:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA72
    
LA73:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA74
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
    
LA74:
    
LA75:
    cmp byte [eswitch], 0
    je LA73
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA72:
    
LA76:
    ret
    
DEFINITION:
    call vstack_clear
    call ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA77
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
    
LA77:
    
LA78:
    ret
    
TOKEN_DEFINITION:
    call vstack_clear
    call ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA79
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
    
LA79:
    
LA80:
    ret
    
TX1:
    call vstack_clear
    call TX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA81
    
LA82:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA83
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
    
LA83:
    
LA84:
    cmp byte [eswitch], 0
    je LA82
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA81:
    
LA85:
    ret
    
TX2:
    call vstack_clear
    call TX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA86
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    
LA87:
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
    
LA88:
    
LA89:
    cmp byte [eswitch], 0
    je LA87
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA86:
    
LA90:
    ret
    
TX3:
    test_input_string ".TOKEN"
    cmp byte [eswitch], 1
    je LA91
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 1"
    call newline
    print "call clear_token"
    call newline
    
LA91:
    cmp byte [eswitch], 0
    je LA92
    test_input_string ".DELTOK"
    cmp byte [eswitch], 1
    je LA93
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 0"
    call newline
    
LA93:
    cmp byte [eswitch], 0
    je LA92
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA94
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
    
LA94:
    
LA92:
    cmp byte [eswitch], 1
    je LA95
    print "mov byte [eswitch], 0"
    call newline
    
LA95:
    cmp byte [eswitch], 0
    je LA96
    test_input_string ".ANYBUT("
    cmp byte [eswitch], 1
    je LA97
    call vstack_clear
    call CX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "test byte [eswitch], 0"
    call newline
    print "setz [eswitch]"
    call newline
    print "call scan_or_parse"
    call newline
    
LA97:
    cmp byte [eswitch], 0
    je LA96
    test_input_string ".ANY("
    cmp byte [eswitch], 1
    je LA98
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
    
LA98:
    cmp byte [eswitch], 0
    je LA96
    call vstack_clear
    call ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA99
    print "call "
    call copy_last_match
    call newline
    
LA99:
    cmp byte [eswitch], 0
    je LA96
    test_input_string "("
    cmp byte [eswitch], 1
    je LA100
    call vstack_clear
    call TX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA100:
    
LA96:
    ret
    
CX1:
    call vstack_clear
    call CX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA101
    
LA102:
    test_input_string "!"
    cmp byte [eswitch], 1
    je LA103
    print "je "
    call gn1
    call newline
    call vstack_clear
    call CX2
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA103:
    
LA104:
    cmp byte [eswitch], 0
    je LA102
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA101:
    
LA105:
    ret
    
CX2:
    call vstack_clear
    call CX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA106
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA107
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
    
LA107:
    cmp byte [eswitch], 0
    je LA108
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA109
    print "mov edi, "
    call copy_last_match
    call newline
    print "call test_char_equal"
    call newline
    
LA109:
    
LA108:
    cmp byte [eswitch], 1
    je terminate_program
    
LA106:
    
LA110:
    ret
    
CX3:
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je LA111
    
LA111:
    
LA112:
    ret
    
COMMENT:
    test_input_string "//"
    cmp byte [eswitch], 1
    je LA113
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA113:
    
LA114:
    ret
    
; -- Tokens --
    
PREFIX:
    
LA115:
    mov edi, 32
    call test_char_equal
    je LA116
    mov edi, 9
    call test_char_equal
    je LA116
    mov edi, 13
    call test_char_equal
    je LA116
    mov edi, 10
    call test_char_equal
    
LA116:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA115
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA117
    
LA117:
    
LA118:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA119
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA119
    call DIGIT
    cmp byte [eswitch], 1
    je LA119
    
LA120:
    call DIGIT
    cmp byte [eswitch], 0
    je LA120
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA119
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA119
    
LA119:
    
LA121:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA122
    mov edi, 57
    call test_char_less_equal
    
LA122:
    
LA123:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA124
    
LA124:
    
LA125:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA126
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA126
    call ALPHA
    cmp byte [eswitch], 1
    je LA126
    
LA127:
    call ALPHA
    cmp byte [eswitch], 1
    je LA128
    
LA128:
    cmp byte [eswitch], 0
    je LA129
    call DIGIT
    cmp byte [eswitch], 1
    je LA130
    
LA130:
    
LA129:
    cmp byte [eswitch], 0
    je LA127
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA126
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA126
    
LA126:
    
LA131:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA132
    mov edi, 90
    call test_char_less_equal
    
LA132:
    je LA133
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA134
    mov edi, 122
    call test_char_less_equal
    
LA134:
    
LA133:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA135
    
LA135:
    
LA136:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA137
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA137
    mov edi, 34
    call test_char_equal
    
LA138:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA137
    
LA139:
    mov edi, 13
    call test_char_equal
    je LA140
    mov edi, 10
    call test_char_equal
    je LA140
    mov edi, 34
    call test_char_equal
    
LA140:
    test byte [eswitch], 0
    setz [eswitch]
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA139
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA137
    mov edi, 34
    call test_char_equal
    
LA141:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA137
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA137
    
LA137:
    
LA142:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA143
    mov edi, 34
    call test_char_equal
    
LA144:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA143
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA143
    
LA145:
    mov edi, 13
    call test_char_equal
    je LA146
    mov edi, 10
    call test_char_equal
    je LA146
    mov edi, 34
    call test_char_equal
    
LA146:
    test byte [eswitch], 0
    setz [eswitch]
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA145
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA143
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA143
    mov edi, 34
    call test_char_equal
    
LA147:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA143
    
LA143:
    
LA148:
    ret
    