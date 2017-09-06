import { compose, createStore, applyMiddleware, combineReducers } from 'redux';
import thunkMiddleware from 'redux-thunk';
import { composeWithDevTools } from 'redux-devtools-extension';
import { pick } from 'lodash';
import reducers, { initialStates } from '../reducers';

/**
 * Takes only the state for which we have acceptable key values
 * ($$appState, $$productState, etc)
 * @param  {Object} props
 * @return {Object} whiteListedProps
 */
function safetyCheckHydratedState(props) {
  const propKeys = Object.keys(props);
  const cleanKeys = propKeys.filter(k => Object.prototype.hasOwnProperty.call(initialStates, k));
  return pick(props, cleanKeys);
}

/**
 * Merges injected props with initial states
 * @param  {Object} props
 * @return {Object} hydratedProps
 */
function mergeInjectedProps(props) {
  return Object.keys(initialStates).reduce((acc, stateKey) => {
    acc[stateKey] = initialStates[stateKey].merge(props[stateKey]);
    return acc;
  }, {});
}


export default (props = {}) => {
  const whiteListedProps = safetyCheckHydratedState(props);
  const hydratedStates = mergeInjectedProps(whiteListedProps);
  const reducer = combineReducers(reducers);
  const composedStore = compose(composeWithDevTools(applyMiddleware(thunkMiddleware)));

  return composedStore(createStore)(reducer, hydratedStates);
};
