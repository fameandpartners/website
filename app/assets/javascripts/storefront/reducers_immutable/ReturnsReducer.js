import { assign } from 'lodash';

const initialState = {
  returnArray: [],
  returnSubtotal: 222,
  logisticsData: {},
};


export default function (state = initialState, action) {
  console.log('state', state);
  switch (action.type) {
    case 'ADD_PRODUCT_TO_RETURN_ARRAY':
      return assign({}, state, {
        returnArray: action.payload.returnArray,
        returnSubtotal: action.payload.returnSubtotal,
      });
    case 'REMOVE_PRODUCT_FROM_RETURN_ARRAY':
      return assign({}, state, {
        returnArray: action.payload.returnArray,
        returnSubtotal: action.payload.returnSubtotal,
      });
    case 'SET_LOGISTICS_DATA':
      return assign({}, state, {
        logisticsData: action.payload,
      });
    case 'UPDATE_PRIMARY_RETURN_REASON':
      return assign({}, state, {
        returnArray: action.payload,
      });
    case 'UPDATE_OPEN_ENDED_RETURN_REASON':
      return assign({}, state, {
        returnArray: action.payload.returnArray,
      });
    default:
      return state;
  }
}
