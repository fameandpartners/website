import {combineReducers} from 'redux';
import {customizeReducer,
        imageReducer,
        colorReducer,
        defaultSizesReducer,
        sizeChartReducer} from './pdpReducers';

const rootReducer = combineReducers({
  customize: customizeReducer,
  images: imageReducer,
  colors: colorReducer,
  defaultSizes: defaultSizesReducer,
  sizeChart: sizeChartReducer
});

export default rootReducer;
