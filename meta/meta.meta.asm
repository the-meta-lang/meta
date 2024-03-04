
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
    test_input_string ".SYNTAX"
    jne LA2
    call test_for_id
    mov edi, 0
    jne terminate_program ; 0
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
    
LA3:
    call vstack_clear
    call DEFINITION
    call vstack_restore
    jne LA4
    
LA4:
    je LA5
    call vstack_clear
    call INCLUDE_STATEMENT
    call vstack_restore
    jne LA6
    
LA6:
    je LA5
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA7
    
LA7:
    
LA5:
    je LA3
    call set_true
    mov edi, 11
    jne terminate_program ; 11
    test_input_string ".END"
    mov edi, 12
    jne terminate_program ; 12
    
LA2:
    
LA8:
    jne LA9
    
LA9:
    
LA10:
    je LA1
    call set_true
    mov edi, 13
    jne terminate_program ; 13
    
LA11:
    
LA12:
    ret
    
INCLUDE_STATEMENT:
    test_input_string ".INCLUDE"
    jne LA13
    call test_for_string_raw
    mov edi, 14
    jne terminate_program ; 14
    test_input_string ";"
    mov edi, 15
    jne terminate_program ; 15
    mov esi, last_match
    call import_meta_file_mm32
    call set_true
    
LA13:
    
LA14:
    ret
    
DATA_TYPE:
    test_input_string "{"
    jne LA15
    call label
    print "section .bss"
    call newline
    call test_for_number
    mov edi, 16
    jne terminate_program ; 16
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print " resb "
    call copy_last_match
    call newline
    test_input_string "}"
    mov edi, 18
    jne terminate_program ; 18
    
LA15:
    
LA16:
    jne LA17
    
LA17:
    je LA18
    call test_for_string
    jne LA19
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
    
LA19:
    
LA20:
    jne LA21
    
LA21:
    je LA18
    call test_for_number
    jne LA22
    call label
    print "section .data"
    call newline
    mov edi, str_vector_8192
    call vector_pop_string
    call print_mm32
    print " dd "
    call copy_last_match
    call newline
    
LA22:
    
LA23:
    jne LA24
    
LA24:
    
LA18:
    jne LA25
    
LA25:
    
LA26:
    ret
    
OUT1:
    test_input_string "*1"
    jne LA27
    print "call gn1"
    call newline
    
LA27:
    je LA28
    test_input_string "*2"
    jne LA29
    print "call gn2"
    call newline
    
LA29:
    je LA28
    test_input_string "*3"
    jne LA30
    print "call gn3"
    call newline
    
LA30:
    je LA28
    test_input_string "*4"
    jne LA31
    print "call gn4"
    call newline
    
LA31:
    je LA28
    test_input_string "*"
    jne LA32
    print "call copy_last_match"
    call newline
    
LA32:
    je LA28
    test_input_string "%"
    jne LA33
    print "mov edi, str_vector_8192"
    call newline
    print "call vector_pop_string"
    call newline
    print "call print_mm32"
    call newline
    
LA33:
    je LA28
    call test_for_string
    jne LA34
    print "print "
    call copy_last_match
    call newline
    
LA34:
    
LA28:
    ret
    
OUT_IMMEDIATE:
    call test_for_string_raw
    jne LA35
    call copy_last_match
    call newline
    
LA35:
    
LA36:
    ret
    
OUTPUT:
    test_input_string "->"
    jne LA37
    test_input_string "("
    mov edi, 31
    jne terminate_program ; 31
    
LA38:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA39
    
LA39:
    
LA40:
    je LA38
    call set_true
    mov edi, 32
    jne terminate_program ; 32
    test_input_string ")"
    mov edi, 33
    jne terminate_program ; 33
    print "call newline"
    call newline
    
LA37:
    je LA41
    test_input_string ".LABEL"
    jne LA42
    print "call label"
    call newline
    test_input_string "("
    mov edi, 36
    jne terminate_program ; 36
    
LA43:
    call vstack_clear
    call OUT1
    call vstack_restore
    jne LA44
    
LA44:
    
LA45:
    je LA43
    call set_true
    mov edi, 37
    jne terminate_program ; 37
    test_input_string ")"
    mov edi, 38
    jne terminate_program ; 38
    print "call newline"
    call newline
    
LA42:
    je LA41
    test_input_string ".RS"
    jne LA46
    test_input_string "("
    mov edi, 40
    jne terminate_program ; 40
    
LA47:
    call vstack_clear
    call OUT1
    call vstack_restore
    je LA47
    call set_true
    mov edi, 41
    jne terminate_program ; 41
    test_input_string ")"
    mov edi, 42
    jne terminate_program ; 42
    
LA46:
    
LA41:
    jne LA48
    
LA48:
    je LA49
    test_input_string ".DIRECT"
    jne LA50
    test_input_string "("
    mov edi, 43
    jne terminate_program ; 43
    
LA51:
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    je LA51
    call set_true
    mov edi, 44
    jne terminate_program ; 44
    test_input_string ")"
    mov edi, 45
    jne terminate_program ; 45
    
LA50:
    
LA49:
    ret
    
EX3:
    call test_for_id
    jne LA52
    print "call vstack_clear"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_restore"
    call newline
    
LA52:
    je LA53
    call test_for_string
    jne LA54
    print "test_input_string "
    call copy_last_match
    call newline
    
LA54:
    je LA53
    test_input_string ".ID"
    jne LA55
    print "call test_for_id"
    call newline
    
LA55:
    je LA53
    test_input_string ".RET"
    jne LA56
    print "ret"
    call newline
    
LA56:
    je LA53
    test_input_string ".NOT"
    jne LA57
    call test_for_string
    jne LA58
    
LA58:
    je LA59
    call test_for_number
    jne LA60
    
LA60:
    
LA59:
    mov edi, 52
    jne terminate_program ; 52
    print "match_not "
    call copy_last_match
    call newline
    
LA57:
    je LA53
    test_input_string ".NUMBER"
    jne LA61
    print "call test_for_number"
    call newline
    
LA61:
    je LA53
    test_input_string ".STRING_RAW"
    jne LA62
    print "call test_for_string_raw"
    call newline
    
LA62:
    je LA53
    test_input_string ".STRING"
    jne LA63
    print "call test_for_string"
    call newline
    
LA63:
    je LA53
    test_input_string "%>"
    jne LA64
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA64:
    je LA53
    test_input_string "("
    jne LA65
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 60
    jne terminate_program ; 60
    test_input_string ")"
    mov edi, 61
    jne terminate_program ; 61
    
LA65:
    je LA53
    test_input_string ".EMPTY"
    jne LA66
    print "call set_true"
    call newline
    
LA66:
    je LA53
    test_input_string "$"
    jne LA67
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call EX3
    call vstack_restore
    mov edi, 63
    jne terminate_program ; 63
    print "je "
    call gn1
    call newline
    print "call set_true"
    call newline
    
LA67:
    je LA53
    test_input_string "{"
    jne LA68
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 66
    jne terminate_program ; 66
    
LA69:
    test_input_string "|"
    jne LA70
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 67
    jne terminate_program ; 67
    
LA70:
    
LA71:
    je LA69
    call set_true
    mov edi, 68
    jne terminate_program ; 68
    test_input_string "}"
    mov edi, 69
    jne terminate_program ; 69
    
LA68:
    je LA53
    call vstack_clear
    call COMMENT
    call vstack_restore
    jne LA72
    
LA72:
    
LA53:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA73
    print "jne "
    call gn1
    call newline
    
LA73:
    je LA74
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA75
    
LA75:
    
LA74:
    jne LA76
    
LA77:
    call vstack_clear
    call EX3
    call vstack_restore
    jne LA78
    print "jne terminate_program"
    call newline
    
LA78:
    je LA79
    call vstack_clear
    call OUTPUT
    call vstack_restore
    jne LA80
    
LA80:
    
LA79:
    je LA77
    call set_true
    mov edi, 72
    jne terminate_program ; 72
    call label
    call gn1
    print ":"
    call newline
    
LA76:
    
LA81:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    jne LA82
    
LA83:
    test_input_string "|"
    jne LA84
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    mov edi, 74
    jne terminate_program ; 74
    
LA84:
    
LA85:
    je LA83
    call set_true
    mov edi, 75
    jne terminate_program ; 75
    call label
    call gn1
    print ":"
    call newline
    
LA82:
    
LA86:
    ret
    
DEFINITION:
    call test_for_id
    jne LA87
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    mov edi, 76
    jne terminate_program ; 76
    call vstack_clear
    call EX1
    call vstack_restore
    mov edi, 77
    jne terminate_program ; 77
    test_input_string ";"
    mov edi, 78
    jne terminate_program ; 78
    print "ret"
    call newline
    
LA87:
    
LA88:
    ret
    
COMMENT:
    test_input_string "//"
    jne LA89
    match_not 10
    mov edi, 80
    jne terminate_program ; 80
    
LA89:
    
LA90:
    ret
    
