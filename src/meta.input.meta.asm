
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
    jne LOOP_0
    cmp byte [backtrack_switch], 1
    je LA2
    jmp terminate_program
LOOP_0:
    
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
    jne LOOP_1
    cmp byte [backtrack_switch], 1
    je LA10
    jmp terminate_program
LOOP_1:
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
    jne LOOP_2
    cmp byte [backtrack_switch], 1
    je LA10
    jmp terminate_program
LOOP_2:
    
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
    jne LOOP_3
    cmp byte [backtrack_switch], 1
    je LA18
    jmp terminate_program
LOOP_3:
    
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
    jne LOOP_4
    cmp byte [backtrack_switch], 1
    je LA20
    jmp terminate_program
LOOP_4:
    test_input_string ";"
    cmp byte [eswitch], 1
    jne LOOP_5
    cmp byte [backtrack_switch], 1
    je LA20
    jmp terminate_program
LOOP_5:
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
    print "mov esi, eax"
    print 0x0A
    print '    '
    print "mov edi, outbuff"
    print 0x0A
    print '    '
    print "add edi, [outbuff_offset]"
    print 0x0A
    print '    '
    print "call strcpy"
    print 0x0A
    print '    '
    print "add dword [outbuff_offset], eax"
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
    print "mov esi, eax"
    print 0x0A
    print '    '
    print "mov edi, outbuff"
    print 0x0A
    print '    '
    print "add edi, [outbuff_offset]"
    print 0x0A
    print '    '
    print "call strcpy"
    print 0x0A
    print '    '
    print "add dword [outbuff_offset], eax"
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
    print "mov esi, eax"
    print 0x0A
    print '    '
    print "mov edi, outbuff"
    print 0x0A
    print '    '
    print "add edi, [outbuff_offset]"
    print 0x0A
    print '    '
    print "call strcpy"
    print 0x0A
    print '    '
    print "add dword [outbuff_offset], eax"
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
    print "mov esi, eax"
    print 0x0A
    print '    '
    print "mov edi, outbuff"
    print 0x0A
    print '    '
    print "add edi, [outbuff_offset]"
    print 0x0A
    print '    '
    print "call strcpy"
    print 0x0A
    print '    '
    print "add dword [outbuff_offset], eax"
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
    print "call strcpy"
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
    jne LOOP_6
    cmp byte [backtrack_switch], 1
    je LA27
    jmp terminate_program
LOOP_6:
    
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
    jne LOOP_7
    cmp byte [backtrack_switch], 1
    je LA31
    jmp terminate_program
LOOP_7:
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
    print "call strcpy"
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
    
RESOLVE_ARGUMENT:
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
    jne LOOP_8
    cmp byte [backtrack_switch], 1
    je LA36
    jmp terminate_program
LOOP_8:
    cmp byte [eswitch], 1
    jne LOOP_9
    cmp byte [backtrack_switch], 1
    je LA36
    jmp terminate_program
LOOP_9:
    cmp byte [eswitch], 1
    jne LOOP_10
    cmp byte [backtrack_switch], 1
    je LA36
    jmp terminate_program
LOOP_10:
    cmp byte [eswitch], 1
    jne LOOP_11
    cmp byte [backtrack_switch], 1
    je LA36
    jmp terminate_program
LOOP_11:
    cmp byte [eswitch], 1
    jne LOOP_12
    cmp byte [backtrack_switch], 1
    je LA36
    jmp terminate_program
LOOP_12:
    cmp byte [eswitch], 1
    jne LOOP_13
    cmp byte [backtrack_switch], 1
    je LA36
    jmp terminate_program
LOOP_13:
    cmp byte [eswitch], 1
    jne LOOP_14
    cmp byte [backtrack_switch], 1
    je LA36
    jmp terminate_program
LOOP_14:
    print "mov esi, dword [ebp"
    mov edi, symbol_table
    mov esi, last_match
    call hash_get
    cmp byte [eswitch], 1
    jne LOOP_15
    cmp byte [backtrack_switch], 1
    je LA36
    jmp terminate_program
LOOP_15:
    mov ebx, dword [fn_arg_count]
    sub ebx, eax
    cmp byte [eswitch], 1
    jne LOOP_16
    cmp byte [backtrack_switch], 1
    je LA36
    jmp terminate_program
LOOP_16:
    imul eax, ebx, 4
    cmp byte [eswitch], 1
    jne LOOP_17
    cmp byte [backtrack_switch], 1
    je LA36
    jmp terminate_program
LOOP_17:
    add eax, 8
    cmp byte [eswitch], 1
    jne LOOP_18
    cmp byte [backtrack_switch], 1
    je LA36
    jmp terminate_program
LOOP_18:
    mov esi, eax
    cmp byte [eswitch], 1
    jne LOOP_19
    cmp byte [backtrack_switch], 1
    je LA36
    jmp terminate_program
LOOP_19:
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostrsigned
    add dword [outbuff_offset], eax
    print "] ; get "
    call copy_last_match
    print 0x0A
    print '    '
    
LA36:
    
LA37:
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
    je LA38
    cmp byte [eswitch], 1
    jne LOOP_20
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_20:
    cmp byte [eswitch], 1
    jne LOOP_21
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_21:
    cmp byte [eswitch], 1
    jne LOOP_22
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_22:
    cmp byte [eswitch], 1
    jne LOOP_23
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_23:
    cmp byte [eswitch], 1
    jne LOOP_24
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_24:
    cmp byte [eswitch], 1
    jne LOOP_25
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_25:
    cmp byte [eswitch], 1
    jne LOOP_26
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_26:
    cmp byte [eswitch], 1
    jne LOOP_27
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_27:
    cmp byte [eswitch], 1
    jne LOOP_28
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_28:
    cmp byte [eswitch], 1
    jne LOOP_29
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_29:
    cmp byte [eswitch], 1
    jne LOOP_30
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_30:
    cmp byte [eswitch], 1
    jne LOOP_31
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_31:
    cmp byte [eswitch], 1
    jne LOOP_32
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_32:
    cmp byte [eswitch], 1
    jne LOOP_33
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_33:
    cmp byte [eswitch], 1
    jne LOOP_34
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_34:
    cmp byte [eswitch], 1
    jne LOOP_35
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_35:
    cmp byte [eswitch], 1
    jne LOOP_36
    cmp byte [backtrack_switch], 1
    je LA38
    jmp terminate_program
LOOP_36:
    print "pop esi"
    print 0x0A
    print '    '
    print "push esi"
    print 0x0A
    print '    '
    
LA38:
    
LA39:
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
    je LA40
    call copy_last_match
    print 0x0A
    print '    '
    
LA40:
    
LA41:
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
    je LA42
    test_input_string "("
    cmp byte [eswitch], 1
    jne LOOP_37
    cmp byte [backtrack_switch], 1
    je LA42
    jmp terminate_program
LOOP_37:
    
LA43:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA44
    
LA44:
    
LA45:
    cmp byte [eswitch], 0
    je LA43
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_38
    cmp byte [backtrack_switch], 1
    je LA42
    jmp terminate_program
LOOP_38:
    test_input_string ")"
    cmp byte [eswitch], 1
    jne LOOP_39
    cmp byte [backtrack_switch], 1
    je LA42
    jmp terminate_program
LOOP_39:
    print "print 0x0A"
    print 0x0A
    print '    '
    print "print '    '"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_40
    cmp byte [backtrack_switch], 1
    je LA42
    jmp terminate_program
LOOP_40:
    
LA42:
    cmp byte [eswitch], 0
    je LA46
    test_input_string ".UF"
    cmp byte [eswitch], 1
    je LA47
    test_input_string "("
    cmp byte [eswitch], 1
    jne LOOP_41
    cmp byte [backtrack_switch], 1
    je LA47
    jmp terminate_program
LOOP_41:
    
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
    jne LOOP_42
    cmp byte [backtrack_switch], 1
    je LA47
    jmp terminate_program
LOOP_42:
    test_input_string ")"
    cmp byte [eswitch], 1
    jne LOOP_43
    cmp byte [backtrack_switch], 1
    je LA47
    jmp terminate_program
LOOP_43:
    
LA47:
    cmp byte [eswitch], 0
    je LA46
    test_input_string ".LABEL"
    cmp byte [eswitch], 1
    je LA51
    print "call label"
    print 0x0A
    print '    '
    test_input_string "("
    cmp byte [eswitch], 1
    jne LOOP_44
    cmp byte [backtrack_switch], 1
    je LA51
    jmp terminate_program
LOOP_44:
    
LA52:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA53
    
LA53:
    
LA54:
    cmp byte [eswitch], 0
    je LA52
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_45
    cmp byte [backtrack_switch], 1
    je LA51
    jmp terminate_program
LOOP_45:
    test_input_string ")"
    cmp byte [eswitch], 1
    jne LOOP_46
    cmp byte [backtrack_switch], 1
    je LA51
    jmp terminate_program
LOOP_46:
    print "print 0x0A"
    print 0x0A
    print '    '
    print "print '    '"
    print 0x0A
    print '    '
    
LA51:
    cmp byte [eswitch], 0
    je LA46
    test_input_string ".RS"
    cmp byte [eswitch], 1
    je LA55
    test_input_string "("
    cmp byte [eswitch], 1
    jne LOOP_47
    cmp byte [backtrack_switch], 1
    je LA55
    jmp terminate_program
LOOP_47:
    
LA56:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA57
    
LA57:
    
LA58:
    cmp byte [eswitch], 0
    je LA56
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_48
    cmp byte [backtrack_switch], 1
    je LA55
    jmp terminate_program
LOOP_48:
    test_input_string ")"
    cmp byte [eswitch], 1
    jne LOOP_49
    cmp byte [backtrack_switch], 1
    je LA55
    jmp terminate_program
LOOP_49:
    
LA55:
    
LA46:
    cmp byte [eswitch], 1
    je LA59
    
LA59:
    cmp byte [eswitch], 0
    je LA60
    test_input_string ".DIRECT"
    cmp byte [eswitch], 1
    je LA61
    test_input_string "("
    cmp byte [eswitch], 1
    jne LOOP_50
    cmp byte [backtrack_switch], 1
    je LA61
    jmp terminate_program
LOOP_50:
    
LA62:
    error_store 'OUT_IMMEDIATE'
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA62
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_51
    cmp byte [backtrack_switch], 1
    je LA61
    jmp terminate_program
LOOP_51:
    test_input_string ")"
    cmp byte [eswitch], 1
    jne LOOP_52
    cmp byte [backtrack_switch], 1
    je LA61
    jmp terminate_program
LOOP_52:
    
LA61:
    
LA60:
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
    je LA63
    mov esi, last_match
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_53
    cmp byte [backtrack_switch], 1
    je LA63
    jmp terminate_program
LOOP_53:
    cmp byte [eswitch], 1
    jne LOOP_54
    cmp byte [backtrack_switch], 1
    je LA63
    jmp terminate_program
LOOP_54:
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
    je LA64
    error_store 'GENERIC_ARG'
    call vstack_clear
    call GENERIC_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA65
    
LA66:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA67
    error_store 'GENERIC_ARG'
    call vstack_clear
    call GENERIC_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_55
    cmp byte [backtrack_switch], 1
    je LA67
    jmp terminate_program
LOOP_55:
    
LA67:
    
LA68:
    cmp byte [eswitch], 0
    je LA66
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_56
    cmp byte [backtrack_switch], 1
    je LA65
    jmp terminate_program
LOOP_56:
    
LA65:
    cmp byte [eswitch], 0
    je LA69
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA70
    
LA70:
    
LA69:
    cmp byte [eswitch], 1
    jne LOOP_57
    cmp byte [backtrack_switch], 1
    je LA64
    jmp terminate_program
LOOP_57:
    test_input_string ">"
    cmp byte [eswitch], 1
    jne LOOP_58
    cmp byte [backtrack_switch], 1
    je LA64
    jmp terminate_program
LOOP_58:
    
LA64:
    
LA71:
    cmp byte [eswitch], 1
    je LA72
    
LA72:
    cmp byte [eswitch], 0
    je LA73
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA74
    
LA74:
    
LA73:
    cmp byte [eswitch], 1
    jne LOOP_59
    cmp byte [backtrack_switch], 1
    je LA63
    jmp terminate_program
LOOP_59:
    print "call "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    print "call vstack_restore"
    print 0x0A
    print '    '
    print "call error_clear"
    print 0x0A
    print '    '
    
LA63:
    cmp byte [eswitch], 0
    je LA75
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA76
    print "test_input_string "
    call copy_last_match
    print 0x0A
    print '    '
    
LA76:
    cmp byte [eswitch], 0
    je LA75
    test_input_string ".RET"
    cmp byte [eswitch], 1
    je LA77
    print "ret"
    print 0x0A
    print '    '
    
LA77:
    cmp byte [eswitch], 0
    je LA75
    test_input_string ".NOT"
    cmp byte [eswitch], 1
    je LA78
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA79
    
LA79:
    cmp byte [eswitch], 0
    je LA80
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA81
    
LA81:
    
LA80:
    cmp byte [eswitch], 1
    jne LOOP_60
    cmp byte [backtrack_switch], 1
    je LA78
    jmp terminate_program
LOOP_60:
    print "match_not "
    call copy_last_match
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_61
    cmp byte [backtrack_switch], 1
    je LA78
    jmp terminate_program
LOOP_61:
    cmp byte [eswitch], 1
    jne LOOP_62
    cmp byte [backtrack_switch], 1
    je LA78
    jmp terminate_program
LOOP_62:
    cmp byte [eswitch], 1
    jne LOOP_63
    cmp byte [backtrack_switch], 1
    je LA78
    jmp terminate_program
LOOP_63:
    cmp byte [eswitch], 1
    jne LOOP_64
    cmp byte [backtrack_switch], 1
    je LA78
    jmp terminate_program
LOOP_64:
    
LA78:
    cmp byte [eswitch], 0
    je LA75
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA82
    test_input_string "<"
    cmp byte [eswitch], 1
    je LA83
    
LA84:
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA85
    call label
    print "section .data"
    print 0x0A
    print '    '
    call gn3
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
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
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_65
    cmp byte [backtrack_switch], 1
    je LA85
    jmp terminate_program
LOOP_65:
    cmp byte [eswitch], 1
    jne LOOP_66
    cmp byte [backtrack_switch], 1
    je LA85
    jmp terminate_program
LOOP_66:
    cmp byte [eswitch], 1
    jne LOOP_67
    cmp byte [backtrack_switch], 1
    je LA85
    jmp terminate_program
LOOP_67:
    cmp byte [eswitch], 1
    jne LOOP_68
    cmp byte [backtrack_switch], 1
    je LA85
    jmp terminate_program
LOOP_68:
    
LA85:
    cmp byte [eswitch], 0
    je LA86
    test_input_string "*"
    cmp byte [eswitch], 1
    je LA87
    error_store 'RESOLVE_ARGUMENT'
    call vstack_clear
    call RESOLVE_ARGUMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA88
    print "mov edi, outbuff"
    print 0x0A
    print '    '
    print "add edi, [outbuff_offset]"
    print 0x0A
    print '    '
    print "call strcpy"
    print 0x0A
    print '    '
    print "add dword [outbuff_offset], eax"
    print 0x0A
    print '    '
    
LA88:
    cmp byte [eswitch], 0
    je LA89
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA90
    print "mov edi, last_match"
    print 0x0A
    print '    '
    
LA90:
    
LA89:
    cmp byte [eswitch], 1
    jne LOOP_69
    cmp byte [backtrack_switch], 1
    je LA87
    jmp terminate_program
LOOP_69:
    print "call strcat"
    print 0x0A
    print '    '
    print "mov esi, eax"
    print 0x0A
    print '    '
    
LA87:
    
LA91:
    cmp byte [eswitch], 1
    je LA92
    
LA92:
    
LA86:
    cmp byte [eswitch], 0
    je LA84
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_70
    cmp byte [backtrack_switch], 1
    je LA83
    jmp terminate_program
LOOP_70:
    test_input_string ">"
    cmp byte [eswitch], 1
    jne LOOP_71
    cmp byte [backtrack_switch], 1
    je LA83
    jmp terminate_program
LOOP_71:
    
LA83:
    cmp byte [eswitch], 0
    je LA93
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA94
    print "mov esi, last_match"
    print 0x0A
    print '    '
    
LA94:
    
LA93:
    cmp byte [eswitch], 1
    jne LOOP_72
    cmp byte [backtrack_switch], 1
    je LA82
    jmp terminate_program
LOOP_72:
    print "mov edi, str_vector_8192"
    print 0x0A
    print '    '
    print "call vector_push_string_mm32"
    print 0x0A
    print '    '
    
LA82:
    cmp byte [eswitch], 0
    je LA75
    test_input_string "("
    cmp byte [eswitch], 1
    je LA95
    error_store 'EX1'
    call vstack_clear
    call EX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_73
    cmp byte [backtrack_switch], 1
    je LA95
    jmp terminate_program
LOOP_73:
    test_input_string ")"
    cmp byte [eswitch], 1
    jne LOOP_74
    cmp byte [backtrack_switch], 1
    je LA95
    jmp terminate_program
LOOP_74:
    
LA95:
    cmp byte [eswitch], 0
    je LA75
    test_input_string ".EMPTY"
    cmp byte [eswitch], 1
    je LA96
    print "mov byte [eswitch], 0"
    print 0x0A
    print '    '
    
LA96:
    cmp byte [eswitch], 0
    je LA75
    test_input_string "$<"
    cmp byte [eswitch], 1
    je LA97
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_75
    cmp byte [backtrack_switch], 1
    je LA97
    jmp terminate_program
LOOP_75:
    call label
    print "section .data"
    print 0x0A
    print '    '
    print "MIN_ITER_"
    call gn3
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print " dd "
    call copy_last_match
    print 0x0A
    print '    '
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA98
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_76
    cmp byte [backtrack_switch], 1
    je LA98
    jmp terminate_program
LOOP_76:
    print "MAX_ITER_"
    call gn3
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print " dd "
    call copy_last_match
    print 0x0A
    print '    '
    
LA98:
    cmp byte [eswitch], 0
    je LA99
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA100
    print "MAX_ITER_"
    call gn3
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print " dd 0xFFFFFFFF"
    print 0x0A
    print '    '
    
LA100:
    
LA99:
    cmp byte [eswitch], 1
    jne LOOP_77
    cmp byte [backtrack_switch], 1
    je LA97
    jmp terminate_program
LOOP_77:
    test_input_string ">"
    cmp byte [eswitch], 1
    jne LOOP_78
    cmp byte [backtrack_switch], 1
    je LA97
    jmp terminate_program
LOOP_78:
    call label
    print "section .text"
    print 0x0A
    print '    '
    print "xor ecx, ecx"
    print 0x0A
    print '    '
    call label
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
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
    jne LOOP_79
    cmp byte [backtrack_switch], 1
    je LA97
    jmp terminate_program
LOOP_79:
    print "pop ecx"
    print 0x0A
    print '    '
    print "cmp ecx, dword [MAX_ITER_"
    call gn3
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print "]"
    print 0x0A
    print '    '
    print "jg "
    call gn2
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    print "cmp ecx, dword [MIN_ITER_"
    call gn3
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print "]"
    print 0x0A
    print '    '
    print "jl "
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
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
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    call label
    call gn2
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ":"
    print 0x0A
    print '    '
    print "mov byte [eswitch], 0"
    print 0x0A
    print '    '
    
LA97:
    cmp byte [eswitch], 0
    je LA75
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA101
    call label
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ":"
    print 0x0A
    print '    '
    error_store 'EX3'
    call vstack_clear
    call EX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_80
    cmp byte [backtrack_switch], 1
    je LA101
    jmp terminate_program
LOOP_80:
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    print "mov byte [eswitch], 0"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_81
    cmp byte [backtrack_switch], 1
    je LA101
    jmp terminate_program
LOOP_81:
    cmp byte [eswitch], 1
    jne LOOP_82
    cmp byte [backtrack_switch], 1
    je LA101
    jmp terminate_program
LOOP_82:
    cmp byte [eswitch], 1
    jne LOOP_83
    cmp byte [backtrack_switch], 1
    je LA101
    jmp terminate_program
LOOP_83:
    
LA101:
    cmp byte [eswitch], 0
    je LA75
    test_input_string "::"
    cmp byte [eswitch], 1
    je LA102
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_84
    cmp byte [backtrack_switch], 1
    je LA102
    jmp terminate_program
LOOP_84:
    print "; Capture "
    call copy_last_match
    print " as single node"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_85
    cmp byte [backtrack_switch], 1
    je LA102
    jmp terminate_program
LOOP_85:
    cmp byte [eswitch], 1
    jne LOOP_86
    cmp byte [backtrack_switch], 1
    je LA102
    jmp terminate_program
LOOP_86:
    
LA102:
    cmp byte [eswitch], 0
    je LA103
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA104
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_87
    cmp byte [backtrack_switch], 1
    je LA104
    jmp terminate_program
LOOP_87:
    test_input_string "<"
    cmp byte [eswitch], 1
    jne LOOP_88
    cmp byte [backtrack_switch], 1
    je LA104
    jmp terminate_program
LOOP_88:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_89
    cmp byte [backtrack_switch], 1
    je LA104
    jmp terminate_program
LOOP_89:
    test_input_string ">"
    cmp byte [eswitch], 1
    jne LOOP_90
    cmp byte [backtrack_switch], 1
    je LA104
    jmp terminate_program
LOOP_90:
    
LA104:
    
LA103:
    cmp byte [eswitch], 1
    je LA105
    cmp byte [eswitch], 1
    jne LOOP_91
    cmp byte [backtrack_switch], 1
    je LA105
    jmp terminate_program
LOOP_91:
    
LA105:
    cmp byte [eswitch], 0
    je LA75
    test_input_string "{"
    cmp byte [eswitch], 1
    je LA106
    cmp byte [eswitch], 1
    jne LOOP_92
    cmp byte [backtrack_switch], 1
    je LA106
    jmp terminate_program
LOOP_92:
    print "call backtrack_store"
    print 0x0A
    print '    '
    error_store 'EX1'
    call vstack_clear
    call EX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_93
    cmp byte [backtrack_switch], 1
    je LA106
    jmp terminate_program
LOOP_93:
    
LA107:
    test_input_string "/"
    cmp byte [eswitch], 1
    je LA108
    cmp byte [eswitch], 1
    jne LOOP_94
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_94:
    cmp byte [eswitch], 1
    jne LOOP_95
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_95:
    cmp byte [eswitch], 1
    jne LOOP_96
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_96:
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_97
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_97:
    cmp byte [eswitch], 1
    jne LOOP_98
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_98:
    print "call backtrack_restore"
    print 0x0A
    print '    '
    error_store 'EX1'
    call vstack_clear
    call EX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_99
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_99:
    
LA108:
    
LA109:
    cmp byte [eswitch], 0
    je LA107
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_100
    cmp byte [backtrack_switch], 1
    je LA106
    jmp terminate_program
LOOP_100:
    test_input_string "}"
    cmp byte [eswitch], 1
    jne LOOP_101
    cmp byte [backtrack_switch], 1
    je LA106
    jmp terminate_program
LOOP_101:
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_102
    cmp byte [backtrack_switch], 1
    je LA106
    jmp terminate_program
LOOP_102:
    print "call backtrack_restore"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_103
    cmp byte [backtrack_switch], 1
    je LA106
    jmp terminate_program
LOOP_103:
    print "mov byte [eswitch], 1"
    print 0x0A
    print '    '
    call label
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ":"
    print 0x0A
    print '    '
    print "call backtrack_clear"
    print 0x0A
    print '    '
    
LA106:
    cmp byte [eswitch], 0
    je LA75
    error_store 'COMMENT'
    call vstack_clear
    call COMMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA110
    
LA110:
    
LA75:
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
    je LA111
    print "cmp byte [eswitch], 1"
    print 0x0A
    print '    '
    print "je "
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA111:
    cmp byte [eswitch], 0
    je LA112
    error_store 'OUTPUT'
    call vstack_clear
    call OUTPUT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA113
    
LA113:
    
LA112:
    cmp byte [eswitch], 1
    je LA114
    
LA115:
    error_store 'EX3'
    call vstack_clear
    call EX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA116
    cmp byte [eswitch], 1
    jne LOOP_104
    cmp byte [backtrack_switch], 1
    je LA116
    jmp terminate_program
LOOP_104:
    cmp byte [eswitch], 1
    jne LOOP_105
    cmp byte [backtrack_switch], 1
    je LA116
    jmp terminate_program
LOOP_105:
    cmp byte [eswitch], 1
    jne LOOP_106
    cmp byte [backtrack_switch], 1
    je LA116
    jmp terminate_program
LOOP_106:
    test_input_string "@"
    cmp byte [eswitch], 1
    je LA117
    cmp byte [eswitch], 1
    jne LOOP_107
    cmp byte [backtrack_switch], 1
    je LA117
    jmp terminate_program
LOOP_107:
    print "cmp byte [eswitch], 1"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_108
    cmp byte [backtrack_switch], 1
    je LA117
    jmp terminate_program
LOOP_108:
    print "jne "
    call gn3
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    print "mov dword [outbuff_offset], 0"
    print 0x0A
    print '    '
    test_input_string "("
    cmp byte [eswitch], 1
    jne LOOP_109
    cmp byte [backtrack_switch], 1
    je LA117
    jmp terminate_program
LOOP_109:
    
LA118:
    error_store 'OUT1'
    call vstack_clear
    call OUT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA119
    
LA119:
    
LA120:
    cmp byte [eswitch], 0
    je LA118
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_110
    cmp byte [backtrack_switch], 1
    je LA117
    jmp terminate_program
LOOP_110:
    test_input_string ")"
    cmp byte [eswitch], 1
    jne LOOP_111
    cmp byte [backtrack_switch], 1
    je LA117
    jmp terminate_program
LOOP_111:
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
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ":"
    print 0x0A
    print '    '
    
LA117:
    
LA121:
    cmp byte [eswitch], 1
    je LA122
    
LA122:
    cmp byte [eswitch], 0
    je LA123
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA124
    print "cmp byte [eswitch], 1"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_112
    cmp byte [backtrack_switch], 1
    je LA124
    jmp terminate_program
LOOP_112:
    print "jne LOOP_"
    mov esi, dword [loop_counter]
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostr
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    print "cmp byte [backtrack_switch], 1"
    print 0x0A
    print '    '
    print "je "
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    cmp byte [eswitch], 1
    jne LOOP_113
    cmp byte [backtrack_switch], 1
    je LA124
    jmp terminate_program
LOOP_113:
    print '    '
    print "jmp terminate_program"
    print 0x0A
    print "LOOP_"
    mov esi, dword [loop_counter]
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostr
    add dword [outbuff_offset], eax
    inc dword [loop_counter]
    print ":"
    print 0x0A
    print '    '
    
LA124:
    
LA123:
    cmp byte [eswitch], 1
    jne LOOP_114
    cmp byte [backtrack_switch], 1
    je LA116
    jmp terminate_program
LOOP_114:
    
LA116:
    cmp byte [eswitch], 0
    je LA125
    error_store 'OUTPUT'
    call vstack_clear
    call OUTPUT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA126
    
LA126:
    
LA125:
    cmp byte [eswitch], 0
    je LA115
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_115
    cmp byte [backtrack_switch], 1
    je LA114
    jmp terminate_program
LOOP_115:
    call label
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ":"
    print 0x0A
    print '    '
    
LA114:
    
LA127:
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
    je LA128
    
LA129:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA130
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    error_store 'EX2'
    call vstack_clear
    call EX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_116
    cmp byte [backtrack_switch], 1
    je LA130
    jmp terminate_program
LOOP_116:
    
LA130:
    
LA131:
    cmp byte [eswitch], 0
    je LA129
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_117
    cmp byte [backtrack_switch], 1
    je LA128
    jmp terminate_program
LOOP_117:
    call label
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ":"
    print 0x0A
    print '    '
    
LA128:
    
LA132:
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
    je LA133
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
    je LA134
    error_store 'GENERIC'
    call vstack_clear
    call GENERIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_118
    cmp byte [backtrack_switch], 1
    je LA134
    jmp terminate_program
LOOP_118:
    
LA135:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA136
    error_store 'GENERIC'
    call vstack_clear
    call GENERIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_119
    cmp byte [backtrack_switch], 1
    je LA136
    jmp terminate_program
LOOP_119:
    
LA136:
    
LA137:
    cmp byte [eswitch], 0
    je LA135
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_120
    cmp byte [backtrack_switch], 1
    je LA134
    jmp terminate_program
LOOP_120:
    test_input_string ">"
    cmp byte [eswitch], 1
    jne LOOP_121
    cmp byte [backtrack_switch], 1
    je LA134
    jmp terminate_program
LOOP_121:
    
LA134:
    cmp byte [eswitch], 0
    je LA138
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA139
    
LA139:
    
LA138:
    cmp byte [eswitch], 1
    jne LOOP_122
    cmp byte [backtrack_switch], 1
    je LA133
    jmp terminate_program
LOOP_122:
    test_input_string "="
    cmp byte [eswitch], 1
    jne LOOP_123
    cmp byte [backtrack_switch], 1
    je LA133
    jmp terminate_program
LOOP_123:
    error_store 'EX1'
    call vstack_clear
    call EX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_124
    cmp byte [backtrack_switch], 1
    je LA133
    jmp terminate_program
LOOP_124:
    test_input_string ";"
    cmp byte [eswitch], 1
    jne LOOP_125
    cmp byte [backtrack_switch], 1
    je LA133
    jmp terminate_program
LOOP_125:
    cmp byte [eswitch], 1
    jne LOOP_126
    cmp byte [backtrack_switch], 1
    je LA133
    jmp terminate_program
LOOP_126:
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
    
LA133:
    
LA140:
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
    je LA141
    inc dword [fn_arg_count] ; found new argument!
    inc dword [fn_arg_num]
    mov edx, dword [fn_arg_num]
    mov edi, symbol_table
    mov esi, last_match
    call hash_set
    
LA141:
    
LA142:
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
    je LA143
    print "mov esi, "
    call copy_last_match
    print 0x0A
    print '    '
    
LA143:
    cmp byte [eswitch], 0
    je LA144
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA145
    call label
    print "section .data"
    print 0x0A
    print '    '
    call gn3
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
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
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA145:
    cmp byte [eswitch], 0
    je LA144
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA146
    print "pop esi"
    print 0x0A
    print '    '
    print "push esi"
    print 0x0A
    print '    '
    
LA146:
    
LA144:
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
    je LA147
    call label
    call copy_last_match
    print ":"
    print 0x0A
    print '    '
    test_input_string "="
    cmp byte [eswitch], 1
    jne LOOP_127
    cmp byte [backtrack_switch], 1
    je LA147
    jmp terminate_program
LOOP_127:
    error_store 'TX1'
    call vstack_clear
    call TX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_128
    cmp byte [backtrack_switch], 1
    je LA147
    jmp terminate_program
LOOP_128:
    test_input_string ";"
    cmp byte [eswitch], 1
    jne LOOP_129
    cmp byte [backtrack_switch], 1
    je LA147
    jmp terminate_program
LOOP_129:
    print "ret"
    print 0x0A
    print '    '
    
LA147:
    
LA148:
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
    je LA149
    
LA150:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA151
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    error_store 'TX2'
    call vstack_clear
    call TX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_130
    cmp byte [backtrack_switch], 1
    je LA151
    jmp terminate_program
LOOP_130:
    
LA151:
    
LA152:
    cmp byte [eswitch], 0
    je LA150
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_131
    cmp byte [backtrack_switch], 1
    je LA149
    jmp terminate_program
LOOP_131:
    call label
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ":"
    print 0x0A
    print '    '
    
LA149:
    
LA153:
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
    je LA154
    print "cmp byte [eswitch], 1"
    print 0x0A
    print '    '
    print "je "
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_132
    cmp byte [backtrack_switch], 1
    je LA154
    jmp terminate_program
LOOP_132:
    
LA155:
    error_store 'TX3'
    call vstack_clear
    call TX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA156
    print "cmp byte [eswitch], 1"
    print 0x0A
    print '    '
    print "je "
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA156:
    
LA157:
    cmp byte [eswitch], 0
    je LA155
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_133
    cmp byte [backtrack_switch], 1
    je LA154
    jmp terminate_program
LOOP_133:
    call label
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ":"
    print 0x0A
    print '    '
    
LA154:
    
LA158:
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
    je LA159
    cmp byte [eswitch], 1
    jne LOOP_134
    cmp byte [backtrack_switch], 1
    je LA159
    jmp terminate_program
LOOP_134:
    print "mov byte [tflag], 1"
    print 0x0A
    print '    '
    print "call clear_token"
    print 0x0A
    print '    '
    
LA159:
    cmp byte [eswitch], 0
    je LA160
    test_input_string ".DELTOK"
    cmp byte [eswitch], 1
    je LA161
    cmp byte [eswitch], 1
    jne LOOP_135
    cmp byte [backtrack_switch], 1
    je LA161
    jmp terminate_program
LOOP_135:
    print "mov byte [tflag], 0"
    print 0x0A
    print '    '
    
LA161:
    cmp byte [eswitch], 0
    je LA160
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA162
    call label
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ":"
    print 0x0A
    print '    '
    error_store 'TX3'
    call vstack_clear
    call TX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_136
    cmp byte [backtrack_switch], 1
    je LA162
    jmp terminate_program
LOOP_136:
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA162:
    
LA160:
    cmp byte [eswitch], 1
    je LA163
    print "mov byte [eswitch], 0"
    print 0x0A
    print '    '
    
LA163:
    cmp byte [eswitch], 0
    je LA164
    test_input_string ".ANYBUT("
    cmp byte [eswitch], 1
    je LA165
    error_store 'CX1'
    call vstack_clear
    call CX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_137
    cmp byte [backtrack_switch], 1
    je LA165
    jmp terminate_program
LOOP_137:
    test_input_string ")"
    cmp byte [eswitch], 1
    jne LOOP_138
    cmp byte [backtrack_switch], 1
    je LA165
    jmp terminate_program
LOOP_138:
    cmp byte [eswitch], 1
    jne LOOP_139
    cmp byte [backtrack_switch], 1
    je LA165
    jmp terminate_program
LOOP_139:
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
    
LA165:
    cmp byte [eswitch], 0
    je LA164
    test_input_string ".ANY("
    cmp byte [eswitch], 1
    je LA166
    error_store 'CX1'
    call vstack_clear
    call CX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_140
    cmp byte [backtrack_switch], 1
    je LA166
    jmp terminate_program
LOOP_140:
    test_input_string ")"
    cmp byte [eswitch], 1
    jne LOOP_141
    cmp byte [backtrack_switch], 1
    je LA166
    jmp terminate_program
LOOP_141:
    print "call scan_or_parse"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_142
    cmp byte [backtrack_switch], 1
    je LA166
    jmp terminate_program
LOOP_142:
    cmp byte [eswitch], 1
    jne LOOP_143
    cmp byte [backtrack_switch], 1
    je LA166
    jmp terminate_program
LOOP_143:
    
LA166:
    cmp byte [eswitch], 0
    je LA164
    test_input_string ".RESERVED("
    cmp byte [eswitch], 1
    je LA167
    
LA168:
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA169
    print "test_input_string_no_cursor_advance "
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
    
LA169:
    
LA170:
    cmp byte [eswitch], 0
    je LA168
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_144
    cmp byte [backtrack_switch], 1
    je LA167
    jmp terminate_program
LOOP_144:
    test_input_string ")"
    cmp byte [eswitch], 1
    jne LOOP_145
    cmp byte [backtrack_switch], 1
    je LA167
    jmp terminate_program
LOOP_145:
    
LA167:
    cmp byte [eswitch], 0
    je LA164
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA171
    print "call "
    call copy_last_match
    print 0x0A
    print '    '
    
LA171:
    cmp byte [eswitch], 0
    je LA164
    test_input_string "("
    cmp byte [eswitch], 1
    je LA172
    error_store 'TX1'
    call vstack_clear
    call TX1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_146
    cmp byte [backtrack_switch], 1
    je LA172
    jmp terminate_program
LOOP_146:
    test_input_string ")"
    cmp byte [eswitch], 1
    jne LOOP_147
    cmp byte [backtrack_switch], 1
    je LA172
    jmp terminate_program
LOOP_147:
    
LA172:
    
LA164:
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
    je LA173
    
LA174:
    test_input_string "!"
    cmp byte [eswitch], 1
    je LA175
    print "cmp byte [eswitch], 0"
    print 0x0A
    print '    '
    print "je "
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    error_store 'CX2'
    call vstack_clear
    call CX2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_148
    cmp byte [backtrack_switch], 1
    je LA175
    jmp terminate_program
LOOP_148:
    
LA175:
    
LA176:
    cmp byte [eswitch], 0
    je LA174
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_149
    cmp byte [backtrack_switch], 1
    je LA173
    jmp terminate_program
LOOP_149:
    call label
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ":"
    print 0x0A
    print '    '
    
LA173:
    
LA177:
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
    je LA178
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA179
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
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    error_store 'CX3'
    call vstack_clear
    call CX3
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_150
    cmp byte [backtrack_switch], 1
    je LA179
    jmp terminate_program
LOOP_150:
    print "mov edi, "
    call copy_last_match
    print 0x0A
    print '    '
    print "call test_char_less_equal"
    print 0x0A
    print '    '
    call label
    call gn1
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ":"
    print 0x0A
    print '    '
    
LA179:
    cmp byte [eswitch], 0
    je LA180
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA181
    print "mov edi, "
    call copy_last_match
    print 0x0A
    print '    '
    print "call test_char_equal"
    print 0x0A
    print '    '
    
LA181:
    
LA180:
    cmp byte [eswitch], 1
    jne LOOP_151
    cmp byte [backtrack_switch], 1
    je LA178
    jmp terminate_program
LOOP_151:
    
LA178:
    
LA182:
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
    je LA183
    
LA183:
    cmp byte [eswitch], 0
    je LA184
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA185
    
LA185:
    
LA184:
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
    je LA186
    match_not 10
    cmp byte [eswitch], 1
    jne LOOP_152
    cmp byte [backtrack_switch], 1
    je LA186
    jmp terminate_program
LOOP_152:
    
LA186:
    
LA187:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
; -- Tokens --
    
PREFIX:
    
LA188:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA189
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA189
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA189
    mov edi, 10
    call test_char_equal
    
LA189:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA188
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA190
    
LA190:
    
LA191:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA192
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA192
    call DIGIT
    cmp byte [eswitch], 1
    je LA192
    
LA193:
    call DIGIT
    cmp byte [eswitch], 0
    je LA193
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA192
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA192
    
LA192:
    
LA194:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA195
    mov edi, 57
    call test_char_less_equal
    
LA195:
    
LA196:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA197
    
LA197:
    
LA198:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA199
    test_input_string_no_cursor_advance "import"
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    cmp byte [eswitch], 1
    je LA199
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA199
    call ALPHA
    cmp byte [eswitch], 1
    je LA199
    
LA200:
    call ALPHA
    cmp byte [eswitch], 1
    je LA201
    
LA201:
    cmp byte [eswitch], 0
    je LA202
    call DIGIT
    cmp byte [eswitch], 1
    je LA203
    
LA203:
    
LA202:
    cmp byte [eswitch], 0
    je LA200
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA199
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA199
    
LA199:
    
LA204:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA205
    mov edi, 90
    call test_char_less_equal
    
LA205:
    cmp byte [eswitch], 0
    je LA206
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA206
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA207
    mov edi, 122
    call test_char_less_equal
    
LA207:
    
LA206:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA208
    
LA208:
    
LA209:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA210
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA210
    mov edi, 34
    call test_char_equal
    
LA211:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA210
    
LA212:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA213
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA213
    mov edi, 34
    call test_char_equal
    
LA213:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA212
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA210
    mov edi, 34
    call test_char_equal
    
LA214:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA210
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA210
    
LA210:
    
LA215:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA216
    mov edi, 34
    call test_char_equal
    
LA217:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA216
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA216
    
LA218:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA219
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA219
    mov edi, 34
    call test_char_equal
    
LA219:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA218
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA216
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA216
    mov edi, 34
    call test_char_equal
    
LA220:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA216
    
LA216:
    
LA221:
    ret
    