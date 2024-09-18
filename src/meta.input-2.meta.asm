
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
    error_store 'ID_REF'
    call vstack_clear
    call ID_REF
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA1
    
LA1:
    
LA2:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
ID_REF:
    push ebp
    mov ebp, esp
    push esi
    error_store 'ID'
    call vstack_clear
    call ID
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA3
    
section .data
    LC1 db "This is my: ", 0x00
    
section .text
    mov esi, LC1
    call gn4
    mov edi, eax
    call strcat
    mov esi, eax
    
section .data
    LC2 db "What up?", 0x00
    
section .text
    mov edi, LC2
    call strcat
    mov esi, eax
    mov edi, last_match
    call strcat
    mov esi, eax
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_0
    cmp byte [backtrack_switch], 1
    je LA3
    jmp terminate_program
LOOP_0:
    mov esi, str_vector_8192
    call vector_pop_string
    mov esi, eax
    mov edi, outbuff
    add edi, [outbuff_offset]
    call strcpy
    add dword [outbuff_offset], eax
    print 0x0A
    print '    '
    
LA3:
    
LA4:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
; -- Tokens --
    
PREFIX:
    
LA5:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA6
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA6
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA6
    mov edi, 10
    call test_char_equal
    
LA6:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA5
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA7
    
LA7:
    
LA8:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA9
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA9
    call DIGIT
    cmp byte [eswitch], 1
    je LA9
    
LA10:
    call DIGIT
    cmp byte [eswitch], 0
    je LA10
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA9
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA9
    
LA9:
    
LA11:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA12
    mov edi, 57
    call test_char_less_equal
    
LA12:
    
LA13:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA14
    
LA14:
    
LA15:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA16
    test_input_string_no_cursor_advance "import"
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    cmp byte [eswitch], 1
    je LA16
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA16
    call ALPHA
    cmp byte [eswitch], 1
    je LA16
    
LA17:
    call ALPHA
    cmp byte [eswitch], 1
    je LA18
    
LA18:
    cmp byte [eswitch], 0
    je LA19
    call DIGIT
    cmp byte [eswitch], 1
    je LA20
    
LA20:
    
LA19:
    cmp byte [eswitch], 0
    je LA17
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA16
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA16
    
LA16:
    
LA21:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA22
    mov edi, 90
    call test_char_less_equal
    
LA22:
    cmp byte [eswitch], 0
    je LA23
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA23
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA24
    mov edi, 122
    call test_char_less_equal
    
LA24:
    
LA23:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA25
    
LA25:
    
LA26:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA27
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA27
    mov edi, 34
    call test_char_equal
    
LA28:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA27
    
LA29:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA30
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA30
    mov edi, 34
    call test_char_equal
    
LA30:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA29
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA27
    mov edi, 34
    call test_char_equal
    
LA31:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA27
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA27
    
LA27:
    
LA32:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA33
    mov edi, 34
    call test_char_equal
    
LA34:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA33
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA33
    
LA35:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA36
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA36
    mov edi, 34
    call test_char_equal
    
LA36:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA35
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA33
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA33
    mov edi, 34
    call test_char_equal
    
LA37:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA33
    
LA33:
    
LA38:
    ret
    
