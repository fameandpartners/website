/* global window */
// TODO: Bring this in from global window lib
import { assign } from 'lodash';

const initialState = {
  returnArray: [],
  returnSubtotal: 0,
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
      // TODO: 1. clicking on a button to view shipping label transforms logisticsData here or in component
      // TODO: 2. Do not use string for route, reference a constant file.
      window.location.hash = '/return-confirmation';
      return assign({}, state, {
        logisticsData: {
          order_id: action.payload.order.id,
          order_number: action.payload.order.number,
          final_return_by_date: action.payload.order.final_return_by_date,
          international_customer: action.payload.order.international_customer,
          line_items: action.payload.line_items,
        },
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
