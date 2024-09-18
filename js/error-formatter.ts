type CursorPosition = {
  line: number;
  column: number;
};

export function formatError(
  lines: string[],
  cursor: CursorPosition,
  maxWidth: number = 80
): void {
  const { line, column } = cursor;

  if (line < 0 || line >= lines.length) {
    console.error(`Error: Invalid line number: ${line}`);
    return;
  }

  const errorLine = lines[line];
  let start = 0;
  let end = errorLine.length;

  // Check if the line needs to be truncated
  if (errorLine.length > maxWidth) {
    const halfWidth = Math.floor(maxWidth / 2);

    // Center the error if possible, otherwise shift to keep it visible
    if (column < halfWidth) {
      // Error near the start of the line
      end = maxWidth;
    } else if (column > errorLine.length - halfWidth) {
      // Error near the end of the line
      start = errorLine.length - maxWidth;
    } else {
      // Error in the middle of a long line
      start = column - halfWidth;
      end = column + halfWidth;
    }
  }

  // Create the windowed line with ellipsis if truncated
  const truncatedLine =
    (start > 0 ? "..." : "") +
    errorLine.slice(start, end) +
    (end < errorLine.length ? "..." : "");

  // Calculate the column position relative to the truncated line
  const truncatedColumn = column - start;
  const indicatorLine = ' '.repeat(truncatedColumn) + '^'; // Position the caret

  // Print the error context with the line number and the indicator
  console.log(`Error occurred at line ${line + 1}, column ${column + 1}:\n`);
  console.log(`${line + 1} | ${truncatedLine}`);
  console.log(`${" ".repeat((line + 1).toString().length + 1)}|${indicatorLine}`);
}

export function getLineAndColumnFromLoc(loc: number, text: string): CursorPosition {
  if (loc < 0 || loc > text.length) {
    throw new Error(`Invalid loc: ${loc}. It must be between 0 and ${text.length}.`);
  }

  let line = 0;
  let column = 0;
  let currentPos = 0;

  for (let i = 0; i < text.length; i++) {
    if (currentPos === loc) {
      return { line, column };
    }

    const char = text[i];

    if (char === '\n') {
      line++;
      column = 0; // Reset column for the new line
    } else {
      column++;
    }

    currentPos++;
  }

	return { line, column }
}