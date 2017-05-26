/* global ga */
import {assign,} from 'lodash';

function isGAAvailable() {
  return typeof window === 'object' && !!window.ga;
}

const defaultData = {
  nonInteraction: false,
};

export function trackEvent(eventData, dynamicStatus, dynamicData) {
  if (isGAAvailable()){
    dynamicStatus ? eventData.label = dynamicData : ''
    const event = assign({}, defaultData, eventData);
    ga('send', 'event', {
      eventCategory: event.category,
      eventAction: event.action,
      eventLabel: event.label,
      nonInteraction: event.nonInteraction,
    })
  }
}