export default function (state = null, action) {
  switch (action.type) {
    case 'UPDATE_ORDER_DATA':
      console.log(action.payload);
      return action.payload;
    default:
      return state;
  }
}
