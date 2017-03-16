import React from 'react';
import RD from 'react-dom';
import { Provider, } from 'react-redux';
import AppStore from '../store/AppStore';
import CollectionFilterSort from '../containers/CollectionFilterSort.jsx';
import CollectionSortMobile from '../components/CollectionSortMobile.jsx';

// GLOBAL INJECTION: Anti pattern to attach props via global scope, but currently necessary
const props = (typeof window === 'object' && typeof window.CollectionFilterSortApp === 'object') ?
  window.CollectionFilterSortApp : {};
const store = AppStore(props); // shared

// Filter sorts within 2col desktop
const CollectionFilterSortApp = () => {
  const reactComponent = (
    <Provider store={store}>
      <CollectionFilterSort />
    </Provider>
  );
  return reactComponent;
};

// Drawer Filter Pattern in mobile
const CollectionFilterMobileApp = () => {
  const reactComponent = (
    <Provider store={store}>
      <CollectionFilterSort isDrawerLayout/>
    </Provider>
  );
  return reactComponent;
};

// Drawer Sort Pattern in mobile
const CollectionSortMobileApp = () => {
  const reactComponent = (
    <Provider store={store}>
      <CollectionSortMobile/>
    </Provider>
  );
  return reactComponent;
};

const elm = document.getElementById('CollectionFilterSortApp');
const mobileFilter = document.getElementById('js-CollectionFilterMobile');
const mobileSort = document.getElementById('js-CollectionSortMobile');

if (elm){ RD.render(CollectionFilterSortApp(), elm); }
if (mobileFilter){ RD.render(CollectionFilterMobileApp(), mobileFilter); }
if (mobileSort){ RD.render(CollectionSortMobileApp(), mobileSort); }
