import React from 'react';
import {render} from 'react-dom';
import configureStore from './store/configureStore';
import {Provider} from 'react-redux';

import PdpGallery from './components/PDP/PdpGallery';
import PdpSidePanelRight from './components/PDP/PdpSidePanelRight';

const store = configureStore(window.PdpData);

console.log('Store changed: ', store.getState());

store.subscribe(() => {
  console.log('Store changed: ', store.getState());
});

//PDP
render(
  <Provider store={store}>
    <PdpGallery />
  </Provider>, document.getElementById('PdpGallery')
);

render(
  <Provider store={store}>
    <PdpSidePanelRight />
  </Provider>, document.getElementById('PdpSidePanelRight')
);
