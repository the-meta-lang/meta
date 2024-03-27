
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
    error_store 'IMPORT1'
    call vstack_clear
    call IMPORT1
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    je LA1
    error_store 'IMPORT2'
    call vstack_clear
    call IMPORT2
    call vstack_restore
    call error_clear
    cmp byte [eswitch], 1
    jne LOOP_0
    cmp byte [backtrack_switch], 1
    je LA1
    jmp terminate_program
LOOP_0:
    
LA1:
    
LA2:
    pop esi
    mov esp, ebp
    pop ebp
    ret
    
