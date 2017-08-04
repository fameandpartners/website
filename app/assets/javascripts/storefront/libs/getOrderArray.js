import _ from 'lodash';

export default function getOrderArray(items) {
  const returnEligibleArray = items.filter(i => !i.returns_meta);
  const alreadyReturnedArray = items.filter(i => i.returns_meta);
  const orderObject = {
    returnEligibleArray,
    alreadyReturnedArray,
  };
  console.log(orderObject);
}
