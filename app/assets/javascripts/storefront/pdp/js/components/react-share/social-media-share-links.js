/* eslint-disable prefer-template */
import { objectToGetParams } from './utils';

export function twitter(url, { title, via, hashtags = [] }) {
  return 'https://twitter.com/share' + objectToGetParams({
    url,
    text: title,
    via,
    hashtags: hashtags.join(','),
  });
}

export function facebook(url) {
  return 'https://www.facebook.com/sharer/sharer.php' + objectToGetParams({
    u: url,
  });
}

export function pinterest(url, { media, description }) {
  return 'https://pinterest.com/pin/create/button/' + objectToGetParams({
    url,
    media,
    description,
  });
}
