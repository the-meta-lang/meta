
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
    
LA1:
    error_store 'ASSERTION'
    call vstack_clear
    call ASSERTION
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
    je LA4
    
LA4:
    
LA5:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
ASSERTION:
    push ebp
    mov ebp, esp
    push esi
    call backtrack_store
    test_input_string "assert"
    cmp byte [eswitch], 1
    je LA6
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_0
    cmp byte [backtrack_switch], 1
    je LA6
    jmp terminate_program
LOOP_0:
    test_input_string "=="
    cmp byte [eswitch], 1
    jne LOOP_1
    cmp byte [backtrack_switch], 1
    je LA6
    jmp terminate_program
LOOP_1:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_2
    cmp byte [backtrack_switch], 1
    je LA6
    jmp terminate_program
LOOP_2:
    test_input_string ";"
    cmp byte [eswitch], 1
    jne LOOP_3
    cmp byte [backtrack_switch], 1
    je LA6
    jmp terminate_program
LOOP_3:
    print "id-number"
    print 0x0A
    
LA6:
    
LA7:
    cmp byte [eswitch], 1
    je LA8
    
LA8:
    
LA9:
    cmp byte [eswitch], 0
    je LA10
    call backtrack_restore
    test_input_string "assert"
    cmp byte [eswitch], 1
    je LA11
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_4
    cmp byte [backtrack_switch], 1
    je LA11
    jmp terminate_program
LOOP_4:
    test_input_string "=="
    cmp byte [eswitch], 1
    jne LOOP_5
    cmp byte [backtrack_switch], 1
    je LA11
    jmp terminate_program
LOOP_5:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_6
    cmp byte [backtrack_switch], 1
    je LA11
    jmp terminate_program
LOOP_6:
    test_input_string ";"
    cmp byte [eswitch], 1
    jne LOOP_7
    cmp byte [backtrack_switch], 1
    je LA11
    jmp terminate_program
LOOP_7:
    print "number-id"
    print 0x0A
    
LA11:
    
LA12:
    cmp byte [eswitch], 1
    je LA13
    
LA13:
    
LA14:
    cmp byte [eswitch], 0
    je LA10
    call backtrack_restore
    test_input_string "assert"
    cmp byte [eswitch], 1
    je LA15
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_8
    cmp byte [backtrack_switch], 1
    je LA15
    jmp terminate_program
LOOP_8:
    test_input_string "=="
    cmp byte [eswitch], 1
    jne LOOP_9
    cmp byte [backtrack_switch], 1
    je LA15
    jmp terminate_program
LOOP_9:
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_10
    cmp byte [backtrack_switch], 1
    je LA15
    jmp terminate_program
LOOP_10:
    test_input_string ";"
    cmp byte [eswitch], 1
    jne LOOP_11
    cmp byte [backtrack_switch], 1
    je LA15
    jmp terminate_program
LOOP_11:
    print "id-id"
    print 0x0A
    
LA15:
    
LA16:
    cmp byte [eswitch], 1
    je LA17
    
LA17:
    
LA18:
    cmp byte [eswitch], 0
    je LA10
    call backtrack_restore
    test_input_string "assert"
    cmp byte [eswitch], 1
    je LA19
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_12
    cmp byte [backtrack_switch], 1
    je LA19
    jmp terminate_program
LOOP_12:
    test_input_string "=="
    cmp byte [eswitch], 1
    jne LOOP_13
    cmp byte [backtrack_switch], 1
    je LA19
    jmp terminate_program
LOOP_13:
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_14
    cmp byte [backtrack_switch], 1
    je LA19
    jmp terminate_program
LOOP_14:
    test_input_string ";"
    cmp byte [eswitch], 1
    jne LOOP_15
    cmp byte [backtrack_switch], 1
    je LA19
    jmp terminate_program
LOOP_15:
    print "number-number"
    print 0x0A
    
LA19:
    
LA20:
    cmp byte [eswitch], 1
    je LA21
    
LA21:
    
LA22:
    cmp byte [eswitch], 0
    je LA10
    call backtrack_restore
    mov byte [eswitch], 1
    
LA10:
    call backtrack_clear
    cmp byte [eswitch], 1
    je LA23
    
LA23:
    
LA24:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
; -- Tokens --
    
PREFIX:
    
LA25:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA26
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA26
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA26
    mov edi, 10
    call test_char_equal
    
LA26:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA25
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA27
    
LA27:
    
LA28:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA29
    mov edi, 57
    call test_char_less_equal
    
LA29:
    
LA30:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA31
    
LA31:
    
LA32:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA33
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA33
    call ALPHA
    cmp byte [eswitch], 1
    je LA33
    
LA34:
    call ALPHA
    cmp byte [eswitch], 1
    je LA35
    
LA35:
    cmp byte [eswitch], 0
    je LA36
    call DIGIT
    cmp byte [eswitch], 1
    je LA37
    
LA37:
    
LA36:
    cmp byte [eswitch], 0
    je LA34
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA33
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA33
    
LA33:
    
LA38:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA39
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA39
    call DIGIT
    cmp byte [eswitch], 1
    je LA39
    
LA40:
    call DIGIT
    cmp byte [eswitch], 0
    je LA40
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA39
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA39
    
LA39:
    
LA41:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA42
    mov edi, 90
    call test_char_less_equal
    
LA42:
    cmp byte [eswitch], 0
    je LA43
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA43
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA44
    mov edi, 122
    call test_char_less_equal
    
LA44:
    
LA43:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA45
    
LA45:
    
LA46:
    ret
    
