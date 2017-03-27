/* global ga */
import assign from 'object-assign';

function isGAAvailable() {
  return typeof window === 'object' && !!window.ga;
}

const defaultData = {
  nonInteraction: false,
};

export function trackEvent(eventData) {
  if (isGAAvailable()){
    const event = assign({}, defaultData, eventData);

    ga('send', 'event', {
      eventCategory: event.category,
      eventAction: event.action,
      eventLabel: event.label,
      nonInteraction: event.nonInteraction,
    });
  }


}
