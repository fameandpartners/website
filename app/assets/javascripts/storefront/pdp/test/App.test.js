/* global window */
// import React from 'react';
// import ReactDOM from 'react-dom';
// import { Provider } from 'react-redux';
// import App from '../js/App';
import AppStore from '../js/stores/AppStore';

it('renders without crashing', () => {
  const store = AppStore();
  const div = window.document.createElement('div');
  // ReactDOM.render(<Provider store={store}><App /></Provider>, div);
});
