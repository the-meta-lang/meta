%define MAX_INPUT_LENGTH 65536
    
%include './lib/asm_macros.asm'
    
section .data
    x db "awd", 0x00
    
section .text
    global _start
    
_start:
    call _read_file_argument
    call _read_file
    call PROGRAM
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
    
LB1:
    test_input_string ".DATA"
    jne LB2
    call label
    print "section .data"
    call newline
    
LB3:
    vstack_push 0xFFFF
    call DATA_DEFINITION
    call vstack_pop
    jne LB4
    
LB4:
    
LB5:
    je LB3
    call set_true
    jne terminate_program
    
LB2:
    je LB6
    test_input_string ".SYNTAX"
    jne LB7
    call test_for_id
    jne terminate_program
    call label
    print "section .text"
    call newline
    print "global _start"
    call newline
    call label
    print "_start:"
    call newline
    print "call _read_file_argument"
    call newline
    print "call _read_file"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "mov eax, 1"
    call newline
    print "mov ebx, 0"
    call newline
    print "int 0x80"
    call newline
    
LB8:
    vstack_push 0xFFFF
    call DEFINITION
    call vstack_pop
    jne LB9
    
LB9:
    
LB10:
    je LB8
    call set_true
    jne terminate_program
    test_input_string ".END"
    jne terminate_program
    
LB7:
    
LB6:
    je LB1
    call set_true
    jne terminate_program
    
LB11:
    
LB12:
    ret
    
DATA_DEFINITION:
    call test_for_id
    jne LB13
    call copy_last_match
    test_input_string "="
    jne terminate_program
    vstack_push 0xFFFF
    call DATA_TYPE
    call vstack_pop
    jne terminate_program
    test_input_string ";"
    jne terminate_program
    
LB13:
    
LB14:
    ret
    
DATA_TYPE:
    call test_for_string
    jne LB15
    print " db "
    call copy_last_match
    print ", 0x00"
    call newline
    
LB15:
    
LB16:
    jne LB17
    
LB17:
    je LB18
    call test_for_number
    jne LB19
    print " dd "
    call copy_last_match
    call newline
    
LB19:
    
LB20:
    jne LB21
    
LB21:
    
LB18:
    ret
    
OUT1:
    test_input_string "*1"
    jne LB22
    print "call gn1"
    call newline
    
LB22:
    je LB23
    test_input_string "*2"
    jne LB24
    print "call gn2"
    call newline
    
LB24:
    je LB23
    test_input_string "*"
    jne LB25
    print "call copy_last_match"
    call newline
    
LB25:
    je LB23
    test_input_string "["
    jne LB26
    call test_for_id
    jne terminate_program
    print "print_ref "
    call copy_last_match
    call newline
    test_input_string "]"
    jne terminate_program
    
LB26:
    je LB23
    call test_for_string
    jne LB27
    print "print "
    call copy_last_match
    call newline
    
LB27:
    
LB23:
    ret
    
OUTPUT:
    test_input_string "->"
    jne LB28
    test_input_string "("
    jne terminate_program
    
LB29:
    vstack_push 0xFFFF
    call OUT1
    call vstack_pop
    je LB29
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    print "call newline"
    call newline
    
LB28:
    je LB30
    test_input_string ".LABEL"
    jne LB31
    print "call label"
    call newline
    test_input_string "("
    jne terminate_program
    
LB32:
    vstack_push 0xFFFF
    call OUT1
    call vstack_pop
    je LB32
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    print "call newline"
    call newline
    
LB31:
    je LB30
    test_input_string ".RS"
    jne LB33
    test_input_string "("
    jne terminate_program
    
LB34:
    vstack_push 0xFFFF
    call OUT1
    call vstack_pop
    je LB34
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB33:
    
LB30:
    jne LB35
    
LB35:
    je LB36
    test_input_string ".OUT"
    jne LB37
    test_input_string "("
    jne terminate_program
    
LB38:
    vstack_push 0xFFFF
    call OUT1
    call vstack_pop
    je LB38
    call set_true
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB37:
    
LB36:
    ret
    
EX3:
    call test_for_id
    jne LB39
    print "vstack_push 0xFFFF"
    call newline
    print "call "
    call copy_last_match
    call newline
    print "call vstack_pop"
    call newline
    
LB39:
    je LB40
    call test_for_string
    jne LB41
    print "test_input_string "
    call copy_last_match
    call newline
    
LB41:
    je LB40
    test_input_string ".ID"
    jne LB42
    print "call test_for_id"
    call newline
    
LB42:
    je LB40
    test_input_string ".RET"
    jne LB43
    print "ret"
    call newline
    
LB43:
    je LB40
    test_input_string ".NOT"
    jne LB44
    call test_for_string
    jne terminate_program
    print "match_not "
    call copy_last_match
    call newline
    
LB44:
    je LB40
    test_input_string ".NUMBER"
    jne LB45
    print "call test_for_number"
    call newline
    
LB45:
    je LB40
    test_input_string ".STRING"
    jne LB46
    print "call test_for_string"
    call newline
    
LB46:
    je LB40
    test_input_string "("
    jne LB47
    vstack_push 0xFFFF
    call EX1
    call vstack_pop
    jne terminate_program
    test_input_string ")"
    jne terminate_program
    
LB47:
    je LB40
    test_input_string ".EMPTY"
    jne LB48
    print "call set_true"
    call newline
    
LB48:
    je LB40
    test_input_string "$"
    jne LB49
    call label
    call gn1
    print ":"
    call newline
    vstack_push 0xFFFF
    call EX3
    call vstack_pop
    jne terminate_program
    print "je "
    call gn1
    call newline
    print "call set_true"
    call newline
    
LB49:
    
LB40:
    ret
    
EX2:
    vstack_push 0xFFFF
    call EX3
    call vstack_pop
    jne LB50
    print "jne "
    call gn1
    call newline
    
LB50:
    je LB51
    vstack_push 0xFFFF
    call OUTPUT
    call vstack_pop
    jne LB52
    
LB52:
    
LB51:
    jne LB53
    
LB54:
    vstack_push 0xFFFF
    call EX3
    call vstack_pop
    jne LB55
    print "jne terminate_program"
    call newline
    
LB55:
    je LB56
    vstack_push 0xFFFF
    call OUTPUT
    call vstack_pop
    jne LB57
    
LB57:
    
LB56:
    je LB54
    call set_true
    jne terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LB53:
    
LB58:
    ret
    
EX1:
    vstack_push 0xFFFF
    call EX2
    call vstack_pop
    jne LB59
    
LB60:
    test_input_string "|"
    jne LB61
    print "je "
    call gn1
    call newline
    vstack_push 0xFFFF
    call EX2
    call vstack_pop
    jne terminate_program
    
LB61:
    
LB62:
    je LB60
    call set_true
    jne terminate_program
    call label
    call gn1
    print ":"
    call newline
    
LB59:
    
LB63:
    ret
    
DEFINITION:
    call test_for_id
    jne LB64
    call label
    call copy_last_match
    print ":"
    call newline
    test_input_string "="
    jne terminate_program
    vstack_push 0xFFFF
    call EX1
    call vstack_pop
    jne terminate_program
    test_input_string ";"
    jne terminate_program
    print "ret"
    call newline
    
LB64:
    
LB65:
    ret