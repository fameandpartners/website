/* eslint-disable */

import React from "react";
import PropTypes from "prop-types";
import Clipboard from "clipboard";
import ReactTooltip from "react-tooltip";
import { findDOMNode } from "react-dom";

export default class ShareModal extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      url:
        location.protocol +
        "//" +
        location.hostname +
        (location.port ? ":" + location.port : "") +
        "/shopping_sprees/" +
        this.props.firebaseNodeId +
        "/join",
    };
  }

  componentDidMount() {
    this.setState({
      clipboard: new Clipboard(this.copyTrigger, {
        text: () => this.state.url,
      }),
    });
  }

  render() {
    return (
      <div>
        <div className="shopping-spree-share-modal-background shopping-spree" />

        <div className="shopping-spree shopping-spree-share-modal container">
          <div className="row">
            <div className="modal-headline text-center col-xs-10 col-xs-push-1 col-md-10 col-md-push-1 no-gutter-mobile">
              Let’s get social. Copy this link to invite your friends!
            </div>
          </div>
          <div className="row equal">
            <div className="col-xs-12 col-md-10 col-lg-8 float-none u-margin-center">
              <input
                readOnly
                defaultValue={this.state.url}
                className="input-lg col-xs-8"
                type="text"
              />
              <div className="col-xs-4 no-horizontal-padding">
                <a
                  data-delay-hide="800"
                  data-event="click"
                  data-tip="copied!"
                  ref={i => (this.copyTrigger = i)}
                  className="btn btn-shopping-spree-blue btn-block col-xs-3"
                >
                  Copy Link
                </a>
                <ReactTooltip
                  afterShow={() => ReactTooltip.hide(findDOMNode(this.copyTrigger))}
                  place="bottom"
                  effect="solid"
                />
              </div>
            </div>
          </div>
          <div className="start-button-wrapper">
            <div id="start-button">
              <div className="col-xs-12 col-lg-6 margin--center float-none no-gutter-mobile">
                {
                  this.props.hasEntered ?
                  (
                    <a
                      onClick={this.props.nextStep}
                      className="center-button-text btn btn-md btn-shopping-spree-blue btn-block"
                    >
                      Share With Friends
                    </a>
                  )
                  :
                  (
                    <a
                      onClick={this.props.nextStep}
                      className="center-button-text btn btn-md btn-shopping-spree-blue btn-block"
                    >
                      Get up to 25% off now
                    </a>
                  )
                }
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

ShareModal.propTypes = {
  firebaseNodeId: PropTypes.string.isRequired,
};
