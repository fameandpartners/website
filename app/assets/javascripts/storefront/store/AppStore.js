import { compose, createStore, applyMiddleware, combineReducers } from 'redux';
import thunkMiddleware from 'redux-thunk';
import { composeWithDevTools } from 'redux-devtools-extension';
import reducers, { initialStates } from '../reducers_immutable';

export default (props) => {
  const { $$userState } = initialStates;

  // Merging of initial state with injected state
  const hydratedState = {
    $$userStore: $$userState.merge(props.user),
  };

  const reducer = combineReducers(reducers);
  const composedStore = compose(
    composeWithDevTools(applyMiddleware(thunkMiddleware)),
  );

  return composedStore(createStore)(reducer, hydratedState);
};
