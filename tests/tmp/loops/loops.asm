
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
    test_input_string "loop"
    cmp byte [eswitch], 1
    je LA2
    print "loop"
    print 0x0A
    
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
    