
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
    call METALS
    pop ebp
    mov edi, outbuff
    call print_mm32
    mov eax, 1
    mov ebx, 0
    int 0x80
    
METALS:
    push ebp
    mov ebp, esp
    push esi
    section .data
    fn_arg_count dd 0
    fn_arg_num dd 0
    cmp byte [eswitch], 1
    je terminate_program
    in_body db 0
    cmp byte [eswitch], 1
    je terminate_program
    returns_from_body db 0
    section .bss
    symbol_table resb 262144
    section .text
    call label
    print "section .text"
    print 0x0A
    print '    '
    print "global _start"
    print 0x0A
    print '    '
    call label
    print "_start:"
    print 0x0A
    print '    '
    
LA1:
    error_store 'FUNCTION_DECLARATION'
    call vstack_clear
    call FUNCTION_DECLARATION
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA2
    
LA2:
    cmp byte [eswitch], 0
    je LA3
    error_store 'WHILE'
    call vstack_clear
    call WHILE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA4
    
LA4:
    cmp byte [eswitch], 0
    je LA3
    error_store 'STATEMENT'
    call vstack_clear
    call STATEMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA5
    
LA5:
    
LA3:
    cmp byte [eswitch], 0
    je LA1
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "exit:"
    print 0x0A
    print '    '
    print "push ebp"
    print 0x0A
    print '    '
    print "mov ebp, esp"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, 1"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    je terminate_program
    print "mov ebx, dword [ebp+8]"
    print 0x0A
    print '    '
    print "int 0x80"
    print 0x0A
    print '    '
    
LA6:
    
LA7:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
FUNCTION_DECLARATION:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "fn"
    cmp byte [eswitch], 1
    je LA8
    cmp byte [eswitch], 1
    je terminate_program
    print "jmp "
    call gn1
    print 0x0A
    print '    '
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
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
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'FUNCTION_PARAM'
    call vstack_clear
    call FUNCTION_PARAM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA9
    
LA10:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA11
    error_store 'FUNCTION_PARAM'
    call vstack_clear
    call FUNCTION_PARAM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA11:
    
LA12:
    cmp byte [eswitch], 0
    je LA10
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA9:
    cmp byte [eswitch], 0
    je LA13
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA14
    
LA14:
    
LA13:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    add dword [fn_arg_num], 2
    test_input_string "{"
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'FUNCTION_BODY'
    call vstack_clear
    call FUNCTION_BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    mov dword [fn_arg_num], 0
    mov dword [fn_arg_count], 0
    print "mov esp, ebp"
    print 0x0A
    print '    '
    print "pop ebp"
    print 0x0A
    print '    '
    print "ret"
    print 0x0A
    print '    '
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    test_input_string "}"
    cmp byte [eswitch], 1
    je terminate_program
    
LA8:
    
LA15:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
FUNCTION_PARAM:
    push ebp
    mov ebp, esp
    push esi
    error_store 'TYPE'
    call vstack_clear
    call TYPE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA16
    error_store 'NAME'
    call vstack_clear
    call NAME
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    inc dword [fn_arg_count] ; found new argument!
    inc dword [fn_arg_num]
    mov edx, dword [fn_arg_num]
    mov edi, symbol_table
    mov esi, last_match
    call hash_set
    
LA16:
    
LA17:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
FUNCTION_BODY:
    push ebp
    mov ebp, esp
    push esi
    
LA18:
    error_store 'WHILE'
    call vstack_clear
    call WHILE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA19
    
LA19:
    cmp byte [eswitch], 0
    je LA20
    error_store 'STATEMENT'
    call vstack_clear
    call STATEMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA21
    
LA21:
    
LA20:
    cmp byte [eswitch], 0
    je LA18
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA22
    
LA22:
    
LA23:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
STATEMENT:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "%var"
    cmp byte [eswitch], 1
    je LA24
    error_store 'TYPE'
    call vstack_clear
    call TYPE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NAME'
    call vstack_clear
    call NAME
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    inc dword [fn_arg_num]
    mov edx, dword [fn_arg_num]
    mov edi, symbol_table
    mov esi, last_match
    call hash_set
    test_input_string ","
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'VALUE'
    call vstack_clear
    
section .data
    LC1 db "eax", 0x00
    
section .text
    mov esi, LC1
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'MOV_INTO'
    call vstack_clear
    call MOV_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "eax"
    print 0x0A
    print '    '
    
LA24:
    
LA25:
    cmp byte [eswitch], 1
    je LA26
    
LA26:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%push"
    cmp byte [eswitch], 1
    je LA28
    error_store 'VALUE'
    call vstack_clear
    
section .data
    LC2 db "eax", 0x00
    
section .text
    mov esi, LC2
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "push eax"
    print 0x0A
    print '    '
    
LA28:
    
LA29:
    cmp byte [eswitch], 1
    je LA30
    
LA30:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%add"
    cmp byte [eswitch], 1
    je LA31
    error_store 'ARITHMETIC_OPERATION_ARGS'
    call vstack_clear
    call ARITHMETIC_OPERATION_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "add eax, ebx"
    print 0x0A
    print '    '
    
LA31:
    
LA32:
    cmp byte [eswitch], 1
    je LA33
    
LA33:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%neq"
    cmp byte [eswitch], 1
    je LA34
    error_store 'ARITHMETIC_OPERATION_ARGS'
    call vstack_clear
    call ARITHMETIC_OPERATION_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "setne al"
    print 0x0A
    print '    '
    
LA34:
    
LA35:
    cmp byte [eswitch], 1
    je LA36
    
LA36:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%eq"
    cmp byte [eswitch], 1
    je LA37
    error_store 'ARITHMETIC_OPERATION_ARGS'
    call vstack_clear
    call ARITHMETIC_OPERATION_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "sete al"
    print 0x0A
    print '    '
    
LA37:
    
LA38:
    cmp byte [eswitch], 1
    je LA39
    
LA39:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%lt"
    cmp byte [eswitch], 1
    je LA40
    error_store 'ARITHMETIC_OPERATION_ARGS'
    call vstack_clear
    call ARITHMETIC_OPERATION_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "setlt al"
    print 0x0A
    print '    '
    
LA40:
    
LA41:
    cmp byte [eswitch], 1
    je LA42
    
LA42:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%gt"
    cmp byte [eswitch], 1
    je LA43
    error_store 'ARITHMETIC_OPERATION_ARGS'
    call vstack_clear
    call ARITHMETIC_OPERATION_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "setgt al"
    print 0x0A
    print '    '
    
LA43:
    
LA44:
    cmp byte [eswitch], 1
    je LA45
    
LA45:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%deref/byte"
    cmp byte [eswitch], 1
    je LA46
    error_store 'VALUE'
    call vstack_clear
    
section .data
    LC3 db "eax", 0x00
    
section .text
    mov esi, LC3
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, byte [eax]"
    print 0x0A
    print '    '
    
LA46:
    
LA47:
    cmp byte [eswitch], 1
    je LA48
    
LA48:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%deref/word"
    cmp byte [eswitch], 1
    je LA49
    error_store 'VALUE'
    call vstack_clear
    
section .data
    LC4 db "eax", 0x00
    
section .text
    mov esi, LC4
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, word [eax]"
    print 0x0A
    print '    '
    
LA49:
    
LA50:
    cmp byte [eswitch], 1
    je LA51
    
LA51:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%deref/dword"
    cmp byte [eswitch], 1
    je LA52
    error_store 'VALUE'
    call vstack_clear
    
section .data
    LC5 db "eax", 0x00
    
section .text
    mov esi, LC5
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, dword [eax]"
    print 0x0A
    print '    '
    
LA52:
    
LA53:
    cmp byte [eswitch], 1
    je LA54
    
LA54:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%set"
    cmp byte [eswitch], 1
    je LA55
    error_store 'NAME'
    call vstack_clear
    call NAME
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ","
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'VALUE'
    call vstack_clear
    
section .data
    LC6 db "eax", 0x00
    
section .text
    mov esi, LC6
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'SET_INTO'
    call vstack_clear
    call SET_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "eax"
    print 0x0A
    print '    '
    
LA55:
    
LA56:
    cmp byte [eswitch], 1
    je LA57
    
LA57:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%ret"
    cmp byte [eswitch], 1
    je LA58
    error_store 'VALUE'
    call vstack_clear
    
section .data
    LC7 db "eax", 0x00
    
section .text
    mov esi, LC7
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA59
    
LA59:
    cmp byte [eswitch], 0
    je LA60
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA61
    
LA61:
    
LA60:
    cmp byte [eswitch], 1
    je terminate_program
    print "mov esp, ebp"
    print 0x0A
    print '    '
    print "pop ebp"
    print 0x0A
    print '    '
    print "ret"
    print 0x0A
    print '    '
    
LA58:
    
LA62:
    cmp byte [eswitch], 1
    je LA63
    
LA63:
    cmp byte [eswitch], 0
    je LA27
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA64
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'FUNCTION_CALL_ARGS'
    call vstack_clear
    call FUNCTION_CALL_ARGS
    call vstack_restore
    call error_clear
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
    
LA64:
    
LA65:
    cmp byte [eswitch], 1
    je LA66
    
LA66:
    
LA27:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
FUNCTION_CALL_ARGS:
    push ebp
    mov ebp, esp
    push esi
    error_store 'FUNCTION_CALL_ARG'
    call vstack_clear
    
section .data
    LC8 db "esi", 0x00
    
section .text
    mov esi, LC8
    call FUNCTION_CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA67
    
LA68:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA69
    error_store 'FUNCTION_CALL_ARG'
    call vstack_clear
    
section .data
    LC9 db "edi", 0x00
    
section .text
    mov esi, LC9
    call FUNCTION_CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA70:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA71
    error_store 'FUNCTION_CALL_ARG'
    call vstack_clear
    
section .data
    LC10 db "edx", 0x00
    
section .text
    mov esi, LC10
    call FUNCTION_CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA72:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA73
    error_store 'FUNCTION_CALL_ARG'
    call vstack_clear
    
section .data
    LC11 db "ecx", 0x00
    
section .text
    mov esi, LC11
    call FUNCTION_CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA74:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA75
    error_store 'FUNCTION_CALL_ARG_REST'
    call vstack_clear
    call FUNCTION_CALL_ARG_REST
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
    
LA73:
    
LA77:
    cmp byte [eswitch], 0
    je LA72
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA71:
    
LA78:
    cmp byte [eswitch], 0
    je LA70
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA69:
    
LA79:
    cmp byte [eswitch], 0
    je LA68
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA67:
    cmp byte [eswitch], 0
    je LA80
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA81
    
LA81:
    
LA80:
    cmp byte [eswitch], 1
    je LA82
    
LA82:
    
LA83:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
FUNCTION_CALL_ARG:
    push ebp
    mov ebp, esp
    push esi
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA84
    print "mov "
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", "
    call copy_last_match
    print 0x0A
    print '    '
    
LA84:
    cmp byte [eswitch], 0
    je LA85
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA86
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
    print "mov "
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", "
    call gn3
    print 0x0A
    print '    '
    
LA86:
    cmp byte [eswitch], 0
    je LA85
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    
section .data
    LC12 db "eax", 0x00
    
section .text
    mov esi, LC12
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA87
    print "mov "
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", eax"
    print 0x0A
    print '    '
    
LA87:
    cmp byte [eswitch], 0
    je LA85
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA88
    print "mov "
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", eax"
    print 0x0A
    print '    '
    
LA88:
    
LA85:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
FUNCTION_CALL_ARG_REST:
    push ebp
    mov ebp, esp
    push esi
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA89
    print "push "
    call copy_last_match
    print 0x0A
    print '    '
    
LA89:
    cmp byte [eswitch], 0
    je LA90
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA91
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
    print "push "
    call gn3
    print 0x0A
    print '    '
    
LA91:
    cmp byte [eswitch], 0
    je LA90
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    
section .data
    LC13 db "eax", 0x00
    
section .text
    mov esi, LC13
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA92
    print "push, eax"
    print 0x0A
    print '    '
    
LA92:
    cmp byte [eswitch], 0
    je LA90
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA93
    print "push, eax"
    print 0x0A
    print '    '
    
LA93:
    
LA90:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
ARITHMETIC_OPERATION_ARGS:
    push ebp
    mov ebp, esp
    push esi
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA94
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ","
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA95
    print "mov ebx, "
    call copy_last_match
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    je terminate_program
    
LA95:
    cmp byte [eswitch], 0
    je LA96
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    
section .data
    LC14 db "ebx", 0x00
    
section .text
    mov esi, LC14
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA97
    
LA97:
    cmp byte [eswitch], 0
    je LA96
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA98
    print "mov ebx, eax"
    print 0x0A
    print '    '
    
LA98:
    
LA96:
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA94:
    
LA99:
    cmp byte [eswitch], 1
    je LA100
    
LA100:
    cmp byte [eswitch], 0
    je LA101
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA102
    test_input_string ","
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA103
    print "mov ebx, "
    call copy_last_match
    print 0x0A
    print '    '
    
LA103:
    cmp byte [eswitch], 0
    je LA104
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    
section .data
    LC15 db "ebx", 0x00
    
section .text
    mov esi, LC15
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA105
    
LA105:
    cmp byte [eswitch], 0
    je LA104
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA106
    print "mov ebx, eax"
    print 0x0A
    print '    '
    
LA106:
    
LA104:
    cmp byte [eswitch], 1
    je terminate_program
    
LA102:
    
LA107:
    cmp byte [eswitch], 1
    je LA108
    
LA108:
    cmp byte [eswitch], 0
    je LA101
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    
section .data
    LC16 db "eax", 0x00
    
section .text
    mov esi, LC16
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA109
    test_input_string ","
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA110
    print "mov ebx, "
    call copy_last_match
    print 0x0A
    print '    '
    
LA110:
    cmp byte [eswitch], 0
    je LA111
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    
section .data
    LC17 db "ebx", 0x00
    
section .text
    mov esi, LC17
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA112
    
LA112:
    cmp byte [eswitch], 0
    je LA111
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA113
    print "mov ebx, eax"
    print 0x0A
    print '    '
    
LA113:
    
LA111:
    cmp byte [eswitch], 1
    je terminate_program
    
LA109:
    
LA114:
    cmp byte [eswitch], 1
    je LA115
    
LA115:
    
LA101:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
SET_INTO:
    push ebp
    mov ebp, esp
    push esi
    print "mov dword [ebp"
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    mov edi, symbol_table
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
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
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostrsigned
    add dword [outbuff_offset], eax
    print "], "
    
LA116:
    
LA117:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
MOV_INTO:
    push ebp
    mov ebp, esp
    push esi
    print "mov dword [ebp"
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    mov eax, dword [fn_arg_num]
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
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostrsigned
    add dword [outbuff_offset], eax
    print "], "
    
LA118:
    
LA119:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
TYPE:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "i32"
    cmp byte [eswitch], 1
    je LA120
    
LA120:
    
LA121:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
VALUE:
    push ebp
    mov ebp, esp
    push esi
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA122
    print "mov eax, "
    call copy_last_match
    print 0x0A
    print '    '
    
LA122:
    cmp byte [eswitch], 0
    je LA123
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA124
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
    print "mov eax, "
    call gn3
    print 0x0A
    print '    '
    
LA124:
    cmp byte [eswitch], 0
    je LA123
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    pop esi
    push esi
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA125
    
LA125:
    cmp byte [eswitch], 0
    je LA123
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA126
    
LA126:
    
LA123:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
RESULT_SPECIFIER:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA127
    
LA127:
    
LA128:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
SYMBOL_TABLE_ID:
    push ebp
    mov ebp, esp
    push esi
    error_store 'NAME'
    call vstack_clear
    call NAME
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA129
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "mov "
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", dword [ebp"
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
    print 0x0A
    print '    '
    
LA129:
    
LA130:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
WHILE:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "while"
    cmp byte [eswitch], 1
    je LA131
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    
LA132:
    error_store 'STATEMENT'
    call vstack_clear
    call STATEMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA133
    
LA133:
    
LA134:
    cmp byte [eswitch], 0
    je LA132
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp al, 1"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    je terminate_program
    print "jne "
    call gn2
    print 0x0A
    print '    '
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "{"
    cmp byte [eswitch], 1
    je terminate_program
    
LA135:
    error_store 'STATEMENT'
    call vstack_clear
    call STATEMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA136
    
LA136:
    
LA137:
    cmp byte [eswitch], 0
    je LA135
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    print "jmp "
    call gn1
    print 0x0A
    print '    '
    call label
    call gn2
    print ":"
    print 0x0A
    print '    '
    test_input_string "}"
    cmp byte [eswitch], 1
    je terminate_program
    
LA131:
    
LA138:
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
    je LA139
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA139:
    
LA140:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
; -- Tokens --
    
PREFIX:
    
LA141:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA142
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA142
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA142
    mov edi, 10
    call test_char_equal
    
LA142:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA141
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA143
    
LA143:
    
LA144:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA145
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA145
    call DIGIT
    cmp byte [eswitch], 1
    je LA145
    
LA146:
    call DIGIT
    cmp byte [eswitch], 0
    je LA146
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA145
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA145
    
LA145:
    
LA147:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA148
    mov edi, 57
    call test_char_less_equal
    
LA148:
    
LA149:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA150
    
LA150:
    
LA151:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA152
    test_input_string "while"
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    cmp byte [eswitch], 1
    je LA152
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA152
    call ALPHA
    cmp byte [eswitch], 1
    je LA152
    
LA153:
    call ALPHA
    cmp byte [eswitch], 1
    je LA154
    
LA154:
    cmp byte [eswitch], 0
    je LA155
    call DIGIT
    cmp byte [eswitch], 1
    je LA156
    
LA156:
    
LA155:
    cmp byte [eswitch], 0
    je LA153
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA152
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA152
    
LA152:
    
LA157:
    ret
    
NAME:
    call PREFIX
    cmp byte [eswitch], 1
    je LA158
    mov edi, 64
    call test_char_equal
    
LA159:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA158
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA158
    call ALPHA
    cmp byte [eswitch], 1
    je LA158
    
LA160:
    call ALPHA
    cmp byte [eswitch], 1
    je LA161
    
LA161:
    cmp byte [eswitch], 0
    je LA162
    call DIGIT
    cmp byte [eswitch], 1
    je LA163
    
LA163:
    
LA162:
    cmp byte [eswitch], 0
    je LA160
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA158
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA158
    
LA158:
    
LA164:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA165
    mov edi, 90
    call test_char_less_equal
    
LA165:
    cmp byte [eswitch], 0
    je LA166
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA166
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA167
    mov edi, 122
    call test_char_less_equal
    
LA167:
    
LA166:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA168
    
LA168:
    
LA169:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA170
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA170
    mov edi, 34
    call test_char_equal
    
LA171:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA170
    
LA172:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA173
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA173
    mov edi, 34
    call test_char_equal
    
LA173:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA172
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA170
    mov edi, 34
    call test_char_equal
    
LA174:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA170
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA170
    
LA170:
    
LA175:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA176
    mov edi, 34
    call test_char_equal
    
LA177:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA176
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA176
    
LA178:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA179
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA179
    mov edi, 34
    call test_char_equal
    
LA179:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA178
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA176
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA176
    mov edi, 34
    call test_char_equal
    
LA180:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA176
    
LA176:
    
LA181:
    ret
    
