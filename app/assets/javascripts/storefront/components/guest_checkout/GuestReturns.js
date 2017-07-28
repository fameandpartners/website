import React, { Component } from 'react';
import { Link } from 'react-router';
import autobind from 'auto-bind';
import axios from 'axios';
import Button from '../returns/components/Button';

class GuestReturnApp extends Component {
  constructor(props) {
    super(props);
    autobind(this);
    this.state = {
      guestEmail: '',
      guestOrderID: '',
      lookupError: false,
    };
  }
  checkOrder(e) {
    e.preventDefault();
    const { guestOrderID, guestEmail } = this.state;
    const that = this;
    axios({
      method: 'get',
      url: `/order-lookup?id=${guestOrderID}&email=${guestEmail}`,
      headers: {
        Accept: 'application/json',
      },
    })
      .then((response) => {
        if (response.data.status) {
          that.setState({
            lookupError: true,
          });
        }
      })
      .catch((error) => {
        console.log(error);
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
          <p className="subheader">Want to return? No problem. You can return
           standard items up to 30 days after your&nbsp;purchase.</p>
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
            <Button primary noMargin className="return-button">Return My Order</Button>
          </form>
          <div className="grid-noGutter-spaceBetween">
            <div className="col-6_sm-12">
              <p className="copy">Have an account?&nbsp;
                <a href="/login">Log In</a>
              </p>
            </div>
            <div className="col-6_sm-12-right">
              <p className="copy">Need help?&nbsp;
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
