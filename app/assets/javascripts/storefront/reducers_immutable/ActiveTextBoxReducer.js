export default function (state = null, action) {
  switch (action.type) {
    case 'ADD_PRODUCT_TO_RETURN_ARRAY':
      return action.payload.productID;
    case 'UPDATE_PRIMARY_RETURN_REASON':
      return action.payload.productID;
    case 'UPDATE_OPEN_ENDED_RETURN_REASON':
      return action.payload.productID;
    default:
      return state;
  }
}
