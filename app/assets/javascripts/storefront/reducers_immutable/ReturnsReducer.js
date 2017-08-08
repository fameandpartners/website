import { assign } from 'lodash';
import ReturnConstants from '../constants/ReturnConstants';

// window polyfill
import win from '../polyfills/windowPolyfill';

const initialState = {
  returnArray: [],
  returnRequestErrors: {},
  returnIsLoading: false,
  returnSubtotal: 0,
  requiresViewOrdersRefresh: false,
  logisticsData: {
    // order_id: Number,
    // order_number: String,
    // final_return_by_date: Number,
    // international_customer: Bool,
    // line_items: [{
    //   line_item_id: Number
    //   item_return_label: {
    //     "return_item_state": String,
    //     "item_return_id": Number,
    //     "label_pdf_url": String,
    //     "label_image_url": String,
    //     "label_url": String,
    //   }
    // }]
  },
};

export default function (state = initialState, action) {
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
    case 'POPULATE_LOGISTICS_DATA':
      // NOTE: This is impure, but we should tightly couple a route change in the action
      win.location.hash = ReturnConstants.RETURN_ROUTES.CONFIRMATION;
      return assign({}, state, {
        requiresViewOrdersRefresh: action.payload.requiresViewOrdersRefresh,
        logisticsData: {
          order_id: action.payload.order.id,
          order_number: action.payload.order.number,
          final_return_by_date: action.payload.order.final_return_by_date,
          international_customer: action.payload.order.international_customer,
          line_items: action.payload.line_items,
        },
      });
    case 'SET_RETURN_LOADING_STATE':
      return assign({}, state, {
        returnIsLoading: action.payload.isLoading,
      });
    case 'SET_RETURN_REASON_ERRORS':
      return assign({}, state, {
        returnRequestErrors: action.payload.returnRequestErrors,
      });
    case 'SET_GUEST_EMAIL':
      return assign({}, state, {
        guestEmail: action.payload,
      });
    case 'UPDATE_PRIMARY_RETURN_REASON':
      return assign({}, state, {
        returnRequestErrors: {},
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
