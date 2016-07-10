import {combineReducers} from 'redux';
import {productReducer,
        discountReducer,
        lengthReducer,
        skirtChartReducer,
        customizeReducer} from './pdpReducers';

const rootReducer = combineReducers({
  product: productReducer,
  discount: discountReducer,
  lengths: lengthReducer,
  skirts: skirtChartReducer,
  customize: customizeReducer
});

export default rootReducer;
