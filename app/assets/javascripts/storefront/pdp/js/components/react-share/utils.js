/* eslint-disable prefer-template */
import win from '../../polyfills/windowPolyfill';

export function objectToGetParams(object) {
  return '?' + Object.keys(object)
    .filter(key => !!object[key])
    .map(key => `${key}=${encodeURIComponent(object[key])}`)
    .join('&');
}

/* eslint-disable no-mixed-operators */
export function windowOpen(url, { name, height = 400, width = 550 }) {
  const left = (win.outerWidth / 2)
    + (win.screenX || win.screenLeft || 0) - (width / 2);
  const top = (win.outerHeight / 2)
    + (win.screenY || win.screenTop || 0) - (height / 2);

  const config = {
    height,
    width,
    left,
    top,
    location: 'no',
    toolbar: 'no',
    status: 'no',
    directories: 'no',
    menubar: 'no',
    scrollbars: 'yes',
    resizable: 'no',
    centerscreen: 'yes',
    chrome: 'yes',
  };

  return win.open(
    url,
    name,
    Object.keys(config).map(key => `${key}=${config[key]}`).join(', '),
  );
}
