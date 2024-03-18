
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
    error_store 'PREAMBLE'
    call vstack_clear
    call PREAMBLE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
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
    error_store 'POSTAMBLE'
    call vstack_clear
    call POSTAMBLE
    call vstack_restore
    call error_clear
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
    error_store 'ASMMACRO'
    call vstack_clear
    call ASMMACRO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA13
    
LA13:
    cmp byte [eswitch], 0
    je LA10
    error_store 'WHILE'
    call vstack_clear
    call WHILE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA14
    
LA14:
    cmp byte [eswitch], 0
    je LA10
    error_store 'IF_ELSE'
    call vstack_clear
    call IF_ELSE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA15
    
LA15:
    cmp byte [eswitch], 0
    je LA10
    error_store 'IF'
    call vstack_clear
    call IF
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA16
    
LA16:
    cmp byte [eswitch], 0
    je LA10
    error_store 'ASM'
    call vstack_clear
    call ASM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA17
    
LA17:
    cmp byte [eswitch], 0
    je LA10
    error_store 'MOV'
    call vstack_clear
    call MOV
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA18
    
LA18:
    cmp byte [eswitch], 0
    je LA10
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA19
    
LA19:
    
LA10:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA8:
    
LA7:
    ret
    
PREAMBLE:
    call label
    print "section .text"
    call newline
    print "global _start"
    call newline
    call label
    print "_start:"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    
LA20:
    
LA21:
    ret
    
POSTAMBLE:
    print "mov esp, ebp"
    call newline
    print "pop ebp"
    call newline
    print "mov eax, 1"
    call newline
    print "mov ebx, 0"
    call newline
    print "int 0x80"
    call newline
    
LA22:
    
LA23:
    ret
    
BODY:
    error_store 'COMMENT'
    call vstack_clear
    call COMMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA24
    
LA24:
    cmp byte [eswitch], 0
    je LA25
    test_input_string "["
    cmp byte [eswitch], 1
    je LA26
    error_store 'DEFINE'
    call vstack_clear
    call DEFINE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA27
    
LA27:
    cmp byte [eswitch], 0
    je LA28
    error_store 'SET'
    call vstack_clear
    call SET
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA29
    
LA29:
    cmp byte [eswitch], 0
    je LA28
    error_store 'WHILE'
    call vstack_clear
    call WHILE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA30
    
LA30:
    cmp byte [eswitch], 0
    je LA28
    error_store 'IF_ELSE'
    call vstack_clear
    call IF_ELSE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA31
    
LA31:
    cmp byte [eswitch], 0
    je LA28
    error_store 'IF'
    call vstack_clear
    call IF
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA32
    
LA32:
    cmp byte [eswitch], 0
    je LA28
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA33
    
LA33:
    cmp byte [eswitch], 0
    je LA28
    error_store 'ASM'
    call vstack_clear
    call ASM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA34
    
LA34:
    cmp byte [eswitch], 0
    je LA28
    error_store 'MOV'
    call vstack_clear
    call MOV
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA35
    
LA35:
    cmp byte [eswitch], 0
    je LA28
    error_store 'RETURN'
    call vstack_clear
    call RETURN
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA36
    
LA36:
    cmp byte [eswitch], 0
    je LA28
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA37
    
LA37:
    
LA28:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA26:
    
LA25:
    ret
    
ARITHMETIC:
    test_input_string "+"
    cmp byte [eswitch], 1
    je LA38
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "add eax, ebx"
    call newline
    
LA38:
    cmp byte [eswitch], 0
    je LA39
    test_input_string "-"
    cmp byte [eswitch], 1
    je LA40
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "sub eax, ebx"
    call newline
    
LA40:
    cmp byte [eswitch], 0
    je LA39
    test_input_string "*"
    cmp byte [eswitch], 1
    je LA41
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "imul eax, ebx"
    call newline
    
LA41:
    cmp byte [eswitch], 0
    je LA39
    test_input_string "/"
    cmp byte [eswitch], 1
    je LA42
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "idiv ebx"
    call newline
    
LA42:
    cmp byte [eswitch], 0
    je LA39
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA43
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "idiv ebx"
    call newline
    
LA43:
    cmp byte [eswitch], 0
    je LA39
    test_input_string "=="
    cmp byte [eswitch], 1
    je LA44
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "cmp eax, ebx"
    call newline
    print "mov eax, 0"
    call newline
    print "sete al"
    call newline
    
LA44:
    cmp byte [eswitch], 0
    je LA39
    test_input_string "!="
    cmp byte [eswitch], 1
    je LA45
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
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
    
LA45:
    cmp byte [eswitch], 0
    je LA39
    test_input_string "<"
    cmp byte [eswitch], 1
    je LA46
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "cmp eax, ebx"
    call newline
    print "mov eax, 0"
    call newline
    print "setl al"
    call newline
    
LA46:
    cmp byte [eswitch], 0
    je LA39
    test_input_string ">"
    cmp byte [eswitch], 1
    je LA47
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "pop ebx"
    call newline
    print "pop eax"
    call newline
    print "cmp eax, ebx"
    call newline
    print "mov eax, 0"
    call newline
    print "setg al"
    call newline
    
LA47:
    
LA39:
    cmp byte [eswitch], 1
    je LA48
    
LA48:
    
LA49:
    ret
    
RETURN:
    test_input_string "return"
    cmp byte [eswitch], 1
    je LA50
    error_store 'CALL_ARG'
    call vstack_clear
    call CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov esp, ebp"
    call newline
    print "pop ebp"
    call newline
    print "ret"
    call newline
    
LA50:
    
LA51:
    ret
    
WHILE:
    test_input_string "while"
    cmp byte [eswitch], 1
    je LA52
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn2
    print ":"
    call newline
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA53
    
LA53:
    cmp byte [eswitch], 0
    je LA54
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA55
    
LA55:
    
LA54:
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
    
LA56:
    error_store 'BODY'
    call vstack_clear
    call BODY
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
    je terminate_program
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA52:
    
LA59:
    ret
    
IF:
    test_input_string "if"
    cmp byte [eswitch], 1
    je LA60
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA61
    
LA61:
    cmp byte [eswitch], 0
    je LA62
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA63
    
LA63:
    
LA62:
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
    
LA64:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA64
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA60:
    
LA65:
    ret
    
IF_ELSE:
    test_input_string "if/else"
    cmp byte [eswitch], 1
    je LA66
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA67
    
LA67:
    cmp byte [eswitch], 0
    je LA68
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA69
    
LA69:
    
LA68:
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
    
LA70:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA70
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
    
LA71:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA71
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
    
LA66:
    
LA72:
    ret
    
ASMMACRO:
    test_input_string "asmmacro"
    cmp byte [eswitch], 1
    je LA73
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
    print "jmp "
    call gn1
    call newline
    call label
    call copy_last_match
    print ":"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    
LA74:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA75
    
LA75:
    
LA76:
    cmp byte [eswitch], 0
    je LA74
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA77:
    error_store 'RAW'
    call vstack_clear
    call RAW
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA78
    call copy_last_match
    call newline
    
LA78:
    
LA79:
    cmp byte [eswitch], 0
    je LA77
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
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
    
LA73:
    
LA80:
    ret
    
ASM:
    test_input_string "asm"
    cmp byte [eswitch], 1
    je LA81
    error_store 'RAW'
    call vstack_clear
    call RAW
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    call copy_last_match
    call newline
    
LA81:
    
LA82:
    ret
    
MOV:
    test_input_string "mov"
    cmp byte [eswitch], 1
    je LA83
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
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA84
    
LA84:
    cmp byte [eswitch], 0
    je LA85
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA86
    
LA86:
    cmp byte [eswitch], 0
    je LA85
    test_input_string "["
    cmp byte [eswitch], 1
    je LA87
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA88
    
LA88:
    cmp byte [eswitch], 0
    je LA89
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA90
    
LA90:
    
LA89:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA87:
    
LA85:
    cmp byte [eswitch], 1
    je LA91
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
    
LA91:
    cmp byte [eswitch], 0
    je LA92
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA93
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
    
LA93:
    
LA92:
    cmp byte [eswitch], 1
    je terminate_program
    
LA83:
    
LA94:
    ret
    
DEFINE:
    test_input_string "define"
    cmp byte [eswitch], 1
    je LA95
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
    cmp byte [eswitch], 1
    je terminate_program
    inc dword [fn_arg_num]
    mov edx, dword [fn_arg_num]
    mov edi, symbol_table
    mov esi, last_match
    call hash_set
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA96
    error_store 'MOV_INTO'
    call vstack_clear
    call MOV_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    call copy_last_match
    print " ; define "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA96:
    
LA97:
    cmp byte [eswitch], 1
    je LA98
    
LA98:
    cmp byte [eswitch], 0
    je LA99
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA100
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
    error_store 'MOV_INTO'
    call vstack_clear
    call MOV_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    call gn3
    print " ; define "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA100:
    
LA101:
    cmp byte [eswitch], 1
    je LA102
    
LA102:
    cmp byte [eswitch], 0
    je LA99
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA103
    error_store 'MOV_INTO'
    call vstack_clear
    call MOV_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "eax ; define "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA103:
    
LA104:
    cmp byte [eswitch], 1
    je LA105
    
LA105:
    cmp byte [eswitch], 0
    je LA99
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA106
    error_store 'MOV_INTO'
    call vstack_clear
    call MOV_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "eax ; define "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA106:
    
LA107:
    cmp byte [eswitch], 1
    je LA108
    
LA108:
    cmp byte [eswitch], 0
    je LA99
    test_input_string "["
    cmp byte [eswitch], 1
    je LA109
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA110
    
LA110:
    cmp byte [eswitch], 0
    je LA111
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA112
    
LA112:
    
LA111:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'MOV_INTO'
    call vstack_clear
    call MOV_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "eax ; define "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA109:
    
LA113:
    cmp byte [eswitch], 1
    je LA114
    
LA114:
    
LA99:
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "sub esp, 4"
    call newline
    
LA95:
    
LA115:
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
    
LA116:
    
LA117:
    ret
    
SET:
    test_input_string "set!"
    cmp byte [eswitch], 1
    je LA118
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
    je LA119
    error_store 'SET_INTO'
    call vstack_clear
    call SET_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    call copy_last_match
    print " ; set "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA119:
    
LA120:
    cmp byte [eswitch], 1
    je LA121
    
LA121:
    cmp byte [eswitch], 0
    je LA122
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA123
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
    error_store 'SET_INTO'
    call vstack_clear
    call SET_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    call gn3
    print " ; set "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA123:
    
LA124:
    cmp byte [eswitch], 1
    je LA125
    
LA125:
    cmp byte [eswitch], 0
    je LA122
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA126
    error_store 'SET_INTO'
    call vstack_clear
    call SET_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "eax ; set "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA126:
    
LA127:
    cmp byte [eswitch], 1
    je LA128
    
LA128:
    cmp byte [eswitch], 0
    je LA122
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA129
    error_store 'SET_INTO'
    call vstack_clear
    call SET_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "eax ; set "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA129:
    
LA130:
    cmp byte [eswitch], 1
    je LA131
    
LA131:
    cmp byte [eswitch], 0
    je LA122
    test_input_string "["
    cmp byte [eswitch], 1
    je LA132
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA133
    
LA133:
    cmp byte [eswitch], 0
    je LA134
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA135
    
LA135:
    
LA134:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'SET_INTO'
    call vstack_clear
    call SET_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "eax ; set "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA132:
    
LA136:
    cmp byte [eswitch], 1
    je LA137
    
LA137:
    
LA122:
    cmp byte [eswitch], 1
    je terminate_program
    
LA118:
    
LA138:
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
    
LA139:
    
LA140:
    ret
    
DEREFERENCE:
    test_input_string "&["
    cmp byte [eswitch], 1
    je LA141
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA142
    
LA142:
    cmp byte [eswitch], 0
    je LA143
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA144
    
LA144:
    
LA143:
    cmp byte [eswitch], 1
    je terminate_program
    print "mov eax, [eax]"
    call newline
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA141:
    cmp byte [eswitch], 0
    je LA145
    test_input_string "&1["
    cmp byte [eswitch], 1
    je LA146
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA147
    
LA147:
    cmp byte [eswitch], 0
    je LA148
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA149
    
LA149:
    
LA148:
    cmp byte [eswitch], 1
    je terminate_program
    print "mov ebx, eax"
    call newline
    print "xor eax, eax"
    call newline
    print "mov al, byte [ebx]"
    call newline
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA146:
    cmp byte [eswitch], 0
    je LA145
    test_input_string "&2["
    cmp byte [eswitch], 1
    je LA150
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA151
    
LA151:
    cmp byte [eswitch], 0
    je LA152
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA153
    
LA153:
    
LA152:
    cmp byte [eswitch], 1
    je terminate_program
    print "mov ebx, eax"
    call newline
    print "xor eax, eax"
    call newline
    print "mov ax, word [ebx]"
    call newline
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA150:
    cmp byte [eswitch], 0
    je LA145
    test_input_string "&"
    cmp byte [eswitch], 1
    je LA154
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA155
    print "mov eax, dword [eax]"
    call newline
    
LA155:
    cmp byte [eswitch], 0
    je LA156
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA157
    print "mov eax, dword [eax]"
    call newline
    
LA157:
    
LA156:
    cmp byte [eswitch], 1
    je terminate_program
    
LA154:
    
LA145:
    ret
    
DEFUNC:
    test_input_string "defunc"
    cmp byte [eswitch], 1
    je LA158
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
    print "jmp "
    call gn1
    call newline
    call label
    call copy_last_match
    print ":"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    mov dword [fn_arg_num], 0
    
LA159:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA160
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    inc dword [fn_arg_count] ; found new argument!
    inc dword [fn_arg_num]
    mov edx, dword [fn_arg_num]
    mov edi, symbol_table
    mov esi, last_match
    call hash_set
    
LA160:
    
LA161:
    cmp byte [eswitch], 0
    je LA159
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    add dword [fn_arg_num], 2
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA162:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA163
    
LA163:
    
LA164:
    cmp byte [eswitch], 0
    je LA162
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    mov dword [fn_arg_count], 0
    mov dword [fn_arg_num], 0
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
    
LA158:
    
LA165:
    ret
    
FUNC_CALL:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA166
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
    print "call "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA166:
    
LA167:
    ret
    
CALL_ARGS:
    
LA168:
    error_store 'CALL_ARG'
    call vstack_clear
    call CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA169
    
LA169:
    
LA170:
    cmp byte [eswitch], 0
    je LA168
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA171
    
LA171:
    
LA172:
    ret
    
CALL_ARG:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA173
    print "push "
    call copy_last_match
    call newline
    
LA173:
    
LA174:
    cmp byte [eswitch], 1
    je LA175
    
LA175:
    cmp byte [eswitch], 0
    je LA176
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA177
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
    print "push "
    call gn3
    call newline
    
LA177:
    
LA178:
    cmp byte [eswitch], 1
    je LA179
    
LA179:
    cmp byte [eswitch], 0
    je LA176
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA180
    print "push eax"
    call newline
    
LA180:
    cmp byte [eswitch], 0
    je LA176
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA181
    print "push eax"
    call newline
    
LA181:
    cmp byte [eswitch], 0
    je LA176
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
    print "push eax"
    call newline
    
LA182:
    
LA176:
    ret
    
SYMBOL_TABLE_ID:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA186
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
    
LA186:
    
LA187:
    ret
    
COMMENT:
    test_input_string "//"
    cmp byte [eswitch], 1
    je LA188
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA188:
    
LA189:
    ret
    
; -- Tokens --
    
PREFIX:
    
LA190:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA191
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA191
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA191
    mov edi, 10
    call test_char_equal
    
LA191:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA190
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA192
    
LA192:
    
LA193:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA194
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA194
    call DIGIT
    cmp byte [eswitch], 1
    je LA194
    
LA195:
    call DIGIT
    cmp byte [eswitch], 0
    je LA195
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA194
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA194
    
LA194:
    
LA196:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA197
    mov edi, 57
    call test_char_less_equal
    
LA197:
    
LA198:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA199
    
LA199:
    
LA200:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA201
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA201
    call ALPHA
    cmp byte [eswitch], 1
    je LA201
    
LA202:
    call ALPHA
    cmp byte [eswitch], 1
    je LA203
    
LA203:
    cmp byte [eswitch], 0
    je LA204
    call DIGIT
    cmp byte [eswitch], 1
    je LA205
    
LA205:
    
LA204:
    cmp byte [eswitch], 0
    je LA202
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA201
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA201
    
LA201:
    
LA206:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA207
    mov edi, 90
    call test_char_less_equal
    
LA207:
    cmp byte [eswitch], 0
    je LA208
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA208
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA209
    mov edi, 122
    call test_char_less_equal
    
LA209:
    
LA208:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA210
    
LA210:
    
LA211:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA212
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA212
    mov edi, 34
    call test_char_equal
    
LA213:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA212
    
LA214:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA215
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA215
    mov edi, 34
    call test_char_equal
    
LA215:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA214
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA212
    mov edi, 34
    call test_char_equal
    
LA216:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA212
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA212
    
LA212:
    
LA217:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA218
    mov edi, 34
    call test_char_equal
    
LA219:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA218
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA218
    
LA220:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA221
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA221
    mov edi, 34
    call test_char_equal
    
LA221:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA220
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA218
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA218
    mov edi, 34
    call test_char_equal
    
LA222:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA218
    
LA218:
    
LA223:
    ret
    
