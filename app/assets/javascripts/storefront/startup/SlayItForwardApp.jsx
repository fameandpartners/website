import React from 'react';
import RD from 'react-dom';
import { Provider } from 'react-redux';

import createStore from '../store/configureStore';
import SlayItForward from '../containers/SlayItForward.jsx';

// See documentation for https://github.com/reactjs/react-redux.
// This is how you get props from the Rails view into the redux store.
// This code here binds your smart component to the redux store.
// railsContext provides contextual information especially useful for server rendering, such as
// knowing the locale. See the React on Rails documentation for more info on the railsContext
const SlayItForwardApp = (props, _railsContext) => {
  const store = createStore(props);
  const reactComponent = (
    <Provider store={store}>
      <SlayItForward />
    </Provider>
  );
  return reactComponent;
};

const elm = document.getElementById('slay-it-forward-app');
if (elm){ RD.render(SlayItForwardApp(), elm); }
