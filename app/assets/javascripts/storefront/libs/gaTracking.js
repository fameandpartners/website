/* global ga */
import {assign,} from 'lodash';

const defaultData = {
  nonInteraction: false,
};

export function trackEvent(eventData, dynamicLabelStatus, dynamicLabelData) {
  dynamicLabelStatus ? eventData.label = dynamicLabelData : '';
  const event = assign({}, defaultData, eventData);

  window.dataLayer.push({
    event: event.action,
    eventDetail: { category: event.category, label: event.label },
  });
}
