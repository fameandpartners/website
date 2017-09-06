/* global window */
import noop from '../libs/noop';

const win = typeof window === 'object'
  ? window
  : {
    document: {},
    addEventListener: noop,
    removeEventListener: noop,
  };

export default win;
