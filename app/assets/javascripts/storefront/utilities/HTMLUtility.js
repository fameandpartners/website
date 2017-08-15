/**
 * Serializes an object into query string params
 * @param  {Object} obj - query params
 * @return {String} queryString
 */
export function serialize(obj) {
  const str = [];
  Object.keys(obj).forEach((key) => {
    if (Object.prototype.hasOwnProperty.call(obj, key)) {
      str.push(`${encodeURIComponent(key)}=${encodeURIComponent(obj[key])}`);
    }
  });
  return str.join('&');
}

export default {
  serialize,
};
