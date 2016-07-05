import {combineReducers} from 'redux';
import {customizeReducer,
        imageReducer,
        defaultColorReducer,
        customColorReducer,
        defaultSizesReducer,
        lengthReducer,
        sizeChartReducer,
        skirtChartReducer,
        preselectedColorReducer,
        customColorPriceReducer,
        customOptionsReducer} from './pdpReducers';

const rootReducer = combineReducers({
  customize: customizeReducer,
  images: imageReducer,
  defaultColors: defaultColorReducer,
  customColors: customColorReducer,
  customColorPrice: customColorPriceReducer,
  defaultSizes: defaultSizesReducer,
  lengths: lengthReducer,
  sizeChart: sizeChartReducer,
  skirts: skirtChartReducer,
  preselectedColor: preselectedColorReducer,
  customOptions: customOptionsReducer
});

export default rootReducer;
