import { NumberToken } from "./Tokens/NumberToken";
import { Pointer } from "./Tokens/Pointer";
import { Register } from "./Tokens/RegisterToken";
import { StringToken } from "./Tokens/StringToken";

/**
 * The addressing mode specifies how the operand is interpreted.
 * @see https://en.wikipedia.org/wiki/Addressing_mode
 * @see https://en.wikipedia.org/wiki/X86_instruction_listings
 * 
 * We use the following structure for our encodings
 * 
 * [Prefix Bytes]    [Opcode]			[mod-reg-r/m] [Optional SIB] [Optional Displacement] [Optional Immediate]
 *   0 - 32 bits     16 bits        8 bits        8 bits					0 - 32 bits                0 - 32 bits
 * 
 * Opcodes: The opcode field specifies the operation to be performed.
 * Mod Reg R/M: This field is used to encode the addressing mode and register operands.
 * Displacement: This field holds a displacement value used in memory addressing.
 * Immediate: This field holds an immediate value.
 */
export enum AddressingModes {
	/**
	 * The operand is a constant value specified directly in the instruction.
	 * @example mov eax, 42
	 */
	IMMEDIATE = 0x00,
	/**
	 * The operand is the content of a register.
	 * @example add eax, ebx
	 */
	REGISTER = 0x01,
	/**
	 * The operand is located at the memory address stored in a register or another memory location.
	 * @example mov [variable], eax
	 */
	DIRECT = 0x02,
	/**
	 * The operand is located at the memory address stored in a register or another memory location.
	 * @example mov eax, [ebx]
	 */
	INDIRECT = 0x03,
	// NOTE: Not Implemented
	/**
	 * The operand is at the sum of a register's content and a constant offset.
	 * @example mov eax, [esi + 4]
	 */
	INDEXED = 0x04,
	/**
	 * TSimilar to indexed addressing, but with a base register and an optional offset.
	 * @example mov eax, [ebp - 8]
	 */
	BASE_REGISTER = 0x05,
	/**
	 * Combines a base register, an index register, and a scale factor.
	 * @example mov eax, [esi + edx * 4]
	 */
	SCALED_INDEXED = 0x06,
	/**
	 * TUsed for branch instructions, where the operand is a relative offset from the current instruction pointer or program counter.
	 * @example jmp short label
	 */
	RELATIVE = 0x07,
}


export function getAddressingMode(destination: Pointer | Register, source: Pointer | Register | NumberToken | StringToken) {
	if (destination instanceof Pointer) {
		return AddressingModes.DIRECT;
	} else if (destination instanceof Register) {
		if (source instanceof Pointer) {
			return AddressingModes.INDIRECT;
		} else if (source instanceof Register) {
			return AddressingModes.REGISTER;
		} else if (source instanceof NumberToken || source instanceof StringToken) {
			return AddressingModes.IMMEDIATE;
		}
	}
}