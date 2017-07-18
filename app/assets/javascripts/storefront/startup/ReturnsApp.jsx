import React from 'react';
import ReactDOM from 'react-dom';
import {Provider} from 'react-redux';
import AppStore from '../store/AppStore';
import {Router, Route, hashHistory} from 'react-router'
import ConfirmationContainer from '../components/returns/containers/ConfirmationContainer'
import OrderContainer from '../components/returns/containers/OrderContainer'
import StepOneContainer from '../components/returns/containers/StepOneContainer'

const store = AppStore({}); // shared

ReactDOM.render(
    <Provider store={store}>
        <Router history={hashHistory}>
        	<Route path="/" component={OrderContainer}></Route>
        	<Route path="/order-history" component={OrderContainer}></Route>
        	<Route path="/start-return/:orderID" component={StepOneContainer}></Route>
        	<Route path="/return-confirmation" component={ConfirmationContainer}></Route>
        </Router>
    </Provider>,
    document.getElementById('returnsApp')
);