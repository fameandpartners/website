import { compose, createStore, applyMiddleware, combineReducers, } from 'redux';
import thunkMiddleware from 'redux-thunk';
import reducers, { initialStates, } from '../reducers_immutable';
import { composeWithDevTools, } from 'redux-devtools-extension';

export default (props) => {
  const initialComments = props.comments;
  const { $$collectionFilterSortState, } = initialStates;
  const initialState = {
    $$collectionFilterSortStore: $$collectionFilterSortState.merge({
      $$bodyShapes: props.bodyShapes,
      $$colors: props.colors,
      $$secondaryColors: props.secondaryColors,
    }),
  };

  const reducer = combineReducers(reducers);
  const composedStore = compose(
    composeWithDevTools(applyMiddleware(thunkMiddleware))
  );

  return composedStore(createStore)(reducer, initialState);
};
