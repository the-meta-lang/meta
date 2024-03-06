
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
    call test_for_string
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
    call test_for_string
    cmp byte [eswitch], 1
    je LA49
    print "test_input_string "
    call copy_last_match
    call newline
    
LA49:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".ID"
    cmp byte [eswitch], 1
    je LA50
    print "call test_for_id"
    call newline
    
LA50:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".RET"
    cmp byte [eswitch], 1
    je LA51
    print "ret"
    call newline
    
LA51:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".NOT"
    cmp byte [eswitch], 1
    je LA52
    call test_for_string
    cmp byte [eswitch], 1
    je LA53
    
LA53:
    cmp byte [eswitch], 0
    je LA54
    call test_for_number
    cmp byte [eswitch], 1
    je LA55
    
LA55:
    
LA54:
    cmp byte [eswitch], 1
    je terminate_program
    print "match_not "
    call copy_last_match
    call newline
    
LA52:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".NUMBER"
    cmp byte [eswitch], 1
    je LA56
    print "call test_for_number"
    call newline
    
LA56:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".STRING_RAW"
    cmp byte [eswitch], 1
    je LA57
    print "call test_for_string_raw"
    call newline
    
LA57:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".STRING"
    cmp byte [eswitch], 1
    je LA58
    print "call test_for_string"
    call newline
    
LA58:
    cmp byte [eswitch], 0
    je LA48
    test_input_string "%>"
    cmp byte [eswitch], 1
    je LA59
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA59:
    cmp byte [eswitch], 0
    je LA48
    test_input_string "("
    cmp byte [eswitch], 1
    je LA60
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA60:
    cmp byte [eswitch], 0
    je LA48
    test_input_string ".EMPTY"
    cmp byte [eswitch], 1
    je LA61
    print "mov byte [eswitch], 0"
    call newline
    
LA61:
    cmp byte [eswitch], 0
    je LA48
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA62
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
    
LA62:
    cmp byte [eswitch], 0
    je LA48
    test_input_string "{"
    cmp byte [eswitch], 1
    je LA63
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA64:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA65
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA65:
    
LA66:
    cmp byte [eswitch], 0
    je LA64
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "}"
    cmp byte [eswitch], 1
    je terminate_program
    
LA63:
    cmp byte [eswitch], 0
    je LA48
    call vstack_clear
    call COMMENT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA67
    
LA67:
    
LA48:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA68
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
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
    cmp byte [eswitch], 1
    je LA71
    
LA72:
    call vstack_clear
    call EX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA73
    print "cmp byte [eswitch], 1"
    call newline
    print "je terminate_program"
    call newline
    
LA73:
    cmp byte [eswitch], 0
    je LA74
    call vstack_clear
    call OUTPUT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA75
    
LA75:
    
LA74:
    cmp byte [eswitch], 0
    je LA72
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA71:
    
LA76:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA77
    
LA78:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA79
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
    
LA79:
    
LA80:
    cmp byte [eswitch], 0
    je LA78
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA77:
    
LA81:
    ret
    
DEFINITION:
    call test_for_id
    cmp byte [eswitch], 1
    je LA82
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
    
LA82:
    
LA83:
    ret
    
TOKEN_DEFINITION:
    call test_for_id
    cmp byte [eswitch], 1
    je LA84
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
    
LA84:
    
LA85:
    ret
    
TX1:
    call vstack_clear
    call TX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA86
    
LA87:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA88
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
    
TX2:
    call vstack_clear
    call TX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA91
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    
LA92:
    call vstack_clear
    call TX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA93
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    
LA93:
    
LA94:
    cmp byte [eswitch], 0
    je LA92
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA91:
    
LA95:
    ret
    
TX3:
    test_input_string ".TOKEN"
    cmp byte [eswitch], 1
    je LA96
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 1"
    call newline
    print "call clear_token"
    call newline
    
LA96:
    cmp byte [eswitch], 0
    je LA97
    test_input_string ".DELTOK"
    cmp byte [eswitch], 1
    je LA98
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 0"
    call newline
    
LA98:
    cmp byte [eswitch], 0
    je LA97
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA99
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
    
LA99:
    
LA97:
    cmp byte [eswitch], 1
    je LA100
    print "mov byte [eswitch], 0"
    call newline
    
LA100:
    cmp byte [eswitch], 0
    je LA101
    test_input_string ".ANYBUT("
    cmp byte [eswitch], 1
    je LA102
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
    
LA102:
    cmp byte [eswitch], 0
    je LA101
    test_input_string ".ANY("
    cmp byte [eswitch], 1
    je LA103
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
    
LA103:
    cmp byte [eswitch], 0
    je LA101
    call test_for_id
    cmp byte [eswitch], 1
    je LA104
    print "call "
    call copy_last_match
    call newline
    
LA104:
    cmp byte [eswitch], 0
    je LA101
    test_input_string "("
    cmp byte [eswitch], 1
    je LA105
    call vstack_clear
    call TX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA105:
    
LA101:
    ret
    
CX1:
    call vstack_clear
    call CX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA106
    
LA107:
    test_input_string "!"
    cmp byte [eswitch], 1
    je LA108
    print "je "
    call gn1
    call newline
    call vstack_clear
    call CX2
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA108:
    
LA109:
    cmp byte [eswitch], 0
    je LA107
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA106:
    
LA110:
    ret
    
CX2:
    call vstack_clear
    call CX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA111
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA112
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
    
LA112:
    cmp byte [eswitch], 0
    je LA113
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA114
    print "mov edi, "
    call copy_last_match
    call newline
    print "call test_char_equal"
    call newline
    
LA114:
    
LA113:
    cmp byte [eswitch], 1
    je terminate_program
    
LA111:
    
LA115:
    ret
    
CX3:
    call test_for_number
    cmp byte [eswitch], 1
    je LA116
    
LA116:
    
LA117:
    ret
    
COMMENT:
    test_input_string "//"
    cmp byte [eswitch], 1
    je LA118
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA118:
    
LA119:
    ret
    
