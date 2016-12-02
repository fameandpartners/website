import Immutable from 'immutable';

import * as actionTypes from '../constants/CollectionFilterSortConstants';

export const $$initialState = Immutable.fromJS({
  $$colors: []
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
    // case actionTypes.SET_IS_FETCHING: {
    //   return $$state.merge({
    //     isFetching: true
    //   });
    // }

    default: {
      return $$state;
    }
  }
}
