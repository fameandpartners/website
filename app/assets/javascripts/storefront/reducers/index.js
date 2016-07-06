import {combineReducers} from 'redux';
import {customizeReducer,
        imageReducer,
        productPriceReducer,
        productDiscountReducer,
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
  productPrice: productPriceReducer,
  productDiscount: productDiscountReducer,
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
