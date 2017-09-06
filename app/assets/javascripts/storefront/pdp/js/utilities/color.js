/* eslint-disable no-bitwise */
export function luminanceFromHex(hexStr) {
  const cleanHexStr = hexStr.length === 7 ? hexStr.substring(1) : hexStr;
  const rgb = parseInt(cleanHexStr, 16);   // convert rrggbb to decimal
  const r = (rgb >> 16) & 0xff;  // bitwise extract red
  const g = (rgb >> 8) & 0xff;  // bitwise extract green
  const b = (rgb >> 0) & 0xff;  // bitwise extract blue
  return (0.2126 * r) + (0.7152 * g) + (0.0722 * b); // per ITU-R BT.709
}

export function isDarkLuminance(hexStr) {
  return luminanceFromHex(hexStr) < 70;
}


export default {
  luminanceFromHex,
  isDarkLuminance,
};
