
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
    error_store 'STRUCT'
    call vstack_clear
    call STRUCT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA4
    
LA4:
    cmp byte [eswitch], 0
    je LA3
    error_store 'WHILE'
    call vstack_clear
    call WHILE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA5
    
LA5:
    cmp byte [eswitch], 0
    je LA3
    error_store 'STATEMENT'
    call vstack_clear
    call STATEMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA6
    
LA6:
    cmp byte [eswitch], 0
    je LA3
    error_store 'COMMENT'
    call vstack_clear
    call COMMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA7
    
LA7:
    
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
    
LA8:
    
LA9:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
STRUCT:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "struct"
    cmp byte [eswitch], 1
    je LA10
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print 0x0A
    print "struc "
    call copy_last_match
    print 0x0A
    test_input_string "{"
    cmp byte [eswitch], 1
    je terminate_program
    
LA11:
    error_store 'STRUCT_MEMBER'
    call vstack_clear
    call STRUCT_MEMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA12
    
LA12:
    
LA13:
    cmp byte [eswitch], 0
    je LA11
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "}"
    cmp byte [eswitch], 1
    je terminate_program
    print "endstruc"
    print 0x0A
    print 0x0A
    
LA10:
    
LA14:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
STRUCT_MEMBER:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "i8"
    cmp byte [eswitch], 1
    je LA15
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print '    '
    print "."
    call copy_last_match
    print ": resb 1"
    print 0x0A
    
LA15:
    
LA16:
    cmp byte [eswitch], 1
    je LA17
    
LA17:
    cmp byte [eswitch], 0
    je LA18
    test_input_string "i16"
    cmp byte [eswitch], 1
    je LA19
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print '    '
    print "."
    call copy_last_match
    print ": resw 1"
    print 0x0A
    
LA19:
    
LA20:
    cmp byte [eswitch], 1
    je LA21
    
LA21:
    cmp byte [eswitch], 0
    je LA18
    test_input_string "i32"
    cmp byte [eswitch], 1
    je LA22
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print '    '
    print "."
    call copy_last_match
    print ": resd 1"
    print 0x0A
    
LA22:
    
LA23:
    cmp byte [eswitch], 1
    je LA24
    
LA24:
    cmp byte [eswitch], 0
    je LA18
    test_input_string "i64"
    cmp byte [eswitch], 1
    je LA25
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print '    '
    print "."
    call copy_last_match
    print ": resq 1"
    print 0x0A
    
LA25:
    
LA26:
    cmp byte [eswitch], 1
    je LA27
    
LA27:
    cmp byte [eswitch], 0
    je LA18
    test_input_string "char["
    cmp byte [eswitch], 1
    je LA28
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print '    '
    print "."
    call copy_last_match
    print ": resb "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    
LA28:
    
LA29:
    cmp byte [eswitch], 1
    je LA30
    
LA30:
    cmp byte [eswitch], 0
    je LA18
    test_input_string "char"
    cmp byte [eswitch], 1
    je LA31
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print '    '
    print "."
    call copy_last_match
    print ": resb 1"
    print 0x0A
    
LA31:
    
LA32:
    cmp byte [eswitch], 1
    je LA33
    
LA33:
    
LA18:
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
    je LA34
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
    
section .data
    LC1 db "esi", 0x00
    
section .text
    mov esi, LC1
    call FUNCTION_PARAM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA35
    
LA36:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA37
    error_store 'FUNCTION_PARAM'
    call vstack_clear
    
section .data
    LC2 db "edi", 0x00
    
section .text
    mov esi, LC2
    call FUNCTION_PARAM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA38:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA39
    error_store 'FUNCTION_PARAM'
    call vstack_clear
    
section .data
    LC3 db "edx", 0x00
    
section .text
    mov esi, LC3
    call FUNCTION_PARAM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA40:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA41
    error_store 'FUNCTION_PARAM'
    call vstack_clear
    
section .data
    LC4 db "ecx", 0x00
    
section .text
    mov esi, LC4
    call FUNCTION_PARAM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA42:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA43
    error_store 'PUSHED_FUNCTION_PARAM'
    call vstack_clear
    call PUSHED_FUNCTION_PARAM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA43:
    
LA44:
    cmp byte [eswitch], 0
    je LA42
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA41:
    
LA45:
    cmp byte [eswitch], 0
    je LA40
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA39:
    
LA46:
    cmp byte [eswitch], 0
    je LA38
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA37:
    
LA47:
    cmp byte [eswitch], 0
    je LA36
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA35:
    cmp byte [eswitch], 0
    je LA48
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA49
    
LA49:
    
LA48:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    add dword [fn_arg_num], 2
    mov eax, dword [fn_arg_count]
    add dword [fn_arg_num], eax
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
    
LA34:
    
LA50:
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
    je LA51
    error_store 'NAME'
    call vstack_clear
    call NAME
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    inc dword [fn_arg_num]
    mov edx, dword [fn_arg_num]
    cmp byte [eswitch], 1
    je terminate_program
    add edx, 2
    add edx, dword [fn_arg_count]
    mov edi, symbol_table
    mov esi, last_match
    call hash_set
    print "mov dword [ebp-"
    mov esi, dword [fn_arg_num]
    imul esi, esi, 4
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostr
    add dword [outbuff_offset], eax
    print "], "
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    print "sub esp, 4"
    print 0x0A
    print '    '
    
LA51:
    
LA52:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
PUSHED_FUNCTION_PARAM:
    push ebp
    mov ebp, esp
    push esi
    error_store 'TYPE'
    call vstack_clear
    call TYPE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA53
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
    sub edx, 4
    mov edi, symbol_table
    mov esi, last_match
    call hash_set
    
LA53:
    
LA54:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
FUNCTION_BODY:
    push ebp
    mov ebp, esp
    push esi
    
LA55:
    error_store 'WHILE'
    call vstack_clear
    call WHILE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA56
    
LA56:
    cmp byte [eswitch], 0
    je LA57
    error_store 'STATEMENT'
    call vstack_clear
    call STATEMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA58
    
LA58:
    cmp byte [eswitch], 0
    je LA57
    error_store 'COMMENT'
    call vstack_clear
    call COMMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA59
    
LA59:
    
LA57:
    cmp byte [eswitch], 0
    je LA55
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA60
    
LA60:
    
LA61:
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
    je LA62
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
    LC5 db "eax", 0x00
    
section .text
    mov esi, LC5
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'MOV_INTO'
    call vstack_clear
    
section .data
    LC6 db "eax", 0x00
    
section .text
    mov esi, LC6
    call MOV_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "sub esp, 4"
    print 0x0A
    print '    '
    
LA62:
    
LA63:
    cmp byte [eswitch], 1
    je LA64
    
LA64:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%push"
    cmp byte [eswitch], 1
    je LA66
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
    je terminate_program
    print "sub esp, 4"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA66:
    
LA67:
    cmp byte [eswitch], 1
    je LA68
    
LA68:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%add"
    cmp byte [eswitch], 1
    je LA69
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
    
LA69:
    
LA70:
    cmp byte [eswitch], 1
    je LA71
    
LA71:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%neq"
    cmp byte [eswitch], 1
    je LA72
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
    
LA72:
    
LA73:
    cmp byte [eswitch], 1
    je LA74
    
LA74:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%eq"
    cmp byte [eswitch], 1
    je LA75
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
    
LA75:
    
LA76:
    cmp byte [eswitch], 1
    je LA77
    
LA77:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%lt"
    cmp byte [eswitch], 1
    je LA78
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
    
LA78:
    
LA79:
    cmp byte [eswitch], 1
    je LA80
    
LA80:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%gt"
    cmp byte [eswitch], 1
    je LA81
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
    
LA81:
    
LA82:
    cmp byte [eswitch], 1
    je LA83
    
LA83:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%deref/byte"
    cmp byte [eswitch], 1
    je LA84
    error_store 'VALUE'
    call vstack_clear
    
section .data
    LC8 db "eax", 0x00
    
section .text
    mov esi, LC8
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov ebx, eax"
    print 0x0A
    print '    '
    print "xor eax, eax"
    print 0x0A
    print '    '
    print "mov al, byte [ebx]"
    print 0x0A
    print '    '
    
LA84:
    
LA85:
    cmp byte [eswitch], 1
    je LA86
    
LA86:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%deref/word"
    cmp byte [eswitch], 1
    je LA87
    error_store 'VALUE'
    call vstack_clear
    
section .data
    LC9 db "eax", 0x00
    
section .text
    mov esi, LC9
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov ax, word [eax]"
    print 0x0A
    print '    '
    
LA87:
    
LA88:
    cmp byte [eswitch], 1
    je LA89
    
LA89:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%deref/dword"
    cmp byte [eswitch], 1
    je LA90
    error_store 'VALUE'
    call vstack_clear
    
section .data
    LC10 db "eax", 0x00
    
section .text
    mov esi, LC10
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, dword [eax]"
    print 0x0A
    print '    '
    
LA90:
    
LA91:
    cmp byte [eswitch], 1
    je LA92
    cmp byte [eswitch], 1
    je terminate_program
    
LA92:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%setref"
    cmp byte [eswitch], 1
    je LA93
    error_store 'VALUE'
    call vstack_clear
    
section .data
    LC11 db "eax", 0x00
    
section .text
    mov esi, LC11
    call VALUE
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
    LC12 db "ebx", 0x00
    
section .text
    mov esi, LC12
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov dword [eax], ebx"
    print 0x0A
    print '    '
    
LA93:
    
LA94:
    cmp byte [eswitch], 1
    je LA95
    
LA95:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%set"
    cmp byte [eswitch], 1
    je LA96
    error_store 'VALUE'
    call vstack_clear
    
section .data
    LC13 db "ebx", 0x00
    
section .text
    mov esi, LC13
    call VALUE
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
    LC14 db "eax", 0x00
    
section .text
    mov esi, LC14
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov dword [ebx], eax"
    print 0x0A
    print '    '
    
LA96:
    
LA97:
    cmp byte [eswitch], 1
    je LA98
    
LA98:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%ret"
    cmp byte [eswitch], 1
    je LA99
    error_store 'VALUE'
    call vstack_clear
    
section .data
    LC15 db "eax", 0x00
    
section .text
    mov esi, LC15
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA100
    
LA100:
    cmp byte [eswitch], 0
    je LA101
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA102
    
LA102:
    
LA101:
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
    
LA99:
    
LA103:
    cmp byte [eswitch], 1
    je LA104
    
LA104:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%call"
    cmp byte [eswitch], 1
    je LA105
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "call "
    call copy_last_match
    print 0x0A
    print '    '
    
LA105:
    
LA106:
    cmp byte [eswitch], 1
    je LA107
    
LA107:
    cmp byte [eswitch], 0
    je LA65
    test_input_string "%arg"
    cmp byte [eswitch], 1
    je LA108
    error_store 'FUNCTION_CALL_ARG'
    call vstack_clear
    
section .data
    LC16 db "esi", 0x00
    
section .text
    mov esi, LC16
    call FUNCTION_CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA109:
    test_input_string "%arg"
    cmp byte [eswitch], 1
    je LA110
    error_store 'FUNCTION_CALL_ARG'
    call vstack_clear
    
section .data
    LC17 db "edi", 0x00
    
section .text
    mov esi, LC17
    call FUNCTION_CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA111:
    test_input_string "%arg"
    cmp byte [eswitch], 1
    je LA112
    error_store 'FUNCTION_CALL_ARG'
    call vstack_clear
    
section .data
    LC18 db "edx", 0x00
    
section .text
    mov esi, LC18
    call FUNCTION_CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA113:
    test_input_string "%arg"
    cmp byte [eswitch], 1
    je LA114
    error_store 'FUNCTION_CALL_ARG'
    call vstack_clear
    
section .data
    LC19 db "ecx", 0x00
    
section .text
    mov esi, LC19
    call FUNCTION_CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA115:
    test_input_string "%arg"
    cmp byte [eswitch], 1
    je LA116
    error_store 'FUNCTION_CALL_ARG_REST'
    call vstack_clear
    call FUNCTION_CALL_ARG_REST
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
    
LA114:
    
LA118:
    cmp byte [eswitch], 0
    je LA113
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA112:
    
LA119:
    cmp byte [eswitch], 0
    je LA111
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA110:
    
LA120:
    cmp byte [eswitch], 0
    je LA109
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA108:
    
LA121:
    cmp byte [eswitch], 1
    je LA122
    
LA122:
    
LA65:
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
    je LA123
    print "mov "
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ", "
    call copy_last_match
    print 0x0A
    print '    '
    
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
    call strcpy
    add dword [outbuff_offset], eax
    print ", "
    call gn3
    print 0x0A
    print '    '
    
LA125:
    cmp byte [eswitch], 0
    je LA124
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    
section .data
    LC20 db "eax", 0x00
    
section .text
    mov esi, LC20
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA126
    print "mov "
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ", eax"
    print 0x0A
    print '    '
    
LA126:
    cmp byte [eswitch], 0
    je LA124
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA127
    print "mov "
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ", eax"
    print 0x0A
    print '    '
    
LA127:
    cmp byte [eswitch], 0
    je LA124
    error_store 'STACK_POINTER'
    call vstack_clear
    call STACK_POINTER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA128
    print "pop "
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA128:
    
LA124:
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
    je LA129
    print "add esp, 4"
    print 0x0A
    print '    '
    print "push "
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
    print "add esp, 4"
    print 0x0A
    print '    '
    print "push "
    call gn3
    print 0x0A
    print '    '
    
LA131:
    cmp byte [eswitch], 0
    je LA130
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    
section .data
    LC21 db "eax", 0x00
    
section .text
    mov esi, LC21
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA132
    print "add esp, 4"
    print 0x0A
    print '    '
    print "push, eax"
    print 0x0A
    print '    '
    
LA132:
    cmp byte [eswitch], 0
    je LA130
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA133
    print "add esp, 4"
    print 0x0A
    print '    '
    print "push, eax"
    print 0x0A
    print '    '
    
LA133:
    cmp byte [eswitch], 0
    je LA130
    error_store 'STACK_POINTER'
    call vstack_clear
    call STACK_POINTER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA134
    print "pop, eax"
    print 0x0A
    print '    '
    print "add esp, 4"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA134:
    
LA130:
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
    je LA135
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
    je LA136
    print "mov ebx, "
    call copy_last_match
    print 0x0A
    print '    '
    
LA136:
    cmp byte [eswitch], 0
    je LA137
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    
section .data
    LC22 db "ebx", 0x00
    
section .text
    mov esi, LC22
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA138
    
LA138:
    cmp byte [eswitch], 0
    je LA137
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA139
    print "mov ebx, eax"
    print 0x0A
    print '    '
    
LA139:
    
LA137:
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA135:
    
LA140:
    cmp byte [eswitch], 1
    je LA141
    
LA141:
    cmp byte [eswitch], 0
    je LA142
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA143
    test_input_string ","
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA144
    print "mov ebx, "
    call copy_last_match
    print 0x0A
    print '    '
    
LA144:
    cmp byte [eswitch], 0
    je LA145
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    
section .data
    LC23 db "ebx", 0x00
    
section .text
    mov esi, LC23
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA146
    
LA146:
    cmp byte [eswitch], 0
    je LA145
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA147
    print "mov ebx, eax"
    print 0x0A
    print '    '
    
LA147:
    
LA145:
    cmp byte [eswitch], 1
    je terminate_program
    
LA143:
    
LA148:
    cmp byte [eswitch], 1
    je LA149
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    
LA149:
    cmp byte [eswitch], 0
    je LA142
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    
section .data
    LC24 db "ecx", 0x00
    
section .text
    mov esi, LC24
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA150
    test_input_string ","
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA151
    print "mov ebx, "
    call copy_last_match
    print 0x0A
    print '    '
    
LA151:
    cmp byte [eswitch], 0
    je LA152
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    
section .data
    LC25 db "ebx", 0x00
    
section .text
    mov esi, LC25
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA153
    
LA153:
    cmp byte [eswitch], 0
    je LA152
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA154
    print "mov ebx, eax"
    print 0x0A
    print '    '
    
LA154:
    
LA152:
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, ecx"
    print 0x0A
    print '    '
    
LA150:
    
LA155:
    cmp byte [eswitch], 1
    je LA156
    
LA156:
    
LA142:
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
    
LA157:
    
LA158:
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
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA159:
    
LA160:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
TYPE:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "*"
    cmp byte [eswitch], 1
    je LA161
    
LA161:
    cmp byte [eswitch], 0
    je LA162
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA163
    
LA163:
    
LA162:
    cmp byte [eswitch], 1
    je LA164
    test_input_string "i8"
    cmp byte [eswitch], 1
    je LA165
    
LA165:
    cmp byte [eswitch], 0
    je LA166
    test_input_string "i16"
    cmp byte [eswitch], 1
    je LA167
    
LA167:
    cmp byte [eswitch], 0
    je LA166
    test_input_string "i32"
    cmp byte [eswitch], 1
    je LA168
    
LA168:
    cmp byte [eswitch], 0
    je LA166
    test_input_string "i64"
    cmp byte [eswitch], 1
    je LA169
    
LA169:
    cmp byte [eswitch], 0
    je LA166
    test_input_string "f32"
    cmp byte [eswitch], 1
    je LA170
    
LA170:
    cmp byte [eswitch], 0
    je LA166
    test_input_string "f64"
    cmp byte [eswitch], 1
    je LA171
    
LA171:
    cmp byte [eswitch], 0
    je LA166
    test_input_string "char["
    cmp byte [eswitch], 1
    je LA172
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA173
    
LA173:
    cmp byte [eswitch], 0
    je LA174
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA175
    
LA175:
    
LA174:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA172:
    
LA176:
    cmp byte [eswitch], 1
    je LA177
    
LA177:
    cmp byte [eswitch], 0
    je LA166
    test_input_string "char"
    cmp byte [eswitch], 1
    je LA178
    
LA178:
    cmp byte [eswitch], 0
    je LA166
    test_input_string "bool"
    cmp byte [eswitch], 1
    je LA179
    
LA179:
    cmp byte [eswitch], 0
    je LA166
    test_input_string "void"
    cmp byte [eswitch], 1
    je LA180
    
LA180:
    cmp byte [eswitch], 0
    je LA166
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA181
    
LA181:
    
LA166:
    cmp byte [eswitch], 1
    je terminate_program
    
LA164:
    
LA182:
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
    je LA183
    print "mov "
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ", "
    call copy_last_match
    print 0x0A
    print '    '
    
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
    call strcpy
    add dword [outbuff_offset], eax
    print ", "
    call gn3
    print 0x0A
    print '    '
    
LA185:
    cmp byte [eswitch], 0
    je LA184
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    pop esi
    push esi
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA186
    
LA186:
    cmp byte [eswitch], 0
    je LA184
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA187
    print "mov "
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print ", eax"
    print 0x0A
    print '    '
    
LA187:
    cmp byte [eswitch], 0
    je LA184
    error_store 'STACK_POINTER'
    call vstack_clear
    call STACK_POINTER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA188
    print "pop "
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA188:
    
LA184:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
STACK_POINTER:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "&"
    cmp byte [eswitch], 1
    je LA189
    
LA189:
    
LA190:
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
    je LA191
    
LA191:
    
LA192:
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
    je LA193
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
    call strcpy
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
    
LA193:
    
LA194:
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
    je LA195
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    
LA196:
    error_store 'STATEMENT'
    call vstack_clear
    call STATEMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA197
    
LA197:
    
LA198:
    cmp byte [eswitch], 0
    je LA196
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
    
LA199:
    error_store 'STATEMENT'
    call vstack_clear
    call STATEMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA200
    
LA200:
    
LA201:
    cmp byte [eswitch], 0
    je LA199
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
    
LA195:
    
LA202:
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
    je LA203
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA203:
    
LA204:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
; -- Tokens --
    
PREFIX:
    
LA205:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA206
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA206
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA206
    mov edi, 10
    call test_char_equal
    
LA206:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA205
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA207
    
LA207:
    
LA208:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA209
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA209
    call DIGIT
    cmp byte [eswitch], 1
    je LA209
    
LA210:
    call DIGIT
    cmp byte [eswitch], 0
    je LA210
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA209
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA209
    
LA209:
    
LA211:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA212
    mov edi, 57
    call test_char_less_equal
    
LA212:
    
LA213:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA214
    
LA214:
    
LA215:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA216
    test_input_string "while"
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    cmp byte [eswitch], 1
    je LA216
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA216
    call ALPHA
    cmp byte [eswitch], 1
    je LA216
    
LA217:
    call ALPHA
    cmp byte [eswitch], 1
    je LA218
    
LA218:
    cmp byte [eswitch], 0
    je LA219
    call DIGIT
    cmp byte [eswitch], 1
    je LA220
    
LA220:
    
LA219:
    cmp byte [eswitch], 0
    je LA217
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA216
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA216
    
LA216:
    
LA221:
    ret
    
NAME:
    call PREFIX
    cmp byte [eswitch], 1
    je LA222
    mov edi, 64
    call test_char_equal
    
LA223:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA222
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA222
    call ALPHA
    cmp byte [eswitch], 1
    je LA222
    
LA224:
    call ALPHA
    cmp byte [eswitch], 1
    je LA225
    
LA225:
    cmp byte [eswitch], 0
    je LA226
    call DIGIT
    cmp byte [eswitch], 1
    je LA227
    
LA227:
    
LA226:
    cmp byte [eswitch], 0
    je LA224
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA222
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA222
    
LA222:
    
LA228:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA229
    mov edi, 90
    call test_char_less_equal
    
LA229:
    cmp byte [eswitch], 0
    je LA230
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA230
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA231
    mov edi, 122
    call test_char_less_equal
    
LA231:
    
LA230:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA232
    
LA232:
    
LA233:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA234
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA234
    mov edi, 34
    call test_char_equal
    
LA235:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA234
    
LA236:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA237
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA237
    mov edi, 34
    call test_char_equal
    
LA237:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA236
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA234
    mov edi, 34
    call test_char_equal
    
LA238:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA234
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA234
    
LA234:
    
LA239:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA240
    mov edi, 34
    call test_char_equal
    
LA241:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA240
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA240
    
LA242:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA243
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA243
    mov edi, 34
    call test_char_equal
    
LA243:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA242
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA240
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA240
    mov edi, 34
    call test_char_equal
    
LA244:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA240
    
LA240:
    
LA245:
    ret
    
