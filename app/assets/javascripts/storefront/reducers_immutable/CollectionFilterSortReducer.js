import Immutable from 'immutable';
import FilterSortConstants from '../constants/CollectionFilterSortConstants';
import {updateExternalLegacyFilters,} from '../utilities/CollectionFilterSortUtilities';

export const $$initialState = Immutable.fromJS({
  $$colors: [],
  $$bodyShapes: [],
  $$bodyStyles: [],
  fastMaking: false,
  order: 'newest',
  selectedColors: [],
  selectedPrices: [],
  selectedShapes: [],
  selectedStyles: [],
  temporaryFilters: {
    // temporaryFilters is populating the object with the same keys as normal filters,
    // it is a simple way to temporaily save filters without applying them via ajax call
    //fastMaking, order, selectedColors, selectedPrices, selectedShapes, etc..
  },
});

export default function CollectionFilterSortReducer($$state = $$initialState, action = null) {
  switch (action.type) {
    case FilterSortConstants.APPLY_TEMPORARY_FILTERS: {
      return $$state.merge(action.temporaryFilters);
    }
    case FilterSortConstants.CLEAR_ALL_COLLECTION_FILTERS: {
      return $$state.merge(FilterSortConstants.FILTER_DEFAULTS);
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
    case FilterSortConstants.SET_SELECTED_STYLES: {
      return $$state.merge({
        selectedStyles: action.selectedStyles,
      });
    }
    case FilterSortConstants.SET_TEMPORARY_FILTERS: {
      return $$state.merge({
        temporaryFilters: action.temporaryFilters,
      });
    }
    //NO MANIPULATION
    case FilterSortConstants.UPDATE_EXTERNAL_LEGACY_FILTERS: {
      const updatedFilters = $$state.merge(action.update);
      updateExternalLegacyFilters(updatedFilters.toJS());
      return $$state;
    }
    default: {
      return $$state;
    }
  }
}
