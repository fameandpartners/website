import moment from 'moment';

export default function setReturnWindow(order) {
  const newOrderArray = [];
  order.map((o) => {
    const { shipDate } = o;
    const currentDay = moment();
    const shipDay = moment(new Date(shipDate));
    const shipDayArray = moment([[shipDay.format('YYYY')][0], [shipDay.format('M')][0], [shipDay.format('D')][0]]);
    const currentDayArray = moment([[currentDay.format('YYYY')][0], [currentDay.format('M')][0], [currentDay.format('D')][0]]);
    const returnEligible = currentDayArray.diff(shipDayArray, 'days') < 0;
    const newOrderObject = Object.assign({}, o, {
      returnEligible,
    });
    newOrderArray.push(newOrderObject);
  });
  console.log(newOrderObject);
  return newOrderArray;
}
