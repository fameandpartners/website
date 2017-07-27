import React from 'react';
import ReactDOM from 'react-dom';
import GuestReturns from '../components/guest_checkout/GuestReturns';

const GuestReturnsApp = () => <GuestReturns />;

export default GuestReturnsApp;

const guestNode = document.getElementById('guestReturn');
if (guestNode) { ReactDOM.render(GuestReturnsApp(), guestNode); }
