import {combineReducers} from 'redux';
import {productReducer,
        discountReducer,
        productPathsReducer,
        lengthReducer,
        skirtChartReducer,
        customizeReducer} from './pdpReducers';

const rootReducer = combineReducers({
  product: productReducer,
  discount: discountReducer,
  paths: productPathsReducer,
  lengths: lengthReducer,
  skirts: skirtChartReducer,
  customize: customizeReducer
});

export default rootReducer;
