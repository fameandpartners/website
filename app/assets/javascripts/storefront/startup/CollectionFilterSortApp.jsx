import React from 'react';
import RD from 'react-dom';
import { Provider } from 'react-redux';
import AppStore from '../store/AppStore';
import CollectionFilterSort from '../containers/CollectionFilterSort.jsx';

// GLOBAL INJECTION: Anti pattern to attach props via global scope, but currently necessary
const props = (typeof window === 'object' && typeof window.CollectionFilterSortApp === 'object') ?
  window.CollectionFilterSortApp : {};

const CollectionFilterSortApp = (props) => {
  const reactComponent = (
    <Provider store={AppStore(props)}>
      <CollectionFilterSort />
    </Provider>
  );
  return reactComponent;
};

const elm = document.getElementById('CollectionFilterSortApp');
if (elm){ RD.render(CollectionFilterSortApp(props), elm); }
