/* eslint-disable */

import React from 'react';
import { render } from 'react-dom';
import Drawer from './Drawer'


render(
        <Drawer firebaseAPI='AIzaSyDhbuF98kzK0KouFeasDELcOKJ4q7DzhHY' firebaseDatabase='shopping-spree-85d74' firebaseNodeId={window.ShoppingSpreeData.firebaseNodeId}/>,
    document.getElementById('shopping-spree')
);
