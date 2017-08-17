import CollectionFilterSortReducer, { $$initialState as $$collectionFilterSortState } from './CollectionFilterSortReducer';
import UserReducer, { $$initialState as $$userState } from './UserReducer';
import ReturnsReducer from './ReturnsReducer';
import SubtotalReducer from './SubtotalReducer';
import OrderDataReducer from './OrderDataReducer';
import ActiveTextBoxReducer from './ActiveTextBoxReducer';

export default {
  $$collectionFilterSortStore: CollectionFilterSortReducer,
  $$userStore: UserReducer,
  returnsData: ReturnsReducer,
  returnSubtotal: SubtotalReducer,
  orderData: OrderDataReducer,
  activeTextBox: ActiveTextBoxReducer,
};

export const initialStates = {
  $$collectionFilterSortState,
  $$userState,
};
