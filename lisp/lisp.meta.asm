
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
    jne LOOP_0
cmp byte [backtrack_switch], 1
    je LA1
    je terminate_program
        LOOP_0:

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
    jne LOOP_1
cmp byte [backtrack_switch], 1
    je LA1
    je terminate_program
        LOOP_1:
error_store 'POSTAMBLE'
    call vstack_clear
    call POSTAMBLE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_2
cmp byte [backtrack_switch], 1
    je LA1
    je terminate_program
        LOOP_2:

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
    jne LOOP_3
cmp byte [backtrack_switch], 1
    je LA8
    je terminate_program
        LOOP_3:
test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_4
cmp byte [backtrack_switch], 1
    je LA8
    je terminate_program
        LOOP_4:

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
    print "mov eax, 1"
    print 0x0A
    print '    '
    print "mov ebx, 0"
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
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA34
    
LA34:
    cmp byte [eswitch], 0
    je LA29
    error_store 'ASM'
    call vstack_clear
    call ASM
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA35
    
LA35:
    cmp byte [eswitch], 0
    je LA29
    error_store 'MOV'
    call vstack_clear
    call MOV
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA36
    
LA36:
    cmp byte [eswitch], 0
    je LA29
    error_store 'RETURN'
    call vstack_clear
    call RETURN
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA37
    
LA37:
    cmp byte [eswitch], 0
    je LA29
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA38
    
LA38:
    
LA29:
    cmp byte [eswitch], 1
    jne LOOP_5
cmp byte [backtrack_switch], 1
    je LA27
    je terminate_program
        LOOP_5:
test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_6
cmp byte [backtrack_switch], 1
    je LA27
    je terminate_program
        LOOP_6:

LA27:
    
LA26:
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
    je LA39
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_7
cmp byte [backtrack_switch], 1
    je LA39
    je terminate_program
        LOOP_7:
print "add eax, ebx"
    print 0x0A
    print '    '
    
LA39:
    cmp byte [eswitch], 0
    je LA40
    test_input_string "-"
    cmp byte [eswitch], 1
    je LA41
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_8
cmp byte [backtrack_switch], 1
    je LA41
    je terminate_program
        LOOP_8:
print "sub eax, ebx"
    print 0x0A
    print '    '
    
LA41:
    cmp byte [eswitch], 0
    je LA40
    test_input_string "*"
    cmp byte [eswitch], 1
    je LA42
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_9
cmp byte [backtrack_switch], 1
    je LA42
    je terminate_program
        LOOP_9:
print "imul eax, ebx"
    print 0x0A
    print '    '
    
LA42:
    cmp byte [eswitch], 0
    je LA40
    test_input_string "/"
    cmp byte [eswitch], 1
    je LA43
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_10
cmp byte [backtrack_switch], 1
    je LA43
    je terminate_program
        LOOP_10:
print "idiv ebx"
    print 0x0A
    print '    '
    
LA43:
    cmp byte [eswitch], 0
    je LA40
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA44
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_11
cmp byte [backtrack_switch], 1
    je LA44
    je terminate_program
        LOOP_11:
print "idiv ebx"
    print 0x0A
    print '    '
    
LA44:
    cmp byte [eswitch], 0
    je LA40
    test_input_string "=="
    cmp byte [eswitch], 1
    je LA45
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_12
cmp byte [backtrack_switch], 1
    je LA45
    je terminate_program
        LOOP_12:
print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "sete al"
    print 0x0A
    print '    '
    
LA45:
    cmp byte [eswitch], 0
    je LA40
    test_input_string "!="
    cmp byte [eswitch], 1
    je LA46
    error_store 'BINOP_ARGS'
    call vstack_clear
    call BINOP_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_13
cmp byte [backtrack_switch], 1
    je LA46
    je terminate_program
        LOOP_13:
print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "setne al"
    print 0x0A
    print '    '
    
LA46:
    cmp byte [eswitch], 0
    je LA40
    test_input_string "<"
    cmp byte [eswitch], 1
    je LA47
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_14
cmp byte [backtrack_switch], 1
    je LA47
    je terminate_program
        LOOP_14:
print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "setl al"
    print 0x0A
    print '    '
    
LA47:
    cmp byte [eswitch], 0
    je LA40
    test_input_string ">"
    cmp byte [eswitch], 1
    je LA48
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_15
cmp byte [backtrack_switch], 1
    je LA48
    je terminate_program
        LOOP_15:
print "cmp eax, ebx"
    print 0x0A
    print '    '
    print "mov eax, 0"
    print 0x0A
    print '    '
    print "setg al"
    print 0x0A
    print '    '
    
LA48:
    
LA40:
    cmp byte [eswitch], 1
    je LA49
    
LA49:
    
LA50:
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
    je LA51
    error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_16
cmp byte [backtrack_switch], 1
    je LA51
    je terminate_program
        LOOP_16:
print "mov esp, ebp"
    print 0x0A
    print '    '
    print "pop ebp"
    print 0x0A
    print '    '
    print "ret"
    print 0x0A
    print '    '
    
LA51:
    
LA52:
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
    je LA53
    test_input_string "["
    cmp byte [eswitch], 1
    jne LOOP_17
cmp byte [backtrack_switch], 1
    je LA53
    je terminate_program
        LOOP_17:
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
    je LA54
    
LA54:
    cmp byte [eswitch], 0
    je LA55
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA56
    
LA56:
    
LA55:
    cmp byte [eswitch], 1
    jne LOOP_18
cmp byte [backtrack_switch], 1
    je LA53
    je terminate_program
        LOOP_18:
print "cmp eax, 1"
    print 0x0A
    print '    '
    print "jne "
    call gn1
    print 0x0A
    print '    '
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_19
cmp byte [backtrack_switch], 1
    je LA53
    je terminate_program
        LOOP_19:

LA57:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA58
    
LA58:
    
LA59:
    cmp byte [eswitch], 0
    je LA57
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_20
cmp byte [backtrack_switch], 1
    je LA53
    je terminate_program
        LOOP_20:
print "jmp "
    call gn2
    print 0x0A
    print '    '
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    
LA53:
    
LA60:
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
    je LA61
    test_input_string "["
    cmp byte [eswitch], 1
    jne LOOP_21
cmp byte [backtrack_switch], 1
    je LA61
    je terminate_program
        LOOP_21:
error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA62
    
LA62:
    cmp byte [eswitch], 0
    je LA63
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA64
    
LA64:
    
LA63:
    cmp byte [eswitch], 1
    jne LOOP_22
cmp byte [backtrack_switch], 1
    je LA61
    je terminate_program
        LOOP_22:
print "cmp eax, 1"
    print 0x0A
    print '    '
    print "jne "
    call gn1
    print 0x0A
    print '    '
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_23
cmp byte [backtrack_switch], 1
    je LA61
    je terminate_program
        LOOP_23:

LA65:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA65
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_24
cmp byte [backtrack_switch], 1
    je LA61
    je terminate_program
        LOOP_24:
call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    
LA61:
    
LA66:
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
    je LA67
    test_input_string "["
    cmp byte [eswitch], 1
    jne LOOP_25
cmp byte [backtrack_switch], 1
    je LA67
    je terminate_program
        LOOP_25:
error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA68
    
LA68:
    cmp byte [eswitch], 0
    je LA69
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA70
    
LA70:
    
LA69:
    cmp byte [eswitch], 1
    jne LOOP_26
cmp byte [backtrack_switch], 1
    je LA67
    je terminate_program
        LOOP_26:
print "cmp eax, 1"
    print 0x0A
    print '    '
    print "jne "
    call gn1
    print 0x0A
    print '    '
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_27
cmp byte [backtrack_switch], 1
    je LA67
    je terminate_program
        LOOP_27:
test_input_string "["
    cmp byte [eswitch], 1
    jne LOOP_28
cmp byte [backtrack_switch], 1
    je LA67
    je terminate_program
        LOOP_28:

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
    jne LOOP_29
cmp byte [backtrack_switch], 1
    je LA67
    je terminate_program
        LOOP_29:
test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_30
cmp byte [backtrack_switch], 1
    je LA67
    je terminate_program
        LOOP_30:
print "jmp "
    call gn2
    print 0x0A
    print '    '
    call label
    call gn1
    print ":"
    print 0x0A
    print '    '
    test_input_string "["
    cmp byte [eswitch], 1
    jne LOOP_31
cmp byte [backtrack_switch], 1
    je LA67
    je terminate_program
        LOOP_31:

LA72:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA72
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_32
cmp byte [backtrack_switch], 1
    je LA67
    je terminate_program
        LOOP_32:
test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_33
cmp byte [backtrack_switch], 1
    je LA67
    je terminate_program
        LOOP_33:
call label
    call gn2
    print ":"
    print 0x0A
    print '    '
    
LA67:
    
LA73:
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
    je LA74
    test_input_string "["
    cmp byte [eswitch], 1
    jne LOOP_34
cmp byte [backtrack_switch], 1
    je LA74
    je terminate_program
        LOOP_34:
error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_35
cmp byte [backtrack_switch], 1
    je LA74
    je terminate_program
        LOOP_35:
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
    
LA75:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA76
    
LA76:
    
LA77:
    cmp byte [eswitch], 0
    je LA75
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_36
cmp byte [backtrack_switch], 1
    je LA74
    je terminate_program
        LOOP_36:
test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_37
cmp byte [backtrack_switch], 1
    je LA74
    je terminate_program
        LOOP_37:

LA78:
    error_store 'RAW'
    call vstack_clear
    call RAW
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA79
    call copy_last_match
    print 0x0A
    print '    '
    
LA79:
    
LA80:
    cmp byte [eswitch], 0
    je LA78
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_38
cmp byte [backtrack_switch], 1
    je LA74
    je terminate_program
        LOOP_38:
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
    
LA74:
    
LA81:
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
    je LA82
    error_store 'RAW'
    call vstack_clear
    call RAW
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_39
cmp byte [backtrack_switch], 1
    je LA82
    je terminate_program
        LOOP_39:
call copy_last_match
    print 0x0A
    print '    '
    
LA82:
    
LA83:
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
    je LA84
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_40
cmp byte [backtrack_switch], 1
    je LA84
    je terminate_program
        LOOP_40:
mov edi, last_match
    call strcat
    mov esi, eax
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_41
cmp byte [backtrack_switch], 1
    je LA84
    je terminate_program
        LOOP_41:
error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA85
    
LA85:
    cmp byte [eswitch], 0
    je LA86
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
    jne LOOP_42
cmp byte [backtrack_switch], 1
    je LA87
    je terminate_program
        LOOP_42:
test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_43
cmp byte [backtrack_switch], 1
    je LA87
    je terminate_program
        LOOP_43:

LA87:
    
LA86:
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
    print 0x0A
    print '    '
    
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
    print 0x0A
    print '    '
    
LA93:
    
LA92:
    cmp byte [eswitch], 1
    jne LOOP_44
cmp byte [backtrack_switch], 1
    je LA84
    je terminate_program
        LOOP_44:

LA84:
    
LA94:
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
    je LA95
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_45
cmp byte [backtrack_switch], 1
    je LA95
    je terminate_program
        LOOP_45:
mov esi, last_match
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_46
cmp byte [backtrack_switch], 1
    je LA95
    je terminate_program
        LOOP_46:
cmp byte [eswitch], 1
    jne LOOP_47
cmp byte [backtrack_switch], 1
    je LA95
    je terminate_program
        LOOP_47:
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
    jne LOOP_48
cmp byte [backtrack_switch], 1
    je LA96
    je terminate_program
        LOOP_48:
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
    jne LOOP_49
cmp byte [backtrack_switch], 1
    je LA100
    je terminate_program
        LOOP_49:
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
    jne LOOP_50
cmp byte [backtrack_switch], 1
    je LA103
    je terminate_program
        LOOP_50:
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
    
LA103:
    
LA104:
    cmp byte [eswitch], 1
    je LA105
    
LA105:
    cmp byte [eswitch], 0
    je LA99
    test_input_string "["
    cmp byte [eswitch], 1
    je LA106
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA107
    
LA107:
    cmp byte [eswitch], 0
    je LA108
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA109
    
LA109:
    
LA108:
    cmp byte [eswitch], 1
    jne LOOP_51
cmp byte [backtrack_switch], 1
    je LA106
    je terminate_program
        LOOP_51:
test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_52
cmp byte [backtrack_switch], 1
    je LA106
    je terminate_program
        LOOP_52:
error_store 'MOV_INTO'
    call vstack_clear
    call MOV_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_53
cmp byte [backtrack_switch], 1
    je LA106
    je terminate_program
        LOOP_53:
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
    
LA106:
    
LA110:
    cmp byte [eswitch], 1
    je LA111
    
LA111:
    
LA99:
    cmp byte [eswitch], 1
    jne LOOP_54
cmp byte [backtrack_switch], 1
    je LA95
    je terminate_program
        LOOP_54:
cmp byte [eswitch], 1
    jne LOOP_55
cmp byte [backtrack_switch], 1
    je LA95
    je terminate_program
        LOOP_55:
print "sub esp, 4"
    print 0x0A
    print '    '
    
LA95:
    
LA112:
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
    jne LOOP_56
cmp byte [backtrack_switch], 1
    je LA113
    je terminate_program
        LOOP_56:
cmp byte [eswitch], 1
    jne LOOP_57
cmp byte [backtrack_switch], 1
    je LA113
    je terminate_program
        LOOP_57:
mov eax, dword [fn_arg_num]
    cmp byte [eswitch], 1
    jne LOOP_58
cmp byte [backtrack_switch], 1
    je LA113
    je terminate_program
        LOOP_58:
mov ebx, dword [fn_arg_count]
    sub ebx, eax
    cmp byte [eswitch], 1
    jne LOOP_59
cmp byte [backtrack_switch], 1
    je LA113
    je terminate_program
        LOOP_59:
imul eax, ebx, 4
    cmp byte [eswitch], 1
    jne LOOP_60
cmp byte [backtrack_switch], 1
    je LA113
    je terminate_program
        LOOP_60:
add eax, 8
    cmp byte [eswitch], 1
    jne LOOP_61
cmp byte [backtrack_switch], 1
    je LA113
    je terminate_program
        LOOP_61:
mov esi, eax
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostrsigned
    add dword [outbuff_offset], eax
    print "], "
    
LA113:
    
LA114:
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
    je LA115
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_62
cmp byte [backtrack_switch], 1
    je LA115
    je terminate_program
        LOOP_62:
mov edi, last_match
    call strcat
    mov esi, eax
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_63
cmp byte [backtrack_switch], 1
    je LA115
    je terminate_program
        LOOP_63:
error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA116
    error_store 'SET_INTO'
    call vstack_clear
    call SET_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_64
cmp byte [backtrack_switch], 1
    je LA116
    je terminate_program
        LOOP_64:
call copy_last_match
    print " ; set "
    print 0x0A
    print '    '
    
LA116:
    
LA117:
    cmp byte [eswitch], 1
    je LA118
    
LA118:
    cmp byte [eswitch], 0
    je LA119
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA120
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
    jne LOOP_65
cmp byte [backtrack_switch], 1
    je LA120
    je terminate_program
        LOOP_65:
call gn3
    print " ; set "
    print 0x0A
    print '    '
    
LA120:
    
LA121:
    cmp byte [eswitch], 1
    je LA122
    
LA122:
    cmp byte [eswitch], 0
    je LA119
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA123
    error_store 'SET_INTO'
    call vstack_clear
    call SET_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_66
cmp byte [backtrack_switch], 1
    je LA123
    je terminate_program
        LOOP_66:
print "eax ; set "
    print 0x0A
    print '    '
    
LA123:
    
LA124:
    cmp byte [eswitch], 1
    je LA125
    
LA125:
    cmp byte [eswitch], 0
    je LA119
    test_input_string "["
    cmp byte [eswitch], 1
    je LA126
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
    jne LOOP_67
cmp byte [backtrack_switch], 1
    je LA126
    je terminate_program
        LOOP_67:
test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_68
cmp byte [backtrack_switch], 1
    je LA126
    je terminate_program
        LOOP_68:
error_store 'SET_INTO'
    call vstack_clear
    call SET_INTO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_69
cmp byte [backtrack_switch], 1
    je LA126
    je terminate_program
        LOOP_69:
print "eax ; set "
    print 0x0A
    print '    '
    
LA126:
    
LA130:
    cmp byte [eswitch], 1
    je LA131
    
LA131:
    
LA119:
    cmp byte [eswitch], 1
    jne LOOP_70
cmp byte [backtrack_switch], 1
    je LA115
    je terminate_program
        LOOP_70:

LA115:
    
LA132:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
SET_INTO:
    push ebp
    mov ebp, esp
    push esi
    print "mov [ebp"
    cmp byte [eswitch], 1
    jne LOOP_71
cmp byte [backtrack_switch], 1
    je LA133
    je terminate_program
        LOOP_71:
cmp byte [eswitch], 1
    jne LOOP_72
cmp byte [backtrack_switch], 1
    je LA133
    je terminate_program
        LOOP_72:
cmp byte [eswitch], 1
    jne LOOP_73
cmp byte [backtrack_switch], 1
    je LA133
    je terminate_program
        LOOP_73:
mov edi, symbol_table
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    call hash_get
    cmp byte [eswitch], 1
    jne LOOP_74
cmp byte [backtrack_switch], 1
    je LA133
    je terminate_program
        LOOP_74:
mov ebx, dword [fn_arg_count]
    sub ebx, eax
    cmp byte [eswitch], 1
    jne LOOP_75
cmp byte [backtrack_switch], 1
    je LA133
    je terminate_program
        LOOP_75:
imul eax, ebx, 4
    cmp byte [eswitch], 1
    jne LOOP_76
cmp byte [backtrack_switch], 1
    je LA133
    je terminate_program
        LOOP_76:
add eax, 8
    cmp byte [eswitch], 1
    jne LOOP_77
cmp byte [backtrack_switch], 1
    je LA133
    je terminate_program
        LOOP_77:
mov esi, eax
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostrsigned
    add dword [outbuff_offset], eax
    print "], "
    
LA133:
    
LA134:
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
    je LA135
    test_input_string "["
    cmp byte [eswitch], 1
    jne LOOP_78
cmp byte [backtrack_switch], 1
    je LA135
    je terminate_program
        LOOP_78:
error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_79
cmp byte [backtrack_switch], 1
    je LA135
    je terminate_program
        LOOP_79:
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
    
LA136:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA137
    cmp byte [eswitch], 1
    jne LOOP_80
cmp byte [backtrack_switch], 1
    je LA137
    je terminate_program
        LOOP_80:
cmp byte [eswitch], 1
    jne LOOP_81
cmp byte [backtrack_switch], 1
    je LA137
    je terminate_program
        LOOP_81:
inc dword [fn_arg_count] ; found new argument!
    inc dword [fn_arg_num]
    mov edx, dword [fn_arg_num]
    mov edi, symbol_table
    mov esi, last_match
    call hash_set
    
LA137:
    
LA138:
    cmp byte [eswitch], 0
    je LA136
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_82
cmp byte [backtrack_switch], 1
    je LA135
    je terminate_program
        LOOP_82:
cmp byte [eswitch], 1
    jne LOOP_83
cmp byte [backtrack_switch], 1
    je LA135
    je terminate_program
        LOOP_83:
cmp byte [eswitch], 1
    jne LOOP_84
cmp byte [backtrack_switch], 1
    je LA135
    je terminate_program
        LOOP_84:
add dword [fn_arg_num], 2
    test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_85
cmp byte [backtrack_switch], 1
    je LA135
    je terminate_program
        LOOP_85:

LA139:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA140
    
LA140:
    
LA141:
    cmp byte [eswitch], 0
    je LA139
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_86
cmp byte [backtrack_switch], 1
    je LA135
    je terminate_program
        LOOP_86:
mov dword [fn_arg_count], 0
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
    
LA135:
    
LA142:
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
    je LA143
    mov esi, last_match
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_87
cmp byte [backtrack_switch], 1
    je LA143
    je terminate_program
        LOOP_87:
error_store 'CALL_ARGS'
    call vstack_clear
    call CALL_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_88
cmp byte [backtrack_switch], 1
    je LA143
    je terminate_program
        LOOP_88:
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
    jne LOOP_89
cmp byte [backtrack_switch], 1
    je LA143
    je terminate_program
        LOOP_89:
print "pop edi"
    print 0x0A
    print '    '
    print "pop edi"
    print 0x0A
    print '    '
    
LA143:
    
LA144:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
CALL_ARGS:
    push ebp
    mov ebp, esp
    push esi
    
LA145:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA146
    
section .data
    LC1 db "push ", 0x00
    
section .text
    mov esi, LC1
    mov edi, last_match
    call strcat
    mov esi, eax
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_90
cmp byte [backtrack_switch], 1
    je LA146
    je terminate_program
        LOOP_90:

LA146:
    cmp byte [eswitch], 0
    je LA147
    test_input_string "["
    cmp byte [eswitch], 1
    je LA148
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA149
    
LA149:
    cmp byte [eswitch], 0
    je LA150
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA151
    
LA151:
    
LA150:
    cmp byte [eswitch], 1
    jne LOOP_91
cmp byte [backtrack_switch], 1
    je LA148
    je terminate_program
        LOOP_91:
test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_92
cmp byte [backtrack_switch], 1
    je LA148
    je terminate_program
        LOOP_92:

section .data
    LC2 db "", 0x00
    
section .text
    mov esi, LC2
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_93
cmp byte [backtrack_switch], 1
    je LA148
    je terminate_program
        LOOP_93:
print "push eax"
    print 0x0A
    print '    '
    
LA148:
    cmp byte [eswitch], 0
    je LA147
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA152
    
section .data
    LC3 db "push eax", 0x00
    
section .text
    mov esi, LC3
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_94
cmp byte [backtrack_switch], 1
    je LA152
    je terminate_program
        LOOP_94:

LA152:
    cmp byte [eswitch], 0
    je LA147
    error_store 'STRING_ARG'
    call vstack_clear
    call STRING_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA153
    
LA153:
    
LA147:
    cmp byte [eswitch], 1
    je LA154
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA154:
    
LA155:
    cmp byte [eswitch], 0
    je LA145
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA156
    
LA156:
    
LA157:
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
    je LA158
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
    LC4 db "", 0x00
    
section .text
    mov esi, LC4
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_95
cmp byte [backtrack_switch], 1
    je LA158
    je terminate_program
        LOOP_95:
print "push "
    call gn3
    print 0x0A
    print '    '
    
LA158:
    
LA159:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
BINOP_ARGS:
    push ebp
    mov ebp, esp
    push esi
    
LA160:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA161
    
section .data
    LC5 db "mov eax, ", 0x00
    
section .text
    mov esi, LC5
    mov edi, last_match
    call strcat
    mov esi, eax
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_96
cmp byte [backtrack_switch], 1
    je LA161
    je terminate_program
        LOOP_96:

LA161:
    cmp byte [eswitch], 0
    je LA162
    test_input_string "["
    cmp byte [eswitch], 1
    je LA163
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA164
    
LA164:
    cmp byte [eswitch], 0
    je LA165
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA166
    
LA166:
    
LA165:
    cmp byte [eswitch], 1
    jne LOOP_97
cmp byte [backtrack_switch], 1
    je LA163
    je terminate_program
        LOOP_97:
test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_98
cmp byte [backtrack_switch], 1
    je LA163
    je terminate_program
        LOOP_98:

section .data
    LC6 db "", 0x00
    
section .text
    mov esi, LC6
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_99
cmp byte [backtrack_switch], 1
    je LA163
    je terminate_program
        LOOP_99:

LA163:
    
LA167:
    cmp byte [eswitch], 1
    je LA168
    cmp byte [eswitch], 1
    jne LOOP_100
cmp byte [backtrack_switch], 1
    je LA168
    je terminate_program
        LOOP_100:

LA168:
    cmp byte [eswitch], 0
    je LA162
    error_store 'SYMBOL_TABLE_ID'
    call vstack_clear
    call SYMBOL_TABLE_ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA169
    
section .data
    LC7 db "", 0x00
    
section .text
    mov esi, LC7
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_101
cmp byte [backtrack_switch], 1
    je LA169
    je terminate_program
        LOOP_101:

LA169:
    
LA162:
    cmp byte [eswitch], 1
    je LA170
    
LA171:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA172
    
section .data
    LC8 db "mov ebx, ", 0x00
    
section .text
    mov esi, LC8
    mov edi, last_match
    call strcat
    mov esi, eax
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_102
cmp byte [backtrack_switch], 1
    je LA172
    je terminate_program
        LOOP_102:

LA172:
    cmp byte [eswitch], 0
    je LA173
    test_input_string "["
    cmp byte [eswitch], 1
    je LA174
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA175
    
LA175:
    cmp byte [eswitch], 0
    je LA176
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA177
    
LA177:
    
LA176:
    cmp byte [eswitch], 1
    jne LOOP_103
cmp byte [backtrack_switch], 1
    je LA174
    je terminate_program
        LOOP_103:
test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_104
cmp byte [backtrack_switch], 1
    je LA174
    je terminate_program
        LOOP_104:

section .data
    LC9 db "", 0x00
    
section .text
    mov esi, LC9
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_105
cmp byte [backtrack_switch], 1
    je LA174
    je terminate_program
        LOOP_105:
print "mov ebx, eax"
    print 0x0A
    print '    '
    
LA174:
    
LA178:
    cmp byte [eswitch], 1
    je LA179
    
LA179:
    cmp byte [eswitch], 0
    je LA173
    error_store 'SYMBOL_TABLE_ID_EBX'
    call vstack_clear
    call SYMBOL_TABLE_ID_EBX
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA180
    
section .data
    LC10 db "", 0x00
    
section .text
    mov esi, LC10
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_106
cmp byte [backtrack_switch], 1
    je LA180
    je terminate_program
        LOOP_106:

LA180:
    
LA173:
    cmp byte [eswitch], 1
    je LA181
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA181:
    
LA182:
    cmp byte [eswitch], 0
    je LA171
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    jne LOOP_107
cmp byte [backtrack_switch], 1
    je LA170
    je terminate_program
        LOOP_107:
mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA170:
    
LA183:
    cmp byte [eswitch], 0
    je LA160
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA184
    
LA184:
    
LA185:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
CALL_ARG:
    push ebp
    mov ebp, esp
    push esi
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA186
    
section .data
    LC11 db "mov esi, ", 0x00
    
section .text
    mov esi, LC11
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_108
cmp byte [backtrack_switch], 1
    je LA186
    je terminate_program
        LOOP_108:
mov edi, last_match
    call strcat
    mov esi, eax
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_109
cmp byte [backtrack_switch], 1
    je LA186
    je terminate_program
        LOOP_109:

LA186:
    cmp byte [eswitch], 0
    je LA187
    test_input_string "["
    cmp byte [eswitch], 1
    je LA188
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA189
    
LA189:
    cmp byte [eswitch], 0
    je LA190
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA191
    
LA191:
    
LA190:
    cmp byte [eswitch], 1
    jne LOOP_110
cmp byte [backtrack_switch], 1
    je LA188
    je terminate_program
        LOOP_110:
test_input_string "]"
    cmp byte [eswitch], 1
    jne LOOP_111
cmp byte [backtrack_switch], 1
    je LA188
    je terminate_program
        LOOP_111:

section .data
    LC12 db "", 0x00
    
section .text
    mov esi, LC12
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_112
cmp byte [backtrack_switch], 1
    je LA188
    je terminate_program
        LOOP_112:

section .data
    LC13 db "", 0x00
    
section .text
    mov esi, LC13
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_113
cmp byte [backtrack_switch], 1
    je LA188
    je terminate_program
        LOOP_113:
print "mov esi, eax"
    print 0x0A
    print '    '
    
LA188:
    
LA187:
    cmp byte [eswitch], 1
    je LA192
    
LA192:
    
LA193:
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
    je LA194
    cmp byte [eswitch], 1
    jne LOOP_114
cmp byte [backtrack_switch], 1
    je LA194
    je terminate_program
        LOOP_114:
cmp byte [eswitch], 1
    jne LOOP_115
cmp byte [backtrack_switch], 1
    je LA194
    je terminate_program
        LOOP_115:
cmp byte [eswitch], 1
    jne LOOP_116
cmp byte [backtrack_switch], 1
    je LA194
    je terminate_program
        LOOP_116:
print "mov eax, dword [ebp"
    mov edi, symbol_table
    mov esi, last_match
    call hash_get
    cmp byte [eswitch], 1
    jne LOOP_117
cmp byte [backtrack_switch], 1
    je LA194
    je terminate_program
        LOOP_117:
mov ebx, dword [fn_arg_count]
    sub ebx, eax
    cmp byte [eswitch], 1
    jne LOOP_118
cmp byte [backtrack_switch], 1
    je LA194
    je terminate_program
        LOOP_118:
imul eax, ebx, 4
    cmp byte [eswitch], 1
    jne LOOP_119
cmp byte [backtrack_switch], 1
    je LA194
    je terminate_program
        LOOP_119:
add eax, 8
    cmp byte [eswitch], 1
    jne LOOP_120
cmp byte [backtrack_switch], 1
    je LA194
    je terminate_program
        LOOP_120:
mov esi, eax
    cmp byte [eswitch], 1
    jne LOOP_121
cmp byte [backtrack_switch], 1
    je LA194
    je terminate_program
        LOOP_121:
mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostrsigned
    add dword [outbuff_offset], eax
    print "] ; get "
    call copy_last_match
    print 0x0A
    print '    '
    
LA194:
    
LA195:
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
    je LA196
    cmp byte [eswitch], 1
    jne LOOP_122
cmp byte [backtrack_switch], 1
    je LA196
    je terminate_program
        LOOP_122:
cmp byte [eswitch], 1
    jne LOOP_123
cmp byte [backtrack_switch], 1
    je LA196
    je terminate_program
        LOOP_123:
cmp byte [eswitch], 1
    jne LOOP_124
cmp byte [backtrack_switch], 1
    je LA196
    je terminate_program
        LOOP_124:
print "mov ebx, dword [ebp"
    mov edi, symbol_table
    mov esi, last_match
    call hash_get
    cmp byte [eswitch], 1
    jne LOOP_125
cmp byte [backtrack_switch], 1
    je LA196
    je terminate_program
        LOOP_125:
mov ebx, dword [fn_arg_count]
    sub ebx, eax
    cmp byte [eswitch], 1
    jne LOOP_126
cmp byte [backtrack_switch], 1
    je LA196
    je terminate_program
        LOOP_126:
imul eax, ebx, 4
    cmp byte [eswitch], 1
    jne LOOP_127
cmp byte [backtrack_switch], 1
    je LA196
    je terminate_program
        LOOP_127:
add eax, 8
    cmp byte [eswitch], 1
    jne LOOP_128
cmp byte [backtrack_switch], 1
    je LA196
    je terminate_program
        LOOP_128:
mov esi, eax
    cmp byte [eswitch], 1
    jne LOOP_129
cmp byte [backtrack_switch], 1
    je LA196
    je terminate_program
        LOOP_129:
mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostrsigned
    add dword [outbuff_offset], eax
    print "] ; get "
    call copy_last_match
    print 0x0A
    print '    '
    
LA196:
    
LA197:
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
    je LA198
    match_not 10
    cmp byte [eswitch], 1
    jne LOOP_130
cmp byte [backtrack_switch], 1
    je LA198
    je terminate_program
        LOOP_130:

LA198:
    
LA199:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
; -- Tokens --
    
PREFIX:
    
LA200:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA201
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA201
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA201
    mov edi, 10
    call test_char_equal
    
LA201:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA200
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA202
    
LA202:
    
LA203:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA204
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA204
    call DIGIT
    cmp byte [eswitch], 1
    je LA204
    
LA205:
    call DIGIT
    cmp byte [eswitch], 0
    je LA205
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA204
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA204
    
LA204:
    
LA206:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA207
    mov edi, 57
    call test_char_less_equal
    
LA207:
    
LA208:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA209
    
LA209:
    
LA210:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA211
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA211
    call ALPHA
    cmp byte [eswitch], 1
    je LA211
    
LA212:
    call ALPHA
    cmp byte [eswitch], 1
    je LA213
    
LA213:
    cmp byte [eswitch], 0
    je LA214
    call DIGIT
    cmp byte [eswitch], 1
    je LA215
    
LA215:
    
LA214:
    cmp byte [eswitch], 0
    je LA212
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA211
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA211
    
LA211:
    
LA216:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA217
    mov edi, 90
    call test_char_less_equal
    
LA217:
    cmp byte [eswitch], 0
    je LA218
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA218
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA219
    mov edi, 122
    call test_char_less_equal
    
LA219:
    
LA218:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA220
    
LA220:
    
LA221:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA222
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA222
    mov edi, 34
    call test_char_equal
    
LA223:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA222
    
LA224:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA225
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA225
    mov edi, 34
    call test_char_equal
    
LA225:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA224
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA222
    mov edi, 34
    call test_char_equal
    
LA226:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA222
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA222
    
LA222:
    
LA227:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA228
    mov edi, 34
    call test_char_equal
    
LA229:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA228
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA228
    
LA230:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA231
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA231
    mov edi, 34
    call test_char_equal
    
LA231:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA230
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA228
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA228
    mov edi, 34
    call test_char_equal
    
LA232:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA228
    
LA228:
    
LA233:
    ret
    
