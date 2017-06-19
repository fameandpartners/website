/* global ga */
import {assign,} from 'lodash';

function isGAAvailable() {
  return typeof window === 'object' && !!window.ga;
}

const defaultData = {
  nonInteraction: false,
};

export function trackEvent(eventData, dynamicLabelStatus, dynamicLabelData) {
  if (isGAAvailable()){
    dynamicLabelStatus ? eventData.label = dynamicLabelData : ''
    const event = assign({}, defaultData, eventData);
    ga('send', 'event', {
      eventCategory: event.category,
      eventAction: event.action,
      eventLabel: event.label,
      eventValue: event.value,
      nonInteraction: event.nonInteraction,
    })
  }
}