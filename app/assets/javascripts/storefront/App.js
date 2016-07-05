import React from 'react';
import {render} from 'react-dom';
import configureStore from './store/configureStore';
import {Provider} from 'react-redux';

import PdpGallery from './components/PDP/Gallery';
import PdpSidePanelRight from './components/PDP/SidePanelRight';

// PDP
if(typeof window.PdpData !== 'undefined') {
  const store = configureStore(window.PdpData);

  store.subscribe(() => {
    console.log('Store changed: ', store.getState());
  });

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
}
