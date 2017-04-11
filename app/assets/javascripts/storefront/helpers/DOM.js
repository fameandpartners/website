/* global window */
/* eslint-disable import/prefer-default-export */
export function noScrollBody(shouldFreeze) {
  if (typeof window === 'object' && window.document) {
    if (shouldFreeze) {
      console.log('freezing body');
      window.document.querySelector('body').classList.add('no-scroll');
    } else {
      window.document.querySelector('body').classList.remove('no-scroll');
    }
  }
}
