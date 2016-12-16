import mirrorCreator from 'mirror-creator';

const actionTypes = mirrorCreator([
  'SET_SELECTED_COLORS',
  'SET_SELECTED_PRICES',
  'SET_SELECTED_SHAPES',
]);

export default actionTypes;
