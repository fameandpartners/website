import {combineReducers} from 'redux';
import {productReducer,
        imagesReducer,
        sizeChartReducer,
        discountReducer,
        productPathsReducer,
        lengthReducer,
        skirtChartReducer,
        customizeReducer,
        siteVersionReducer,
        flagsReducer} from './pdpReducers';

const rootReducer = combineReducers({
  product: productReducer,
  images: imagesReducer,
  sizeChart: sizeChartReducer,
  discount: discountReducer,
  paths: productPathsReducer,
  lengths: lengthReducer,
  skirts: skirtChartReducer,
  customize: customizeReducer,
  siteVersion: siteVersionReducer,
  flags: flagsReducer
});

export default rootReducer;
