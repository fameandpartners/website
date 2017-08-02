/* global document */
const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
const axiosDefaults = require('axios/lib/defaults');

axiosDefaults.headers.common['X-CSRF-Token'] = csrfToken;
