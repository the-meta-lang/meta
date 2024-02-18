
; Macro for printing to stdout including a newline at the end
; Expects 1 argument (string) and automatically calculates it's length and outputs it
%macro print_with_newline 1
		print %1
		call newline
%endmacro