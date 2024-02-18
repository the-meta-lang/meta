%macro label_with_newline 1
		call label
		print %1
		call newline
%endmacro