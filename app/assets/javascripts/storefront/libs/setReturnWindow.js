import moment from 'moment';
import _ from 'lodash';

export default function setReturnWindow(orders) {
  const newOrderArray = [];
  orders.map((orderData) => {
    const { spree_order: spreeOrder } = orderData;
    const { final_return_by_date: lastDayToReturn } = spreeOrder;
    const returnEligible = moment(new Date(lastDayToReturn)).unix() > moment().unix();
    const newOrderObject = _.assign({}, orderData, {
      returnEligible,
    });
    newOrderArray.push(newOrderObject);
  });
  return newOrderArray;
}
