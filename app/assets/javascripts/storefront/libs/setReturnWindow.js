import moment from 'moment';

export default function setReturnWindow(orders) {
  const newOrderArray = [];
  orders.map((orderData) => {
    const { spree_order: spreeOrder } = orderData;
    const { final_return_by_date: lastDayToReturn } = spreeOrder;
    const returnEligible = moment(new Date(lastDayToReturn)).unix() > moment().unix();
    const newOrderObject = Object.assign({}, orderData, {
      returnEligible,
    });
    newOrderArray.push(newOrderObject);
  });
  console.log(newOrderArray);
  return newOrderArray;
}
