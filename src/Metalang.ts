

/**
 * The fully compiled version of the newest Metalang Grammar.
 */
const METALANG: string = `
ADR  PROGRAM
PROGRAM
       TST  ".SYNTAX"
       BF  A0 
       ID 
       BE 
       CL  "ADR "
       CI 
       OUT 
A1 
       JMP  DEFINITION
       BF  A2 
A2 
       BT  A3 
       JMP  COMMENT
       BF  A4 
A4 
A3 
       BT  A1 
       SET 
       BE 
       TST  ".END"
       BE 
       CL  "END"
       OUT 
A0 
A5 
       R 
OUT1
       TST  "*1"
       BF  A6 
       CL  "GN1"
       OUT 
A6 
       BT  A7 
       TST  "*2"
       BF  A8 
       CL  "GN2"
       OUT 
A8 
       BT  A7 
       TST  "*"
       BF  A9 
       CL  "CI"
       OUT 
A9 
       BT  A7 
       SR 
       BF  A10 
       CL  "CL "
       CI 
       OUT 
A10 
       BT  A7 
       TST  "#"
       BF  A11 
       NUM 
       BE 
       CL  "GROUP"
       CI 
       OUT 
A11 
A7 
       R 
OUTPUT
       TST  "->"
       BF  A12 
A13 
       TST  "("
       BT  A13 
       SET 
       BE 
A14 
       JMP  OUT1
       BT  A14 
       SET 
       BE 
       TST  ")"
       BE 
A12 
       BT  A15 
       TST  ".LABEL"
       BF  A16 
       CL  "LB"
       OUT 
       JMP  OUT1
       BE 
A16 
A15 
       BF  A17 
       CL  "OUT"
       OUT 
A17 
A18 
       R 
EX3
       ID 
       BF  A19 
       CL  "JMP "
       CI 
       OUT 
A19 
       BT  A20 
       SR 
       BF  A21 
       CL  "TST "
       CI 
       OUT 
A21 
       BT  A20 
       TST  ".ID"
       BF  A22 
       CL  "ID"
       OUT 
A22 
       BT  A20 
       TST  ".ROL"
       BF  A23 
       CL  "ROL"
       OUT 
A23 
       BT  A20 
       TST  ".NOT"
       BF  A24 
       SR 
       BE 
       CL  "NOT"
       CI 
       OUT 
A24 
       BT  A20 
       TST  "~"
       BF  A25 
       SR 
       BE 
       CL  "NOT"
       CI 
       OUT 
A25 
       BT  A20 
       TST  ".NUMBER"
       BF  A26 
       CL  "NUM"
       OUT 
A26 
       BT  A20 
       TST  ".STRING"
       BF  A27 
       CL  "SR"
       OUT 
A27 
       BT  A20 
       TST  "("
       BF  A28 
       JMP  EX1
       BE 
       TST  ")"
       BE 
A28 
       BT  A20 
       JMP  REGEXP
       BF  A29 
A29 
       BT  A20 
       TST  ".EMPTY"
       BF  A30 
       CL  "SET"
       OUT 
A30 
       BT  A20 
       TST  "$"
       BF  A31 
       LB 
       GN1 
       OUT 
       JMP  EX3
       BE 
       CL  "BT "
       GN1 
       OUT 
       CL  "SET"
       OUT 
A31 
A20 
       R 
EX2
       JMP  EX3
       BF  A32 
       CL  "BF "
       GN1 
       OUT 
A32 
       BT  A33 
       JMP  OUTPUT
       BF  A34 
A34 
A33 
       BF  A35 
A36 
       JMP  EX3
       BF  A37 
       CL  "BE"
       OUT 
A37 
       BT  A38 
       JMP  OUTPUT
       BF  A39 
A39 
A38 
       BT  A36 
       SET 
       BE 
       LB 
       GN1 
       OUT 
A35 
A40 
       R 
EX1
       JMP  EX2
       BF  A41 
A42 
       TST  "|"
       BF  A43 
       CL  "BT "
       GN1 
       OUT 
       JMP  EX2
       BE 
A43 
       BT  A44 
       JMP  COMMENT
       BF  A45 
A45 
A44 
       BT  A42 
       SET 
       BE 
       LB 
       GN1 
       OUT 
A41 
A46 
       R 
REGEXP
       TST  "/"
       BF  A47 
       NOT "/"
       BE 
       CL  "REGEXP"
       CI 
       OUT 
       TST  "/"
       BE 
A47 
A48 
       R 
DEFINITION
       ID 
       BF  A49 
       LB 
       CI 
       OUT 
       TST  "="
       BE 
       JMP  EX1
       BE 
       TST  ";"
       BE 
       CL  "R"
       OUT 
A49 
A50 
       R 
COMMENT
       TST  "["
       BF  A51 
       NOT "]"
       BE 
       TST  "]"
       BE 
A51 
A52 
       R 
       END 
       
`;

export { METALANG }