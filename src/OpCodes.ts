export const OpCodes = {
	// MOV instructions
	// https://www.felixcloutier.com/x86/mov
	MOV_REGISTER_IMMEDIATE: 0xB8,
	MOV_REGISTER_REGISTER: 0x89,
	MOV_MEMORY_REGISTER: 0x89,
	MOV_MEMORY_IMMEDIATE: 0xC7,
}