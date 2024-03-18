
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
    push esi
    section .data
    loop_counter dd 0
    fn_arg_count dd 0
    fn_arg_num dd 0
    section .bss
    symbol_table resb 262144
    section .text
    call label
    print "%define MAX_INPUT_LENGTH 65536"
    print 0x0A
    print '    '
    call label
    print "%include './lib/asm_macros.asm'"
    print 0x0A
    print '    '
    call label
    print "section .text"
    print 0x0A
    print '    '
    print "global _start"
    print 0x0A
    print '    '
    
LA1:
    test_input_string ".TOKENS"
    cmp byte [eswitch], 1
    je LA2
    call label
    print "; -- Tokens --"
    print 0x0A
    print '    '
    
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
    print 0x0A
    print '    '
    print "mov esi, 0"
    print 0x0A
    print '    '
    print "call premalloc"
    print 0x0A
    print '    '
    print "call _read_file_argument"
    print 0x0A
    print '    '
    print "call _read_file"
    print 0x0A
    print '    '
    print "push ebp"
    print 0x0A
    print '    '
    print "mov ebp, esp"
    print 0x0A
    print '    '
    print "call "
    call copy_last_match
    print 0x0A
    print '    '
    print "pop ebp"
    print 0x0A
    print '    '
    print "mov edi, outbuff"
    print 0x0A
    print '    '
    print "call print_mm32"
    print 0x0A
    print '    '
    print "mov eax, 1"
    print 0x0A
    print '    '
    print "mov ebx, 0"
    print 0x0A
    print '    '
    print "int 0x80"
    print 0x0A
    print '    '
    
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
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
IMPORT_STATEMENT:
    push ebp
    mov ebp, esp
    push esi
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
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
OUT1:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "*1"
    cmp byte [eswitch], 1
    je LA22
    print "call gn1"
    print 0x0A
    print '    '
    
LA22:
    cmp byte [eswitch], 0
    je LA23
    test_input_string "*2"
    cmp byte [eswitch], 1
    je LA24
    print "call gn2"
    print 0x0A
    print '    '
    
LA24:
    cmp byte [eswitch], 0
    je LA23
    test_input_string "*3"
    cmp byte [eswitch], 1
    je LA25
    print "call gn3"
    print 0x0A
    print '    '
    
LA25:
    cmp byte [eswitch], 0
    je LA23
    test_input_string "*4"
    cmp byte [eswitch], 1
    je LA26
    print "call gn4"
    print 0x0A
    print '    '
    
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
    print 0x0A
    print '    '
    print "add edi, [outbuff_offset]"
    print 0x0A
    print '    '
    print "call buffc"
    print 0x0A
    print '    '
    print "add dword [outbuff_offset], eax"
    print 0x0A
    print '    '
    
LA28:
    cmp byte [eswitch], 0
    je LA29
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA30
    print "call copy_last_match"
    print 0x0A
    print '    '
    
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
    print 0x0A
    print '    '
    print "add edi, dword [outbuff_offset]"
    print 0x0A
    print '    '
    print "call inttostr"
    print 0x0A
    print '    '
    print "add dword [outbuff_offset], eax"
    print 0x0A
    print '    '
    
LA31:
    cmp byte [eswitch], 0
    je LA23
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA32
    print "mov esi, str_vector_8192"
    print 0x0A
    print '    '
    print "call vector_pop_string"
    print 0x0A
    print '    '
    print "mov esi, eax"
    print 0x0A
    print '    '
    print "mov edi, outbuff"
    print 0x0A
    print '    '
    print "add edi, [outbuff_offset]"
    print 0x0A
    print '    '
    print "call buffc"
    print 0x0A
    print '    '
    print "add dword [outbuff_offset], eax"
    print 0x0A
    print '    '
    
LA32:
    cmp byte [eswitch], 0
    je LA23
    test_input_string ".NL"
    cmp byte [eswitch], 1
    je LA33
    print "print 0x0A"
    print 0x0A
    print '    '
    
LA33:
    cmp byte [eswitch], 0
    je LA23
    test_input_string ".TB"
    cmp byte [eswitch], 1
    je LA34
    print "print '    '"
    print 0x0A
    print '    '
    
LA34:
    cmp byte [eswitch], 0
    je LA23
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA35
    print "print "
    call copy_last_match
    print 0x0A
    print '    '
    
LA35:
    
LA23:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
GET_REFERENCE:
    push ebp
    mov ebp, esp
    push esi
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA36
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "pop esi"
    print 0x0A
    print '    '
    print "push esi"
    print 0x0A
    print '    '
    
LA36:
    
LA37:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
OUT_IMMEDIATE:
    push ebp
    mov ebp, esp
    push esi
    error_store 'RAW'
    call vstack_clear
    call RAW
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA38
    call copy_last_match
    print 0x0A
    print '    '
    
LA38:
    
LA39:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
OUTPUT:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "->"
    cmp byte [eswitch], 1
    je LA40
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA41:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA42
    
LA42:
    
LA43:
    cmp byte [eswitch], 0
    je LA41
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "print 0x0A"
    print 0x0A
    print '    '
    print "print '    '"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    je terminate_program
    
LA40:
    cmp byte [eswitch], 0
    je LA44
    test_input_string ".UF"
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
    cmp byte [eswitch], 0
    je LA44
    test_input_string ".LABEL"
    cmp byte [eswitch], 1
    je LA49
    print "call label"
    print 0x0A
    print '    '
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA50:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
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
    print "print 0x0A"
    print 0x0A
    print '    '
    print "print '    '"
    print 0x0A
    print '    '
    
LA49:
    cmp byte [eswitch], 0
    je LA44
    test_input_string ".RS"
    cmp byte [eswitch], 1
    je LA53
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA54:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA55
    
LA55:
    
LA56:
    cmp byte [eswitch], 0
    je LA54
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA53:
    
LA44:
    cmp byte [eswitch], 1
    je LA57
    
LA57:
    cmp byte [eswitch], 0
    je LA58
    test_input_string ".DIRECT"
    cmp byte [eswitch], 1
    je LA59
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA60:
    error_store 'OUT_IMMEDIATE'
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA60
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA59:
    
LA58:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
EX3:
    push ebp
    mov ebp, esp
    push esi
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA61
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
    print 0x0A
    print '    '
    print "call vstack_clear"
    print 0x0A
    print '    '
    test_input_string "<"
    cmp byte [eswitch], 1
    je LA62
    error_store 'GENERIC_ARG'
    call vstack_clear
    call GENERIC_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA63
    
LA64:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA65
    error_store 'GENERIC_ARG'
    call vstack_clear
    call GENERIC_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA65:
    
LA66:
    cmp byte [eswitch], 0
    je LA64
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA63:
    cmp byte [eswitch], 0
    je LA67
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA68
    
LA68:
    
LA67:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ">"
    cmp byte [eswitch], 1
    je terminate_program
    
LA62:
    
LA69:
    cmp byte [eswitch], 1
    je LA70
    
LA70:
    cmp byte [eswitch], 0
    je LA71
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA72
    
LA72:
    
LA71:
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
    print 0x0A
    print '    '
    print "call vstack_restore"
    print 0x0A
    print '    '
    print "call error_clear"
    print 0x0A
    print '    '
    
LA61:
    cmp byte [eswitch], 0
    je LA73
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA74
    print "test_input_string "
    call copy_last_match
    print 0x0A
    print '    '
    
LA74:
    cmp byte [eswitch], 0
    je LA73
    test_input_string ".RET"
    cmp byte [eswitch], 1
    je LA75
    print "ret"
    print 0x0A
    print '    '
    
LA75:
    cmp byte [eswitch], 0
    je LA73
    test_input_string ".NOT"
    cmp byte [eswitch], 1
    je LA76
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA77
    
LA77:
    cmp byte [eswitch], 0
    je LA78
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA79
    
LA79:
    
LA78:
    cmp byte [eswitch], 1
    je terminate_program
    print "match_not "
    call copy_last_match
    print 0x0A
    print '    '
    
LA76:
    cmp byte [eswitch], 0
    je LA73
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA80
    print "mov edi, str_vector_8192"
    print 0x0A
    print '    '
    print "mov esi, last_match"
    print 0x0A
    print '    '
    print "call vector_push_string_mm32"
    print 0x0A
    print '    '
    
LA80:
    cmp byte [eswitch], 0
    je LA73
    test_input_string "("
    cmp byte [eswitch], 1
    je LA81
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
    
LA81:
    cmp byte [eswitch], 0
    je LA73
    test_input_string ".EMPTY"
    cmp byte [eswitch], 1
    je LA82
    print "mov byte [eswitch], 0"
    print 0x0A
    print '    '
    
LA82:
    cmp byte [eswitch], 0
    je LA73
    test_input_string "$<"
    cmp byte [eswitch], 1
    je LA83
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "section .data"
    print 0x0A
    print '    '
    print "MIN_ITER_"
    call gn3
    print " dd "
    call copy_last_match
    print 0x0A
    print '    '
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA84
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
    print 0x0A
    print '    '
    
LA84:
    cmp byte [eswitch], 0
    je LA85
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA86
    print "MAX_ITER_"
    call gn3
    print " dd 0xFFFFFFFF"
    print 0x0A
    print '    '
    
LA86:
    
LA85:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ">"
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "section .text"
    print 0x0A
    print '    '
    print "xor ecx, ecx"
    print 0x0A
    print '    '
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    print "push ecx"
    print 0x0A
    print '    '
    error_store 'EX3'
    call vstack_clear
    call EX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "pop ecx"
    print 0x0A
    print '    '
    print "cmp ecx, dword [MAX_ITER_"
    call gn3
    print "]"
    print 0x0A
    print '    '
    print "jg "
    call gn2
    print 0x0A
    print '    '
    print "cmp ecx, dword [MIN_ITER_"
    call gn3
    print "]"
    print 0x0A
    print '    '
    print "jl "
    call gn1
    print 0x0A
    print '    '
    print "inc ecx"
    print 0x0A
    print '    '
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    print 0x0A
    print '    '
    call label
    call gn2
    print ":"
    print 0x0A
    print '    '
    print "mov byte [eswitch], 0"
    print 0x0A
    print '    '
    
LA83:
    cmp byte [eswitch], 0
    je LA73
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA87
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    error_store 'EX3'
    call vstack_clear
    call EX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    print 0x0A
    print '    '
    print "mov byte [eswitch], 0"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    
LA87:
    cmp byte [eswitch], 0
    je LA73
    test_input_string "::"
    cmp byte [eswitch], 1
    je LA88
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
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    
LA88:
    cmp byte [eswitch], 0
    je LA89
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA90
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
    
LA90:
    
LA89:
    cmp byte [eswitch], 1
    je LA91
    cmp byte [eswitch], 1
    je terminate_program
    
LA91:
    cmp byte [eswitch], 0
    je LA73
    test_input_string "{"
    cmp byte [eswitch], 1
    je LA92
    cmp byte [eswitch], 1
    je terminate_program
    print "call backtrack_store"
    print 0x0A
    print '    '
    error_store 'EX1'
    call vstack_clear
    call EX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA93:
    test_input_string "/"
    cmp byte [eswitch], 1
    je LA94
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "call backtrack_restore"
    print 0x0A
    print '    '
    error_store 'EX1'
    call vstack_clear
    call EX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA94:
    
LA95:
    cmp byte [eswitch], 0
    je LA93
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "}"
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    je terminate_program
    print "call backtrack_restore"
    print 0x0A
    print '    '
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    print "call backtrack_clear"
    print 0x0A
    print '    '
    
LA92:
    cmp byte [eswitch], 0
    je LA73
    error_store 'COMMENT'
    call vstack_clear
    call COMMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA96
    
LA96:
    
LA73:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
EX2:
    push ebp
    mov ebp, esp
    push esi
    error_store 'EX3'
    call vstack_clear
    call EX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA97
    print "cmp byte [eswitch], 1"
    print 0x0A
    print '    '
    print "je "
    call gn1
    print 0x0A
    print '    '
    
LA97:
    cmp byte [eswitch], 0
    je LA98
    error_store 'OUTPUT'
    call vstack_clear
    call OUTPUT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA99
    
LA99:
    
LA98:
    cmp byte [eswitch], 1
    je LA100
    
LA101:
    error_store 'EX3'
    call vstack_clear
    call EX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA102
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "@"
    cmp byte [eswitch], 1
    je LA103
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 1"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    je terminate_program
    print "jne "
    call gn3
    print 0x0A
    print '    '
    print "mov dword [outbuff_offset], 0"
    print 0x0A
    print '    '
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA104:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA105
    
LA105:
    
LA106:
    cmp byte [eswitch], 0
    je LA104
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "mov edi, outbuff"
    print 0x0A
    print '    '
    print "call print_mm32"
    print 0x0A
    print '    '
    print "call stacktrace"
    print 0x0A
    print '    '
    print "mov eax, 1"
    print 0x0A
    print '    '
    print "mov ebx, 1"
    print 0x0A
    print '    '
    print "int 0x80"
    print 0x0A
    print '    '
    call label
    call gn3
    print ":"
    print 0x0A
    print '    '
    
LA103:
    
LA107:
    cmp byte [eswitch], 1
    je LA108
    
LA108:
    cmp byte [eswitch], 0
    je LA109
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA110
    print "cmp byte [eswitch], 1"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    je terminate_program
    print "jne LOOP_"
    mov esi, dword [loop_counter]
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostr
    add dword [outbuff_offset], eax
    print 0x0A
    print "cmp byte [backtrack_switch], 1"
    print 0x0A
    print '    '
    print "je "
    call gn1
    print 0x0A
    print '    '
    print "je terminate_program"
    print 0x0A
    print '    '
    print '    '
    print "LOOP_"
    mov esi, dword [loop_counter]
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostr
    add dword [outbuff_offset], eax
    inc dword [loop_counter]
    print ":"
    print 0x0A
    
LA110:
    
LA109:
    cmp byte [eswitch], 1
    je terminate_program
    
LA102:
    cmp byte [eswitch], 0
    je LA111
    error_store 'OUTPUT'
    call vstack_clear
    call OUTPUT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA112
    
LA112:
    
LA111:
    cmp byte [eswitch], 0
    je LA101
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    
LA100:
    
LA113:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
EX1:
    push ebp
    mov ebp, esp
    push esi
    error_store 'EX2'
    call vstack_clear
    call EX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA114
    
LA115:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA116
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    print 0x0A
    print '    '
    error_store 'EX2'
    call vstack_clear
    call EX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA116:
    
LA117:
    cmp byte [eswitch], 0
    je LA115
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    
LA114:
    
LA118:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
DEFINITION:
    push ebp
    mov ebp, esp
    push esi
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA119
    call label
    call copy_last_match
    print ":"
    print 0x0A
    print '    '
    print "push ebp"
    print 0x0A
    print '    '
    print "mov ebp, esp"
    print 0x0A
    print '    '
    print "push esi"
    print 0x0A
    print '    '
    test_input_string "<"
    cmp byte [eswitch], 1
    je LA120
    error_store 'GENERIC'
    call vstack_clear
    call GENERIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA121:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA122
    error_store 'GENERIC'
    call vstack_clear
    call GENERIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA122:
    
LA123:
    cmp byte [eswitch], 0
    je LA121
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ">"
    cmp byte [eswitch], 1
    je terminate_program
    
LA120:
    cmp byte [eswitch], 0
    je LA124
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA125
    
LA125:
    
LA124:
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
    print "pop esi"
    print 0x0A
    print '    '
    print "mov esp, ebp"
    print 0x0A
    print '    '
    print "pop ebp"
    print 0x0A
    print '    '
    print "ret"
    print 0x0A
    print '    '
    
LA119:
    
LA126:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
GENERIC:
    push ebp
    mov ebp, esp
    push esi
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA127
    inc dword [fn_arg_count] ; found new argument!
    inc dword [fn_arg_num]
    mov edx, dword [fn_arg_num]
    mov edi, symbol_table
    mov esi, last_match
    call hash_set
    
LA127:
    
LA128:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
GENERIC_ARG:
    push ebp
    mov ebp, esp
    push esi
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA129
    print "mov esi, "
    call copy_last_match
    print 0x0A
    print '    '
    
LA129:
    cmp byte [eswitch], 0
    je LA130
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA131
    call label
    print "section .data"
    print 0x0A
    print '    '
    call gn3
    print " db "
    call copy_last_match
    print ", 0x00"
    print 0x0A
    print '    '
    call label
    print "section .text"
    print 0x0A
    print '    '
    print "mov esi, "
    call gn3
    print 0x0A
    print '    '
    
LA131:
    cmp byte [eswitch], 0
    je LA130
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA132
    print "pop esi"
    print 0x0A
    print '    '
    print "push esi"
    print 0x0A
    print '    '
    
LA132:
    
LA130:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
TOKEN_DEFINITION:
    push ebp
    mov ebp, esp
    push esi
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA133
    call label
    call copy_last_match
    print ":"
    print 0x0A
    print '    '
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
    print 0x0A
    print '    '
    
LA133:
    
LA134:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
TX1:
    push ebp
    mov ebp, esp
    push esi
    error_store 'TX2'
    call vstack_clear
    call TX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA135
    
LA136:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA137
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    print 0x0A
    print '    '
    error_store 'TX2'
    call vstack_clear
    call TX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA137:
    
LA138:
    cmp byte [eswitch], 0
    je LA136
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    
LA135:
    
LA139:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
TX2:
    push ebp
    mov ebp, esp
    push esi
    error_store 'TX3'
    call vstack_clear
    call TX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA140
    print "cmp byte [eswitch], 1"
    print 0x0A
    print '    '
    print "je "
    call gn1
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    je terminate_program
    
LA141:
    error_store 'TX3'
    call vstack_clear
    call TX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA142
    print "cmp byte [eswitch], 1"
    print 0x0A
    print '    '
    print "je "
    call gn1
    print 0x0A
    print '    '
    
LA142:
    
LA143:
    cmp byte [eswitch], 0
    je LA141
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    
LA140:
    
LA144:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
TX3:
    push ebp
    mov ebp, esp
    push esi
    test_input_string ".TOKEN"
    cmp byte [eswitch], 1
    je LA145
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 1"
    print 0x0A
    print '    '
    print "call clear_token"
    print 0x0A
    print '    '
    
LA145:
    cmp byte [eswitch], 0
    je LA146
    test_input_string ".DELTOK"
    cmp byte [eswitch], 1
    je LA147
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 0"
    print 0x0A
    print '    '
    
LA147:
    cmp byte [eswitch], 0
    je LA146
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA148
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    error_store 'TX3'
    call vstack_clear
    call TX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    print 0x0A
    print '    '
    
LA148:
    
LA146:
    cmp byte [eswitch], 1
    je LA149
    print "mov byte [eswitch], 0"
    print 0x0A
    print '    '
    
LA149:
    cmp byte [eswitch], 0
    je LA150
    test_input_string ".ANYBUT("
    cmp byte [eswitch], 1
    je LA151
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
    print 0x0A
    print '    '
    print "xor al, 1"
    print 0x0A
    print '    '
    print "mov byte [eswitch], al"
    print 0x0A
    print '    '
    print "call scan_or_parse"
    print 0x0A
    print '    '
    
LA151:
    cmp byte [eswitch], 0
    je LA150
    test_input_string ".ANY("
    cmp byte [eswitch], 1
    je LA152
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
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    
LA152:
    cmp byte [eswitch], 0
    je LA150
    test_input_string ".RESERVED("
    cmp byte [eswitch], 1
    je LA153
    
LA154:
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA155
    print "test_input_string "
    call copy_last_match
    print 0x0A
    print '    '
    print "mov al, byte [eswitch]"
    print 0x0A
    print '    '
    print "xor al, 1"
    print 0x0A
    print '    '
    print "mov byte [eswitch], al"
    print 0x0A
    print '    '
    
LA155:
    
LA156:
    cmp byte [eswitch], 0
    je LA154
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA153:
    cmp byte [eswitch], 0
    je LA150
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA157
    print "call "
    call copy_last_match
    print 0x0A
    print '    '
    
LA157:
    cmp byte [eswitch], 0
    je LA150
    test_input_string "("
    cmp byte [eswitch], 1
    je LA158
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
    
LA158:
    
LA150:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
CX1:
    push ebp
    mov ebp, esp
    push esi
    error_store 'CX2'
    call vstack_clear
    call CX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA159
    
LA160:
    test_input_string "!"
    cmp byte [eswitch], 1
    je LA161
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    print 0x0A
    print '    '
    error_store 'CX2'
    call vstack_clear
    call CX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA161:
    
LA162:
    cmp byte [eswitch], 0
    je LA160
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    
LA159:
    
LA163:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
CX2:
    push ebp
    mov ebp, esp
    push esi
    error_store 'CX3'
    call vstack_clear
    call CX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA164
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA165
    print "mov edi, "
    call copy_last_match
    print 0x0A
    print '    '
    print "call test_char_greater_equal"
    print 0x0A
    print '    '
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "jne "
    call gn1
    print 0x0A
    print '    '
    error_store 'CX3'
    call vstack_clear
    call CX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov edi, "
    call copy_last_match
    print 0x0A
    print '    '
    print "call test_char_less_equal"
    print 0x0A
    print '    '
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    
LA165:
    cmp byte [eswitch], 0
    je LA166
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA167
    print "mov edi, "
    call copy_last_match
    print 0x0A
    print '    '
    print "call test_char_equal"
    print 0x0A
    print '    '
    
LA167:
    
LA166:
    cmp byte [eswitch], 1
    je terminate_program
    
LA164:
    
LA168:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
CX3:
    push ebp
    mov ebp, esp
    push esi
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA169
    
LA169:
    cmp byte [eswitch], 0
    je LA170
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA171
    
LA171:
    
LA170:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
COMMENT:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "//"
    cmp byte [eswitch], 1
    je LA172
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA172:
    
LA173:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
; -- Tokens --
    
PREFIX:
    
LA174:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA175
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA175
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA175
    mov edi, 10
    call test_char_equal
    
LA175:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA174
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA176
    
LA176:
    
LA177:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA178
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA178
    call DIGIT
    cmp byte [eswitch], 1
    je LA178
    
LA179:
    call DIGIT
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
    
LA180:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA181
    mov edi, 57
    call test_char_less_equal
    
LA181:
    
LA182:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA183
    
LA183:
    
LA184:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA185
    test_input_string "import"
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    cmp byte [eswitch], 1
    je LA185
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA185
    call ALPHA
    cmp byte [eswitch], 1
    je LA185
    
LA186:
    call ALPHA
    cmp byte [eswitch], 1
    je LA187
    
LA187:
    cmp byte [eswitch], 0
    je LA188
    call DIGIT
    cmp byte [eswitch], 1
    je LA189
    
LA189:
    
LA188:
    cmp byte [eswitch], 0
    je LA186
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA185
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA185
    
LA185:
    
LA190:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA191
    mov edi, 90
    call test_char_less_equal
    
LA191:
    cmp byte [eswitch], 0
    je LA192
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA192
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA193
    mov edi, 122
    call test_char_less_equal
    
LA193:
    
LA192:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA194
    
LA194:
    
LA195:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA196
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA196
    mov edi, 34
    call test_char_equal
    
LA197:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA196
    
LA198:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA199
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA199
    mov edi, 34
    call test_char_equal
    
LA199:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA198
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA196
    mov edi, 34
    call test_char_equal
    
LA200:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA196
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA196
    
LA196:
    
LA201:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA202
    mov edi, 34
    call test_char_equal
    
LA203:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA202
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA202
    
LA204:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA205
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA205
    mov edi, 34
    call test_char_equal
    
LA205:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA204
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA202
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA202
    mov edi, 34
    call test_char_equal
    
LA206:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA202
    
LA202:
    
LA207:
    ret
    
