
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
    call_arg_count dd 0
    indent dd 0
    section .bss
    call_arg_count_vector resb 512
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
    je LA33
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    
section .data
    LC1 db "%add", 0x00
    
section .text
    mov esi, LC1
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
    
section .data
    LC2 db "%sub", 0x00
    
section .text
    mov esi, LC2
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA35:
    cmp byte [eswitch], 0
    je LA34
    test_input_string "*"
    cmp byte [eswitch], 1
    je LA36
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    
section .data
    LC3 db "%imul", 0x00
    
section .text
    mov esi, LC3
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA36:
    cmp byte [eswitch], 0
    je LA34
    test_input_string "/"
    cmp byte [eswitch], 1
    je LA37
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    
section .data
    LC4 db "%idiv", 0x00
    
section .text
    mov esi, LC4
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA37:
    cmp byte [eswitch], 0
    je LA34
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA38
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    
section .data
    LC5 db "%mod", 0x00
    
section .text
    mov esi, LC5
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA38:
    cmp byte [eswitch], 0
    je LA34
    test_input_string "=="
    cmp byte [eswitch], 1
    je LA39
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    
section .data
    LC6 db "%eq", 0x00
    
section .text
    mov esi, LC6
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA39:
    cmp byte [eswitch], 0
    je LA34
    test_input_string "!="
    cmp byte [eswitch], 1
    je LA40
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    
section .data
    LC7 db "%neq", 0x00
    
section .text
    mov esi, LC7
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA40:
    cmp byte [eswitch], 0
    je LA34
    test_input_string "<"
    cmp byte [eswitch], 1
    je LA41
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    
section .data
    LC8 db "%lt", 0x00
    
section .text
    mov esi, LC8
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA41:
    cmp byte [eswitch], 0
    je LA34
    test_input_string ">"
    cmp byte [eswitch], 1
    je LA42
    error_store 'ARITHMETIC_ARGS'
    call vstack_clear
    
section .data
    LC9 db "%gt", 0x00
    
section .text
    mov esi, LC9
    call ARITHMETIC_ARGS
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA42:
    
LA34:
    cmp byte [eswitch], 1
    je LA43
    
LA43:
    
LA44:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
ARITHMETIC_ARGS:
    push ebp
    mov ebp, esp
    push esi
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " "
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", @"
    call copy_last_match
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", $"
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", $"
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " "
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " $, "
    call copy_last_match
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " $, @"
    call copy_last_match
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " $, $"
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " $, $"
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " $, "
    call copy_last_match
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " @"
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", @"
    call copy_last_match
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", $"
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " @"
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print ", $"
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " @"
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " $, "
    call copy_last_match
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " $, @"
    call copy_last_match
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " $, $"
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " $, $"
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop esi
    push esi
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " $, "
    call copy_last_match
    print 0x0A
    
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
    je LA97
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA98
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%ret "
    call copy_last_match
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%ret "
    call copy_last_match
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%ret @"
    call copy_last_match
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%ret $"
    print 0x0A
    
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%ret $"
    print 0x0A
    
LA107:
    
LA101:
    cmp byte [eswitch], 1
    je terminate_program
    
LA97:
    
LA111:
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
    je LA112
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "while ("
    print 0x0A
    inc dword [indent]
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
    dec dword [indent]
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print ") {"
    print 0x0A
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    inc dword [indent]
    
LA116:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA116
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    dec dword [indent]
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "}"
    print 0x0A
    
LA112:
    
LA117:
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
    je LA118
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "if ("
    print 0x0A
    inc dword [indent]
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA119
    
LA119:
    cmp byte [eswitch], 0
    je LA120
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA121
    
LA121:
    
LA120:
    cmp byte [eswitch], 1
    je terminate_program
    dec dword [indent]
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print ") {"
    print 0x0A
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    inc dword [indent]
    
LA122:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA122
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    dec dword [indent]
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "}"
    print 0x0A
    
LA118:
    
LA123:
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
    je LA124
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA125
    
LA125:
    cmp byte [eswitch], 0
    je LA126
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA127
    
LA127:
    
LA126:
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp eax, 1"
    print 0x0A
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "jne "
    call gn1
    print 0x0A
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    
LA128:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA128
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "jmp "
    call gn2
    print 0x0A
    call gn1
    print ":"
    print 0x0A
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    
LA129:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 0
    je LA129
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    call gn2
    print ":"
    print 0x0A
    
LA124:
    
LA130:
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
    je LA131
    error_store 'RAW'
    call vstack_clear
    call RAW
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    call copy_last_match
    print 0x0A
    
LA131:
    
LA132:
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
    je LA133
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
    je LA134
    
LA134:
    cmp byte [eswitch], 0
    je LA135
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA136
    
LA136:
    cmp byte [eswitch], 0
    je LA135
    test_input_string "["
    cmp byte [eswitch], 1
    je LA137
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA138
    
LA138:
    cmp byte [eswitch], 0
    je LA139
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA140
    
LA140:
    
LA139:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA137:
    
LA135:
    cmp byte [eswitch], 1
    je LA141
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
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
    
LA141:
    cmp byte [eswitch], 0
    je LA142
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA143
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
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
    
LA143:
    
LA142:
    cmp byte [eswitch], 1
    je terminate_program
    
LA133:
    
LA144:
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
    je LA145
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
    je LA146
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
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
    print ", "
    call copy_last_match
    print 0x0A
    
LA146:
    
LA147:
    cmp byte [eswitch], 1
    je LA148
    
LA148:
    cmp byte [eswitch], 0
    je LA149
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA150
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
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
    print ", "
    call copy_last_match
    print 0x0A
    
LA150:
    
LA151:
    cmp byte [eswitch], 1
    je LA152
    
LA152:
    cmp byte [eswitch], 0
    je LA149
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA153
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
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
    print ", @"
    call copy_last_match
    print 0x0A
    
LA153:
    
LA154:
    cmp byte [eswitch], 1
    je LA155
    
LA155:
    cmp byte [eswitch], 0
    je LA149
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA156
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
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
    print 0x0A
    
LA156:
    
LA157:
    cmp byte [eswitch], 1
    je LA158
    
LA158:
    cmp byte [eswitch], 0
    je LA149
    test_input_string "["
    cmp byte [eswitch], 1
    je LA159
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA160
    
LA160:
    cmp byte [eswitch], 0
    je LA161
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA162
    
LA162:
    
LA161:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
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
    print 0x0A
    
LA159:
    
LA163:
    cmp byte [eswitch], 1
    je LA164
    
LA164:
    
LA149:
    cmp byte [eswitch], 1
    je terminate_program
    
LA145:
    
LA165:
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
    je LA166
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
    je LA167
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
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
    print ", "
    call copy_last_match
    print 0x0A
    
LA167:
    
LA168:
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
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
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
    print ", "
    call copy_last_match
    print 0x0A
    
LA171:
    
LA172:
    cmp byte [eswitch], 1
    je LA173
    
LA173:
    cmp byte [eswitch], 0
    je LA170
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA174
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
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
    print ", @"
    call copy_last_match
    print 0x0A
    
LA174:
    
LA175:
    cmp byte [eswitch], 1
    je LA176
    
LA176:
    cmp byte [eswitch], 0
    je LA170
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA177
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
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
    print 0x0A
    
LA177:
    
LA178:
    cmp byte [eswitch], 1
    je LA179
    
LA179:
    cmp byte [eswitch], 0
    je LA170
    test_input_string "["
    cmp byte [eswitch], 1
    je LA180
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA181
    
LA181:
    cmp byte [eswitch], 0
    je LA182
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA183
    
LA183:
    
LA182:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
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
    print 0x0A
    
LA180:
    
LA184:
    cmp byte [eswitch], 1
    je LA185
    
LA185:
    
LA170:
    cmp byte [eswitch], 1
    je terminate_program
    
LA166:
    
LA186:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
DEREFERENCE:
    push ebp
    mov ebp, esp
    push esi
    test_input_string "&["
    cmp byte [eswitch], 1
    je LA187
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA188
    
LA188:
    cmp byte [eswitch], 0
    je LA189
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA190
    
LA190:
    
LA189:
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%deref/dword $"
    print 0x0A
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA187:
    cmp byte [eswitch], 0
    je LA191
    test_input_string "&1["
    cmp byte [eswitch], 1
    je LA192
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA193
    
LA193:
    cmp byte [eswitch], 0
    je LA194
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA195
    
LA195:
    
LA194:
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%deref/byte $"
    print 0x0A
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA192:
    cmp byte [eswitch], 0
    je LA191
    test_input_string "&2["
    cmp byte [eswitch], 1
    je LA196
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA197
    
LA197:
    cmp byte [eswitch], 0
    je LA198
    error_store 'ARITHMETIC'
    call vstack_clear
    call ARITHMETIC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA199
    
LA199:
    
LA198:
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%deref/word $"
    print 0x0A
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA196:
    cmp byte [eswitch], 0
    je LA191
    test_input_string "&"
    cmp byte [eswitch], 1
    je LA200
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA201
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%deref/dword @"
    call copy_last_match
    print 0x0A
    
LA201:
    cmp byte [eswitch], 0
    je LA202
    error_store 'DEREFERENCE'
    call vstack_clear
    call DEREFERENCE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA203
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%deref/dword $"
    print 0x0A
    
LA203:
    
LA202:
    cmp byte [eswitch], 1
    je terminate_program
    
LA200:
    
LA191:
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
    je LA204
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
    inc dword [indent]
    print "fn "
    call copy_last_match
    print "("
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    
LA205:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA206
    print "i32 @"
    call copy_last_match
    print ""
    
LA206:
    
LA207:
    cmp byte [eswitch], 1
    je LA208
    
LA209:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA210
    print ", i32 @"
    call copy_last_match
    
LA210:
    
LA211:
    cmp byte [eswitch], 0
    je LA209
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA212
    
LA212:
    cmp byte [eswitch], 0
    je LA213
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA214
    
LA214:
    
LA213:
    cmp byte [eswitch], 1
    je terminate_program
    
LA208:
    
LA215:
    cmp byte [eswitch], 0
    je LA205
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    print ") {"
    print 0x0A
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA216:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA217
    
LA217:
    
LA218:
    cmp byte [eswitch], 0
    je LA216
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "%ret"
    print 0x0A
    print "}"
    print 0x0A
    print 0x0A
    dec dword [indent]
    
LA204:
    
LA219:
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
    je LA220
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    inc dword [call_arg_count]
    
LA221:
    error_store 'CALL_ARG'
    call vstack_clear
    call CALL_ARG
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA222
    
LA222:
    
LA223:
    cmp byte [eswitch], 0
    je LA221
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    mov esi, dword [call_arg_count]
    mov edi, call_arg_count_vector
    call vector_push
    mov dword [call_arg_count], 0
    mov esi, call_arg_count_vector
    call vector_pop
    push eax
    mov edi, str_vector_8192
    mov esi, eax
    call vector_reverse_n_string
    error_store 'TAB'
    call vstack_clear
    call TAB
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    pop eax
    .loop:
    push eax
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " "
    pop eax
    dec eax
    cmp eax, 0
    je .loop_end
    jmp .loop
    .loop_end:
    print 0x0A
    
LA220:
    
LA224:
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
    je LA225
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    inc dword [call_arg_count]
    
LA225:
    cmp byte [eswitch], 0
    je LA226
    test_input_string "["
    cmp byte [eswitch], 1
    je LA227
    section .data
    dollar_sign db '$', 0x00
    section .text
    mov edi, str_vector_8192
    mov esi, dollar_sign
    call vector_push_string_mm32
    mov esi, dword [call_arg_count]
    mov edi, call_arg_count_vector
    call vector_push
    mov dword [call_arg_count], 0
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA228
    
LA228:
    
LA229:
    cmp byte [eswitch], 1
    je terminate_program
    mov esi, call_arg_count_vector
    call vector_pop
    mov dword [call_arg_count], eax
    add dword [call_arg_count], 1
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA227:
    
LA226:
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
    je LA230
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA230:
    
LA231:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
TAB:
    push ebp
    mov ebp, esp
    push esi
    xor ecx, ecx
    mov eax, dword [indent]
    .loop:
    cmp eax, ecx
    je .loop_end
    inc ecx
    print '    '
    jmp .loop
    .loop_end:
    
LA232:
    
LA233:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
; -- Tokens --
    
PREFIX:
    
LA234:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA235
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA235
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA235
    mov edi, 10
    call test_char_equal
    
LA235:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA234
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA236
    
LA236:
    
LA237:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA238
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA238
    call DIGIT
    cmp byte [eswitch], 1
    je LA238
    
LA239:
    call DIGIT
    cmp byte [eswitch], 0
    je LA239
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA238
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA238
    
LA238:
    
LA240:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA241
    mov edi, 57
    call test_char_less_equal
    
LA241:
    
LA242:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA243
    
LA243:
    
LA244:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA245
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA245
    call ALPHA
    cmp byte [eswitch], 1
    je LA245
    
LA246:
    call ALPHA
    cmp byte [eswitch], 1
    je LA247
    
LA247:
    cmp byte [eswitch], 0
    je LA248
    call DIGIT
    cmp byte [eswitch], 1
    je LA249
    
LA249:
    
LA248:
    cmp byte [eswitch], 0
    je LA246
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA245
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA245
    
LA245:
    
LA250:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA251
    mov edi, 90
    call test_char_less_equal
    
LA251:
    cmp byte [eswitch], 0
    je LA252
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA252
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA253
    mov edi, 122
    call test_char_less_equal
    
LA253:
    
LA252:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA254
    
LA254:
    
LA255:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA256
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA256
    mov edi, 34
    call test_char_equal
    
LA257:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA256
    
LA258:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA259
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA259
    mov edi, 34
    call test_char_equal
    
LA259:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA258
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA256
    mov edi, 34
    call test_char_equal
    
LA260:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA256
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA256
    
LA256:
    
LA261:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA262
    mov edi, 34
    call test_char_equal
    
LA263:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA262
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA262
    
LA264:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA265
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA265
    mov edi, 34
    call test_char_equal
    
LA265:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA264
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA262
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA262
    mov edi, 34
    call test_char_equal
    
LA266:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA262
    
LA262:
    
LA267:
    ret
    
