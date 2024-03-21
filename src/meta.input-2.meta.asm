
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
    
section .data
    LC1 db "id", 0x00
    
section .text
    mov esi, LC1
    call 
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
    call 
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA3
    
section .data
    LC2 db "This is my ", 0x00
    
section .text
    mov esi, LC2
    mov edi, last_match
    call strcat
    mov esi, eax
    mov esi, last_match
    mov edi, str_vector_8192
    call vector_push_string_mm32
    cmp byte [eswitch], 1
    jne LOOP_0
cmp byte [backtrack_switch], 1
    je LA3
    je terminate_program
        LOOP_0:
error_store 'name'
    call vstack_clear
    call 
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_1
cmp byte [backtrack_switch], 1
    je LA3
    je terminate_program
        LOOP_1:
test_input_string ": "
    cmp byte [eswitch], 1
    jne LOOP_2
cmp byte [backtrack_switch], 1
    je LA3
    je terminate_program
        LOOP_2:

LA3:
    
LA4:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
