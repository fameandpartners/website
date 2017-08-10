import { assign } from 'lodash';

const initialState = {
  orders: [],
  hasRequestedOrders: false,
};

export default function (state = initialState, action) {
  switch (action.type) {
    case 'SET_HAS_REQUESTED_ORDERS':
      return assign({}, state, { hasRequestedOrders: action.payload.hasRequestedOrders });
    case 'UPDATE_ORDER_DATA':
      return assign({}, state, { orders: action.payload });
    default:
      return state;
  }
}
