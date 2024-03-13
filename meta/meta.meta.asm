
%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .text
    global _start
    
_start:
    mov esi, 0
    call premalloc
    call _read_file_argument
    call _read_file
    push ebp
    mov ebp, esp
    call PROGRAM
    pop ebp
    mov edi, outbuff
    call print_mm32
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
    call label
    print "section .text"
    call newline
    print "global _start"
    call newline
    
LA1:
    test_input_string ".TOKENS"
    cmp byte [eswitch], 1
    je LA2
    call label
    print "; -- Tokens --"
    call newline
    
LA3:
    error_store 'TOKEN_DEFINITION'
    call vstack_clear
    call TOKEN_DEFINITION
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA4
    
LA4:
    cmp byte [eswitch], 0
    je LA5
    error_store 'COMMENT'
    call vstack_clear
    call COMMENT
    call vstack_restore
    call error_clear
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
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "_start:"
    call newline
    print "mov esi, 0"
    call newline
    print "call premalloc"
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
    print "mov edi, outbuff"
    call newline
    print "call print_mm32"
    call newline
    print "mov eax, 1"
    call newline
    print "mov ebx, 0"
    call newline
    print "int 0x80"
    call newline
    
LA11:
    error_store 'DEFINITION'
    call vstack_clear
    call DEFINITION
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA12
    
LA12:
    cmp byte [eswitch], 0
    je LA13
    error_store 'IMPORT_STATEMENT'
    call vstack_clear
    call IMPORT_STATEMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA14
    
LA14:
    cmp byte [eswitch], 0
    je LA13
    error_store 'COMMENT'
    call vstack_clear
    call COMMENT
    call vstack_restore
    call error_clear
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
    
LA18:
    
LA19:
    ret
    
IMPORT_STATEMENT:
    test_input_string "import"
    cmp byte [eswitch], 1
    je LA20
    error_store 'RAW'
    call vstack_clear
    call RAW
    call vstack_restore
    call error_clear
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
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA28
    print "mov esi, "
    call copy_last_match
    call newline
    print "mov edi, outbuff"
    call newline
    print "add edi, [outbuff_offset]"
    call newline
    print "call buffc"
    call newline
    print "add dword [outbuff_offset], eax"
    call newline
    
LA28:
    cmp byte [eswitch], 0
    je LA29
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA30
    print "call copy_last_match"
    call newline
    
LA30:
    
LA29:
    cmp byte [eswitch], 1
    je terminate_program
    
LA27:
    cmp byte [eswitch], 0
    je LA23
    test_input_string "#"
    cmp byte [eswitch], 1
    je LA31
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov esi, dword ["
    call copy_last_match
    print "]"
    call newline
    print "mov edi, outbuff"
    call newline
    print "add edi, dword [outbuff_offset]"
    call newline
    print "call inttostr"
    call newline
    print "add dword [outbuff_offset], eax"
    call newline
    
LA31:
    cmp byte [eswitch], 0
    je LA23
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA32
    print "mov esi, str_vector_8192"
    call newline
    print "call vector_pop_string"
    call newline
    print "mov esi, eax"
    call newline
    print "mov edi, outbuff"
    call newline
    print "add edi, [outbuff_offset]"
    call newline
    print "call buffc"
    call newline
    print "add dword [outbuff_offset], eax"
    call newline
    
LA32:
    cmp byte [eswitch], 0
    je LA23
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA33
    print "print "
    call copy_last_match
    call newline
    
LA33:
    
LA23:
    ret
    
OUT_IMMEDIATE:
    error_store 'RAW'
    call vstack_clear
    call RAW
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA34
    call copy_last_match
    call newline
    
LA34:
    
LA35:
    ret
    
OUTPUT:
    test_input_string "->"
    cmp byte [eswitch], 1
    je LA36
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA37:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA38
    
LA38:
    
LA39:
    cmp byte [eswitch], 0
    je LA37
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "call newline"
    call newline
    
LA36:
    cmp byte [eswitch], 0
    je LA40
    test_input_string ".LABEL"
    cmp byte [eswitch], 1
    je LA41
    print "call label"
    call newline
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA42:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA43
    
LA43:
    
LA44:
    cmp byte [eswitch], 0
    je LA42
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "call newline"
    call newline
    
LA41:
    cmp byte [eswitch], 0
    je LA40
    test_input_string ".RS"
    cmp byte [eswitch], 1
    je LA45
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA46:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA47
    
LA47:
    
LA48:
    cmp byte [eswitch], 0
    je LA46
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA45:
    
LA40:
    cmp byte [eswitch], 1
    je LA49
    
LA49:
    cmp byte [eswitch], 0
    je LA50
    test_input_string ".DIRECT"
    cmp byte [eswitch], 1
    je LA51
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA52:
    error_store 'OUT_IMMEDIATE'
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA52
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA51:
    
LA50:
    ret
    
EX3:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA53
    cmp byte [eswitch], 1
    je terminate_program
    print "error_store '"
    call copy_last_match
    print "'"
    call newline
    print "call vstack_clear"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_restore"
    call newline
    print "call error_clear"
    call newline
    
LA53:
    cmp byte [eswitch], 0
    je LA54
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA55
    print "test_input_string "
    call copy_last_match
    call newline
    
LA55:
    cmp byte [eswitch], 0
    je LA54
    test_input_string ".RET"
    cmp byte [eswitch], 1
    je LA56
    print "ret"
    call newline
    
LA56:
    cmp byte [eswitch], 0
    je LA54
    test_input_string ".NOT"
    cmp byte [eswitch], 1
    je LA57
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA58
    
LA58:
    cmp byte [eswitch], 0
    je LA59
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA60
    
LA60:
    
LA59:
    cmp byte [eswitch], 1
    je terminate_program
    print "match_not "
    call copy_last_match
    call newline
    
LA57:
    cmp byte [eswitch], 0
    je LA54
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA61
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA61:
    cmp byte [eswitch], 0
    je LA54
    test_input_string "("
    cmp byte [eswitch], 1
    je LA62
    error_store 'EX1'
    call vstack_clear
    call EX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA62:
    cmp byte [eswitch], 0
    je LA54
    test_input_string ".EMPTY"
    cmp byte [eswitch], 1
    je LA63
    print "mov byte [eswitch], 0"
    call newline
    
LA63:
    cmp byte [eswitch], 0
    je LA54
    test_input_string "$<"
    cmp byte [eswitch], 1
    je LA64
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "section .data"
    call newline
    print "MIN_ITER_"
    call gn3
    print " dd "
    call copy_last_match
    call newline
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA65
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "MAX_ITER_"
    call gn3
    print " dd "
    call copy_last_match
    call newline
    
LA65:
    cmp byte [eswitch], 0
    je LA66
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA67
    print "MAX_ITER_"
    call gn3
    print " dd 0xFFFFFFFF"
    call newline
    
LA67:
    
LA66:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ">"
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "section .text"
    call newline
    print "xor ecx, ecx"
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "push ecx"
    call newline
    error_store 'EX3'
    call vstack_clear
    call EX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "pop ecx"
    call newline
    print "cmp ecx, dword [MAX_ITER_"
    call gn3
    print "]"
    call newline
    print "jg "
    call gn2
    call newline
    print "cmp ecx, dword [MIN_ITER_"
    call gn3
    print "]"
    call newline
    print "jl "
    call gn1
    call newline
    print "inc ecx"
    call newline
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    call label
    call gn2
    print ":"
    call newline
    print "mov byte [eswitch], 0"
    call newline
    
LA64:
    cmp byte [eswitch], 0
    je LA54
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA68
    call label
    call gn1
    print ":"
    call newline
    error_store 'EX3'
    call vstack_clear
    call EX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    print "mov byte [eswitch], 0"
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    
LA68:
    cmp byte [eswitch], 0
    je LA54
    test_input_string "::"
    cmp byte [eswitch], 1
    je LA69
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "; Capture "
    call copy_last_match
    print " as single node"
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    
LA69:
    cmp byte [eswitch], 0
    je LA70
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA71
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "<"
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ">"
    cmp byte [eswitch], 1
    je terminate_program
    
LA71:
    
LA70:
    cmp byte [eswitch], 1
    je LA72
    cmp byte [eswitch], 1
    je terminate_program
    
LA72:
    cmp byte [eswitch], 0
    je LA54
    test_input_string "{"
    cmp byte [eswitch], 1
    je LA73
    cmp byte [eswitch], 1
    je terminate_program
    print "call backtrack_store"
    call newline
    error_store 'EX1'
    call vstack_clear
    call EX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA74:
    test_input_string "/"
    cmp byte [eswitch], 1
    je LA75
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "call backtrack_restore"
    call newline
    error_store 'EX1'
    call vstack_clear
    call EX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA75:
    
LA76:
    cmp byte [eswitch], 0
    je LA74
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "}"
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    print "call backtrack_restore"
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "call backtrack_clear"
    call newline
    
LA73:
    cmp byte [eswitch], 0
    je LA54
    error_store 'COMMENT'
    call vstack_clear
    call COMMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA77
    
LA77:
    
LA54:
    ret
    
EX2:
    error_store 'EX3'
    call vstack_clear
    call EX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA78
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    
LA78:
    cmp byte [eswitch], 0
    je LA79
    error_store 'OUTPUT'
    call vstack_clear
    call OUTPUT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA80
    
LA80:
    
LA79:
    cmp byte [eswitch], 1
    je LA81
    
LA82:
    error_store 'EX3'
    call vstack_clear
    call EX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA83
    print "cmp byte [eswitch], 1"
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "@"
    cmp byte [eswitch], 1
    je LA84
    cmp byte [eswitch], 1
    je terminate_program
    print "jne "
    call gn2
    call newline
    print "mov dword [outbuff_offset], 0"
    call newline
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA85:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA86
    
LA86:
    
LA87:
    cmp byte [eswitch], 0
    je LA85
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "mov edi, outbuff"
    call newline
    print "call print_mm32"
    call newline
    print "call stacktrace"
    call newline
    print "mov eax, 1"
    call newline
    print "mov ebx, 1"
    call newline
    print "int 0x80"
    call newline
    call label
    call gn2
    print ":"
    call newline
    
LA84:
    
LA88:
    cmp byte [eswitch], 1
    je LA89
    
LA89:
    cmp byte [eswitch], 0
    je LA90
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA91
    print "je terminate_program"
    call newline
    
LA91:
    
LA90:
    cmp byte [eswitch], 1
    je terminate_program
    
LA83:
    cmp byte [eswitch], 0
    je LA92
    error_store 'OUTPUT'
    call vstack_clear
    call OUTPUT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA93
    
LA93:
    
LA92:
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
    
LA94:
    ret
    
EX1:
    error_store 'EX2'
    call vstack_clear
    call EX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA95
    
LA96:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA97
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    error_store 'EX2'
    call vstack_clear
    call EX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA97:
    
LA98:
    cmp byte [eswitch], 0
    je LA96
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA95:
    
LA99:
    ret
    
DEFINITION:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA100
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'EX1'
    call vstack_clear
    call EX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ";"
    cmp byte [eswitch], 1
    jne LB1
    mov dword [outbuff_offset], 0
    print "Missing semicolon: "
    mov esi, dword [cursor]
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostr
    add dword [outbuff_offset], eax
    mov edi, outbuff
    call print_mm32
    call stacktrace
    mov eax, 1
    mov ebx, 1
    int 0x80
    
LB1:
    print "ret"
    call newline
    
LA100:
    
LA101:
    ret
    
TOKEN_DEFINITION:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA102
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'TX1'
    call vstack_clear
    call TX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ";"
    cmp byte [eswitch], 1
    je terminate_program
    print "ret"
    call newline
    
LA102:
    
LA103:
    ret
    
TX1:
    error_store 'TX2'
    call vstack_clear
    call TX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA104
    
LA105:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA106
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    error_store 'TX2'
    call vstack_clear
    call TX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA106:
    
LA107:
    cmp byte [eswitch], 0
    je LA105
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA104:
    
LA108:
    ret
    
TX2:
    error_store 'TX3'
    call vstack_clear
    call TX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA109
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    
LA110:
    error_store 'TX3'
    call vstack_clear
    call TX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA111
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    
LA111:
    
LA112:
    cmp byte [eswitch], 0
    je LA110
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA109:
    
LA113:
    ret
    
TX3:
    test_input_string ".TOKEN"
    cmp byte [eswitch], 1
    je LA114
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 1"
    call newline
    print "call clear_token"
    call newline
    
LA114:
    cmp byte [eswitch], 0
    je LA115
    test_input_string ".DELTOK"
    cmp byte [eswitch], 1
    je LA116
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 0"
    call newline
    
LA116:
    cmp byte [eswitch], 0
    je LA115
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA117
    call label
    call gn1
    print ":"
    call newline
    error_store 'TX3'
    call vstack_clear
    call TX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    
LA117:
    
LA115:
    cmp byte [eswitch], 1
    je LA118
    print "mov byte [eswitch], 0"
    call newline
    
LA118:
    cmp byte [eswitch], 0
    je LA119
    test_input_string ".ANYBUT("
    cmp byte [eswitch], 1
    je LA120
    error_store 'CX1'
    call vstack_clear
    call CX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "mov al, byte [eswitch]"
    call newline
    print "xor al, 1"
    call newline
    print "mov byte [eswitch], al"
    call newline
    print "call scan_or_parse"
    call newline
    
LA120:
    cmp byte [eswitch], 0
    je LA119
    test_input_string ".ANY("
    cmp byte [eswitch], 1
    je LA121
    error_store 'CX1'
    call vstack_clear
    call CX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "call scan_or_parse"
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    
LA121:
    cmp byte [eswitch], 0
    je LA119
    test_input_string ".RESERVED("
    cmp byte [eswitch], 1
    je LA122
    
LA123:
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA124
    print "test_input_string "
    call copy_last_match
    call newline
    print "mov al, byte [eswitch]"
    call newline
    print "xor al, 1"
    call newline
    print "mov byte [eswitch], al"
    call newline
    
LA124:
    
LA125:
    cmp byte [eswitch], 0
    je LA123
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA122:
    cmp byte [eswitch], 0
    je LA119
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA126
    print "call "
    call copy_last_match
    call newline
    
LA126:
    cmp byte [eswitch], 0
    je LA119
    test_input_string "("
    cmp byte [eswitch], 1
    je LA127
    error_store 'TX1'
    call vstack_clear
    call TX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA127:
    
LA119:
    ret
    
CX1:
    error_store 'CX2'
    call vstack_clear
    call CX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA128
    
LA129:
    test_input_string "!"
    cmp byte [eswitch], 1
    je LA130
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    error_store 'CX2'
    call vstack_clear
    call CX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA130:
    
LA131:
    cmp byte [eswitch], 0
    je LA129
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA128:
    
LA132:
    ret
    
CX2:
    error_store 'CX3'
    call vstack_clear
    call CX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA133
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA134
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
    error_store 'CX3'
    call vstack_clear
    call CX3
    call vstack_restore
    call error_clear
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
    
LA134:
    cmp byte [eswitch], 0
    je LA135
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA136
    print "mov edi, "
    call copy_last_match
    call newline
    print "call test_char_equal"
    call newline
    
LA136:
    
LA135:
    cmp byte [eswitch], 1
    je terminate_program
    
LA133:
    
LA137:
    ret
    
CX3:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA138
    
LA138:
    cmp byte [eswitch], 0
    je LA139
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA140
    
LA140:
    
LA139:
    ret
    
COMMENT:
    test_input_string "//"
    cmp byte [eswitch], 1
    je LA141
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA141:
    
LA142:
    ret
    
; -- Tokens --
    
PREFIX:
    
LA143:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA144
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA144
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA144
    mov edi, 10
    call test_char_equal
    
LA144:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA143
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA145
    
LA145:
    
LA146:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA147
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA147
    call DIGIT
    cmp byte [eswitch], 1
    je LA147
    
LA148:
    call DIGIT
    cmp byte [eswitch], 0
    je LA148
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA147
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA147
    
LA147:
    
LA149:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA150
    mov edi, 57
    call test_char_less_equal
    
LA150:
    
LA151:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA152
    
LA152:
    
LA153:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA154
    test_input_string "import"
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    cmp byte [eswitch], 1
    je LA154
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA154
    call ALPHA
    cmp byte [eswitch], 1
    je LA154
    
LA155:
    call ALPHA
    cmp byte [eswitch], 1
    je LA156
    
LA156:
    cmp byte [eswitch], 0
    je LA157
    call DIGIT
    cmp byte [eswitch], 1
    je LA158
    
LA158:
    
LA157:
    cmp byte [eswitch], 0
    je LA155
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA154
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA154
    
LA154:
    
LA159:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA160
    mov edi, 90
    call test_char_less_equal
    
LA160:
    cmp byte [eswitch], 0
    je LA161
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA161
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA162
    mov edi, 122
    call test_char_less_equal
    
LA162:
    
LA161:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA163
    
LA163:
    
LA164:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA165
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA165
    mov edi, 34
    call test_char_equal
    
LA166:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA165
    
LA167:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA168
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA168
    mov edi, 34
    call test_char_equal
    
LA168:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA167
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA165
    mov edi, 34
    call test_char_equal
    
LA169:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA165
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA165
    
LA165:
    
LA170:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA171
    mov edi, 34
    call test_char_equal
    
LA172:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA171
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA171
    
LA173:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA174
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA174
    mov edi, 34
    call test_char_equal
    
LA174:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA173
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA171
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA171
    mov edi, 34
    call test_char_equal
    
LA175:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA171
    
LA171:
    
LA176:
    ret
    
