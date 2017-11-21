/* eslint-disable */

import React from 'react';
import PropTypes from "prop-types";

export default class StepMessage extends React.Component {

  render() {
    const stepNum = Number(this.props.step);
    let message = "";

    if (stepNum == 1) {
      message = (
        <div>
          <p className="StepMessage__content">
            Step 1
            <br/>
            Invite your friends to shop with you
          </p>
          <button
            className="StepMessage__invite-button"
            onClick={this.props.showShareModal}
          >
            Invite
          </button>
        </div>
      );
    } else if (stepNum == 2) {
      message = (
        <div>
          <p className="StepMessage__content">
            Step 2
            <br/>
            Start sharing! Easily share products with the group from any product page.
          </p>
        </div>
      );
    } else if (stepNum == 3) {
      message = (
        <div>
          <p className="StepMessage__content">
            Step 3
            <br/>
            Shop and save! Get up to 25% off when you check out together
          </p>
        </div>
      );
    }

    return (
      <li className="StepMessage">
        <div className="row equal no-left-gutter">
          <div className="StepMessage__container col-xs-push-1 col-xs-10">
            {message}
          </div>
        </div>
      </li>
    );
  }
}

StepMessage.propTypes = {
  step: PropTypes.string.isRequired,
  showShareModal: PropTypes.func.isRequired,
};
