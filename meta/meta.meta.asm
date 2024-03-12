
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
    call label
    print "%define MAX_INPUT_LENGTH 65536"
    call newline
    call label
    print "%include './lib/asm_macros.asm'"
    call newline
    call label
    print "section .text"
    call newline
    print "global _start"
    call newline
    
LA1:
    test_input_string ".TOKENS"
    cmp byte [eswitch], 1
    je LA2
    call label
    print "; -- Tokens --"
    call newline
    
LA3:
    call vstack_clear
    call TOKEN_DEFINITION
    call vstack_restore
    cmp byte [eswitch], 1
    je LA4
    
LA4:
    cmp byte [eswitch], 0
    je LA5
    call vstack_clear
    call COMMENT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA6
    
LA6:
    
LA5:
    cmp byte [eswitch], 0
    je LA3
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA2:
    
LA7:
    cmp byte [eswitch], 1
    je LA8
    
LA8:
    cmp byte [eswitch], 0
    je LA9
    test_input_string ".CODE"
    cmp byte [eswitch], 1
    je LA10
    call label
    print "; -- Code --"
    call newline
    
LA11:
    call vstack_clear
    call LISP
    call vstack_restore
    cmp byte [eswitch], 1
    je LA12
    
LA12:
    cmp byte [eswitch], 0
    je LA13
    call vstack_clear
    call COMMENT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA14
    
LA14:
    
LA13:
    cmp byte [eswitch], 0
    je LA11
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA10:
    
LA15:
    cmp byte [eswitch], 1
    je LA16
    
LA16:
    cmp byte [eswitch], 0
    je LA9
    test_input_string ".SYNTAX"
    cmp byte [eswitch], 1
    je LA17
    call vstack_clear
    call ID
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "_start:"
    call newline
    print "mov esi, 0"
    call newline
    print "call premalloc"
    call newline
    print "call _read_file_argument"
    call newline
    print "call _read_file"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "pop ebp"
    call newline
    print "mov edi, outbuff"
    call newline
    print "call print_mm32"
    call newline
    print "mov eax, 1"
    call newline
    print "mov ebx, 0"
    call newline
    print "int 0x80"
    call newline
    
LA18:
    call vstack_clear
    call DEFINITION
    call vstack_restore
    cmp byte [eswitch], 1
    je LA19
    
LA19:
    cmp byte [eswitch], 0
    je LA20
    call vstack_clear
    call IMPORT_STATEMENT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA21
    
LA21:
    cmp byte [eswitch], 0
    je LA20
    call vstack_clear
    call COMMENT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA22
    
LA22:
    
LA20:
    cmp byte [eswitch], 0
    je LA18
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA17:
    
LA23:
    cmp byte [eswitch], 1
    je LA24
    
LA24:
    
LA9:
    cmp byte [eswitch], 0
    je LA1
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA25:
    
LA26:
    ret
    
LISP:
    test_input_string "["
    cmp byte [eswitch], 1
    je LA27
    call vstack_clear
    call LISP_DEFINE
    call vstack_restore
    cmp byte [eswitch], 1
    je LA28
    
LA28:
    cmp byte [eswitch], 0
    je LA29
    test_input_string "defunc"
    cmp byte [eswitch], 1
    je LA30
    test_input_string "["
    cmp byte [eswitch], 1
    je terminate_program
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call copy_last_match
    print ":"
    call newline
    print "push ebp"
    call newline
    print "mov ebp, esp"
    call newline
    
LA31:
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA32
    
LA32:
    
LA33:
    cmp byte [eswitch], 0
    je LA31
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    call vstack_clear
    call LISP
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "pop eax"
    call newline
    print "mov esp, ebp"
    call newline
    print "pop ebp"
    call newline
    print "ret"
    call newline
    
LA30:
    
LA34:
    cmp byte [eswitch], 1
    je LA35
    
LA35:
    cmp byte [eswitch], 0
    je LA29
    test_input_string "set"
    cmp byte [eswitch], 1
    je LA36
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    call vstack_clear
    call LISP_ARG
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "pop eax"
    call newline
    print "mov dword ["
    mov edi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print "], eax"
    call newline
    print "push eax"
    call newline
    
LA36:
    
LA37:
    cmp byte [eswitch], 1
    je LA38
    
LA38:
    cmp byte [eswitch], 0
    je LA29
    test_input_string "+"
    cmp byte [eswitch], 1
    je LA39
    call vstack_clear
    call LISP_ARG
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    call vstack_clear
    call LISP_ARG
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "pop eax"
    call newline
    print "pop ebx"
    call newline
    print "add eax, ebx"
    call newline
    print "push eax"
    call newline
    
LA39:
    
LA40:
    cmp byte [eswitch], 1
    je LA41
    cmp byte [eswitch], 1
    je terminate_program
    
LA41:
    cmp byte [eswitch], 0
    je LA29
    test_input_string "asm"
    cmp byte [eswitch], 1
    je LA42
    call vstack_clear
    call RAW
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    call copy_last_match
    call newline
    
LA42:
    
LA43:
    cmp byte [eswitch], 1
    je LA44
    
LA44:
    cmp byte [eswitch], 0
    je LA29
    call vstack_clear
    call LISP_FN_CALL
    call vstack_restore
    cmp byte [eswitch], 1
    je LA45
    
LA45:
    
LA29:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "]"
    cmp byte [eswitch], 1
    je terminate_program
    
LA27:
    
LA46:
    ret
    
LISP_DEFINE:
    test_input_string "define"
    cmp byte [eswitch], 1
    je LA47
    call vstack_clear
    call LISP_ID
    call vstack_restore
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
    print "; -- Define "
    call copy_last_match
    print " --"
    call newline
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je LA48
    call label
    print "section .data"
    call newline
    mov edi, str_vector_8192
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
    print "mov eax, "
    mov edi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA48:
    
LA49:
    cmp byte [eswitch], 1
    je LA50
    
LA50:
    cmp byte [eswitch], 0
    je LA51
    call vstack_clear
    call STRING
    call vstack_restore
    cmp byte [eswitch], 1
    je LA52
    call label
    print "section .data"
    call newline
    mov edi, str_vector_8192
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
    mov edi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA52:
    
LA53:
    cmp byte [eswitch], 1
    je LA54
    
LA54:
    cmp byte [eswitch], 0
    je LA51
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA55
    call label
    print "section .data"
    call newline
    mov edi, str_vector_8192
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
    mov edi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print "], eax"
    call newline
    
LA55:
    
LA56:
    cmp byte [eswitch], 1
    je LA57
    
LA57:
    cmp byte [eswitch], 0
    je LA51
    test_input_string "&"
    cmp byte [eswitch], 1
    je LA58
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "section .data"
    call newline
    mov edi, str_vector_8192
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
    mov edi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print "], eax"
    call newline
    
LA58:
    
LA59:
    cmp byte [eswitch], 1
    je LA60
    
LA60:
    cmp byte [eswitch], 0
    je LA51
    call vstack_clear
    call LISP
    call vstack_restore
    cmp byte [eswitch], 1
    je LA61
    call label
    print "section .data"
    call newline
    mov edi, str_vector_8192
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
    mov edi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    print "], eax"
    call newline
    
LA61:
    
LA62:
    cmp byte [eswitch], 1
    je LA63
    
LA63:
    
LA51:
    cmp byte [eswitch], 1
    je terminate_program
    
LA47:
    
LA64:
    ret
    
LISP_FN_CALL:
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA65
    mov edi, str_vector_8192
    mov esi, last_match
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    je terminate_program
    call vstack_clear
    call LISP_CALL_ARGS
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "call "
    mov edi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call buffc
    add dword [outbuff_offset], eax
    call newline
    
LA65:
    
LA66:
    ret
    
LISP_CALL_ARGS:
    
LA67:
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je LA68
    print "mov esi, "
    call copy_last_match
    call newline
    
LA68:
    
LA69:
    cmp byte [eswitch], 1
    je LA70
    
LA70:
    cmp byte [eswitch], 0
    je LA71
    call vstack_clear
    call STRING
    call vstack_restore
    cmp byte [eswitch], 1
    je LA72
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
    
LA72:
    
LA73:
    cmp byte [eswitch], 1
    je LA74
    
LA74:
    cmp byte [eswitch], 0
    je LA71
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA75
    print "mov esi, "
    call copy_last_match
    call newline
    
LA75:
    
LA76:
    cmp byte [eswitch], 1
    je LA77
    
LA77:
    cmp byte [eswitch], 0
    je LA71
    test_input_string "&"
    cmp byte [eswitch], 1
    je LA78
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "mov esi, ["
    call copy_last_match
    print "]"
    call newline
    
LA78:
    
LA79:
    cmp byte [eswitch], 1
    je LA80
    
LA80:
    cmp byte [eswitch], 0
    je LA71
    call vstack_clear
    call LISP
    call vstack_restore
    cmp byte [eswitch], 1
    je LA81
    print "pop esi"
    call newline
    
LA81:
    
LA71:
    cmp byte [eswitch], 1
    je LA82
    
LA83:
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je LA84
    print "mov edi, "
    call copy_last_match
    call newline
    
LA84:
    
LA85:
    cmp byte [eswitch], 1
    je LA86
    
LA86:
    cmp byte [eswitch], 0
    je LA87
    call vstack_clear
    call STRING
    call vstack_restore
    cmp byte [eswitch], 1
    je LA88
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
    
LA88:
    
LA89:
    cmp byte [eswitch], 1
    je LA90
    
LA90:
    cmp byte [eswitch], 0
    je LA87
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA91
    print "mov edi, "
    call copy_last_match
    call newline
    
LA91:
    
LA92:
    cmp byte [eswitch], 1
    je LA93
    
LA93:
    cmp byte [eswitch], 0
    je LA87
    test_input_string "&"
    cmp byte [eswitch], 1
    je LA94
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "mov edi, ["
    call copy_last_match
    print "]"
    call newline
    
LA94:
    
LA95:
    cmp byte [eswitch], 1
    je LA96
    
LA96:
    cmp byte [eswitch], 0
    je LA87
    call vstack_clear
    call LISP
    call vstack_restore
    cmp byte [eswitch], 1
    je LA97
    print "pop edi"
    call newline
    
LA97:
    
LA87:
    cmp byte [eswitch], 1
    je LA98
    
LA99:
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je LA100
    print "mov edx, "
    call copy_last_match
    call newline
    
LA100:
    
LA101:
    cmp byte [eswitch], 1
    je LA102
    
LA102:
    cmp byte [eswitch], 0
    je LA103
    call vstack_clear
    call STRING
    call vstack_restore
    cmp byte [eswitch], 1
    je LA104
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
    
LA104:
    
LA105:
    cmp byte [eswitch], 1
    je LA106
    
LA106:
    cmp byte [eswitch], 0
    je LA103
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA107
    print "mov edx, "
    call copy_last_match
    call newline
    
LA107:
    
LA108:
    cmp byte [eswitch], 1
    je LA109
    
LA109:
    cmp byte [eswitch], 0
    je LA103
    test_input_string "&"
    cmp byte [eswitch], 1
    je LA110
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "mov edx, ["
    call copy_last_match
    print "]"
    call newline
    
LA110:
    
LA111:
    cmp byte [eswitch], 1
    je LA112
    
LA112:
    cmp byte [eswitch], 0
    je LA103
    call vstack_clear
    call LISP
    call vstack_restore
    cmp byte [eswitch], 1
    je LA113
    print "pop edx"
    call newline
    
LA113:
    
LA103:
    cmp byte [eswitch], 1
    je LA114
    
LA114:
    
LA115:
    cmp byte [eswitch], 0
    je LA99
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA98:
    
LA116:
    cmp byte [eswitch], 0
    je LA83
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    
LA82:
    
LA117:
    cmp byte [eswitch], 0
    je LA67
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA118
    
LA118:
    
LA119:
    ret
    
LISP_ARG:
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je LA120
    print "push "
    call copy_last_match
    call newline
    
LA120:
    cmp byte [eswitch], 0
    je LA121
    call vstack_clear
    call STRING
    call vstack_restore
    cmp byte [eswitch], 1
    je LA122
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
    
LA122:
    cmp byte [eswitch], 0
    je LA121
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA123
    print "push "
    call copy_last_match
    call newline
    
LA123:
    cmp byte [eswitch], 0
    je LA121
    test_input_string "&"
    cmp byte [eswitch], 1
    je LA124
    call vstack_clear
    call LISP_ID
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "push ["
    call copy_last_match
    print "]"
    call newline
    
LA124:
    cmp byte [eswitch], 0
    je LA121
    call vstack_clear
    call LISP
    call vstack_restore
    cmp byte [eswitch], 1
    je LA125
    
LA125:
    
LA121:
    ret
    
IMPORT_STATEMENT:
    test_input_string "import"
    cmp byte [eswitch], 1
    je LA126
    call vstack_clear
    call RAW
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ";"
    cmp byte [eswitch], 1
    je terminate_program
    mov esi, last_match
    call import_meta_file_mm32
    mov byte [eswitch], 0
    
LA126:
    
LA127:
    ret
    
OUT1:
    test_input_string "*1"
    cmp byte [eswitch], 1
    je LA128
    print "call gn1"
    call newline
    
LA128:
    cmp byte [eswitch], 0
    je LA129
    test_input_string "*2"
    cmp byte [eswitch], 1
    je LA130
    print "call gn2"
    call newline
    
LA130:
    cmp byte [eswitch], 0
    je LA129
    test_input_string "*3"
    cmp byte [eswitch], 1
    je LA131
    print "call gn3"
    call newline
    
LA131:
    cmp byte [eswitch], 0
    je LA129
    test_input_string "*4"
    cmp byte [eswitch], 1
    je LA132
    print "call gn4"
    call newline
    
LA132:
    cmp byte [eswitch], 0
    je LA129
    test_input_string "*"
    cmp byte [eswitch], 1
    je LA133
    call vstack_clear
    call ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA134
    print "mov esi, "
    call copy_last_match
    call newline
    print "mov edi, outbuff"
    call newline
    print "add edi, [outbuff_offset]"
    call newline
    print "call buffc"
    call newline
    print "add dword [outbuff_offset], eax"
    call newline
    
LA134:
    cmp byte [eswitch], 0
    je LA135
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA136
    print "call copy_last_match"
    call newline
    
LA136:
    
LA135:
    cmp byte [eswitch], 1
    je terminate_program
    
LA133:
    cmp byte [eswitch], 0
    je LA129
    test_input_string "#"
    cmp byte [eswitch], 1
    je LA137
    call vstack_clear
    call ID
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "mov esi, dword ["
    call copy_last_match
    print "]"
    call newline
    print "mov edi, outbuff"
    call newline
    print "add edi, dword [outbuff_offset]"
    call newline
    print "call inttostr"
    call newline
    print "add dword [outbuff_offset], eax"
    call newline
    
LA137:
    cmp byte [eswitch], 0
    je LA129
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA138
    print "mov edi, str_vector_8192"
    call newline
    print "call vector_pop_string"
    call newline
    print "mov esi, eax"
    call newline
    print "mov edi, outbuff"
    call newline
    print "add edi, [outbuff_offset]"
    call newline
    print "call buffc"
    call newline
    print "add dword [outbuff_offset], eax"
    call newline
    
LA138:
    cmp byte [eswitch], 0
    je LA129
    call vstack_clear
    call STRING
    call vstack_restore
    cmp byte [eswitch], 1
    je LA139
    print "print "
    call copy_last_match
    call newline
    
LA139:
    
LA129:
    ret
    
OUT_IMMEDIATE:
    call vstack_clear
    call RAW
    call vstack_restore
    cmp byte [eswitch], 1
    je LA140
    call copy_last_match
    call newline
    
LA140:
    
LA141:
    ret
    
OUTPUT:
    test_input_string "->"
    cmp byte [eswitch], 1
    je LA142
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA143:
    call vstack_clear
    call OUT1
    call vstack_restore
    cmp byte [eswitch], 1
    je LA144
    
LA144:
    
LA145:
    cmp byte [eswitch], 0
    je LA143
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "call newline"
    call newline
    
LA142:
    cmp byte [eswitch], 0
    je LA146
    test_input_string ".LABEL"
    cmp byte [eswitch], 1
    je LA147
    print "call label"
    call newline
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA148:
    call vstack_clear
    call OUT1
    call vstack_restore
    cmp byte [eswitch], 1
    je LA149
    
LA149:
    
LA150:
    cmp byte [eswitch], 0
    je LA148
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "call newline"
    call newline
    
LA147:
    cmp byte [eswitch], 0
    je LA146
    test_input_string ".RS"
    cmp byte [eswitch], 1
    je LA151
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA152:
    call vstack_clear
    call OUT1
    call vstack_restore
    cmp byte [eswitch], 1
    je LA153
    
LA153:
    
LA154:
    cmp byte [eswitch], 0
    je LA152
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA151:
    
LA146:
    cmp byte [eswitch], 1
    je LA155
    
LA155:
    cmp byte [eswitch], 0
    je LA156
    test_input_string ".DIRECT"
    cmp byte [eswitch], 1
    je LA157
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA158:
    call vstack_clear
    call OUT_IMMEDIATE
    call vstack_restore
    cmp byte [eswitch], 0
    je LA158
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA157:
    cmp byte [eswitch], 0
    je LA156
    test_input_string ".ERROR"
    cmp byte [eswitch], 1
    je LA159
    cmp byte [eswitch], 1
    je terminate_program
    print "mov dword [outbuff_offset], 0"
    call newline
    test_input_string "("
    cmp byte [eswitch], 1
    je terminate_program
    
LA160:
    call vstack_clear
    call OUT1
    call vstack_restore
    cmp byte [eswitch], 1
    je LA161
    
LA161:
    
LA162:
    cmp byte [eswitch], 0
    je LA160
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "mov edi, outbuff"
    call newline
    print "call print_mm32"
    call newline
    print "mov eax, 1"
    call newline
    print "mov ebx, 1"
    call newline
    print "int 0x80"
    call newline
    
LA159:
    
LA156:
    ret
    
EX3:
    call vstack_clear
    call ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA163
    print "call vstack_clear"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_restore"
    call newline
    
LA163:
    cmp byte [eswitch], 0
    je LA164
    call vstack_clear
    call STRING
    call vstack_restore
    cmp byte [eswitch], 1
    je LA165
    print "test_input_string "
    call copy_last_match
    call newline
    
LA165:
    cmp byte [eswitch], 0
    je LA164
    test_input_string ".RET"
    cmp byte [eswitch], 1
    je LA166
    print "ret"
    call newline
    
LA166:
    cmp byte [eswitch], 0
    je LA164
    test_input_string ".NOT"
    cmp byte [eswitch], 1
    je LA167
    call vstack_clear
    call STRING
    call vstack_restore
    cmp byte [eswitch], 1
    je LA168
    
LA168:
    cmp byte [eswitch], 0
    je LA169
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je LA170
    
LA170:
    
LA169:
    cmp byte [eswitch], 1
    je terminate_program
    print "match_not "
    call copy_last_match
    call newline
    
LA167:
    cmp byte [eswitch], 0
    je LA164
    test_input_string "%"
    cmp byte [eswitch], 1
    je LA171
    print "mov edi, str_vector_8192"
    call newline
    print "mov esi, last_match"
    call newline
    print "call vector_push_string_mm32"
    call newline
    
LA171:
    cmp byte [eswitch], 0
    je LA164
    test_input_string "("
    cmp byte [eswitch], 1
    je LA172
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA172:
    cmp byte [eswitch], 0
    je LA164
    test_input_string ".EMPTY"
    cmp byte [eswitch], 1
    je LA173
    print "mov byte [eswitch], 0"
    call newline
    
LA173:
    cmp byte [eswitch], 0
    je LA164
    test_input_string "$<"
    cmp byte [eswitch], 1
    je LA174
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "section .data"
    call newline
    print "MIN_ITER_"
    call gn3
    print " dd "
    call copy_last_match
    call newline
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA175
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "MAX_ITER_"
    call gn3
    print " dd "
    call copy_last_match
    call newline
    
LA175:
    cmp byte [eswitch], 0
    je LA176
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA177
    print "MAX_ITER_"
    call gn3
    print " dd 0xFFFFFFFF"
    call newline
    
LA177:
    
LA176:
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ">"
    cmp byte [eswitch], 1
    je terminate_program
    call label
    print "section .text"
    call newline
    print "xor ecx, ecx"
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "push ecx"
    call newline
    call vstack_clear
    call EX3
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "pop ecx"
    call newline
    print "cmp ecx, dword [MAX_ITER_"
    call gn3
    print "]"
    call newline
    print "jg "
    call gn2
    call newline
    print "cmp ecx, dword [MIN_ITER_"
    call gn3
    print "]"
    call newline
    print "jl "
    call gn1
    call newline
    print "inc ecx"
    call newline
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    call label
    call gn2
    print ":"
    call newline
    print "mov byte [eswitch], 0"
    call newline
    
LA174:
    cmp byte [eswitch], 0
    je LA164
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA178
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call EX3
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    print "mov byte [eswitch], 0"
    call newline
    
LA178:
    cmp byte [eswitch], 0
    je LA164
    call vstack_clear
    call LISP
    call vstack_restore
    cmp byte [eswitch], 1
    je LA179
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    
LA179:
    cmp byte [eswitch], 0
    je LA164
    test_input_string "::"
    cmp byte [eswitch], 1
    je LA180
    call vstack_clear
    call ID
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "; Capture "
    call copy_last_match
    print " as single node"
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    
LA180:
    cmp byte [eswitch], 0
    je LA181
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA182
    call vstack_clear
    call ID
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "<"
    cmp byte [eswitch], 1
    je terminate_program
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ">"
    cmp byte [eswitch], 1
    je terminate_program
    
LA182:
    
LA181:
    cmp byte [eswitch], 1
    je LA183
    cmp byte [eswitch], 1
    je terminate_program
    
LA183:
    cmp byte [eswitch], 0
    je LA164
    test_input_string "{"
    cmp byte [eswitch], 1
    je LA184
    cmp byte [eswitch], 1
    je terminate_program
    print "call backtrack_store"
    call newline
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA185:
    test_input_string "/"
    cmp byte [eswitch], 1
    je LA186
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "call backtrack_restore"
    call newline
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA186:
    
LA187:
    cmp byte [eswitch], 0
    je LA185
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string "}"
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    print "call backtrack_restore"
    call newline
    call label
    call gn1
    print ":"
    call newline
    print "call backtrack_clear"
    call newline
    
LA184:
    cmp byte [eswitch], 0
    je LA164
    call vstack_clear
    call COMMENT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA188
    
LA188:
    
LA164:
    ret
    
EX2:
    call vstack_clear
    call EX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA189
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    
LA189:
    cmp byte [eswitch], 0
    je LA190
    call vstack_clear
    call OUTPUT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA191
    
LA191:
    
LA190:
    cmp byte [eswitch], 1
    je LA192
    
LA193:
    call vstack_clear
    call EX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA194
    print "cmp byte [eswitch], 1"
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "je terminate_program"
    call newline
    
LA194:
    cmp byte [eswitch], 0
    je LA195
    call vstack_clear
    call OUTPUT
    call vstack_restore
    cmp byte [eswitch], 1
    je LA196
    
LA196:
    
LA195:
    cmp byte [eswitch], 0
    je LA193
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA192:
    
LA197:
    ret
    
EX1:
    call vstack_clear
    call EX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA198
    
LA199:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA200
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call EX2
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA200:
    
LA201:
    cmp byte [eswitch], 0
    je LA199
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA198:
    
LA202:
    ret
    
DEFINITION:
    call vstack_clear
    call ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA203
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    cmp byte [eswitch], 1
    je terminate_program
    call vstack_clear
    call EX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ";"
    cmp byte [eswitch], 1
    je LA204
    
LA204:
    cmp byte [eswitch], 0
    je LA205
    mov dword [outbuff_offset], 0
    print "Missing semicolon on char: "
    mov esi, dword [input_string_offset]
    mov edi, outbuff
    add edi, dword [outbuff_offset]
    call inttostr
    add dword [outbuff_offset], eax
    mov edi, outbuff
    call print_mm32
    mov eax, 1
    mov ebx, 1
    int 0x80
    
LA206:
    
LA205:
    cmp byte [eswitch], 1
    je terminate_program
    print "ret"
    call newline
    
LA203:
    
LA207:
    ret
    
TOKEN_DEFINITION:
    call vstack_clear
    call ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA208
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    cmp byte [eswitch], 1
    je terminate_program
    call vstack_clear
    call TX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ";"
    cmp byte [eswitch], 1
    je terminate_program
    print "ret"
    call newline
    
LA208:
    
LA209:
    ret
    
TX1:
    call vstack_clear
    call TX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA210
    
LA211:
    test_input_string "|"
    cmp byte [eswitch], 1
    je LA212
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call TX2
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA212:
    
LA213:
    cmp byte [eswitch], 0
    je LA211
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA210:
    
LA214:
    ret
    
TX2:
    call vstack_clear
    call TX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA215
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    
LA216:
    call vstack_clear
    call TX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA217
    print "cmp byte [eswitch], 1"
    call newline
    print "je "
    call gn1
    call newline
    
LA217:
    
LA218:
    cmp byte [eswitch], 0
    je LA216
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA215:
    
LA219:
    ret
    
TX3:
    test_input_string ".TOKEN"
    cmp byte [eswitch], 1
    je LA220
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 1"
    call newline
    print "call clear_token"
    call newline
    
LA220:
    cmp byte [eswitch], 0
    je LA221
    test_input_string ".DELTOK"
    cmp byte [eswitch], 1
    je LA222
    cmp byte [eswitch], 1
    je terminate_program
    print "mov byte [tflag], 0"
    call newline
    
LA222:
    cmp byte [eswitch], 0
    je LA221
    test_input_string "$"
    cmp byte [eswitch], 1
    je LA223
    call label
    call gn1
    print ":"
    call newline
    call vstack_clear
    call TX3
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    
LA223:
    
LA221:
    cmp byte [eswitch], 1
    je LA224
    print "mov byte [eswitch], 0"
    call newline
    
LA224:
    cmp byte [eswitch], 0
    je LA225
    test_input_string ".ANYBUT("
    cmp byte [eswitch], 1
    je LA226
    call vstack_clear
    call CX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    print "mov al, byte [eswitch]"
    call newline
    print "xor al, 1"
    call newline
    print "mov byte [eswitch], al"
    call newline
    print "call scan_or_parse"
    call newline
    
LA226:
    cmp byte [eswitch], 0
    je LA225
    test_input_string ".ANY("
    cmp byte [eswitch], 1
    je LA227
    call vstack_clear
    call CX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    print "call scan_or_parse"
    call newline
    cmp byte [eswitch], 1
    je terminate_program
    cmp byte [eswitch], 1
    je terminate_program
    
LA227:
    cmp byte [eswitch], 0
    je LA225
    test_input_string ".RESERVED("
    cmp byte [eswitch], 1
    je LA228
    
LA229:
    call vstack_clear
    call STRING
    call vstack_restore
    cmp byte [eswitch], 1
    je LA230
    print "test_input_string "
    call copy_last_match
    call newline
    print "mov al, byte [eswitch]"
    call newline
    print "xor al, 1"
    call newline
    print "mov byte [eswitch], al"
    call newline
    
LA230:
    
LA231:
    cmp byte [eswitch], 0
    je LA229
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA228:
    cmp byte [eswitch], 0
    je LA225
    call vstack_clear
    call ID
    call vstack_restore
    cmp byte [eswitch], 1
    je LA232
    print "call "
    call copy_last_match
    call newline
    
LA232:
    cmp byte [eswitch], 0
    je LA225
    test_input_string "("
    cmp byte [eswitch], 1
    je LA233
    call vstack_clear
    call TX1
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    test_input_string ")"
    cmp byte [eswitch], 1
    je terminate_program
    
LA233:
    
LA225:
    ret
    
CX1:
    call vstack_clear
    call CX2
    call vstack_restore
    cmp byte [eswitch], 1
    je LA234
    
LA235:
    test_input_string "!"
    cmp byte [eswitch], 1
    je LA236
    print "cmp byte [eswitch], 0"
    call newline
    print "je "
    call gn1
    call newline
    call vstack_clear
    call CX2
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    
LA236:
    
LA237:
    cmp byte [eswitch], 0
    je LA235
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LA234:
    
LA238:
    ret
    
CX2:
    call vstack_clear
    call CX3
    call vstack_restore
    cmp byte [eswitch], 1
    je LA239
    test_input_string ":"
    cmp byte [eswitch], 1
    je LA240
    print "mov edi, "
    call copy_last_match
    call newline
    print "call test_char_greater_equal"
    call newline
    print "cmp byte [eswitch], 0"
    call newline
    print "jne "
    call gn1
    call newline
    call vstack_clear
    call CX3
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "mov edi, "
    call copy_last_match
    call newline
    print "call test_char_less_equal"
    call newline
    call label
    call gn1
    print ":"
    call newline
    
LA240:
    cmp byte [eswitch], 0
    je LA241
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA242
    print "mov edi, "
    call copy_last_match
    call newline
    print "call test_char_equal"
    call newline
    
LA242:
    
LA241:
    cmp byte [eswitch], 1
    je terminate_program
    
LA239:
    
LA243:
    ret
    
CX3:
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je LA244
    
LA244:
    cmp byte [eswitch], 0
    je LA245
    call vstack_clear
    call STRING
    call vstack_restore
    cmp byte [eswitch], 1
    je LA246
    
LA246:
    
LA245:
    ret
    
COMMENT:
    test_input_string "//"
    cmp byte [eswitch], 1
    je LA247
    match_not 10
    cmp byte [eswitch], 1
    je terminate_program
    
LA247:
    
LA248:
    ret
    
; -- Tokens --
    
PREFIX:
    
LA249:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA250
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA250
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA250
    mov edi, 10
    call test_char_equal
    
LA250:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA249
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA251
    
LA251:
    
LA252:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA253
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA253
    call DIGIT
    cmp byte [eswitch], 1
    je LA253
    
LA254:
    call DIGIT
    cmp byte [eswitch], 0
    je LA254
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA253
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA253
    
LA253:
    
LA255:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA256
    mov edi, 57
    call test_char_less_equal
    
LA256:
    
LA257:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA258
    
LA258:
    
LA259:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA260
    test_input_string "import"
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    cmp byte [eswitch], 1
    je LA260
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA260
    call ALPHA
    cmp byte [eswitch], 1
    je LA260
    
LA261:
    call ALPHA
    cmp byte [eswitch], 1
    je LA262
    
LA262:
    cmp byte [eswitch], 0
    je LA263
    call DIGIT
    cmp byte [eswitch], 1
    je LA264
    
LA264:
    
LA263:
    cmp byte [eswitch], 0
    je LA261
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA260
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA260
    
LA260:
    
LA265:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA266
    mov edi, 90
    call test_char_less_equal
    
LA266:
    cmp byte [eswitch], 0
    je LA267
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA267
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA268
    mov edi, 122
    call test_char_less_equal
    
LA268:
    
LA267:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA269
    
LA269:
    
LA270:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA271
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA271
    mov edi, 34
    call test_char_equal
    
LA272:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA271
    
LA273:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA274
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA274
    mov edi, 34
    call test_char_equal
    
LA274:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA273
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA271
    mov edi, 34
    call test_char_equal
    
LA275:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA271
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA271
    
LA271:
    
LA276:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA277
    mov edi, 34
    call test_char_equal
    
LA278:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA277
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA277
    
LA279:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA280
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA280
    mov edi, 34
    call test_char_equal
    
LA280:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA279
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA277
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA277
    mov edi, 34
    call test_char_equal
    
LA281:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA277
    
LA277:
    
LA282:
    ret
    
LISP_ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA283
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA283
    call ALPHA
    cmp byte [eswitch], 1
    je LA283
    
LA284:
    call ALPHA
    cmp byte [eswitch], 1
    je LA285
    
LA285:
    cmp byte [eswitch], 0
    je LA286
    call DIGIT
    cmp byte [eswitch], 1
    je LA287
    
LA287:
    
LA286:
    cmp byte [eswitch], 0
    je LA284
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA283
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA283
    
LA283:
    
LA288:
    ret
    
