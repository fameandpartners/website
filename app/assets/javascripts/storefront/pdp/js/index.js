/* global document */
import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import App from './App';

// CSS
import '../css/index.scss';

// MOCK JSON
import productJSON from '../mock/product.json';

// Transforms
import { transformProductJSON } from './utilities/pdp';

// Store
import AppStore from './stores/AppStore';

function renderApp(Component) {
  ReactDOM.render(
    Component,
    document.getElementById('root'),
  );
}

// WARN: This can not go in production, it is just to show how hydration works
// eslint-disable-next-line
// const hydrated = (typeof window === 'object') ? window.__data : {
const hydrated = transformProductJSON(productJSON);
const store = AppStore(hydrated);

const component = <Provider store={store}><App /></Provider>;
renderApp(component);


if (module.hot) {
  module.hot.accept('./App.js', () => {
    /* eslint-disable global-require */
    const NextRootContainer = require('./App.js');
    const AppNode = (<Provider store={store}><NextRootContainer /></Provider>);
    renderApp(AppNode);
  });
}
