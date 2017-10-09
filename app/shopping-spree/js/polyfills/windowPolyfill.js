/* global window */
const win = typeof window === 'object'
  ? window
  : {
    isMockWindow: true,
    document: {},
    location: {
      href: '',
    },
  };

export default win;
