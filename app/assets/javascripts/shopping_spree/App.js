/* eslint-disable */

import React from 'react';
import { render } from 'react-dom';
import ShoppingSpree from './ShoppingSpree';
import Cookies from 'universal-cookie';

const cookies = new Cookies();

render(
        <ShoppingSpree firebaseAPI={window.ShoppingSpreeData.firebaseAPI} firebaseDatabase={window.ShoppingSpreeData.firebaseDatabase} name={cookies.get('shopping_spree_name')} icon={parseInt(cookies.get('shopping_spree_icon'))} email={cookies.get('shopping_spree_email')} firebaseId={cookies.get('shopping_spree_id')}/>,
    document.getElementById( 'shopping-spree' )
);
