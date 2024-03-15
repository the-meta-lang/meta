
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
    call LISP
    pop ebp
    mov edi, outbuff
    call print_mm32
    mov eax, 1
    mov ebx, 0
    int 0x80
    
LISP:
    section .data
    fn_arg_count dd 0
    fn_arg_num dd 0
    section .bss
    symbol_table resb 262144
    section .text
    
LA1:
    error_store 'ROOT_BODY'
    call vstack_clear
    call ROOT_BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA2
    
LA2:
    
LA3:
    cmp byte [eswitch], 0
    je LA1
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA4:
    
LA5:
    ret
    
ROOT_BODY:
    error_store 'COMMENT'
    call vstack_clear
    call COMMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA6
    
LA6:
    cmp byte [eswitch], 0
    je LA7
    test_input_string "["
    cmp byte [eswitch], 1
    je LA8
    error_store 'DEFUNC'
    call vstack_clear
    call DEFUNC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA9
    
LA9:
    cmp byte [eswitch], 0
    je LA10
    error_store 'DEFINE'
    call vstack_clear
    call DEFINE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA11
    
LA11:
    cmp byte [eswitch], 0
    je LA10
    error_store 'SET'
    call vstack_clear
    call SET
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA12
    
LA12:
    cmp byte [eswitch], 0
    je LA10
    error_store 'WHILE'
    call vstack_clear
    call WHILE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA13
    
LA13:
    cmp byte [eswitch], 0
    je LA10
    error_store 'IF_ELSE'
    call vstack_clear
    call IF_ELSE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA14
    
LA14:
    cmp byte [eswitch], 0
    je LA10
    error_store 'IF'
    call vstack_clear
    call IF
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA15
    
LA15:
    cmp byte [eswitch], 0
    je LA10
    error_store 'ASM'
    call vstack_clear
    call ASM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA16
    
LA16:
    cmp byte [eswitch], 0
    je LA10
    error_store 'MOV'
    call vstack_clear
    call MOV
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA17
    
LA17:
    cmp byte [eswitch], 0
    je LA10
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA18
    
LA18:
    
LA10:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA8:
    
LA7:
    ret
    
BODY:
    error_store 'COMMENT'
    call vstack_clear
    call COMMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA19
    
LA19:
    cmp byte [eswitch], 0
    je LA20
    test_input_string "["
    cmp byte [eswitch], 1
    je LA21
    error_store 'DEFINE'
    call vstack_clear
    call DEFINE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA22
    
LA22:
    cmp byte [eswitch], 0
    je LA23
    error_store 'SET'
    call vstack_clear
    call SET
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA24
    
LA24:
    cmp byte [eswitch], 0
    je LA23
    error_store 'WHILE'
    call vstack_clear
    call WHILE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA25
    
LA25:
    cmp byte [eswitch], 0
    je LA23
    error_store 'IF_ELSE'
    call vstack_clear
    call IF_ELSE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA26
    
LA26:
    cmp byte [eswitch], 0
    je LA23
    error_store 'IF'
    call vstack_clear
    call IF
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA27
    
LA27:
    cmp byte [eswitch], 0
    je LA23
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA28
    
LA28:
    cmp byte [eswitch], 0
    je LA23
    error_store 'ASM'
    call vstack_clear
    call ASM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA29
    
LA29:
    cmp byte [eswitch], 0
    je LA23
    error_store 'MOV'
    call vstack_clear
    call MOV
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA30
    
LA30:
    cmp byte [eswitch], 0
    je LA23
    error_store 'RETURN'
    call vstack_clear
    call RETURN
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA31
    
LA31:
    cmp byte [eswitch], 0
    je LA23
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA32
    
LA32:
    
LA23:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA21:
    
LA20:
    ret
    
ARITHMETIC:
    test_input_string "+"
    cmp byte [eswitch], 1
    je LA33
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA33:
    cmp byte [eswitch], 0
    je LA34
    test_input_string "-"
    cmp byte [eswitch], 1
    je LA35
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%stack sub"
    call newline
    
LA35:
    cmp byte [eswitch], 0
    je LA34
    test_input_string "*"
    cmp byte [eswitch], 1
    je LA36
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%stack imul"
    call newline
    
LA36:
    cmp byte [eswitch], 0
    je LA34
    test_input_string "/"
    cmp byte [eswitch], 1
    je LA37
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%stack idiv"
    call newline
    
LA37:
    cmp byte [eswitch], 0
    je LA34
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA38
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%stack mod"
    call newline
    
LA38:
    cmp byte [eswitch], 0
    je LA34
    test_input_string "=="
    cmp byte [eswitch], 1
    je LA39
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%stack cmp eq"
    call newline
    
LA39:
    cmp byte [eswitch], 0
    je LA34
    test_input_string "!="
    cmp byte [eswitch], 1
    je LA40
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%stack cmp neq"
    call newline
    
LA40:
    cmp byte [eswitch], 0
    je LA34
    test_input_string "<"
    cmp byte [eswitch], 1
    je LA41
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%stack cmp lt"
    call newline
    
LA41:
    cmp byte [eswitch], 0
    je LA34
    test_input_string ">"
    cmp byte [eswitch], 1
    je LA42
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%stack cmp gt"
    call newline
    
LA42:
    
LA34:
    cmp byte [eswitch], 1
    je LA43
    
LA43:
    
LA44:
    ret
    
ARITHMETIC_ARGS:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA45
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA46
    print "%add "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", "
    call copy_last_match
    call newline
    
LA46:
    cmp byte [eswitch], 0
    je LA47
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA48
    print "%add "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", @"
    call copy_last_match
    call newline
    
LA48:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "["
    cmp byte [eswitch], 1
    je LA49
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA50
    
LA50:
    cmp byte [eswitch], 0
    je LA51
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA52
    
LA52:
    
LA51:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    print "%add "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", $"
    call newline
    
LA49:
    cmp byte [eswitch], 0
    je LA47
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA53
    print "%add "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", $"
    call newline
    
LA53:
    cmp byte [eswitch], 0
    je LA47
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA54
    print "%add "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", "
    call copy_last_match
    call newline
    
LA54:
    
LA47:
    cmp byte [eswitch], 1
    je terminate_program
    
LA45:
    
LA55:
    cmp byte [eswitch], 1
    je LA56
    
LA56:
    cmp byte [eswitch], 0
    je LA57
    test_input_string "["
    cmp byte [eswitch], 1
    je LA58
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA59
    
LA59:
    cmp byte [eswitch], 0
    je LA60
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA61
    
LA61:
    
LA60:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA62
    print "%add $, "
    call copy_last_match
    call newline
    
LA62:
    cmp byte [eswitch], 0
    je LA63
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA64
    print "%add $, @"
    call copy_last_match
    call newline
    
LA64:
    cmp byte [eswitch], 0
    je LA63
    test_input_string "["
    cmp byte [eswitch], 1
    je LA65
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA66
    
LA66:
    cmp byte [eswitch], 0
    je LA67
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA68
    
LA68:
    
LA67:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    print "%add $, $"
    call newline
    
LA65:
    cmp byte [eswitch], 0
    je LA63
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA69
    print "%add $, $"
    call newline
    
LA69:
    cmp byte [eswitch], 0
    je LA63
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA70
    print "%add $, "
    call copy_last_match
    call newline
    
LA70:
    
LA63:
    cmp byte [eswitch], 1
    je terminate_program
    
LA58:
    
LA71:
    cmp byte [eswitch], 1
    je LA72
    
LA72:
    cmp byte [eswitch], 0
    je LA57
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA73
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA74
    print "%add @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", "
    call copy_last_match
    call newline
    
LA74:
    cmp byte [eswitch], 0
    je LA75
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA76
    print "%add @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", @"
    call copy_last_match
    call newline
    
LA76:
    cmp byte [eswitch], 0
    je LA75
    test_input_string "["
    cmp byte [eswitch], 1
    je LA77
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA78
    
LA78:
    cmp byte [eswitch], 0
    je LA79
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA80
    
LA80:
    
LA79:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    print "%add @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", $"
    call newline
    
LA77:
    cmp byte [eswitch], 0
    je LA75
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA81
    print "%add @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", $"
    call newline
    
LA81:
    cmp byte [eswitch], 0
    je LA75
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA82
    print "%add @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", "
    call copy_last_match
    call newline
    
LA82:
    
LA75:
    cmp byte [eswitch], 1
    je terminate_program
    
LA73:
    
LA83:
    cmp byte [eswitch], 1
    je LA84
    
LA84:
    cmp byte [eswitch], 0
    je LA57
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA85
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA86
    print "%add $, "
    call copy_last_match
    call newline
    
LA86:
    cmp byte [eswitch], 0
    je LA87
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA88
    print "%add $, @"
    call copy_last_match
    call newline
    
LA88:
    cmp byte [eswitch], 0
    je LA87
    test_input_string "["
    cmp byte [eswitch], 1
    je LA89
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA90
    
LA90:
    cmp byte [eswitch], 0
    je LA91
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA92
    
LA92:
    
LA91:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    print "%add $, $"
    call newline
    
LA89:
    cmp byte [eswitch], 0
    je LA87
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA93
    print "%add $, $"
    call newline
    
LA93:
    cmp byte [eswitch], 0
    je LA87
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA94
    print "%add $, "
    call copy_last_match
    call newline
    
LA94:
    
LA87:
    cmp byte [eswitch], 1
    je terminate_program
    
LA85:
    
LA95:
    cmp byte [eswitch], 1
    je LA96
    
LA96:
    
LA57:
    ret
    
RETURN:
    test_input_string "return"
    cmp byte [eswitch], 1
    je LA97
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA98
    print "%ret "
    call copy_last_match
    call newline
    
LA98:
    
LA99:
    cmp byte [eswitch], 1
    je LA100
    
LA100:
    cmp byte [eswitch], 0
    je LA101
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA102
    print "%ret "
    call copy_last_match
    call newline
    
LA102:
    
LA103:
    cmp byte [eswitch], 1
    je LA104
    
LA104:
    cmp byte [eswitch], 0
    je LA101
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA105
    print "%ret @"
    call copy_last_match
    call newline
    
LA105:
    cmp byte [eswitch], 0
    je LA101
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA106
    print "%ret $"
    call newline
    
LA106:
    cmp byte [eswitch], 0
    je LA101
    test_input_string "["
    cmp byte [eswitch], 1
    je LA107
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA108
    
LA108:
    cmp byte [eswitch], 0
    je LA109
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA110
    
LA110:
    
LA109:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    print "%ret $"
    call newline
    
LA107:
    
LA101:
    cmp byte [eswitch], 1
    je terminate_program
    
LA97:
    
LA111:
    ret
    
WHILE:
    test_input_string "while"
    cmp byte [eswitch], 1
    je LA112
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "while ("
    call newline
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA113
    
LA113:
    cmp byte [eswitch], 0
    je LA114
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA115
    
LA115:
    
LA114:
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print ") {"
    call newline
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA116:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA117
    
LA117:
    
LA118:
    cmp byte [eswitch], 0
    je LA116
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "}"
    call newline
    
LA112:
    
LA119:
    ret
    
IF:
    test_input_string "if"
    cmp byte [eswitch], 1
    je LA120
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "if {"
    call newline
    call label
    print ".cond {"
    call newline
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA121
    
LA121:
    cmp byte [eswitch], 0
    je LA122
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA123
    
LA123:
    
LA122:
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "}"
    call newline
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print ".body {"
    call newline
    
LA124:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA124
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "}"
    call newline
    call label
    print "}"
    call newline
    
LA120:
    
LA125:
    ret
    
IF_ELSE:
    test_input_string "if/else"
    cmp byte [eswitch], 1
    je LA126
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA127
    
LA127:
    cmp byte [eswitch], 0
    je LA128
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA129
    
LA129:
    
LA128:
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp eax, 1"
    call newline
    print "jne "
    call gn1
    call newline
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    
LA130:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA130
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    
LA131:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA131
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn2
    print ":"
    call newline
    
LA126:
    
LA132:
    ret
    
ASM:
    test_input_string "asm"
    cmp byte [eswitch], 1
    je LA133
    error_store 'RAW'
    call vstack_clear
    call RAW
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    call copy_last_match
    call newline
    
LA133:
    
LA134:
    ret
    
MOV:
    test_input_string "mov"
    cmp byte [eswitch], 1
    je LA135
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA136
    
LA136:
    cmp byte [eswitch], 0
    je LA137
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA138
    
LA138:
    cmp byte [eswitch], 0
    je LA137
    test_input_string "["
    cmp byte [eswitch], 1
    je LA139
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA140
    
LA140:
    cmp byte [eswitch], 0
    je LA141
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA142
    
LA142:
    
LA141:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA139:
    
LA137:
    cmp byte [eswitch], 1
    je LA143
    print "mov "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", eax"
    call newline
    
LA143:
    cmp byte [eswitch], 0
    je LA144
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA145
    print "mov "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", "
    call copy_last_match
    call newline
    
LA145:
    
LA144:
    cmp byte [eswitch], 1
    je terminate_program
    
LA135:
    
LA146:
    ret
    
DEFINE:
    test_input_string "define"
    cmp byte [eswitch], 1
    je LA147
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA148
    print "%var i32 @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", "
    call copy_last_match
    call newline
    
LA148:
    
LA149:
    cmp byte [eswitch], 1
    je LA150
    
LA150:
    cmp byte [eswitch], 0
    je LA151
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA152
    print "%var i32 @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", "
    call copy_last_match
    call newline
    
LA152:
    
LA153:
    cmp byte [eswitch], 1
    je LA154
    
LA154:
    cmp byte [eswitch], 0
    je LA151
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA155
    print "%var i32 @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", @"
    call copy_last_match
    call newline
    
LA155:
    
LA156:
    cmp byte [eswitch], 1
    je LA157
    
LA157:
    cmp byte [eswitch], 0
    je LA151
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA158
    print "%var i32 @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", $"
    call newline
    
LA158:
    
LA159:
    cmp byte [eswitch], 1
    je LA160
    
LA160:
    cmp byte [eswitch], 0
    je LA151
    test_input_string "["
    cmp byte [eswitch], 1
    je LA161
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA162
    
LA162:
    cmp byte [eswitch], 0
    je LA163
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA164
    
LA164:
    
LA163:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    print "%var i32 @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", $"
    call newline
    
LA161:
    
LA165:
    cmp byte [eswitch], 1
    je LA166
    
LA166:
    
LA151:
    cmp byte [eswitch], 1
    je terminate_program
    
LA147:
    
LA167:
    ret
    
SET:
    test_input_string "set!"
    cmp byte [eswitch], 1
    je LA168
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA169
    print "%set @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", "
    call copy_last_match
    call newline
    
LA169:
    
LA170:
    cmp byte [eswitch], 1
    je LA171
    
LA171:
    cmp byte [eswitch], 0
    je LA172
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA173
    print "%set @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", "
    call copy_last_match
    call newline
    
LA173:
    
LA174:
    cmp byte [eswitch], 1
    je LA175
    
LA175:
    cmp byte [eswitch], 0
    je LA172
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA176
    print "%set @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", @"
    call copy_last_match
    call newline
    
LA176:
    
LA177:
    cmp byte [eswitch], 1
    je LA178
    
LA178:
    cmp byte [eswitch], 0
    je LA172
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA179
    print "%set @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", $"
    call newline
    
LA179:
    
LA180:
    cmp byte [eswitch], 1
    je LA181
    
LA181:
    cmp byte [eswitch], 0
    je LA172
    test_input_string "["
    cmp byte [eswitch], 1
    je LA182
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA183
    
LA183:
    cmp byte [eswitch], 0
    je LA184
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA185
    
LA185:
    
LA184:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    print "%set @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", $"
    call newline
    
LA182:
    
LA186:
    cmp byte [eswitch], 1
    je LA187
    
LA187:
    
LA172:
    cmp byte [eswitch], 1
    je terminate_program
    
LA168:
    
LA188:
    ret
    
DEREFERENCE:
    test_input_string "&["
    cmp byte [eswitch], 1
    je LA189
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA190
    
LA190:
    cmp byte [eswitch], 0
    je LA191
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA192
    
LA192:
    
LA191:
    cmp byte [eswitch], 1
    je terminate_program
    print "%deref/dword $"
    call newline
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA189:
    cmp byte [eswitch], 0
    je LA193
    test_input_string "&1["
    cmp byte [eswitch], 1
    je LA194
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA195
    
LA195:
    cmp byte [eswitch], 0
    je LA196
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA197
    
LA197:
    
LA196:
    cmp byte [eswitch], 1
    je terminate_program
    print "%deref/byte $"
    call newline
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA194:
    cmp byte [eswitch], 0
    je LA193
    test_input_string "&2["
    cmp byte [eswitch], 1
    je LA198
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA199
    
LA199:
    cmp byte [eswitch], 0
    je LA200
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA201
    
LA201:
    
LA200:
    cmp byte [eswitch], 1
    je terminate_program
    print "%deref/word $"
    call newline
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA198:
    cmp byte [eswitch], 0
    je LA193
    test_input_string "&"
    cmp byte [eswitch], 1
    je LA202
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA203
    print "%deref/dword @"
    call copy_last_match
    call newline
    
LA203:
    cmp byte [eswitch], 0
    je LA204
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA205
    print "%deref/dword $"
    call newline
    
LA205:
    
LA204:
    cmp byte [eswitch], 1
    je terminate_program
    
LA202:
    
LA193:
    ret
    
DEFUNC:
    test_input_string "defunc"
    cmp byte [eswitch], 1
    je LA206
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "fn "
    call copy_last_match
    print "("
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    
LA207:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA208
    print "i32 @"
    call copy_last_match
    print ""
    
LA208:
    
LA209:
    cmp byte [eswitch], 1
    je LA210
    
LA211:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA212
    print ", "
    print "i32 @"
    call copy_last_match
    
LA212:
    
LA213:
    cmp byte [eswitch], 0
    je LA211
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA214
    
LA214:
    cmp byte [eswitch], 0
    je LA215
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA216
    
LA216:
    
LA215:
    cmp byte [eswitch], 1
    je terminate_program
    
LA210:
    
LA217:
    cmp byte [eswitch], 0
    je LA207
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    print ") {"
    call newline
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA218:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA219
    
LA219:
    
LA220:
    cmp byte [eswitch], 0
    je LA218
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    print "%ret"
    call newline
    call label
    print "}"
    call newline
    
LA206:
    
LA221:
    ret
    
FUNC_CALL:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA222
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "call @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA222:
    
LA223:
    ret
    
CALL_ARGS:
    
LA224:
    error_store 'CALL_ARG'
    call vstack_clear
    call CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA225
    
LA225:
    
LA226:
    cmp byte [eswitch], 0
    je LA224
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA227
    
LA227:
    
LA228:
    ret
    
CALL_ARG:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA229
    print "%callarg "
    call copy_last_match
    call newline
    
LA229:
    
LA230:
    cmp byte [eswitch], 1
    je LA231
    
LA231:
    cmp byte [eswitch], 0
    je LA232
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA233
    print "%callarg "
    call copy_last_match
    call newline
    
LA233:
    
LA234:
    cmp byte [eswitch], 1
    je LA235
    
LA235:
    cmp byte [eswitch], 0
    je LA232
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA236
    print "%callarg @"
    call copy_last_match
    call newline
    
LA236:
    cmp byte [eswitch], 0
    je LA232
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA237
    print "%callarg $"
    call newline
    
LA237:
    cmp byte [eswitch], 0
    je LA232
    test_input_string "["
    cmp byte [eswitch], 1
    je LA238
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA239
    
LA239:
    cmp byte [eswitch], 0
    je LA240
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA241
    
LA241:
    
LA240:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    print "%callarg $"
    call newline
    
LA238:
    
LA232:
    ret
    
COMMENT:
    test_input_string "//"
    cmp byte [eswitch], 1
    je LA242
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA242:
    
LA243:
    ret
    
; -- Tokens --
    
PREFIX:
    
LA244:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA245
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA245
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA245
    mov edi, 10
    call test_char_equal
    
LA245:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA244
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA246
    
LA246:
    
LA247:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA248
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA248
    call DIGIT
    cmp byte [eswitch], 1
    je LA248
    
LA249:
    call DIGIT
    cmp byte [eswitch], 0
    je LA249
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA248
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA248
    
LA248:
    
LA250:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA251
    mov edi, 57
    call test_char_less_equal
    
LA251:
    
LA252:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA253
    
LA253:
    
LA254:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA255
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA255
    call ALPHA
    cmp byte [eswitch], 1
    je LA255
    
LA256:
    call ALPHA
    cmp byte [eswitch], 1
    je LA257
    
LA257:
    cmp byte [eswitch], 0
    je LA258
    call DIGIT
    cmp byte [eswitch], 1
    je LA259
    
LA259:
    
LA258:
    cmp byte [eswitch], 0
    je LA256
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA255
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA255
    
LA255:
    
LA260:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA261
    mov edi, 90
    call test_char_less_equal
    
LA261:
    cmp byte [eswitch], 0
    je LA262
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA262
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA263
    mov edi, 122
    call test_char_less_equal
    
LA263:
    
LA262:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA264
    
LA264:
    
LA265:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA266
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA266
    mov edi, 34
    call test_char_equal
    
LA267:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA266
    
LA268:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA269
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA269
    mov edi, 34
    call test_char_equal
    
LA269:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA268
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA266
    mov edi, 34
    call test_char_equal
    
LA270:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA266
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA266
    
LA266:
    
LA271:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA272
    mov edi, 34
    call test_char_equal
    
LA273:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA272
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA272
    
LA274:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA275
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA275
    mov edi, 34
    call test_char_equal
    
LA275:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA274
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA272
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA272
    mov edi, 34
    call test_char_equal
    
LA276:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA272
    
LA272:
    
LA277:
    ret
    
