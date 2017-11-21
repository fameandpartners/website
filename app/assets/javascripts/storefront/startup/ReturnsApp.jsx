/* global window */
import React from 'react';
import ReactDOM from 'react-dom';
import { Router, Route, hashHistory } from 'react-router';
import { Provider } from 'react-redux';
import AppStore from '../store/AppStore';
import ConfirmationContainer from '../components/returns/containers/ConfirmationContainer';
import OrderContainer from '../components/returns/containers/OrderContainer';
import ReturnReasonsContainer from '../components/returns/containers/ReturnReasonsContainer';
import '../libs/default-csrf';

const returnNode = window.document.getElementById('returnsApp');
if (returnNode) {
  const user = window.ApplicationStateData ? window.ApplicationStateData.UserData.user : {};
  const store = AppStore({ user: {
    id: user.id,
    email: user.email,
    user_signed_in: !!user.email,
  } }); // shared
  ReactDOM.render(
    <Provider store={store}>
      <Router history={hashHistory}>
        <Route path="/" component={OrderContainer} />
        <Route path="/guest-return/:orderID/:email" component={OrderContainer} />
        <Route path="/start-return/:orderID" component={ReturnReasonsContainer} />
        <Route path="/return-confirmation" component={ConfirmationContainer} />
      </Router>
    </Provider>,
    returnNode);
}
