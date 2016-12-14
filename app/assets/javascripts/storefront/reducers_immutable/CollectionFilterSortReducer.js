import Immutable from 'immutable';

import actionTypes from '../constants/CollectionFilterSortConstants';

export const $$initialState = Immutable.fromJS({
  $$colors: [],
  $$secondaryColors: [],
  $$bodyShapes: [],
  selectedColors: []
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
    case actionTypes.SET_SELECTED_COLORS: {
      console.log('action', action);
      return $$state.merge({
        selectedColors: action.selectedColors
      });
    }

    default: {
      return $$state;
    }
  }
}
