/* global window */
const win = typeof window === 'object'
  ? window
  : { document: {} };

export default win;
