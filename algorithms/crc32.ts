const toUnsignedInt32 = (n: number): number => {
  if (n >= 0) {
    return n;
  }
  return 0xFFFFFFFF - (n * -1) + 1;
}
const crc32UnsignedFull = (input: string): number => {
  const encoder = new TextEncoder();
  const bytes = encoder.encode(input);
  const divisor = 0xEDB88320;
  let crc = 0xFFFFFFFF;
  for (const byte of bytes) {
    crc = (crc ^ byte);
    for (let i = 0; i < 8; i++) {
      if (crc & 1) {
        crc = (crc >>> 1) ^ divisor;
      } else {
        crc = crc >>> 1;
      }
    }
  }
  return toUnsignedInt32(crc ^ 0xFFFFFFFF);
};

console.log(crc32UnsignedFull("Hello"))