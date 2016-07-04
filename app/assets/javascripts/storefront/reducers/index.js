import {combineReducers} from 'redux';
import {customizeReducer,
        imageReducer,
        colorReducer,
        defaultSizesReducer,
        lengthReducer,
        sizeChartReducer,
        skirtChartReducer} from './pdpReducers';

const rootReducer = combineReducers({
  customize: customizeReducer,
  images: imageReducer,
  colors: colorReducer,
  defaultSizes: defaultSizesReducer,
  lengths: lengthReducer,
  sizeChart: sizeChartReducer,
  skirts: skirtChartReducer
});

export default rootReducer;
