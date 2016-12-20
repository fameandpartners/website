import assign from 'object-assign';
import mirrorCreator from 'mirror-creator';

const actionTypes = assign({},
  mirrorCreator([
    'APPLY_TEMPORARY_FILTERS',
    'CLEAR_ALL_COLLECTION_FILTER_SORTS',
    'SET_FAST_MAKING',
    'SET_SELECTED_COLORS',
    'SET_SELECTED_PRICES',
    'SET_SELECTED_SHAPES',
    'SET_TEMPORARY_FILTERS',
    'ORDER_PRODUCTS_BY',
  ]),
  { DEFAULTS :
    {
      fastMaking: undefined,
      order: undefined,
      selectedColors: [],
      selectedPrices: [],
      selectedShapes: [],
    },
  }
)


;

export default actionTypes;
