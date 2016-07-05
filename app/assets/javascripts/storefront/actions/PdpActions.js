export function selectSize(customize) {
  return { type: 'SELECT_SIZE', customize };
}

export function selectLength(customize) {
  return { type: 'SELECT_LENGTH', customize };
}

export function selectColor(customize) {
  return { type: 'SELECT_COLOR', customize };
}

export function selectCustom(customize) {
  return { type: 'SELECT_CUSTOM', customize };
}
