
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
    call newline
    print "global _start"
    call newline
    call label
    print "_start:"
    call newline
    
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
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, 1"
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    print "mov ebx, dword [ebp+8]"
    call newline
    print "int 0x80"
    call newline
    
LA6:
    
LA7:
    ret
    
FUNCTION_DECLARATION:
    test_input_string "fn"
    cmp byte [eswitch], 1
    je LA8
    cmp byte [eswitch], 1
    je terminate_program
    print "jmp "
    call gn1
    call newline
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
    call newline
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
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
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
    call newline
    print "pop ebp"
    call newline
    print "ret"
    call newline
    call label
    call gn1
    print ":"
    call newline
    test_input_string "}"
    cmp byte [eswitch], 1
    je terminate_program
    
LA8:
    
LA15:
    ret
    
FUNCTION_PARAM:
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
    ret
    
FUNCTION_BODY:
    
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
    ret
    
STATEMENT:
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
    call newline
    
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
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "push eax"
    call newline
    
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
    call newline
    
LA31:
    
LA32:
    cmp byte [eswitch], 1
    je LA33
    
LA33:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%cmp"
    cmp byte [eswitch], 1
    je LA34
    error_store 'CMP_OPERATOR'
    call vstack_clear
    call CMP_OPERATOR
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA34:
    
LA35:
    cmp byte [eswitch], 1
    je LA36
    
LA36:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%deref/byte"
    cmp byte [eswitch], 1
    je LA37
    error_store 'VALUE'
    call vstack_clear
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, byte [eax]"
    call newline
    
LA37:
    
LA38:
    cmp byte [eswitch], 1
    je LA39
    
LA39:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%deref/word"
    cmp byte [eswitch], 1
    je LA40
    error_store 'VALUE'
    call vstack_clear
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, word [eax]"
    call newline
    
LA40:
    
LA41:
    cmp byte [eswitch], 1
    je LA42
    
LA42:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%deref/dword"
    cmp byte [eswitch], 1
    je LA43
    error_store 'VALUE'
    call vstack_clear
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, dword [eax]"
    call newline
    
LA43:
    
LA44:
    cmp byte [eswitch], 1
    je LA45
    
LA45:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%set"
    cmp byte [eswitch], 1
    je LA46
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
    call newline
    
LA46:
    
LA47:
    cmp byte [eswitch], 1
    je LA48
    
LA48:
    cmp byte [eswitch], 0
    je LA27
    test_input_string "%ret"
    cmp byte [eswitch], 1
    je LA49
    error_store 'VALUE'
    call vstack_clear
    call VALUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA50
    
LA50:
    cmp byte [eswitch], 0
    je LA51
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA52
    
LA52:
    
LA51:
    cmp byte [eswitch], 1
    je terminate_program
    print "mov esp, ebp"
    call newline
    print "pop ebp"
    call newline
    print "ret"
    call newline
    
LA49:
    
LA53:
    cmp byte [eswitch], 1
    je LA54
    
LA54:
    cmp byte [eswitch], 0
    je LA27
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
    call newline
    
LA55:
    
LA56:
    cmp byte [eswitch], 1
    je LA57
    
LA57:
    
LA27:
    ret
    
FUNCTION_CALL_ARGS:
    error_store 'FUNCTION_CALL_ARG'
    call vstack_clear
    call FUNCTION_CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA58
    
LA59:
    test_input_string ","
    cmp byte [eswitch], 1
    je LA60
    error_store 'FUNCTION_CALL_ARG'
    call vstack_clear
    call FUNCTION_CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA60:
    
LA61:
    cmp byte [eswitch], 0
    je LA59
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA58:
    cmp byte [eswitch], 0
    je LA62
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA63
    
LA63:
    
LA62:
    cmp byte [eswitch], 1
    je LA64
    
LA64:
    
LA65:
    ret
    
FUNCTION_CALL_ARG:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA66
    print "mov esi, "
    call copy_last_match
    call newline
    
LA66:
    cmp byte [eswitch], 0
    je LA67
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA68
    call label
    print "section .data"
    call newline
    call gn3
    print " db "
    call copy_last_match
    print ", 0x00"
    call newline
    call label
    print "section .text"
    call newline
    print "mov esi, "
    call gn3
    call newline
    
LA68:
    cmp byte [eswitch], 0
    je LA67
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA69
    print "mov esi, eax"
    call newline
    
LA69:
    cmp byte [eswitch], 0
    je LA67
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA70
    print "mov esi, eax"
    call newline
    
LA70:
    
LA67:
    ret
    
ARITHMETIC_OPERATION_ARGS:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA71
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
    je LA72
    print "mov ebx, "
    call copy_last_match
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    
LA72:
    cmp byte [eswitch], 0
    je LA73
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA74
    
LA74:
    cmp byte [eswitch], 0
    je LA73
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA75
    print "mov ebx, eax"
    call newline
    
LA75:
    
LA73:
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
    call newline
    
LA71:
    
LA76:
    cmp byte [eswitch], 1
    je LA77
    
LA77:
    cmp byte [eswitch], 0
    je LA78
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA79
    test_input_string ","
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA80
    print "mov ebx, "
    call copy_last_match
    call newline
    
LA80:
    cmp byte [eswitch], 0
    je LA81
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA82
    
LA82:
    cmp byte [eswitch], 0
    je LA81
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA83
    print "mov ebx, eax"
    call newline
    
LA83:
    
LA81:
    cmp byte [eswitch], 1
    je terminate_program
    
LA79:
    
LA84:
    cmp byte [eswitch], 1
    je LA85
    
LA85:
    cmp byte [eswitch], 0
    je LA78
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA86
    test_input_string ","
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA87
    print "mov ebx, "
    call copy_last_match
    call newline
    
LA87:
    cmp byte [eswitch], 0
    je LA88
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA89
    
LA89:
    cmp byte [eswitch], 0
    je LA88
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA90
    print "mov ebx, eax"
    call newline
    
LA90:
    
LA88:
    cmp byte [eswitch], 1
    je terminate_program
    
LA86:
    
LA91:
    cmp byte [eswitch], 1
    je LA92
    
LA92:
    
LA78:
    ret
    
SET_INTO:
    print "mov [ebp"
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
    
LA93:
    
LA94:
    ret
    
MOV_INTO:
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
    
LA95:
    
LA96:
    ret
    
TYPE:
    test_input_string "i32"
    cmp byte [eswitch], 1
    je LA97
    
LA97:
    
LA98:
    ret
    
CMP_OPERATOR:
    test_input_string "neq"
    cmp byte [eswitch], 1
    je LA99
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "cmp eax, ebx"
    call newline
    print "mov eax, 0"
    call newline
    print "setne al"
    call newline
    
LA99:
    
LA100:
    cmp byte [eswitch], 1
    je LA101
    
LA101:
    cmp byte [eswitch], 0
    je LA102
    test_input_string "eq"
    cmp byte [eswitch], 1
    je LA103
    
LA103:
    cmp byte [eswitch], 0
    je LA102
    test_input_string "lt"
    cmp byte [eswitch], 1
    je LA104
    
LA104:
    cmp byte [eswitch], 0
    je LA102
    test_input_string "gt"
    cmp byte [eswitch], 1
    je LA105
    
LA105:
    
LA102:
    ret
    
VALUE:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA106
    print "mov eax, "
    call copy_last_match
    call newline
    
LA106:
    cmp byte [eswitch], 0
    je LA107
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA108
    call label
    print "section .data"
    call newline
    call gn3
    print " db "
    call copy_last_match
    print ", 0x00"
    call newline
    call label
    print "section .text"
    call newline
    print "mov eax, "
    call gn3
    call newline
    
LA108:
    cmp byte [eswitch], 0
    je LA107
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA109
    
LA109:
    cmp byte [eswitch], 0
    je LA107
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA110
    
LA110:
    
LA107:
    ret
    
VALUE_EBX:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA111
    print "mov ebx, "
    call copy_last_match
    call newline
    
LA111:
    cmp byte [eswitch], 0
    je LA112
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA113
    call label
    print "section .data"
    call newline
    call gn3
    print " db "
    call copy_last_match
    print ", 0x00"
    call newline
    call label
    print "section .text"
    call newline
    print "mov ebx, "
    call gn3
    call newline
    
LA113:
    cmp byte [eswitch], 0
    je LA112
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA114
    
LA114:
    cmp byte [eswitch], 0
    je LA112
    error_store 'RESULT_SPECIFIER'
    call vstack_clear
    call RESULT_SPECIFIER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA115
    
LA115:
    
LA112:
    ret
    
RESULT_SPECIFIER:
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA116
    
LA116:
    
LA117:
    ret
    
SYMBOL_TABLE_ID:
    error_store 'NAME'
    call vstack_clear
    call NAME
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA118
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, dword [ebp"
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
    
LA118:
    
LA119:
    ret
    
WHILE:
    test_input_string "while"
    cmp byte [eswitch], 1
    je LA120
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA121:
    error_store 'STATEMENT'
    call vstack_clear
    call STATEMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA122
    
LA122:
    
LA123:
    cmp byte [eswitch], 0
    je LA121
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp al, 1"
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    print "jne "
    call gn2
    call newline
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "{"
    cmp byte [eswitch], 1
    je terminate_program
    
LA124:
    error_store 'STATEMENT'
    call vstack_clear
    call STATEMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA125
    
LA125:
    
LA126:
    cmp byte [eswitch], 0
    je LA124
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    print "jmp "
    call gn1
    call newline
    call label
    call gn2
    print ":"
    call newline
    test_input_string "}"
    cmp byte [eswitch], 1
    je terminate_program
    
LA120:
    
LA127:
    ret
    
COMMENT:
    test_input_string "//"
    cmp byte [eswitch], 1
    je LA128
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA128:
    
LA129:
    ret
    
; -- Tokens --
    
PREFIX:
    
LA130:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA131
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA131
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA131
    mov edi, 10
    call test_char_equal
    
LA131:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA130
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA132
    
LA132:
    
LA133:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA134
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA134
    call DIGIT
    cmp byte [eswitch], 1
    je LA134
    
LA135:
    call DIGIT
    cmp byte [eswitch], 0
    je LA135
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA134
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA134
    
LA134:
    
LA136:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA137
    mov edi, 57
    call test_char_less_equal
    
LA137:
    
LA138:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA139
    
LA139:
    
LA140:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA141
    test_input_string "while"
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    cmp byte [eswitch], 1
    je LA141
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA141
    call ALPHA
    cmp byte [eswitch], 1
    je LA141
    
LA142:
    call ALPHA
    cmp byte [eswitch], 1
    je LA143
    
LA143:
    cmp byte [eswitch], 0
    je LA144
    call DIGIT
    cmp byte [eswitch], 1
    je LA145
    
LA145:
    
LA144:
    cmp byte [eswitch], 0
    je LA142
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA141
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA141
    
LA141:
    
LA146:
    ret
    
NAME:
    call PREFIX
    cmp byte [eswitch], 1
    je LA147
    mov edi, 64
    call test_char_equal
    
LA148:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA147
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA147
    call ALPHA
    cmp byte [eswitch], 1
    je LA147
    
LA149:
    call ALPHA
    cmp byte [eswitch], 1
    je LA150
    
LA150:
    cmp byte [eswitch], 0
    je LA151
    call DIGIT
    cmp byte [eswitch], 1
    je LA152
    
LA152:
    
LA151:
    cmp byte [eswitch], 0
    je LA149
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA147
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA147
    
LA147:
    
LA153:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA154
    mov edi, 90
    call test_char_less_equal
    
LA154:
    cmp byte [eswitch], 0
    je LA155
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA155
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA156
    mov edi, 122
    call test_char_less_equal
    
LA156:
    
LA155:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA157
    
LA157:
    
LA158:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA159
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA159
    mov edi, 34
    call test_char_equal
    
LA160:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA159
    
LA161:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA162
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA162
    mov edi, 34
    call test_char_equal
    
LA162:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA161
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA159
    mov edi, 34
    call test_char_equal
    
LA163:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA159
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA159
    
LA159:
    
LA164:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA165
    mov edi, 34
    call test_char_equal
    
LA166:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA165
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
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
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA165
    mov edi, 34
    call test_char_equal
    
LA169:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA165
    
LA165:
    
LA170:
    ret
    
