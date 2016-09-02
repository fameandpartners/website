import {combineReducers} from 'redux';
import {productReducer,
        imagesReducer,
        sizeChartReducer,
        discountReducer,
        productPathsReducer,
        lengthReducer,
        skirtChartReducer,
        customizeReducer,
        siteVersionReducer} from './pdpReducers';

const rootReducer = combineReducers({
  product: productReducer,
  images: imagesReducer,
  sizeChart: sizeChartReducer,
  discount: discountReducer,
  paths: productPathsReducer,
  lengths: lengthReducer,
  skirts: skirtChartReducer,
  customize: customizeReducer,
  siteVersion: siteVersionReducer
});

export default rootReducer;
