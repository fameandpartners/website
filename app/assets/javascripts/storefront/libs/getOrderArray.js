import _ from 'lodash';

export default function getOrderArray(items) {
  const grouped = _.groupBy(items, p => p.trackingNumber);
  const trackingNumberArray = Object.keys(grouped);
  const orderArray = [];
  trackingNumberArray.map(i => orderArray.push(grouped[trackingNumberArray[i]]));
  return orderArray;
}
