import {combineReducers} from 'redux';
import {productReducer,
        imagesReducer,
        discountReducer,
        productPathsReducer,
        lengthReducer,
        skirtChartReducer,
        customizeReducer} from './pdpReducers';

const rootReducer = combineReducers({
  product: productReducer,
  images: imagesReducer,
  discount: discountReducer,
  paths: productPathsReducer,
  lengths: lengthReducer,
  skirts: skirtChartReducer,
  customize: customizeReducer
});

export default rootReducer;
