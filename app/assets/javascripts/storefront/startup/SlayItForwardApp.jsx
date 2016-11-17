import React from 'react';
import RD from 'react-dom';
import { Provider } from 'react-redux';

import configureStore from '../store/configureStore';
import SlayItForward from '../containers/SlayItForward.jsx';

const SlayItForwardApp = (props) => {
  const store = configureStore(props);
  const reactComponent = (
    <Provider store={store}>
      <SlayItForward />
    </Provider>
  );
  return reactComponent;
};

const elm = document.getElementById('slay-it-forward-app');
if (elm){ RD.render(SlayItForwardApp(), elm); }
