/* global window, document */
/* global $ */
import React, { Component } from 'react';
import { browserHistory } from 'react-router';
import autobind from 'auto-bind';

const csrfToken = document.querySelector('meta[name="csrf-token"]') ? document.querySelector('meta[name="csrf-token"]').content : '';

$.ajaxSetup({
  headers: {
    'X-CSRF-Token': csrfToken,
  },
});

class GuestReturnApp extends Component {
  constructor(props) {
    super(props);
    autobind(this);
    this.state = {
      lookupError: false,
    };
  }
  checkOrder(e) {
    e.preventDefault();
    const { guestOrderID, guestEmail } = this.state;
    const that = this;
    $.ajax({
      method: 'get',
      url: `api/v1/guest/order?order_number=${guestOrderID}&email=${guestEmail}`,
    })
    .success((response) => {
      if (response) {
        browserHistory.push(`/view-orders#/guest-return/${guestOrderID}/${guestEmail}`);
        window.location.reload();
      }
    })
    .error(() => {
      that.setState({
        lookupError: true,
      });
    });
  }
  updateEmail(event) {
    this.setState({
      guestEmail: event.target.value,
    });
  }
  updateOrderNumber(event) {
    this.setState({
      guestOrderID: event.target.value,
    });
  }

  render() {
    const { guestOrderID, guestEmail, lookupError } = this.state;
    return (
      <div className="grid-center-noGutter GuestReturn__Container">
        <div className="col-4_md-5_sm-10">
          <p className="headline">Let’s get started.</p>
          <p className="subheader">Want to return? No problem.<br /> Orders
           placed with the Returns Deposit may be returned within 30 days of
           the delivery date for a refund (excluding the returns deposit).</p>
          <div className={lookupError ? 'error-box' : 'u-hide'}>
            <p>Sorry, the order number or email address you entered is incorrect.
              Please check your information and try again.</p>
          </div>
          <form className="guestForm__container" onSubmit={this.checkOrder}>
            <input
              type="text"
              placeholder="Order number"
              onChange={this.updateOrderNumber}
              value={guestOrderID}
            />
            <input
              type="email"
              placeholder="Email address"
              onChange={this.updateEmail}
              value={guestEmail}
            />
            <input type="submit" value="Return My Order" className="GuestReturn--submitButton" />
          </form>
          <div className="grid-noGutter-spaceBetween">
            <div className="col-6_sm-12">
              <p className="guest-copy">Have an account?&nbsp;
                <a href="/login">Log In</a>
              </p>
            </div>
            <div className="col-6_sm-12-right">
              <p className="guest-copy contact-us">Need help?&nbsp;
                <a href="/contact">Contact Us</a>
              </p>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default GuestReturnApp;
