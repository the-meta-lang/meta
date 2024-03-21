import { spawn } from "bun";
import path from "path";

export const compile = async (absoluteFilePath: string) => {
	const process = spawn([path.join(import.meta.dir, "../../bootstrap/meta.bin"), absoluteFilePath]);
	const output = await new Response(process.stdout).text();

	return output;
}