import {assign,} from 'lodash';
import mirrorCreator from 'mirror-creator';

const actionTypes = assign({},
  mirrorCreator([
    'APPLY_TEMPORARY_FILTERS',
    'CLEAR_ALL_COLLECTION_FILTER_SORTS',
    'SET_FAST_MAKING',
    'SET_SELECTED_COLORS',
    'SET_SELECTED_PRICES',
    'SET_SELECTED_SHAPES',
    'SET_SELECTED_STYLES',
    'SET_TEMPORARY_FILTERS',
    'ORDER_PRODUCTS_BY',
    'UPDATE_EXTERNAL_LEGACY_FILTERS',
  ]),
  {
    DEFAULTS : {
      fastMaking: false,
      order: 'newest',
      selectedColors: [],
      selectedPrices: [],
      selectedShapes: [],
      selectedStyles: [],
    },
  },
  {
    ORDERS: {
      newest: 'Newest',
      price_high: 'Price High to Low',
      price_low: 'Price Low to High',
    },
  },
  { PRICES:
    [
      {
        id: '0-199',
        range: [0, 199,],
        presentation: '$0 - $199',
      },
      {
        id: '200-299',
        range: [200, 299,],
        presentation: '$200 - $299',
      },
      {
        id: '300-399',
        range: [300, 399,],
        presentation: '$300 - $399',
      },
  ],
  }
);

export default actionTypes;
