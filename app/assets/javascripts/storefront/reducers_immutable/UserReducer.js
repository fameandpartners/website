import Immutable from 'immutable';

export const $$initialState = Immutable.fromJS({
  id: null,
  user_signed_in: null,
});

export default function UserReducer($$state = $$initialState, action = null) {
  switch (action.type) {
    default: {
      return $$state;
    }
  }
}
