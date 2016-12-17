import mirrorCreator from 'mirror-creator';

const actionTypes = mirrorCreator([
  'CLEAR_ALL_COLLECTION_FILTER_SORTS',
  'SET_FAST_MAKING',
  'SET_SELECTED_COLORS',
  'SET_SELECTED_PRICES',
  'SET_SELECTED_SHAPES',
  'ORDER_PRODUCTS_BY',
]);

export default actionTypes;
