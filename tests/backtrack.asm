
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
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je LA1
    call copy_last_match
    call newline
    call backtrack_store
    test_input_string "<"
    cmp byte [eswitch], 1
    je LA2
    call vstack_clear
    call NUMBER
    call vstack_restore
    cmp byte [eswitch], 1
    je LA2
    print "; lt "
    call copy_last_match
    call newline
    
LA2:
    
LA3:
    cmp byte [eswitch], 0
    je LA4
    call backtrack_restore
    test_input_string "<-"
    cmp byte [eswitch], 1
    je LA5
    call vstack_clear
    call ID
    call vstack_restore
    cmp byte [eswitch], 1
    je terminate_program
    print "; bind "
    call copy_last_match
    call newline
    
LA5:
    
LA6:
    cmp byte [eswitch], 0
    je LA4
    call backtrack_restore
    
LA4:
    call backtrack_clear
    cmp byte [eswitch], 1
    je terminate_program
    
LA1:
    
LA7:
    ret
    
; -- Tokens --
    
PREFIX:
    
LA8:
    mov edi, 32
    call test_char_equal
    cmp byte [eswitch], 0
    je LA9
    mov edi, 9
    call test_char_equal
    cmp byte [eswitch], 0
    je LA9
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA9
    mov edi, 10
    call test_char_equal
    
LA9:
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA8
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA10
    
LA10:
    
LA11:
    ret
    
NUMBER:
    call PREFIX
    cmp byte [eswitch], 1
    je LA12
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA12
    call DIGIT
    cmp byte [eswitch], 1
    je LA12
    
LA13:
    call DIGIT
    cmp byte [eswitch], 0
    je LA13
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA12
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA12
    
LA12:
    
LA14:
    ret
    
DIGIT:
    mov edi, 48
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA15
    mov edi, 57
    call test_char_less_equal
    
LA15:
    
LA16:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA17
    
LA17:
    
LA18:
    ret
    
ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA19
    test_input_string "import"
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    cmp byte [eswitch], 1
    je LA19
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA19
    call ALPHA
    cmp byte [eswitch], 1
    je LA19
    
LA20:
    call ALPHA
    cmp byte [eswitch], 1
    je LA21
    
LA21:
    cmp byte [eswitch], 0
    je LA22
    call DIGIT
    cmp byte [eswitch], 1
    je LA23
    
LA23:
    
LA22:
    cmp byte [eswitch], 0
    je LA20
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA19
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA19
    
LA19:
    
LA24:
    ret
    
ALPHA:
    mov edi, 65
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA25
    mov edi, 90
    call test_char_less_equal
    
LA25:
    cmp byte [eswitch], 0
    je LA26
    mov edi, 95
    call test_char_equal
    cmp byte [eswitch], 0
    je LA26
    mov edi, 97
    call test_char_greater_equal
    cmp byte [eswitch], 0
    jne LA27
    mov edi, 122
    call test_char_less_equal
    
LA27:
    
LA26:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA28
    
LA28:
    
LA29:
    ret
    
STRING:
    call PREFIX
    cmp byte [eswitch], 1
    je LA30
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA30
    mov edi, 34
    call test_char_equal
    
LA31:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA30
    
LA32:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA33
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA33
    mov edi, 34
    call test_char_equal
    
LA33:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA32
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA30
    mov edi, 34
    call test_char_equal
    
LA34:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA30
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA30
    
LA30:
    
LA35:
    ret
    
RAW:
    call PREFIX
    cmp byte [eswitch], 1
    je LA36
    mov edi, 34
    call test_char_equal
    
LA37:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA36
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA36
    
LA38:
    mov edi, 13
    call test_char_equal
    cmp byte [eswitch], 0
    je LA39
    mov edi, 10
    call test_char_equal
    cmp byte [eswitch], 0
    je LA39
    mov edi, 34
    call test_char_equal
    
LA39:
    mov al, byte [eswitch]
    xor al, 1
    mov byte [eswitch], al
    call scan_or_parse
    cmp byte [eswitch], 0
    je LA38
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA36
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA36
    mov edi, 34
    call test_char_equal
    
LA40:
    call scan_or_parse
    cmp byte [eswitch], 1
    je LA36
    
LA36:
    
LA41:
    ret
    
LISP_ID:
    call PREFIX
    cmp byte [eswitch], 1
    je LA42
    mov byte [tflag], 1
    call clear_token
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA42
    call ALPHA
    cmp byte [eswitch], 1
    je LA42
    
LA43:
    call ALPHA
    cmp byte [eswitch], 1
    je LA44
    
LA44:
    cmp byte [eswitch], 0
    je LA45
    call DIGIT
    cmp byte [eswitch], 1
    je LA46
    
LA46:
    
LA45:
    cmp byte [eswitch], 0
    je LA43
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA42
    mov byte [tflag], 0
    mov byte [eswitch], 0
    cmp byte [eswitch], 1
    je LA42
    
LA42:
    
LA47:
    ret
    