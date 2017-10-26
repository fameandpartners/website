/* eslint-disable */
import React from 'react';
import { render } from 'react-dom';
import ShoppingSpree from './ShoppingSpree';

render(
    <ShoppingSpree firebaseAPI={window.ShoppingSpreeData.firebaseAPI}
                   firebaseDatabase={window.ShoppingSpreeData.firebaseDatabase}/>,

    document.getElementById( 'shopping-spree' )
);
