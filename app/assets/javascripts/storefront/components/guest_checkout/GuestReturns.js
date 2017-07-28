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
      guestEmail: 'notreal@gmail.com',
      guestOrderID: 'R833073426',
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
           standard items up to 30 days after your purchase.</p>
          <div className={lookupError ? 'error-box' : 'u-hide'}>
            <p>Sorry the order number and/or email you entered are incorrect.
              Please check them and enter again.</p>
          </div>
          <form className="guestForm__container" onSubmit={this.checkOrder}>
            <input
              type="text"
              placeholder="Enter your order number"
              onChange={this.updateOrderNumber}
              value={guestOrderID}
            />
            <input
              type="email"
              placeholder="Email"
              onChange={this.updateEmail}
              value={guestEmail}
            />
            <Button primary noMargin className="return-button">Start Your Return</Button>
          </form>
          <div className="grid-noGutter-spaceBetween">
            <div className="col">
              <p className="copy">Have an account?&nbsp;
                <Link to="/login">Log in</Link>
              </p>
            </div>
            <div className="col-right">
              <p className="copy">Need help?&nbsp;
                <Link to="/login">Contact Us</Link>
              </p>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default GuestReturnApp;
