
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
    push ebp
    mov ebp, esp
    push esi
    section .data
    cmp byte [eswitch], 1
    jne LOOP_0
    cmp byte [backtrack_switch], 1
    je LA1
    jmp terminate_program
LOOP_0:
    used_arg_count dd 0
    push_prefix db 'push dword [ebp', 0x00
    push_prefix_global db 'push dword [', 0x00
    fn_arg_num dd 0
    cmp byte [eswitch], 1
    jne LOOP_1
    cmp byte [backtrack_switch], 1
    je LA1
    jmp terminate_program
LOOP_1:
    is_global db 1
    loop_counter dd 0
    section .bss
    push_buffer resb 128
    symbol_table resb 262144
    section .text
    error_store 'PREAMBLE'
    call vstack_clear
    call PREAMBLE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_2
    cmp byte [backtrack_switch], 1
    je LA1
    jmp terminate_program
LOOP_2:
    
LA2:
    error_store 'ROOT_BODY'
    call vstack_clear
    call ROOT_BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA3
    
LA3:
    
LA4:
    cmp byte [eswitch], 0
    je LA2
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_3
    cmp byte [backtrack_switch], 1
    je LA1
    jmp terminate_program
LOOP_3:
    error_store 'POSTAMBLE'
    call vstack_clear
    call POSTAMBLE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_4
    cmp byte [backtrack_switch], 1
    je LA1
    jmp terminate_program
LOOP_4:
    
LA1:
    
LA5:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
ROOT_BODY:
    push ebp
    mov ebp, esp
    push esi
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
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA17
    
LA17:
    cmp byte [eswitch], 0
    je LA10
    error_store 'ASM'
    call vstack_clear
    call ASM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA18
    
LA18:
    cmp byte [eswitch], 0
    je LA10
    error_store 'MOV'
    call vstack_clear
    call MOV
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA19
    
LA19:
    cmp byte [eswitch], 0
    je LA10
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA20
    
LA20:
    
LA10:
    cmp byte [eswitch], 1
    jne LOOP_5
    cmp byte [backtrack_switch], 1
    je LA8
    jmp terminate_program
LOOP_5:
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_6
    cmp byte [backtrack_switch], 1
    je LA8
    jmp terminate_program
LOOP_6:
    
LA8:
    
LA7:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
PREAMBLE:
    push ebp
    mov ebp, esp
    push esi
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
    print "push ebp"
    print 0x0A
    print '    '
    print "mov ebp, esp"
    print 0x0A
    print '    '
    
LA21:
    
LA22:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
POSTAMBLE:
    push ebp
    mov ebp, esp
    push esi
    print "mov esp, ebp"
    print 0x0A
    print '    '
    print "pop ebp"
    print 0x0A
    print '    '
    print "mov ebx, eax"
    print 0x0A
    print '    '
    print "mov eax, 1"
    print 0x0A
    print '    '
    print "int 0x80"
    print 0x0A
    print '    '
    
LA23:
    
LA24:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
BODY:
    push ebp
    mov ebp, esp
    push esi
    error_store 'COMMENT'
    call vstack_clear
    call COMMENT
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA25
    
LA25:
    cmp byte [eswitch], 0
    je LA26
    test_input_string "["
    cmp byte [eswitch], 1
    je LA27
    error_store 'DEFINE'
    call vstack_clear
    call DEFINE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA28
    
LA28:
    cmp byte [eswitch], 0
    je LA29
    error_store 'SET'
    call vstack_clear
    call SET
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA30
    
LA30:
    cmp byte [eswitch], 0
    je LA29
    error_store 'WHILE'
    call vstack_clear
    call WHILE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA31
    
LA31:
    cmp byte [eswitch], 0
    je LA29
    error_store 'IF_ELSE'
    call vstack_clear
    call IF_ELSE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA32
    
LA32:
    cmp byte [eswitch], 0
    je LA29
    error_store 'IF'
    call vstack_clear
    call IF
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA33
    
LA33:
    cmp byte [eswitch], 0
    je LA29
    error_store 'CONTINUE'
    call vstack_clear
    call CONTINUE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA34
    
LA34:
    cmp byte [eswitch], 0
    je LA29
    error_store 'BREAK'
    call vstack_clear
    call BREAK
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA35
    
LA35:
    cmp byte [eswitch], 0
    je LA29
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA36
    
LA36:
    cmp byte [eswitch], 0
    je LA29
    error_store 'ASM'
    call vstack_clear
    call ASM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA37
    
LA37:
    cmp byte [eswitch], 0
    je LA29
    error_store 'MOV'
    call vstack_clear
    call MOV
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA38
    
LA38:
    cmp byte [eswitch], 0
    je LA29
    error_store 'RETURN'
    call vstack_clear
    call RETURN
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA39
    
LA39:
    cmp byte [eswitch], 0
    je LA29
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA40
    
LA40:
    cmp byte [eswitch], 0
    je LA29
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA41
    
LA41:
    
LA29:
    cmp byte [eswitch], 1
    jne LOOP_7
    cmp byte [backtrack_switch], 1
    je LA27
    jmp terminate_program
LOOP_7:
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_8
    cmp byte [backtrack_switch], 1
    je LA27
    jmp terminate_program
LOOP_8:
    
LA27:
    
LA26:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
CONTINUE:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "continue"
    cmp byte [eswitch], 1
    je LA42
    print "jmp "
    call gn2
    print 0x0A
    print '    '
    
LA42:
    
LA43:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
BREAK:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "break"
    cmp byte [eswitch], 1
    je LA44
    print "jmp "
    call gn1
    print 0x0A
    print '    '
    
LA44:
    
LA45:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
ARITHMETIC:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "+"
    cmp byte [eswitch], 1
    je LA46
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_9
    cmp byte [backtrack_switch], 1
    je LA46
    jmp terminate_program
LOOP_9:
    print "add eax, ebx"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA46:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "-"
    cmp byte [eswitch], 1
    je LA48
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_10
    cmp byte [backtrack_switch], 1
    je LA48
    jmp terminate_program
LOOP_10:
    print "sub eax, ebx"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA48:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "*"
    cmp byte [eswitch], 1
    je LA49
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_11
    cmp byte [backtrack_switch], 1
    je LA49
    jmp terminate_program
LOOP_11:
    print "imul eax, ebx"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA49:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "/"
    cmp byte [eswitch], 1
    je LA50
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_12
    cmp byte [backtrack_switch], 1
    je LA50
    jmp terminate_program
LOOP_12:
    print "xor edx, edx"
    print 0x0A
    print '    '
    print "div ebx"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_13
    cmp byte [backtrack_switch], 1
    je LA50
    jmp terminate_program
LOOP_13:
    
LA50:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA51
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_14
    cmp byte [backtrack_switch], 1
    je LA51
    jmp terminate_program
LOOP_14:
    print "xor edx, edx"
    print 0x0A
    print '    '
    print "div ebx"
    print 0x0A
    print '    '
    print "mov eax, edx"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA51:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "and"
    cmp byte [eswitch], 1
    je LA52
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_15
    cmp byte [backtrack_switch], 1
    je LA52
    jmp terminate_program
LOOP_15:
    print "and eax, ebx"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA52:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "or"
    cmp byte [eswitch], 1
    je LA53
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_16
    cmp byte [backtrack_switch], 1
    je LA53
    jmp terminate_program
LOOP_16:
    print "or eax, ebx"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA53:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "not"
    cmp byte [eswitch], 1
    je LA54
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_17
    cmp byte [backtrack_switch], 1
    je LA54
    jmp terminate_program
LOOP_17:
    print "not eax"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA54:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "<="
    cmp byte [eswitch], 1
    je LA55
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_18
    cmp byte [backtrack_switch], 1
    je LA55
    jmp terminate_program
LOOP_18:
    print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "setle al"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA55:
    cmp byte [eswitch], 0
    je LA47
    test_input_string ">="
    cmp byte [eswitch], 1
    je LA56
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_19
    cmp byte [backtrack_switch], 1
    je LA56
    jmp terminate_program
LOOP_19:
    print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "setge al"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA56:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "=="
    cmp byte [eswitch], 1
    je LA57
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_20
    cmp byte [backtrack_switch], 1
    je LA57
    jmp terminate_program
LOOP_20:
    print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "sete al"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA57:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "!="
    cmp byte [eswitch], 1
    je LA58
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_21
    cmp byte [backtrack_switch], 1
    je LA58
    jmp terminate_program
LOOP_21:
    print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "setne al"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_22
    cmp byte [backtrack_switch], 1
    je LA58
    jmp terminate_program
LOOP_22:
    
LA58:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "<<"
    cmp byte [eswitch], 1
    je LA59
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_23
    cmp byte [backtrack_switch], 1
    je LA59
    jmp terminate_program
LOOP_23:
    print "mov ecx, ebx"
    print 0x0A
    print '    '
    print "shl eax, cl"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_24
    cmp byte [backtrack_switch], 1
    je LA59
    jmp terminate_program
LOOP_24:
    
LA59:
    cmp byte [eswitch], 0
    je LA47
    test_input_string ">>"
    cmp byte [eswitch], 1
    je LA60
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_25
    cmp byte [backtrack_switch], 1
    je LA60
    jmp terminate_program
LOOP_25:
    print "mov ecx, ebx"
    print 0x0A
    print '    '
    print "shr eax, cl"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    cmp byte [eswitch], 1
    jne LOOP_26
    cmp byte [backtrack_switch], 1
    je LA60
    jmp terminate_program
LOOP_26:
    
LA60:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "^"
    cmp byte [eswitch], 1
    je LA61
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_27
    cmp byte [backtrack_switch], 1
    je LA61
    jmp terminate_program
LOOP_27:
    print "xor eax, ebx"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA61:
    cmp byte [eswitch], 0
    je LA47
    test_input_string "<"
    cmp byte [eswitch], 1
    je LA62
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_28
    cmp byte [backtrack_switch], 1
    je LA62
    jmp terminate_program
LOOP_28:
    print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "setl al"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA62:
    cmp byte [eswitch], 0
    je LA47
    test_input_string ">"
    cmp byte [eswitch], 1
    je LA63
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_29
    cmp byte [backtrack_switch], 1
    je LA63
    jmp terminate_program
LOOP_29:
    print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "setg al"
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA63:
    
LA47:
    cmp byte [eswitch], 1
    je LA64
    
LA64:
    
LA65:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
RETURN:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "return"
    cmp byte [eswitch], 1
    je LA66
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_30
    cmp byte [backtrack_switch], 1
    je LA66
    jmp terminate_program
LOOP_30:
    print "mov esp, ebp"
    print 0x0A
    print '    '
    print "pop ebp"
    print 0x0A
    print '    '
    print "ret"
    print 0x0A
    print '    '
    
LA66:
    
LA67:
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
    je LA68
    test_input_string "["
    cmp byte [eswitch], 1
    jne LOOP_31
    cmp byte [backtrack_switch], 1
    je LA68
    jmp terminate_program
LOOP_31:
    call label
    call gn2
    print ":"
    print 0x0A
    print '    '
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA69
    
LA69:
    cmp byte [eswitch], 0
    je LA70
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA71
    
LA71:
    
LA70:
    cmp byte [eswitch], 1
    jne LOOP_32
    cmp byte [backtrack_switch], 1
    je LA68
    jmp terminate_program
LOOP_32:
    print "cmp eax, 1"
    print 0x0A
    print '    '
    print "jne "
    call gn1
    print 0x0A
    print '    '
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_33
    cmp byte [backtrack_switch], 1
    je LA68
    jmp terminate_program
LOOP_33:
    
LA72:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA73
    
LA73:
    
LA74:
    cmp byte [eswitch], 0
    je LA72
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_34
    cmp byte [backtrack_switch], 1
    je LA68
    jmp terminate_program
LOOP_34:
    print "jmp "
    call gn2
    print 0x0A
    print '    '
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    
LA68:
    
LA75:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
IF:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "if"
    cmp byte [eswitch], 1
    je LA76
    test_input_string "["
    cmp byte [eswitch], 1
    jne LOOP_35
    cmp byte [backtrack_switch], 1
    je LA76
    jmp terminate_program
LOOP_35:
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA77
    
LA77:
    cmp byte [eswitch], 0
    je LA78
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA79
    
LA79:
    
LA78:
    cmp byte [eswitch], 1
    jne LOOP_36
    cmp byte [backtrack_switch], 1
    je LA76
    jmp terminate_program
LOOP_36:
    print "cmp eax, 1"
    print 0x0A
    print '    '
    print "jne "
    call gn1
    print 0x0A
    print '    '
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_37
    cmp byte [backtrack_switch], 1
    je LA76
    jmp terminate_program
LOOP_37:
    
LA80:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA80
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_38
    cmp byte [backtrack_switch], 1
    je LA76
    jmp terminate_program
LOOP_38:
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    
LA76:
    
LA81:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
IF_ELSE:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "if/else"
    cmp byte [eswitch], 1
    je LA82
    test_input_string "["
    cmp byte [eswitch], 1
    jne LOOP_39
    cmp byte [backtrack_switch], 1
    je LA82
    jmp terminate_program
LOOP_39:
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA83
    
LA83:
    cmp byte [eswitch], 0
    je LA84
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA85
    
LA85:
    
LA84:
    cmp byte [eswitch], 1
    jne LOOP_40
    cmp byte [backtrack_switch], 1
    je LA82
    jmp terminate_program
LOOP_40:
    print "cmp eax, 1"
    print 0x0A
    print '    '
    print "jne "
    call gn1
    print 0x0A
    print '    '
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_41
    cmp byte [backtrack_switch], 1
    je LA82
    jmp terminate_program
LOOP_41:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_42
    cmp byte [backtrack_switch], 1
    je LA82
    jmp terminate_program
LOOP_42:
    print "jmp "
    call gn2
    print 0x0A
    print '    '
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_43
    cmp byte [backtrack_switch], 1
    je LA82
    jmp terminate_program
LOOP_43:
    call label
    call gn2
    print ":"
    print 0x0A
    print '    '
    
LA82:
    
LA86:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
ASMMACRO:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "asmmacro"
    cmp byte [eswitch], 1
    je LA87
    test_input_string "["
    cmp byte [eswitch], 1
    jne LOOP_44
    cmp byte [backtrack_switch], 1
    je LA87
    jmp terminate_program
LOOP_44:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_45
    cmp byte [backtrack_switch], 1
    je LA87
    jmp terminate_program
LOOP_45:
    print "jmp "
    call gn1
    print 0x0A
    print '    '
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
    
LA88:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA89
    
LA89:
    
LA90:
    cmp byte [eswitch], 0
    je LA88
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_46
    cmp byte [backtrack_switch], 1
    je LA87
    jmp terminate_program
LOOP_46:
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_47
    cmp byte [backtrack_switch], 1
    je LA87
    jmp terminate_program
LOOP_47:
    
LA91:
    error_store 'RAW'
    call vstack_clear
    call RAW
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA92
    call copy_last_match
    print 0x0A
    print '    '
    
LA92:
    
LA93:
    cmp byte [eswitch], 0
    je LA91
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_48
    cmp byte [backtrack_switch], 1
    je LA87
    jmp terminate_program
LOOP_48:
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
    
LA87:
    
LA94:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
ASM:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "asm"
    cmp byte [eswitch], 1
    je LA95
    error_store 'RAW'
    call vstack_clear
    call RAW
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_49
    cmp byte [backtrack_switch], 1
    je LA95
    jmp terminate_program
LOOP_49:
    call copy_last_match
    print 0x0A
    print '    '
    
LA95:
    
LA96:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
MOV:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "mov"
    cmp byte [eswitch], 1
    je LA97
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_50
    cmp byte [backtrack_switch], 1
    je LA97
    jmp terminate_program
LOOP_50:
    mov esi, last_match
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_51
    cmp byte [backtrack_switch], 1
    je LA97
    jmp terminate_program
LOOP_51:
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA98
    
LA98:
    cmp byte [eswitch], 0
    je LA99
    test_input_string "["
    cmp byte [eswitch], 1
    je LA100
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA101
    
LA101:
    cmp byte [eswitch], 0
    je LA102
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA103
    
LA103:
    
LA102:
    cmp byte [eswitch], 1
    jne LOOP_52
    cmp byte [backtrack_switch], 1
    je LA100
    jmp terminate_program
LOOP_52:
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_53
    cmp byte [backtrack_switch], 1
    je LA100
    jmp terminate_program
LOOP_53:
    
LA100:
    
LA99:
    cmp byte [eswitch], 1
    je LA104
    print "mov "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", eax"
    print 0x0A
    print '    '
    
LA104:
    cmp byte [eswitch], 0
    je LA105
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA106
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
    print 0x0A
    print '    '
    
LA106:
    
LA105:
    cmp byte [eswitch], 1
    jne LOOP_54
    cmp byte [backtrack_switch], 1
    je LA97
    jmp terminate_program
LOOP_54:
    
LA97:
    
LA107:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
DEFINE:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "define"
    cmp byte [eswitch], 1
    je LA108
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_55
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_55:
    mov esi, last_match
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_56
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_56:
    mov esi, last_match
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_57
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_57:
    cmp byte [eswitch], 1
    jne LOOP_58
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_58:
    cmp byte [eswitch], 1
    jne LOOP_59
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_59:
    cmp byte [is_global], 1
    jne define_local
    cmp byte [eswitch], 1
    jne LOOP_60
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_60:
    cmp byte [eswitch], 1
    jne LOOP_61
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_61:
    mov edx, 0x80000000
    mov edi, symbol_table
    mov esi, last_match
    call hash_set
    jmp define_end
    define_local:
    mov edx, dword [fn_arg_num]
    mov edi, symbol_table
    mov esi, last_match
    call hash_set
    define_end:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA109
    error_store 'MOV_INTO'
    call vstack_clear
    call MOV_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_62
    cmp byte [backtrack_switch], 1
    je LA109
    jmp terminate_program
LOOP_62:
    call copy_last_match
    print " ; define "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA109:
    
LA110:
    cmp byte [eswitch], 1
    je LA111
    
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
    error_store 'MOV_INTO'
    call vstack_clear
    call MOV_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_63
    cmp byte [backtrack_switch], 1
    je LA113
    jmp terminate_program
LOOP_63:
    call gn3
    print " ; define "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA113:
    
LA114:
    cmp byte [eswitch], 1
    je LA115
    
LA115:
    cmp byte [eswitch], 0
    je LA112
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA116
    error_store 'MOV_INTO'
    call vstack_clear
    call MOV_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_64
    cmp byte [backtrack_switch], 1
    je LA116
    jmp terminate_program
LOOP_64:
    print "eax ; define "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA116:
    
LA117:
    cmp byte [eswitch], 1
    je LA118
    
LA118:
    cmp byte [eswitch], 0
    je LA112
    test_input_string "["
    cmp byte [eswitch], 1
    je LA119
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA120
    
LA120:
    cmp byte [eswitch], 0
    je LA121
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA122
    
LA122:
    
LA121:
    cmp byte [eswitch], 1
    jne LOOP_65
    cmp byte [backtrack_switch], 1
    je LA119
    jmp terminate_program
LOOP_65:
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_66
    cmp byte [backtrack_switch], 1
    je LA119
    jmp terminate_program
LOOP_66:
    error_store 'MOV_INTO'
    call vstack_clear
    call MOV_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_67
    cmp byte [backtrack_switch], 1
    je LA119
    jmp terminate_program
LOOP_67:
    print "eax ; define "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA119:
    
LA123:
    cmp byte [eswitch], 1
    je LA124
    
LA124:
    
LA112:
    cmp byte [eswitch], 1
    jne LOOP_68
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_68:
    cmp byte [eswitch], 1
    jne LOOP_69
    cmp byte [backtrack_switch], 1
    je LA108
    jmp terminate_program
LOOP_69:
    cmp byte [is_global], 1
    je no_sub
    dec dword [fn_arg_num]
    print "sub esp, 4"
    print 0x0A
    print '    '
    no_sub:
    
LA108:
    
LA125:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
MOV_INTO:
    push ebp
    mov ebp, esp
    push esi
    cmp byte [eswitch], 1
    je LA126
    cmp byte [is_global], 1
    jne mov_into_local
    cmp byte [eswitch], 1
    jne LOOP_70
    cmp byte [backtrack_switch], 1
    je LA126
    jmp terminate_program
LOOP_70:
    call label
    print "section .bss"
    print 0x0A
    print '    '
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " resd 1"
    print 0x0A
    print '    '
    call label
    print "section .text"
    print 0x0A
    print '    '
    print "mov dword ["
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print "], "
    jmp mov_end
    mov_into_local:
    print "mov dword [ebp"
    cmp byte [eswitch], 1
    jne LOOP_71
    cmp byte [backtrack_switch], 1
    je LA126
    jmp terminate_program
LOOP_71:
    cmp byte [eswitch], 1
    jne LOOP_72
    cmp byte [backtrack_switch], 1
    je LA126
    jmp terminate_program
LOOP_72:
    mov eax, dword [fn_arg_num]
    cmp byte [eswitch], 1
    jne LOOP_73
    cmp byte [backtrack_switch], 1
    je LA126
    jmp terminate_program
LOOP_73:
    imul eax, eax, 4
    cmp byte [eswitch], 1
    jne LOOP_74
    cmp byte [backtrack_switch], 1
    je LA126
    jmp terminate_program
LOOP_74:
    add eax, 8
    cmp byte [eswitch], 1
    jne LOOP_75
    cmp byte [backtrack_switch], 1
    je LA126
    jmp terminate_program
LOOP_75:
    mov esi, eax
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostrsigned
    add dword [outbuff_offset], eax
    print "], "
    mov_end:
    
LA126:
    
LA127:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
SET:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "set!"
    cmp byte [eswitch], 1
    je LA128
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_76
    cmp byte [backtrack_switch], 1
    je LA128
    jmp terminate_program
LOOP_76:
    
section .data
    LC1 db "", 0x00
    
section .text
    mov esi, LC1
    mov edi, last_match
    call strcat
    mov esi, eax
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_77
    cmp byte [backtrack_switch], 1
    je LA128
    jmp terminate_program
LOOP_77:
    
section .data
    LC2 db "", 0x00
    
section .text
    mov esi, LC2
    mov edi, last_match
    call strcat
    mov esi, eax
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_78
    cmp byte [backtrack_switch], 1
    je LA128
    jmp terminate_program
LOOP_78:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
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
    jne LOOP_79
    cmp byte [backtrack_switch], 1
    je LA129
    jmp terminate_program
LOOP_79:
    call copy_last_match
    print " ; set "
    print 0x0A
    print '    '
    
LA129:
    
LA130:
    cmp byte [eswitch], 1
    je LA131
    
LA131:
    cmp byte [eswitch], 0
    je LA132
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA133
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
    error_store 'SET_INTO'
    call vstack_clear
    call SET_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_80
    cmp byte [backtrack_switch], 1
    je LA133
    jmp terminate_program
LOOP_80:
    call gn3
    print " ; set "
    print 0x0A
    print '    '
    
LA133:
    
LA134:
    cmp byte [eswitch], 1
    je LA135
    
LA135:
    cmp byte [eswitch], 0
    je LA132
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA136
    error_store 'SET_INTO'
    call vstack_clear
    call SET_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_81
    cmp byte [backtrack_switch], 1
    je LA136
    jmp terminate_program
LOOP_81:
    print "eax ; set "
    print 0x0A
    print '    '
    
LA136:
    
LA137:
    cmp byte [eswitch], 1
    je LA138
    
LA138:
    cmp byte [eswitch], 0
    je LA132
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
    jne LOOP_82
    cmp byte [backtrack_switch], 1
    je LA139
    jmp terminate_program
LOOP_82:
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_83
    cmp byte [backtrack_switch], 1
    je LA139
    jmp terminate_program
LOOP_83:
    error_store 'SET_INTO'
    call vstack_clear
    call SET_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_84
    cmp byte [backtrack_switch], 1
    je LA139
    jmp terminate_program
LOOP_84:
    print "eax ; set "
    print 0x0A
    print '    '
    
LA139:
    
LA143:
    cmp byte [eswitch], 1
    je LA144
    
LA144:
    
LA132:
    cmp byte [eswitch], 1
    jne LOOP_85
    cmp byte [backtrack_switch], 1
    je LA128
    jmp terminate_program
LOOP_85:
    
LA128:
    
LA145:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
SET_INTO:
    push ebp
    mov ebp, esp
    push esi
    mov edi, symbol_table
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    call hash_get
    cmp byte [eswitch], 1
    jne LOOP_86
    cmp byte [backtrack_switch], 1
    je LA146
    jmp terminate_program
LOOP_86:
    cmp byte [eswitch], 1
    jne LOOP_87
    cmp byte [backtrack_switch], 1
    je LA146
    jmp terminate_program
LOOP_87:
    cmp eax, 0x80000000
    jne set_into_local
    print "mov dword ["
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print "], "
    jmp set_into_end
    set_into_local:
    push eax
    print "mov dword [ebp"
    pop eax
    cmp byte [eswitch], 1
    jne LOOP_88
    cmp byte [backtrack_switch], 1
    je LA146
    jmp terminate_program
LOOP_88:
    cmp byte [eswitch], 1
    jne LOOP_89
    cmp byte [backtrack_switch], 1
    je LA146
    jmp terminate_program
LOOP_89:
    cmp byte [eswitch], 1
    jne LOOP_90
    cmp byte [backtrack_switch], 1
    je LA146
    jmp terminate_program
LOOP_90:
    imul eax, eax, 4
    cmp byte [eswitch], 1
    jne LOOP_91
    cmp byte [backtrack_switch], 1
    je LA146
    jmp terminate_program
LOOP_91:
    add eax, 8
    cmp byte [eswitch], 1
    jne LOOP_92
    cmp byte [backtrack_switch], 1
    je LA146
    jmp terminate_program
LOOP_92:
    mov esi, eax
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostrsigned
    add dword [outbuff_offset], eax
    print "], "
    set_into_end:
    
LA146:
    
LA147:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
DEFUNC:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "defunc"
    cmp byte [eswitch], 1
    je LA148
    mov byte [is_global], 0
    test_input_string "["
    cmp byte [eswitch], 1
    jne LOOP_93
    cmp byte [backtrack_switch], 1
    je LA148
    jmp terminate_program
LOOP_93:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_94
    cmp byte [backtrack_switch], 1
    je LA148
    jmp terminate_program
LOOP_94:
    print "jmp "
    call gn1
    print 0x0A
    print '    '
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
    mov dword [fn_arg_num], 0
    
LA149:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA150
    cmp byte [eswitch], 1
    jne LOOP_95
    cmp byte [backtrack_switch], 1
    je LA150
    jmp terminate_program
LOOP_95:
    cmp byte [eswitch], 1
    jne LOOP_96
    cmp byte [backtrack_switch], 1
    je LA150
    jmp terminate_program
LOOP_96:
    mov edx, dword [fn_arg_num]
    mov edi, symbol_table
    mov esi, last_match
    call hash_set
    inc dword [fn_arg_num]
    
LA150:
    
LA151:
    cmp byte [eswitch], 0
    je LA149
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_97
    cmp byte [backtrack_switch], 1
    je LA148
    jmp terminate_program
LOOP_97:
    cmp byte [eswitch], 1
    jne LOOP_98
    cmp byte [backtrack_switch], 1
    je LA148
    jmp terminate_program
LOOP_98:
    cmp byte [eswitch], 1
    jne LOOP_99
    cmp byte [backtrack_switch], 1
    je LA148
    jmp terminate_program
LOOP_99:
    mov dword [fn_arg_num], -3
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_100
    cmp byte [backtrack_switch], 1
    je LA148
    jmp terminate_program
LOOP_100:
    
LA152:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA153
    
LA153:
    
LA154:
    cmp byte [eswitch], 0
    je LA152
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_101
    cmp byte [backtrack_switch], 1
    je LA148
    jmp terminate_program
LOOP_101:
    mov dword [fn_arg_num], 0
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
    mov byte [is_global], 1
    
LA148:
    
LA155:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
FUNC_CALL:
    push ebp
    mov ebp, esp
    push esi
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA156
    mov esi, last_match
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_102
    cmp byte [backtrack_switch], 1
    je LA156
    jmp terminate_program
LOOP_102:
    mov dword [used_arg_count], 0
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_103
    cmp byte [backtrack_switch], 1
    je LA156
    jmp terminate_program
LOOP_103:
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
    cmp byte [eswitch], 1
    jne LOOP_104
    cmp byte [backtrack_switch], 1
    je LA156
    jmp terminate_program
LOOP_104:
    mov ebx, dword [used_arg_count]
    imul ebx, ebx, 4
    print "add esp, "
    mov esi, ebx
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostr
    add dword [outbuff_offset], eax
    mov dword [used_arg_count], 0
    print 0x0A
    print '    '
    print "push eax"
    print 0x0A
    print '    '
    
LA156:
    
LA157:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
CALL_ARGS:
    push ebp
    mov ebp, esp
    push esi
    
LA158:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA159
    
section .data
    LC3 db "push ", 0x00
    
section .text
    mov esi, LC3
    mov edi, last_match
    call strcat
    mov esi, eax
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_105
    cmp byte [backtrack_switch], 1
    je LA159
    jmp terminate_program
LOOP_105:
    
LA159:
    cmp byte [eswitch], 0
    je LA160
    test_input_string "["
    cmp byte [eswitch], 1
    je LA161
    push dword [used_arg_count]
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
    jne LOOP_106
    cmp byte [backtrack_switch], 1
    je LA161
    jmp terminate_program
LOOP_106:
    pop dword [used_arg_count]
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_107
    cmp byte [backtrack_switch], 1
    je LA161
    jmp terminate_program
LOOP_107:
    
section .data
    LC4 db "", 0x00
    
section .text
    mov esi, LC4
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_108
    cmp byte [backtrack_switch], 1
    je LA161
    jmp terminate_program
LOOP_108:
    
LA161:
    cmp byte [eswitch], 0
    je LA160
    error_store 'SYMBOL_TABLE_PUSH_BUFFER'
    call vstack_clear
    call SYMBOL_TABLE_PUSH_BUFFER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA165
    
LA165:
    cmp byte [eswitch], 0
    je LA160
    error_store 'STRING_ARG'
    call vstack_clear
    call STRING_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA166
    
LA166:
    
LA160:
    cmp byte [eswitch], 1
    je LA167
    inc dword [used_arg_count]
    
LA167:
    
LA168:
    cmp byte [eswitch], 0
    je LA158
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA169
    mov ecx, dword [used_arg_count]
    loop_pop_args:
    cmp ecx, 0
    je loop_pop_args_end
    push ecx
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    pop ecx
    dec ecx
    jmp loop_pop_args
    loop_pop_args_end:
    
LA169:
    
LA170:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
SYMBOL_TABLE_PUSH_BUFFER:
    push ebp
    mov ebp, esp
    push esi
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA171
    mov edi, symbol_table
    mov esi, last_match
    call hash_get
    cmp byte [eswitch], 1
    jne LOOP_109
    cmp byte [backtrack_switch], 1
    je LA171
    jmp terminate_program
LOOP_109:
    cmp byte [eswitch], 1
    jne LOOP_110
    cmp byte [backtrack_switch], 1
    je LA171
    jmp terminate_program
LOOP_110:
    cmp eax, 0x80000000
    jne stpb_local
    mov esi, push_prefix_global
    mov edi, push_buffer
    call buffc
    mov esi, last_match
    mov edi, push_buffer
    add edi, 12
    call buffc
    mov edi, push_buffer
    add edi, 12
    mov byte [edi+eax], ']'
    mov byte [edi+eax+1], 0x00
    mov esi, push_buffer
    mov edi, str_vector_8192
    call vector_push_string_mm32
    jmp stpb_end
    stpb_local:
    cmp byte [eswitch], 1
    jne LOOP_111
    cmp byte [backtrack_switch], 1
    je LA171
    jmp terminate_program
LOOP_111:
    cmp byte [eswitch], 1
    jne LOOP_112
    cmp byte [backtrack_switch], 1
    je LA171
    jmp terminate_program
LOOP_112:
    cmp byte [eswitch], 1
    jne LOOP_113
    cmp byte [backtrack_switch], 1
    je LA171
    jmp terminate_program
LOOP_113:
    push eax
    mov esi, push_prefix
    mov edi, push_buffer
    call buffc
    pop eax
    imul eax, eax, 4
    cmp byte [eswitch], 1
    jne LOOP_114
    cmp byte [backtrack_switch], 1
    je LA171
    jmp terminate_program
LOOP_114:
    add eax, 8
    cmp byte [eswitch], 1
    jne LOOP_115
    cmp byte [backtrack_switch], 1
    je LA171
    jmp terminate_program
LOOP_115:
    mov esi, eax
    cmp byte [eswitch], 1
    jne LOOP_116
    cmp byte [backtrack_switch], 1
    je LA171
    jmp terminate_program
LOOP_116:
    mov edi, push_buffer
    add edi, 15
    call inttostrsigned
    mov edi, push_buffer
    add edi, 15
    mov byte [edi+eax], ']'
    mov byte [edi+eax+1], 0x00
    mov esi, push_buffer
    mov edi, str_vector_8192
    call vector_push_string_mm32
    stpb_end:
    
LA171:
    
LA172:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
STRING_ARG:
    push ebp
    mov ebp, esp
    push esi
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA173
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
    
section .data
    LC5 db "", 0x00
    
section .text
    mov esi, LC5
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_117
    cmp byte [backtrack_switch], 1
    je LA173
    jmp terminate_program
LOOP_117:
    print "push "
    call gn3
    print 0x0A
    print '    '
    
LA173:
    
LA174:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
BINOP_ARGS:
    push ebp
    mov ebp, esp
    push esi
    
LA175:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA176
    print "push "
    call copy_last_match
    print 0x0A
    print '    '
    
LA176:
    cmp byte [eswitch], 0
    je LA177
    test_input_string "["
    cmp byte [eswitch], 1
    je LA178
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA179
    
LA179:
    cmp byte [eswitch], 0
    je LA180
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA181
    
LA181:
    
LA180:
    cmp byte [eswitch], 1
    jne LOOP_118
    cmp byte [backtrack_switch], 1
    je LA178
    jmp terminate_program
LOOP_118:
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_119
    cmp byte [backtrack_switch], 1
    je LA178
    jmp terminate_program
LOOP_119:
    
LA178:
    
LA182:
    cmp byte [eswitch], 1
    je LA183
    
LA183:
    cmp byte [eswitch], 0
    je LA177
    error_store 'SYMBOL_TABLE_PUSH'
    call vstack_clear
    call SYMBOL_TABLE_PUSH
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA184
    
LA184:
    
LA177:
    cmp byte [eswitch], 1
    je LA185
    
LA186:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA187
    print "push "
    call copy_last_match
    print 0x0A
    print '    '
    
LA187:
    cmp byte [eswitch], 0
    je LA188
    test_input_string "["
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
    jne LOOP_120
    cmp byte [backtrack_switch], 1
    je LA189
    jmp terminate_program
LOOP_120:
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_121
    cmp byte [backtrack_switch], 1
    je LA189
    jmp terminate_program
LOOP_121:
    
LA189:
    
LA193:
    cmp byte [eswitch], 1
    je LA194
    
LA194:
    cmp byte [eswitch], 0
    je LA188
    error_store 'SYMBOL_TABLE_PUSH'
    call vstack_clear
    call SYMBOL_TABLE_PUSH
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA195
    
LA195:
    
LA188:
    cmp byte [eswitch], 1
    je LA196
    print "pop ebx"
    print 0x0A
    print '    '
    
LA196:
    
LA197:
    cmp byte [eswitch], 0
    je LA186
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_122
    cmp byte [backtrack_switch], 1
    je LA185
    jmp terminate_program
LOOP_122:
    print "pop eax"
    print 0x0A
    print '    '
    
LA185:
    
LA198:
    cmp byte [eswitch], 0
    je LA175
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA199
    
LA199:
    
LA200:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
SYMBOL_TABLE_PUSH:
    push ebp
    mov ebp, esp
    push esi
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA201
    mov edi, symbol_table
    mov esi, last_match
    call hash_get
    cmp byte [eswitch], 1
    jne LOOP_123
    cmp byte [backtrack_switch], 1
    je LA201
    jmp terminate_program
LOOP_123:
    cmp byte [eswitch], 1
    jne LOOP_124
    cmp byte [backtrack_switch], 1
    je LA201
    jmp terminate_program
LOOP_124:
    cmp eax, 0x80000000
    jne stp_local
    print "push dword ["
    call copy_last_match
    print "]"
    print 0x0A
    print '    '
    jmp stp_end
    stp_local:
    cmp byte [eswitch], 1
    jne LOOP_125
    cmp byte [backtrack_switch], 1
    je LA201
    jmp terminate_program
LOOP_125:
    cmp byte [eswitch], 1
    jne LOOP_126
    cmp byte [backtrack_switch], 1
    je LA201
    jmp terminate_program
LOOP_126:
    cmp byte [eswitch], 1
    jne LOOP_127
    cmp byte [backtrack_switch], 1
    je LA201
    jmp terminate_program
LOOP_127:
    push eax
    print "push dword [ebp"
    pop eax
    imul eax, eax, 4
    cmp byte [eswitch], 1
    jne LOOP_128
    cmp byte [backtrack_switch], 1
    je LA201
    jmp terminate_program
LOOP_128:
    add eax, 8
    cmp byte [eswitch], 1
    jne LOOP_129
    cmp byte [backtrack_switch], 1
    je LA201
    jmp terminate_program
LOOP_129:
    mov esi, eax
    cmp byte [eswitch], 1
    jne LOOP_130
    cmp byte [backtrack_switch], 1
    je LA201
    jmp terminate_program
LOOP_130:
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostrsigned
    add dword [outbuff_offset], eax
    print "] ; get "
    call copy_last_match
    print 0x0A
    print '    '
    stp_end:
    
LA201:
    
LA202:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
SYMBOL_TABLE_ID:
    push ebp
    mov ebp, esp
    push esi
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA203
    mov edi, symbol_table
    mov esi, last_match
    call hash_get
    cmp byte [eswitch], 1
    jne LOOP_131
    cmp byte [backtrack_switch], 1
    je LA203
    jmp terminate_program
LOOP_131:
    cmp byte [eswitch], 1
    jne LOOP_132
    cmp byte [backtrack_switch], 1
    je LA203
    jmp terminate_program
LOOP_132:
    cmp eax, 0x80000000
    jne st_local
    print "mov eax, dword ["
    call copy_last_match
    print "]"
    print 0x0A
    print '    '
    jmp st_end
    st_local:
    cmp byte [eswitch], 1
    jne LOOP_133
    cmp byte [backtrack_switch], 1
    je LA203
    jmp terminate_program
LOOP_133:
    cmp byte [eswitch], 1
    jne LOOP_134
    cmp byte [backtrack_switch], 1
    je LA203
    jmp terminate_program
LOOP_134:
    cmp byte [eswitch], 1
    jne LOOP_135
    cmp byte [backtrack_switch], 1
    je LA203
    jmp terminate_program
LOOP_135:
    push eax
    print "mov eax, dword [ebp"
    pop eax
    imul eax, eax, 4
    cmp byte [eswitch], 1
    jne LOOP_136
    cmp byte [backtrack_switch], 1
    je LA203
    jmp terminate_program
LOOP_136:
    add eax, 8
    cmp byte [eswitch], 1
    jne LOOP_137
    cmp byte [backtrack_switch], 1
    je LA203
    jmp terminate_program
LOOP_137:
    mov esi, eax
    cmp byte [eswitch], 1
    jne LOOP_138
    cmp byte [backtrack_switch], 1
    je LA203
    jmp terminate_program
LOOP_138:
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostrsigned
    add dword [outbuff_offset], eax
    print "] ; get "
    call copy_last_match
    print 0x0A
    print '    '
    st_end:
    
LA203:
    
LA204:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
SYMBOL_TABLE_ID_EBX:
    push ebp
    mov ebp, esp
    push esi
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA205
    mov edi, symbol_table
    mov esi, last_match
    call hash_get
    cmp byte [eswitch], 1
    jne LOOP_139
    cmp byte [backtrack_switch], 1
    je LA205
    jmp terminate_program
LOOP_139:
    cmp byte [eswitch], 1
    jne LOOP_140
    cmp byte [backtrack_switch], 1
    je LA205
    jmp terminate_program
LOOP_140:
    cmp eax, 0x80000000
    jne st_ebx_local
    print "mov ebx, dword ["
    call copy_last_match
    print "]"
    print 0x0A
    print '    '
    jmp st_ebx_end
    st_ebx_local:
    cmp byte [eswitch], 1
    jne LOOP_141
    cmp byte [backtrack_switch], 1
    je LA205
    jmp terminate_program
LOOP_141:
    cmp byte [eswitch], 1
    jne LOOP_142
    cmp byte [backtrack_switch], 1
    je LA205
    jmp terminate_program
LOOP_142:
    cmp byte [eswitch], 1
    jne LOOP_143
    cmp byte [backtrack_switch], 1
    je LA205
    jmp terminate_program
LOOP_143:
    push eax
    print "mov ebx, dword [ebp"
    pop eax
    imul eax, eax, 4
    cmp byte [eswitch], 1
    jne LOOP_144
    cmp byte [backtrack_switch], 1
    je LA205
    jmp terminate_program
LOOP_144:
    add eax, 8
    cmp byte [eswitch], 1
    jne LOOP_145
    cmp byte [backtrack_switch], 1
    je LA205
    jmp terminate_program
LOOP_145:
    mov esi, eax
    cmp byte [eswitch], 1
    jne LOOP_146
    cmp byte [backtrack_switch], 1
    je LA205
    jmp terminate_program
LOOP_146:
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostrsigned
    add dword [outbuff_offset], eax
    print "] ; get "
    call copy_last_match
    print 0x0A
    print '    '
    st_ebx_end:
    
LA205:
    
LA206:
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
    je LA207
    match_not 10
    cmp byte [eswitch], 1
    jne LOOP_147
    cmp byte [backtrack_switch], 1
    je LA207
    jmp terminate_program
LOOP_147:
    
LA207:
    
LA208:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
; -- Tokens --
    
PREFIX:
    
LA209:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA210
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA210
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA210
    mov edi, 10
    call test_char_equal
    
LA210:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA209
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA211
    
LA211:
    
LA212:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA213
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA213
    call DIGIT
    cmp byte [eswitch], 1
    je LA213
    
LA214:
    call DIGIT
    cmp byte [eswitch], 0
    je LA214
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA213
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA213
    
LA213:
    
LA215:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA216
    mov edi, 57
    call test_char_less_equal
    
LA216:
    
LA217:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA218
    
LA218:
    
LA219:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA220
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA220
    call ALPHA
    cmp byte [eswitch], 1
    je LA220
    
LA221:
    call ALPHA
    cmp byte [eswitch], 1
    je LA222
    
LA222:
    cmp byte [eswitch], 0
    je LA223
    call DIGIT
    cmp byte [eswitch], 1
    je LA224
    
LA224:
    
LA223:
    cmp byte [eswitch], 0
    je LA221
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA220
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA220
    
LA220:
    
LA225:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA226
    mov edi, 90
    call test_char_less_equal
    
LA226:
    cmp byte [eswitch], 0
    je LA227
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA227
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA228
    mov edi, 122
    call test_char_less_equal
    
LA228:
    
LA227:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA229
    
LA229:
    
LA230:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA231
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA231
    mov edi, 34
    call test_char_equal
    
LA232:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA231
    
LA233:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA234
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA234
    mov edi, 34
    call test_char_equal
    
LA234:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA233
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA231
    mov edi, 34
    call test_char_equal
    
LA235:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA231
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA231
    
LA231:
    
LA236:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA237
    mov edi, 34
    call test_char_equal
    
LA238:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA237
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA237
    
LA239:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA240
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA240
    mov edi, 34
    call test_char_equal
    
LA240:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA239
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA237
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA237
    mov edi, 34
    call test_char_equal
    
LA241:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA237
    
LA237:
    
LA242:
    ret
    
