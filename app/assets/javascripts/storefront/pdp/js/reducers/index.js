import AppReducer, { $$initialState as $$appState } from './AppReducer';
import ModalReducer, { $$initialState as $$modalState } from './ModalReducer';
import ProductReducer, { $$initialState as $$productState } from './ProductReducer';
import CartReducer, { $$initialState as $$cartState } from './CartReducer';
import CustomizationReducer, { $$initialState as $$customizationState } from './CustomizationReducer';

export default {
  $$appState: AppReducer,
  $$modalState: ModalReducer,
  $$productState: ProductReducer,
  $$customizationState: CustomizationReducer,
  $$cartState: CartReducer,
};

export const initialStates = {
  $$appState,
  $$modalState,
  $$productState,
  $$customizationState,
  $$cartState,
};
