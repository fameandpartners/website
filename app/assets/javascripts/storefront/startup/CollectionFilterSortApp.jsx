import React from 'react';
import RD from 'react-dom';
import {assign,} from 'lodash';
import { Provider, } from 'react-redux';
import AppStore from '../store/AppStore';
import { buildWhiteListedFilterSortProps, } from '../utilities/CollectionFilterSortUtilities';
import CollectionFilter from '../components/CollectionFilter.jsx';
import CollectionSort from '../components/CollectionSort.jsx';
import CollectionSortMobile from '../components/CollectionSortMobile.jsx';

// GLOBAL INJECTION PATTERN: Anti pattern to attach props via global scope (currently necessary)
const props = buildWhiteListedFilterSortProps();
const store = AppStore(props); // shared

// Filter sorts within 2col desktop
const CollectionFilterApp = () => {
  return (
    <Provider store={store}>
      <CollectionFilter />
    </Provider>
  );
};
// Filter sorts within 2col desktop
const CollectionSortApp = () => {
  return (
    <Provider store={store}>
      <CollectionSort />
    </Provider>
  );
};

// Drawer Filter Pattern in mobile
const CollectionFilterMobileApp = () => {
  return (
    <Provider store={store}>
      <CollectionFilter isDrawerLayout/>
    </Provider>
  );
};

// Drawer Sort Pattern in mobile
const CollectionSortMobileApp = () => {
  return (
    <Provider store={store}>
      <CollectionSortMobile/>
    </Provider>
  );
};

// Nodes for Mounting
const filterNode = document.getElementById('js-CollectionFilterApp');
const sortNode = document.getElementById('js-CollectionSortApp');
const mobileFilterNode = document.getElementById('js-CollectionFilterMobile');
const mobileSortNode = document.getElementById('js-CollectionSortMobile');

// Mounting of Nodes
if (filterNode){ RD.render(CollectionFilterApp(), filterNode); }
if (sortNode){ RD.render(CollectionSortApp(), sortNode); }
if (mobileFilterNode){ RD.render(CollectionFilterMobileApp(), mobileFilterNode); }
if (mobileSortNode){ RD.render(CollectionSortMobileApp(), mobileSortNode); }
