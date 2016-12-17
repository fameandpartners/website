import Immutable from 'immutable';

import actionTypes from '../constants/CollectionFilterSortConstants';

export const $$initialState = Immutable.fromJS({
  $$colors: [],
  $$secondaryColors: [],
  $$bodyShapes: [],
  fastMaking: undefined,
  order: 'newest',
  selectedColors: [],
  selectedPrices: [],
  selectedShapes: [],
});

export default function CollectionFilterSortReducer($$state = $$initialState, action = null) {
  switch (action.type) {

    // case actionTypes.SUBMIT_COMMENT_SUCCESS: {
    //   return $$state.withMutations(state => (
    //     state
    //       .updateIn(
    //         ['$$colors'],
    //         $$colors => $$colors.unshift(Immutable.fromJS(action.comment))
    //       )
    //       .merge({
    //         submitCommentError: null,
    //         isSaving: false
    //       })
    //   ));
    // }
    //
    case actionTypes.CLEAR_ALL_COLLECTION_FILTER_SORTS: {
      // TODO @elgrecode: Push these defaults to constants
      return $$state.merge({
        fastMaking: undefined,
        order: 'newest',
        selectedColors: [],
        selectedPrices: [],
        selectedShapes: [],
      });
    }

    case actionTypes.ORDER_PRODUCTS_BY: {
      return $$state.merge({
        order: action.order,
      });
    }

    case actionTypes.SET_FAST_MAKING: {
      return $$state.merge({
        fastMaking: action.fastMaking,
      });
    }

    case actionTypes.SET_SELECTED_COLORS: {
      return $$state.merge({
        selectedColors: action.selectedColors,
      });
    }

    case actionTypes.SET_SELECTED_PRICES: {
      return $$state.merge({
        selectedPrices: action.selectedPrices,
      });
    }

    case actionTypes.SET_SELECTED_SHAPES: {
      return $$state.merge({
        selectedShapes: action.selectedShapes,
      });
    }

    default: {
      return $$state;
    }
  }
}
