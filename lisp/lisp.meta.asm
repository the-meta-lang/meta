
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
    error_store 'PREAMBLE'
    call vstack_clear
    call PREAMBLE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA1
    
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
    je terminate_program
    error_store 'POSTAMBLE'
    call vstack_clear
    call POSTAMBLE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA1:
    
LA5:
    ret
    
ROOT_BODY:
    test_input_string "["
    cmp byte [eswitch], 1
    je LA6
    error_store 'DEFUNC'
    call vstack_clear
    call DEFUNC
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA7
    
LA7:
    cmp byte [eswitch], 0
    je LA8
    error_store 'DEFINE'
    call vstack_clear
    call DEFINE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA9
    
LA9:
    cmp byte [eswitch], 0
    je LA8
    error_store 'ASMMACRO'
    call vstack_clear
    call ASMMACRO
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA10
    
LA10:
    cmp byte [eswitch], 0
    je LA8
    error_store 'WHILE'
    call vstack_clear
    call WHILE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA11
    
LA11:
    cmp byte [eswitch], 0
    je LA8
    error_store 'IF_ELSE'
    call vstack_clear
    call IF_ELSE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA12
    
LA12:
    cmp byte [eswitch], 0
    je LA8
    error_store 'IF'
    call vstack_clear
    call IF
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA13
    
LA13:
    cmp byte [eswitch], 0
    je LA8
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA14
    
LA14:
    
LA8:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA6:
    
LA15:
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
    
LA16:
    
LA17:
    ret
    
POSTAMBLE:
    print "mov esp, ebp"
    call newline
    print "pop ebp"
    call newline
    call label
    print "exit:"
    call newline
    print "mov eax, 1"
    call newline
    print "mov ebx, esi"
    call newline
    print "int 0x80"
    call newline
    
LA18:
    
LA19:
    ret
    
BODY:
    test_input_string "["
    cmp byte [eswitch], 1
    je LA20
    error_store 'DEFINE'
    call vstack_clear
    call DEFINE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA21
    
LA21:
    cmp byte [eswitch], 0
    je LA22
    error_store 'WHILE'
    call vstack_clear
    call WHILE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA23
    
LA23:
    cmp byte [eswitch], 0
    je LA22
    error_store 'IF_ELSE'
    call vstack_clear
    call IF_ELSE
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA24
    
LA24:
    cmp byte [eswitch], 0
    je LA22
    error_store 'IF'
    call vstack_clear
    call IF
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA25
    
LA25:
    cmp byte [eswitch], 0
    je LA22
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA26
    
LA26:
    
LA22:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA20:
    
LA27:
    ret
    
WHILE:
    test_input_string "while"
    cmp byte [eswitch], 1
    je LA28
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
    je terminate_program
    print "cmp eax, 1"
    call newline
    print "jne "
    call gn1
    call newline
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA29:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA30
    
LA30:
    
LA31:
    cmp byte [eswitch], 0
    je LA29
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
    
LA28:
    
LA32:
    ret
    
IF:
    test_input_string "if"
    cmp byte [eswitch], 1
    je LA33
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
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
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA33:
    
LA34:
    ret
    
IF_ELSE:
    test_input_string "if/else"
    cmp byte [eswitch], 1
    je LA35
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
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
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "jmp "
    call gn2
    call newline
    call label
    call gn1
    print ":"
    call newline
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn2
    print ":"
    call newline
    
LA35:
    
LA36:
    ret
    
ASMMACRO:
    test_input_string "asmmacro"
    cmp byte [eswitch], 1
    je LA37
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
    
LA38:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA39
    
LA39:
    
LA40:
    cmp byte [eswitch], 0
    je LA38
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA41:
    error_store 'RAW'
    call vstack_clear
    call RAW
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA42
    call copy_last_match
    call newline
    
LA42:
    
LA43:
    cmp byte [eswitch], 0
    je LA41
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
    
LA37:
    
LA44:
    ret
    
DEFINE:
    test_input_string "define"
    cmp byte [eswitch], 1
    je LA45
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
    call label
    print "; -- Define "
    call copy_last_match
    print " --"
    call newline
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA46
    call label
    print "section .data"
    call newline
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " dd "
    call copy_last_match
    call newline
    call label
    print "section .text"
    call newline
    print "mov eax, dword ["
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print "]"
    call newline
    
LA46:
    
LA47:
    cmp byte [eswitch], 1
    je LA48
    
LA48:
    cmp byte [eswitch], 0
    je LA49
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA50
    call label
    print "section .data"
    call newline
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " db "
    call copy_last_match
    print ", 0x00"
    call newline
    call label
    print "section .text"
    call newline
    print "mov eax, "
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA50:
    
LA51:
    cmp byte [eswitch], 1
    je LA52
    
LA52:
    cmp byte [eswitch], 0
    je LA49
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA53
    call label
    print "section .data"
    call newline
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " dd 0"
    call newline
    call label
    print "section .text"
    call newline
    print "mov eax, "
    call copy_last_match
    call newline
    print "mov dword ["
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print "], eax"
    call newline
    
LA53:
    
LA54:
    cmp byte [eswitch], 1
    je LA55
    
LA55:
    cmp byte [eswitch], 0
    je LA49
    test_input_string "&"
    cmp byte [eswitch], 1
    je LA56
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "section .data"
    call newline
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " dd 0"
    call newline
    call label
    print "section .text"
    call newline
    print "mov eax, ["
    call copy_last_match
    print "]"
    call newline
    print "mov dword ["
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print "], eax"
    call newline
    
LA56:
    
LA57:
    cmp byte [eswitch], 1
    je LA58
    
LA58:
    cmp byte [eswitch], 0
    je LA49
    error_store 'LISP'
    call vstack_clear
    call LISP
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA59
    call label
    print "section .data"
    call newline
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print " dd 0"
    call newline
    call label
    print "section .text"
    call newline
    print "mov dword ["
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print "], eax"
    call newline
    
LA59:
    
LA60:
    cmp byte [eswitch], 1
    je LA61
    
LA61:
    
LA49:
    cmp byte [eswitch], 1
    je terminate_program
    
LA45:
    
LA62:
    ret
    
DEFUNC:
    test_input_string "defunc"
    cmp byte [eswitch], 1
    je LA63
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
    
LA64:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA65
    print "mov dword [ebp+16], esi"
    call newline
    
LA65:
    
LA66:
    cmp byte [eswitch], 0
    je LA64
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA67:
    error_store 'BODY'
    call vstack_clear
    call BODY
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA68
    
LA68:
    
LA69:
    cmp byte [eswitch], 0
    je LA67
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
    
LA63:
    
LA70:
    ret
    
FUNC_CALL:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA71
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    error_store 'LISP_CALL_ARGS'
    call vstack_clear
    call LISP_CALL_ARGS
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
    
LA71:
    
LA72:
    ret
    
LISP_CALL_ARGS:
    
LA73:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA74
    print "mov esi, "
    call copy_last_match
    call newline
    
LA74:
    
LA75:
    cmp byte [eswitch], 1
    je LA76
    
LA76:
    cmp byte [eswitch], 0
    je LA77
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA78
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
    
LA78:
    
LA79:
    cmp byte [eswitch], 1
    je LA80
    
LA80:
    cmp byte [eswitch], 0
    je LA77
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA81
    print "mov esi, "
    call copy_last_match
    call newline
    
LA81:
    
LA82:
    cmp byte [eswitch], 1
    je LA83
    
LA83:
    cmp byte [eswitch], 0
    je LA77
    test_input_string "&"
    cmp byte [eswitch], 1
    je LA84
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov esi, ["
    call copy_last_match
    print "]"
    call newline
    
LA84:
    
LA85:
    cmp byte [eswitch], 1
    je LA86
    
LA86:
    cmp byte [eswitch], 0
    je LA77
    test_input_string "["
    cmp byte [eswitch], 1
    je LA87
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    print "pop esi"
    call newline
    
LA87:
    
LA77:
    cmp byte [eswitch], 1
    je LA88
    
LA89:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA90
    print "mov edi, "
    call copy_last_match
    call newline
    
LA90:
    
LA91:
    cmp byte [eswitch], 1
    je LA92
    
LA92:
    cmp byte [eswitch], 0
    je LA93
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA94
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
    print "mov edi, "
    call gn3
    call newline
    
LA94:
    
LA95:
    cmp byte [eswitch], 1
    je LA96
    
LA96:
    cmp byte [eswitch], 0
    je LA93
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA97
    print "mov edi, "
    call copy_last_match
    call newline
    
LA97:
    
LA98:
    cmp byte [eswitch], 1
    je LA99
    
LA99:
    cmp byte [eswitch], 0
    je LA93
    test_input_string "&"
    cmp byte [eswitch], 1
    je LA100
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov edi, ["
    call copy_last_match
    print "]"
    call newline
    
LA100:
    
LA101:
    cmp byte [eswitch], 1
    je LA102
    
LA102:
    cmp byte [eswitch], 0
    je LA93
    test_input_string "["
    cmp byte [eswitch], 1
    je LA103
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    print "pop edi"
    call newline
    
LA103:
    
LA93:
    cmp byte [eswitch], 1
    je LA104
    
LA105:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA106
    print "mov edx, "
    call copy_last_match
    call newline
    
LA106:
    
LA107:
    cmp byte [eswitch], 1
    je LA108
    
LA108:
    cmp byte [eswitch], 0
    je LA109
    error_store 'STRING'
    call vstack_clear
    call STRING
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA110
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
    print "mov edx, "
    call gn3
    call newline
    
LA110:
    
LA111:
    cmp byte [eswitch], 1
    je LA112
    
LA112:
    cmp byte [eswitch], 0
    je LA109
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA113
    print "mov edx, "
    call copy_last_match
    call newline
    
LA113:
    
LA114:
    cmp byte [eswitch], 1
    je LA115
    
LA115:
    cmp byte [eswitch], 0
    je LA109
    test_input_string "&"
    cmp byte [eswitch], 1
    je LA116
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    print "mov edx, ["
    call copy_last_match
    print "]"
    call newline
    
LA116:
    
LA117:
    cmp byte [eswitch], 1
    je LA118
    
LA118:
    cmp byte [eswitch], 0
    je LA109
    test_input_string "["
    cmp byte [eswitch], 1
    je LA119
    error_store 'FUNC_CALL'
    call vstack_clear
    call FUNC_CALL
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    print "pop edx"
    call newline
    
LA119:
    
LA109:
    cmp byte [eswitch], 1
    je LA120
    
LA120:
    
LA121:
    cmp byte [eswitch], 0
    je LA105
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA104:
    
LA122:
    cmp byte [eswitch], 0
    je LA89
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA88:
    
LA123:
    cmp byte [eswitch], 0
    je LA73
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA124
    
LA124:
    
LA125:
    ret
    
; -- Tokens --
    
PREFIX:
    
LA126:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA127
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA127
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA127
    mov edi, 10
    call test_char_equal
    
LA127:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA126
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA128
    
LA128:
    
LA129:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA130
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA130
    call DIGIT
    cmp byte [eswitch], 1
    je LA130
    
LA131:
    call DIGIT
    cmp byte [eswitch], 0
    je LA131
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA130
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA130
    
LA130:
    
LA132:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA133
    mov edi, 57
    call test_char_less_equal
    
LA133:
    
LA134:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA135
    
LA135:
    
LA136:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA137
    test_input_string "import"
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    cmp byte [eswitch], 1
    je LA137
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA137
    call ALPHA
    cmp byte [eswitch], 1
    je LA137
    
LA138:
    call ALPHA
    cmp byte [eswitch], 1
    je LA139
    
LA139:
    cmp byte [eswitch], 0
    je LA140
    call DIGIT
    cmp byte [eswitch], 1
    je LA141
    
LA141:
    
LA140:
    cmp byte [eswitch], 0
    je LA138
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA137
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA137
    
LA137:
    
LA142:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA143
    mov edi, 90
    call test_char_less_equal
    
LA143:
    cmp byte [eswitch], 0
    je LA144
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA144
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA145
    mov edi, 122
    call test_char_less_equal
    
LA145:
    
LA144:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA146
    
LA146:
    
LA147:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA148
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA148
    mov edi, 34
    call test_char_equal
    
LA149:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA148
    
LA150:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA151
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA151
    mov edi, 34
    call test_char_equal
    
LA151:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA150
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA148
    mov edi, 34
    call test_char_equal
    
LA152:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA148
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA148
    
LA148:
    
LA153:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA154
    mov edi, 34
    call test_char_equal
    
LA155:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA154
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA154
    
LA156:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA157
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA157
    mov edi, 34
    call test_char_equal
    
LA157:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA156
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA154
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA154
    mov edi, 34
    call test_char_equal
    
LA158:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA154
    
LA154:
    
LA159:
    ret
    
LISP_ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA160
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA160
    call ALPHA
    cmp byte [eswitch], 1
    je LA160
    
LA161:
    call ALPHA
    cmp byte [eswitch], 1
    je LA162
    
LA162:
    cmp byte [eswitch], 0
    je LA163
    call DIGIT
    cmp byte [eswitch], 1
    je LA164
    
LA164:
    
LA163:
    cmp byte [eswitch], 0
    je LA161
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA160
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA160
    
LA160:
    
LA165:
    ret
    
