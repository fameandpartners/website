import React from 'react';
import RD from 'react-dom';
import { Provider, } from 'react-redux';
import AppStore from '../store/AppStore';
import CollectionFilterSort from '../containers/CollectionFilterSort.jsx';

// GLOBAL INJECTION: Anti pattern to attach props via global scope, but currently necessary
const props = (typeof window === 'object' && typeof window.CollectionFilterSortApp === 'object') ?
  window.CollectionFilterSortApp : {};
const store = AppStore(props);

// Filter sorts within 2col desktop
const CollectionFilterSortApp = () => {
  const reactComponent = (
    <Provider store={store}>
      <CollectionFilterSort />
    </Provider>
  );
  return reactComponent;
};

// Drawer Pattern in mobile
const CollectionFilterSortMobileApp = () => {
  const reactComponent = (
    <Provider store={store}>
      <CollectionFilterSort isDrawerLayout/>
    </Provider>
  );
  return reactComponent;
};

const elm = document.getElementById('CollectionFilterSortApp');
const mobileElm = document.getElementById('CollectionFilterSortMobileApp');
if (elm){ RD.render(CollectionFilterSortApp(), elm); }
if (mobileElm){ RD.render(CollectionFilterSortMobileApp(), mobileElm); }
