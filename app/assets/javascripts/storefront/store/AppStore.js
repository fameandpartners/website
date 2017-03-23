import { compose, createStore, applyMiddleware, combineReducers, } from 'redux';
import thunkMiddleware from 'redux-thunk';
import reducers, { initialStates, } from '../reducers_immutable';
import { composeWithDevTools, } from 'redux-devtools-extension';

export default (props) => {
  const initialComments = props.comments;
  const { $$collectionFilterSortState, } = initialStates;

  const injectedState = {
    $$bodyShapes: props.bodyShapes,
    $$colors: props.colors,
    fastMaking: props.fastMaking,
    order: props.order,
    selectedColors: props.selectedColors,
    selectedPrices: props.selectedPrices,
    selectedShapes: props.selectedShapes,
    selectedStyles: props.selectedStyles,
  };

  // Merging of initial state with injected state
  const hydratedState = {
    $$collectionFilterSortStore: $$collectionFilterSortState.mergeWith((initialVal, newVal) => {
      return (newVal === null || newVal === undefined) ? initialVal : newVal;
    }, injectedState),
  };

  const reducer = combineReducers(reducers);
  const composedStore = compose(
    composeWithDevTools(applyMiddleware(thunkMiddleware))
  );

  return composedStore(createStore)(reducer, hydratedState);
};
