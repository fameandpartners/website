import CollectionFilterSortReducer, { $$initialState as $$collectionFilterSortState } from './CollectionFilterSortReducer';
import ReturnsReducer from './ReturnsReducer';
import SubtotalReducer from './SubtotalReducer';
import OrderDataReducer from './OrderDataReducer';
import ActiveTextBoxReducer from './ActiveTextBoxReducer';

export default {
  $$collectionFilterSortStore: CollectionFilterSortReducer,
  returnsData: ReturnsReducer,
  returnSubtotal: SubtotalReducer,
  orderData: OrderDataReducer,
  activeTextBox: ActiveTextBoxReducer,
};

export const initialStates = {
  $$collectionFilterSortState,
};
