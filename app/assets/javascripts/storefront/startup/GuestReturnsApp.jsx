import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import {Link} from 'react-router';
import GuestReturns from '../components/guest_checkout/GuestReturns'

const GuestReturnsApp = () => {
  return <GuestReturns />
}

export default GuestReturnsApp

const guestNode = document.getElementById('guestReturn');
if (guestNode){ ReactDOM.render(GuestReturnsApp(), guestNode); }
