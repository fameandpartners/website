/* eslint-disable */

import React, { Component } from 'react';
import PropTypes from "prop-types";

export default class StepMessage extends Component {

  render() {
    const stepNum = Number(this.props.step);
    let message = "";

    if (stepNum == 1) {
      message = (
        <div>
          <p>Step 1</p>
          <p>
            Invite your friends to shop with you
          </p>
          <button>Invite</button>
        </div>
      );
    } else if (stepNum == 2) {
      message = (
        <div>
          <p>Step 2</p>
          <p>
            Start sharing! Easily share products with the group from any product page.
          </p>
        </div>
      );
    } else if (stepNum == 3) {
      message = (
        <div>
          <p>Step 3</p>
          <p>
            Shop and save! Get up to 25% off when you check out together
          </p>
        </div>
      );
    }

    return (
      <li className="text-message">
        <div className="row equal no-left-gutter">
          <div className="firebase-text col-xs-12">
            {message}
          </div>
        </div>
      </li>
    );
  }
}

StepMessage.propTypes = {
  step: PropTypes.string.isRequired,
};
