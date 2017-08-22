/* eslint-disable */

import React from 'react';
import { render } from 'react-dom';
import Drawer from './Drawer';
import ShoppingSpreeOnboarding from './ShoppingSpreeOnboarding';


// render(
//        <Drawer firebaseAPI={window.ShoppingSpreeData.firebaseAPI} firebaseDatabase={window.ShoppingSpreeData.firebaseDatabase} firebaseNodeId={window.ShoppingSpreeData.firebaseNodeId}/>,
//    document.getElementById('shopping-spree')
// );

 
render(
    <ShoppingSpreeOnboarding firebaseAPI={window.ShoppingSpreeData.firebaseAPI} firebaseDatabase={window.ShoppingSpreeData.firebaseDatabase} firebaseNodeId={window.ShoppingSpreeData.firebaseNodeId}/>,
    document.getElementById( 'shopping-spree-modal' )
);
