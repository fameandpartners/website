import Immutable from 'immutable';
import FilterSortConstants from '../constants/CollectionFilterSortConstants';

export const $$initialState = Immutable.fromJS({
  $$colors: [],
  $$secondaryColors: [],
  $$bodyShapes: [],
  fastMaking: false,
  order: 'newest',
  selectedColors: [],
  selectedPrices: [],
  selectedShapes: [],
});

export default function CollectionFilterSortReducer($$state = $$initialState, action = null) {
  switch (action.type) {
    case FilterSortConstants.CLEAR_ALL_COLLECTION_FILTER_SORTS: {
      return $$state.merge(FilterSortConstants.DEFAULTS);
    }
    case FilterSortConstants.ORDER_PRODUCTS_BY: {
      return $$state.merge({
        order: action.order,
      });
    }
    case FilterSortConstants.SET_FAST_MAKING: {
      return $$state.merge({
        fastMaking: action.fastMaking,
      });
    }
    case FilterSortConstants.SET_SELECTED_COLORS: {
      return $$state.merge({
        selectedColors: action.selectedColors,
      });
    }
    case FilterSortConstants.SET_SELECTED_PRICES: {
      return $$state.merge({
        selectedPrices: action.selectedPrices,
      });
    }
    case FilterSortConstants.SET_SELECTED_SHAPES: {
      return $$state.merge({
        selectedShapes: action.selectedShapes,
      });
    }

    default: {
      return $$state;
    }
  }
}
