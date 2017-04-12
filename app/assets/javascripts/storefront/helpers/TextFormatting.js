/**
 * Takes hyphenated, underscored, and spaced words capitalizes the first letter
 * @param  {String} word
 * @param  {Array} removeChars - chars to be replaced by spaces
 * @return {String}
 */
export function cleanCapitalizeWord(word, removeChars = []){
  // 'apple' -> 'Apple'
  // 'hour_glass' -> 'Hour Glass' (removedChars: ['_'])
  // 'blue-purple' -> 'Blue-Purple'
  const capitalizedWord = word.replace(
    /(^([a-z\p{M}]))|([ -_][a-z\p{M}])/g, l => l.toUpperCase()
  );

  return removeChars.reduce((acc, cur) => acc.replace(new RegExp(cur, 'g'), ' '), capitalizedWord);
}
