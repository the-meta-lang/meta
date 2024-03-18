
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
    call backtrack_store
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA1
    test_input_string ">"
    cmp byte [eswitch], 1
    jne LOOP_0
cmp byte [backtrack_switch], 1
    je LA1
    je terminate_program
        LOOP_0:
print "greater"
    print 0x0A
    print '    '
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_1
cmp byte [backtrack_switch], 1
    je LA1
    je terminate_program
        LOOP_1:

LA1:
    
LA2:
    cmp byte [eswitch], 1
    je LA3
    
LA3:
    
LA4:
    cmp byte [eswitch], 0
    je LA5
    call backtrack_restore
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA6
    test_input_string ">="
    cmp byte [eswitch], 1
    jne LOOP_2
cmp byte [backtrack_switch], 1
    je LA6
    je terminate_program
        LOOP_2:
print "greater equal"
    print 0x0A
    print '    '
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_3
cmp byte [backtrack_switch], 1
    je LA6
    je terminate_program
        LOOP_3:

LA6:
    
LA7:
    cmp byte [eswitch], 1
    je LA8
    
LA8:
    
LA9:
    cmp byte [eswitch], 0
    je LA5
    call backtrack_restore
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA10
    test_input_string ">=>"
    cmp byte [eswitch], 1
    jne LOOP_4
cmp byte [backtrack_switch], 1
    je LA10
    je terminate_program
        LOOP_4:
print "awdawd equal"
    print 0x0A
    print '    '
    error_store 'NUMBER'
    call vstack_clear
    call NUMBER
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_5
cmp byte [backtrack_switch], 1
    je LA10
    je terminate_program
        LOOP_5:

LA10:
    
LA11:
    cmp byte [eswitch], 1
    je LA12
    
LA12:
    
LA13:
    cmp byte [eswitch], 0
    je LA5
    call backtrack_restore
    
LA5:
    call backtrack_clear
    cmp byte [eswitch], 1
    je LA14
    
LA14:
    
LA15:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
; -- Tokens --
    
PREFIX:
    
LA16:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA17
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA17
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA17
    mov edi, 10
    call test_char_equal
    
LA17:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA16
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA18
    
LA18:
    
LA19:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA20
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA20
    call DIGIT
    cmp byte [eswitch], 1
    je LA20
    
LA21:
    call DIGIT
    cmp byte [eswitch], 0
    je LA21
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA20
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA20
    
LA20:
    
LA22:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA23
    mov edi, 57
    call test_char_less_equal
    
LA23:
    
LA24:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA25
    
LA25:
    
LA26:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA27
    test_input_string "import"
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    cmp byte [eswitch], 1
    je LA27
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA27
    call ALPHA
    cmp byte [eswitch], 1
    je LA27
    
LA28:
    call ALPHA
    cmp byte [eswitch], 1
    je LA29
    
LA29:
    cmp byte [eswitch], 0
    je LA30
    call DIGIT
    cmp byte [eswitch], 1
    je LA31
    
LA31:
    
LA30:
    cmp byte [eswitch], 0
    je LA28
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA27
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA27
    
LA27:
    
LA32:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA33
    mov edi, 90
    call test_char_less_equal
    
LA33:
    cmp byte [eswitch], 0
    je LA34
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA34
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA35
    mov edi, 122
    call test_char_less_equal
    
LA35:
    
LA34:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA36
    
LA36:
    
LA37:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA38
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA38
    mov edi, 34
    call test_char_equal
    
LA39:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA38
    
LA40:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA41
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA41
    mov edi, 34
    call test_char_equal
    
LA41:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA40
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA38
    mov edi, 34
    call test_char_equal
    
LA42:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA38
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA38
    
LA38:
    
LA43:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA44
    mov edi, 34
    call test_char_equal
    
LA45:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA44
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA44
    
LA46:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA47
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA47
    mov edi, 34
    call test_char_equal
    
LA47:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA46
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA44
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA44
    mov edi, 34
    call test_char_equal
    
LA48:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA44
    
LA44:
    
LA49:
    ret
    
