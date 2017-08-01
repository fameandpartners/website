export default function (state = null, action) {
  console.log('initial state', state);
  console.log('action name', action.type);
  console.log('action', action);
  console.log('*');
  console.log('');

  switch (action.type) {
    case 'UPDATE_ORDER_DATA':
      return action.payload;
    default:
      return state;
  }
}
