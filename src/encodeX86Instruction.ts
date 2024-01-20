export function encodeX86Instruction(prefixBytes: number, opcode: number, modRegRm: number, sib = 0, displacement = 0, immediate = 0) {
  // Create a Uint32Array to store the encoded instruction
  const encodedInstruction = new Uint32Array(2);

  // Encode the first 32 bits with the prefix bytes, opcode, and mod-reg-r/m
  encodedInstruction[0] = (prefixBytes << 24) | (opcode << 16) | (modRegRm << 8);

  // Encode the remaining 32 bits with the SIB, displacement, and immediate values
  encodedInstruction[1] = (sib << 24) | (displacement << 16) | immediate;

  return encodedInstruction;
}