import { combineReducers } from 'redux';
import {
  productReducer,
  imagesReducer,
  sizeChartReducer,
  discountReducer,
  productPathsReducer,
  lengthReducer,
  skirtChartReducer,
  addonsReducer,
  customizeReducer,
  siteVersionReducer,
  flagsReducer
} from './pdpReducers';

import SlayItForwardReducer from './SlayItForwardReducer';
import { initialState as SlayItForwardState } from './SlayItForwardReducer';

const rootReducer = combineReducers({
  product: productReducer,
  images: imagesReducer,
  sizeChart: sizeChartReducer,
  discount: discountReducer,
  paths: productPathsReducer,
  lengths: lengthReducer,
  skirts: skirtChartReducer,
  addons: addonsReducer,
  customize: customizeReducer,
  siteVersion: siteVersionReducer,
  flags: flagsReducer,
  SlayItForwardStore: SlayItForwardReducer
});

export const initialStates = {
  SlayItForwardState
};

export default rootReducer;
