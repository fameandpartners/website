import CollectionFilterSortReducer, { $$initialState as $$collectionFilterSortState, } from './CollectionFilterSortReducer';
import ReturnArrayReducer from './returnArrayReducer'
import SubtotalReducer from './SubtotalReducer'
import OrderDataReducer from './OrderDataReducer'
import ActiveTextBoxReducer from './ActiveTextBoxReducer'

export default {
  $$collectionFilterSortStore: CollectionFilterSortReducer,
  returnArray: ReturnArrayReducer,
  returnSubtotal: SubtotalReducer,
  orderData: OrderDataReducer,
  activeTextBox: ActiveTextBoxReducer,
};

export const initialStates = {
  $$collectionFilterSortState,
};
