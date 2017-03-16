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
      order: 'newest',
      selectedColors: [],
      selectedPrices: [],
      selectedShapes: [],
    },
  },
  { ORDERS:
    {
      newest: 'What\'s New',
      price_high: 'Price High to Low',
      price_low: 'Price Low to High',
    }
  }
);

export default actionTypes;
