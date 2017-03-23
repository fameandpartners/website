import React from 'react';
import RD from 'react-dom';
import assign from 'object-assign';
import { Provider, } from 'react-redux';
import AppStore from '../store/AppStore';
import {decodeQueryParams,} from '../helpers/BOM';
import {convertURLPrices,} from '../utilities/CollectionFilterSortUtilities';
import CollectionFilter from '../components/CollectionFilter.jsx';
import CollectionSort from '../components/CollectionSort.jsx';
import CollectionSortMobile from '../components/CollectionSortMobile.jsx';

// GLOBAL INJECTION: Anti pattern to attach props via global scope, but currently necessary
let props = {};
if (typeof window === 'object' && typeof window.CollectionFilterData === 'object'){
  // Converting legacy filtering from url
  let filterSorts = {};
  const queryObj = decodeQueryParams();

  // Whitelisting query params for hydration
  if (queryObj.order){ filterSorts.order = queryObj.order; }
  if (queryObj.fast_making){ filterSorts.fastMaking = true; }
  if (queryObj.price_min && queryObj.price_max){
    filterSorts.selectedPrices = convertURLPrices(queryObj.price_max);
  } // TODO: translate prices here
  if (queryObj.bodyshape){
    filterSorts.selectedShapes = Array.isArray(queryObj.bodyshape)
    ? queryObj.bodyshape
    : [queryObj.bodyshape,];
  }
  if (queryObj.color){
    filterSorts.selectedColors = Array.isArray(queryObj.color)
    ? queryObj.color
    : [queryObj.color,];
  }
  props = assign({}, window.CollectionFilterData, filterSorts);
}

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

const filterNode = document.getElementById('CollectionFilterApp');
const sortNode = document.getElementById('CollectionSortApp');
const mobileFilterNode = document.getElementById('js-CollectionFilterMobile');
const mobileSortNode = document.getElementById('js-CollectionSortMobile');

if (filterNode){ RD.render(CollectionFilterApp(), filterNode); }
if (sortNode){ RD.render(CollectionSortApp(), sortNode); }
if (mobileFilterNode){ RD.render(CollectionFilterMobileApp(), mobileFilterNode); }
if (mobileSortNode){ RD.render(CollectionSortMobileApp(), mobileSortNode); }
