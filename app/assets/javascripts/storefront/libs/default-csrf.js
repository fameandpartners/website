/* global document */
const csrfToken = document.querySelector('meta[name="csrf-token"]') ? document.querySelector('meta[name="csrf-token"]').content : '';
const contentType = 'application/json';

export default {
  csrfToken,
  contentType,
};
