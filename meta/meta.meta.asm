
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
    push ebp
    mov ebp, esp
    section .data
    fn_arg_count dd 0
    fn_arg_num dd 0
    section .bss
    symbol_table resb 262144
    section .text
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
    mov esp, ebp
    pop ebp
    ret
    
IMPORT_STATEMENT:
    push ebp
    mov ebp, esp
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
    mov esp, ebp
    pop ebp
    ret
    
OUT1:
    push ebp
    mov ebp, esp
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
    error_store 'GET_REFERENCE'
    call vstack_clear
    call GET_REFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA28
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
    error_store 'GET_REFERENCE'
    call vstack_clear
    call GET_REFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
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
    mov esp, ebp
    pop ebp
    ret
    
GET_REFERENCE:
    push ebp
    mov ebp, esp
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA34
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "mov esi, dword [ebp"
    mov edi, symbol_table
    mov esi, last_match
    call hash_get
    cmp byte [eswitch], 1
    je terminate_program
    mov ebx, dword [fn_arg_count]
    sub ebx, eax
    cmp byte [eswitch], 1
    je terminate_program
    imul eax, ebx, 4
    cmp byte [eswitch], 1
    je terminate_program
    add eax, 8
    cmp byte [eswitch], 1
    je terminate_program
    mov esi, eax
    cmp byte [eswitch], 1
    je terminate_program
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostrsigned
    add dword [outbuff_offset], eax
    print "] ; get "
    call copy_last_match
    call newline
    
LA34:
    
LA35:
    mov esp, ebp
    pop ebp
    ret
    
OUT_IMMEDIATE:
    push ebp
    mov ebp, esp
    error_store 'RAW'
    call vstack_clear
    call RAW
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA36
    call copy_last_match
    call newline
    
LA36:
    
LA37:
    mov esp, ebp
    pop ebp
    ret
    
OUTPUT:
    push ebp
    mov ebp, esp
    test_input_string "->"
    cmp byte [eswitch], 1
    je LA38
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA39:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA40
    
LA40:
    
LA41:
    cmp byte [eswitch], 0
    je LA39
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "call newline"
    call newline
    
LA38:
    cmp byte [eswitch], 0
    je LA42
    test_input_string ".LABEL"
    cmp byte [eswitch], 1
    je LA43
    print "call label"
    call newline
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA44:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA45
    
LA45:
    
LA46:
    cmp byte [eswitch], 0
    je LA44
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "call newline"
    call newline
    
LA43:
    cmp byte [eswitch], 0
    je LA42
    test_input_string ".RS"
    cmp byte [eswitch], 1
    je LA47
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA48:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA49
    
LA49:
    
LA50:
    cmp byte [eswitch], 0
    je LA48
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA47:
    
LA42:
    cmp byte [eswitch], 1
    je LA51
    
LA51:
    cmp byte [eswitch], 0
    je LA52
    test_input_string ".DIRECT"
    cmp byte [eswitch], 1
    je LA53
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA54:
    error_store 'OUT_IMMEDIATE'
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA54
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA53:
    
LA52:
    mov esp, ebp
    pop ebp
    ret
    
EX3:
    push ebp
    mov ebp, esp
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA55
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "error_store '"
    call copy_last_match
    print "'"
    call newline
    print "call vstack_clear"
    call newline
    test_input_string "<"
    cmp byte [eswitch], 1
    je LA56
    error_store 'GENERIC_ARGS'
    call vstack_clear
    call GENERIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ">"
    cmp byte [eswitch], 1
    je terminate_program
    
LA56:
    
LA57:
    cmp byte [eswitch], 1
    je LA58
    
LA58:
    cmp byte [eswitch], 0
    je LA59
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA60
    
LA60:
    
LA59:
    cmp byte [eswitch], 1
    je terminate_program
    print "call "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    print "call vstack_restore"
    call newline
    print "call error_clear"
    call newline
    
LA55:
    cmp byte [eswitch], 0
    je LA61
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA62
    print "test_input_string "
    call copy_last_match
    call newline
    
LA62:
    cmp byte [eswitch], 0
    je LA61
    test_input_string ".RET"
    cmp byte [eswitch], 1
    je LA63
    print "ret"
    call newline
    
LA63:
    cmp byte [eswitch], 0
    je LA61
    test_input_string ".NOT"
    cmp byte [eswitch], 1
    je LA64
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA65
    
LA65:
    cmp byte [eswitch], 0
    je LA66
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
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
    je LA61
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA68
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA68:
    cmp byte [eswitch], 0
    je LA61
    test_input_string "("
    cmp byte [eswitch], 1
    je LA69
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
    
LA69:
    cmp byte [eswitch], 0
    je LA61
    test_input_string ".EMPTY"
    cmp byte [eswitch], 1
    je LA70
    print "mov byte [eswitch], 0"
    call newline
    
LA70:
    cmp byte [eswitch], 0
    je LA61
    test_input_string "$<"
    cmp byte [eswitch], 1
    je LA71
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
    je LA72
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
    
LA72:
    cmp byte [eswitch], 0
    je LA73
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA74
    print "MAX_ITER_"
    call gn3
    print " dd 0xFFFFFFFF"
    call newline
    
LA74:
    
LA73:
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
    
LA71:
    cmp byte [eswitch], 0
    je LA61
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA75
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
    
LA75:
    cmp byte [eswitch], 0
    je LA61
    test_input_string "::"
    cmp byte [eswitch], 1
    je LA76
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
    
LA76:
    cmp byte [eswitch], 0
    je LA77
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA78
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
    
LA78:
    
LA77:
    cmp byte [eswitch], 1
    je LA79
    cmp byte [eswitch], 1
    je terminate_program
    
LA79:
    cmp byte [eswitch], 0
    je LA61
    test_input_string "{"
    cmp byte [eswitch], 1
    je LA80
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
    
LA81:
    test_input_string "/"
    cmp byte [eswitch], 1
    je LA82
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
    
LA82:
    
LA83:
    cmp byte [eswitch], 0
    je LA81
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
    
LA80:
    cmp byte [eswitch], 0
    je LA61
    error_store 'COMMENT'
    call vstack_clear
    call COMMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA84
    
LA84:
    
LA61:
    mov esp, ebp
    pop ebp
    ret
    
EX2:
    push ebp
    mov ebp, esp
    error_store 'EX3'
    call vstack_clear
    call EX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA85
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    
LA85:
    cmp byte [eswitch], 0
    je LA86
    error_store 'OUTPUT'
    call vstack_clear
    call OUTPUT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA87
    
LA87:
    
LA86:
    cmp byte [eswitch], 1
    je LA88
    
LA89:
    error_store 'EX3'
    call vstack_clear
    call EX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA90
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
    je LA91
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
    
LA92:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA93
    
LA93:
    
LA94:
    cmp byte [eswitch], 0
    je LA92
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
    
LA91:
    
LA95:
    cmp byte [eswitch], 1
    je LA96
    
LA96:
    cmp byte [eswitch], 0
    je LA97
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA98
    print "je terminate_program"
    call newline
    
LA98:
    
LA97:
    cmp byte [eswitch], 1
    je terminate_program
    
LA90:
    cmp byte [eswitch], 0
    je LA99
    error_store 'OUTPUT'
    call vstack_clear
    call OUTPUT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA100
    
LA100:
    
LA99:
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
    
LA101:
    mov esp, ebp
    pop ebp
    ret
    
EX1:
    push ebp
    mov ebp, esp
    error_store 'EX2'
    call vstack_clear
    call EX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA102
    
LA103:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA104
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
    
LA104:
    
LA105:
    cmp byte [eswitch], 0
    je LA103
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA102:
    
LA106:
    mov esp, ebp
    pop ebp
    ret
    
DEFINITION:
    push ebp
    mov ebp, esp
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA107
    call label
    call copy_last_match
    print ":"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    test_input_string "<"
    cmp byte [eswitch], 1
    je LA108
    error_store 'GENERIC'
    call vstack_clear
    call GENERIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA109:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA110
    error_store 'GENERIC'
    call vstack_clear
    call GENERIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA110:
    
LA111:
    cmp byte [eswitch], 0
    je LA109
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ">"
    cmp byte [eswitch], 1
    je terminate_program
    
LA108:
    cmp byte [eswitch], 0
    je LA112
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA113
    
LA113:
    
LA112:
    cmp byte [eswitch], 1
    je terminate_program
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
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "mov esp, ebp"
    call newline
    print "pop ebp"
    call newline
    print "ret"
    call newline
    
LA107:
    
LA114:
    mov esp, ebp
    pop ebp
    ret
    
GENERIC:
    push ebp
    mov ebp, esp
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA115
    inc dword [fn_arg_count] ; found new argument!
    inc dword [fn_arg_num]
    mov edx, dword [fn_arg_num]
    mov edi, symbol_table
    mov esi, last_match
    call hash_set
    
LA115:
    
LA116:
    mov esp, ebp
    pop ebp
    ret
    
GENERIC_ARGS:
    push ebp
    mov ebp, esp
    error_store 'GENERIC_ARG'
    call vstack_clear
    call GENERIC_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA117
    
LA118:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA119
    error_store 'GENERIC_ARG'
    call vstack_clear
    call GENERIC_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA119:
    
LA120:
    cmp byte [eswitch], 0
    je LA118
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA117:
    cmp byte [eswitch], 0
    je LA121
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA122
    
LA122:
    
LA121:
    mov esp, ebp
    pop ebp
    ret
    
GENERIC_ARG:
    push ebp
    mov ebp, esp
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA123
    print "push "
    call copy_last_match
    call newline
    
LA123:
    cmp byte [eswitch], 0
    je LA124
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA125
    print "push "
    call copy_last_match
    call newline
    
LA125:
    
LA124:
    mov esp, ebp
    pop ebp
    ret
    
TOKEN_DEFINITION:
    push ebp
    mov ebp, esp
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA126
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
    
LA126:
    
LA127:
    mov esp, ebp
    pop ebp
    ret
    
TX1:
    push ebp
    mov ebp, esp
    error_store 'TX2'
    call vstack_clear
    call TX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA128
    
LA129:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA130
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
    mov esp, ebp
    pop ebp
    ret
    
TX2:
    push ebp
    mov ebp, esp
    error_store 'TX3'
    call vstack_clear
    call TX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA133
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    
LA134:
    error_store 'TX3'
    call vstack_clear
    call TX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA135
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    
LA135:
    
LA136:
    cmp byte [eswitch], 0
    je LA134
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA133:
    
LA137:
    mov esp, ebp
    pop ebp
    ret
    
TX3:
    push ebp
    mov ebp, esp
    test_input_string ".TOKEN"
    cmp byte [eswitch], 1
    je LA138
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 1"
    call newline
    print "call clear_token"
    call newline
    
LA138:
    cmp byte [eswitch], 0
    je LA139
    test_input_string ".DELTOK"
    cmp byte [eswitch], 1
    je LA140
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 0"
    call newline
    
LA140:
    cmp byte [eswitch], 0
    je LA139
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA141
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
    
LA141:
    
LA139:
    cmp byte [eswitch], 1
    je LA142
    print "mov byte [eswitch], 0"
    call newline
    
LA142:
    cmp byte [eswitch], 0
    je LA143
    test_input_string ".ANYBUT("
    cmp byte [eswitch], 1
    je LA144
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
    
LA144:
    cmp byte [eswitch], 0
    je LA143
    test_input_string ".ANY("
    cmp byte [eswitch], 1
    je LA145
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
    
LA145:
    cmp byte [eswitch], 0
    je LA143
    test_input_string ".RESERVED("
    cmp byte [eswitch], 1
    je LA146
    
LA147:
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA148
    print "test_input_string "
    call copy_last_match
    call newline
    print "mov al, byte [eswitch]"
    call newline
    print "xor al, 1"
    call newline
    print "mov byte [eswitch], al"
    call newline
    
LA148:
    
LA149:
    cmp byte [eswitch], 0
    je LA147
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA146:
    cmp byte [eswitch], 0
    je LA143
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA150
    print "call "
    call copy_last_match
    call newline
    
LA150:
    cmp byte [eswitch], 0
    je LA143
    test_input_string "("
    cmp byte [eswitch], 1
    je LA151
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
    
LA151:
    
LA143:
    mov esp, ebp
    pop ebp
    ret
    
CX1:
    push ebp
    mov ebp, esp
    error_store 'CX2'
    call vstack_clear
    call CX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA152
    
LA153:
    test_input_string "!"
    cmp byte [eswitch], 1
    je LA154
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
    
LA154:
    
LA155:
    cmp byte [eswitch], 0
    je LA153
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA152:
    
LA156:
    mov esp, ebp
    pop ebp
    ret
    
CX2:
    push ebp
    mov ebp, esp
    error_store 'CX3'
    call vstack_clear
    call CX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA157
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA158
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
    
LA158:
    cmp byte [eswitch], 0
    je LA159
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA160
    print "mov edi, "
    call copy_last_match
    call newline
    print "call test_char_equal"
    call newline
    
LA160:
    
LA159:
    cmp byte [eswitch], 1
    je terminate_program
    
LA157:
    
LA161:
    mov esp, ebp
    pop ebp
    ret
    
CX3:
    push ebp
    mov ebp, esp
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA162
    
LA162:
    cmp byte [eswitch], 0
    je LA163
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA164
    
LA164:
    
LA163:
    mov esp, ebp
    pop ebp
    ret
    
COMMENT:
    push ebp
    mov ebp, esp
    test_input_string "//"
    cmp byte [eswitch], 1
    je LA165
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA165:
    
LA166:
    mov esp, ebp
    pop ebp
    ret
    
; -- Tokens --
    
PREFIX:
    
LA167:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA168
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA168
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA168
    mov edi, 10
    call test_char_equal
    
LA168:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA167
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA169
    
LA169:
    
LA170:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA171
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA171
    call DIGIT
    cmp byte [eswitch], 1
    je LA171
    
LA172:
    call DIGIT
    cmp byte [eswitch], 0
    je LA172
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA171
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA171
    
LA171:
    
LA173:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA174
    mov edi, 57
    call test_char_less_equal
    
LA174:
    
LA175:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA176
    
LA176:
    
LA177:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA178
    test_input_string "import"
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    cmp byte [eswitch], 1
    je LA178
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA178
    call ALPHA
    cmp byte [eswitch], 1
    je LA178
    
LA179:
    call ALPHA
    cmp byte [eswitch], 1
    je LA180
    
LA180:
    cmp byte [eswitch], 0
    je LA181
    call DIGIT
    cmp byte [eswitch], 1
    je LA182
    
LA182:
    
LA181:
    cmp byte [eswitch], 0
    je LA179
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA178
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA178
    
LA178:
    
LA183:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA184
    mov edi, 90
    call test_char_less_equal
    
LA184:
    cmp byte [eswitch], 0
    je LA185
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA185
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA186
    mov edi, 122
    call test_char_less_equal
    
LA186:
    
LA185:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA187
    
LA187:
    
LA188:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA189
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA189
    mov edi, 34
    call test_char_equal
    
LA190:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA189
    
LA191:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA192
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA192
    mov edi, 34
    call test_char_equal
    
LA192:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA191
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA189
    mov edi, 34
    call test_char_equal
    
LA193:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA189
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA189
    
LA189:
    
LA194:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA195
    mov edi, 34
    call test_char_equal
    
LA196:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA195
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA195
    
LA197:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA198
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA198
    mov edi, 34
    call test_char_equal
    
LA198:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA197
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA195
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA195
    mov edi, 34
    call test_char_equal
    
LA199:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA195
    
LA195:
    
LA200:
    ret
    
