import {createStore, applyMiddleware} from 'redux';
import rootReducer from '../reducers';
import reduxImmutableStateInvariant from 'redux-immutable-state-invariant';

export default function configureStore(initialState) {
  initialState = Object.assign({}, initialState,
    {
      customize: {
        size: {
          id: '',
          presentation: ''
        }
      }
    }
  );

  return createStore(
    rootReducer,
    initialState,
    applyMiddleware(reduxImmutableStateInvariant())
  );
}
