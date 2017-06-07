/* global ga */
import {assign,} from 'lodash';

function isGAAvailable() {
  return typeof window === 'object' && !!window.ga;
}

const defaultData = {
  nonInteraction: false,
};

<<<<<<< HEAD
export function trackEvent(eventData, dynamicStatus, dynamicData) {
  if (isGAAvailable()){
    dynamicStatus ? eventData.label = dynamicData : ''
=======
export function trackEvent(eventData, dynamicLabelStatus, dynamicLabelData) {
  if (isGAAvailable()){
    dynamicLabelStatus ? eventData.label = dynamicLabelData : ''
>>>>>>> 29fce2d770f582ca396f60acf49719abb8fce26d
    const event = assign({}, defaultData, eventData);
    ga('send', 'event', {
      eventCategory: event.category,
      eventAction: event.action,
      eventLabel: event.label,
      eventValue: event.value,
      nonInteraction: event.nonInteraction,
    })
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 29fce2d770f582ca396f60acf49719abb8fce26d
