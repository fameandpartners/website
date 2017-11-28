/* eslint-disable */

import React from "react";
import request from "superagent";
import _ from 'lodash';

import FirebaseComponent from "./FirebaseComponent";

export default class Onboarding extends FirebaseComponent {
  constructor(props) {
    super(props);
    this.join = this.join.bind(this);
  }

  join(event) {
    event.preventDefault();
    let context = this;

    this.connectToFirebase();

    let shoppingSpreeId = this.props.shoppingSpreeId;
    if (shoppingSpreeId == null) {
      shoppingSpreeId = this.createNewShoppingSpree();
    } else {
      this.firebaseNodeId = shoppingSpreeId;
    }

    let icon = Math.floor(Math.random() * 20);
    this.createJoinedMessage(this.nameInput.value, this.emailInput.value, icon);

    context.props.doneOnboarding(
      this.emailInput.value,
      this.nameInput.value,
      icon,
      shoppingSpreeId,
    );
  }

  render() {
    return (
      <div
        id="shopping-spree-modal"
        className="shopping-spree shopping-spree-onboarding modal modal animated bounceIn"
        role="dialog"
        aria-hidden="true"
      >
        <div id="shopping-spree-modal-content" className="container">
          <a className="btn-close med" alt="Close" onClick={this.props.close} />

          <div className="row">
            <div className="col-xs-12 OnboardingHero__wrapper">
              <div className="row">
                <div className="col-xs-4 col-xs-offset-8 text-center visible-md visible-lg OnboardingHero__desktop-text">
                  <h2 className="OnboardingHero__heading">
                    Welcome<br/>
                    to <em>The Social<br/>
                    Experience</em>
                  </h2>
                  <h4 className="OnboardingHero__subheading">
                    Easily shop, share and save with friends
                  </h4>
                  <p>
                    Invite your friends to shop with you, easily share products with each other, and save up to 25% when you check out together.
                  </p>
                  <p>
                    When everyone shops, <em>everyone saves</em>.
                  </p>
                </div>
              </div>
            </div>
            <div className="col-xs-12 text-center visible-xs visible-sm OnboardingHero__mobile-text">
              <h2 className="OnboardingHero__heading">
                Welcome<br/>
                to <em>The Social<br/>
                Experience</em>
              </h2>
              <h4 className="OnboardingHero__subheading">
                Easily shop, share and save with friends
              </h4>
              <p>
                Invite your friends to shop with you, easily share products with each other, and save up to 25% when you check out together.
              </p>
              <p>
                When everyone shops, <em>everyone saves</em>.
              </p>
            </div>
            <div className="col-xs-12 OnboardingScreenshot__wrapper">
              <img className="visible-md visible-lg" src="/images/shopping_spree/onboarding/screenshot.jpg" alt=""/>
              <img className="visible-xs visible-sm" src="/images/shopping_spree/onboarding/screenshot_mobile.jpg" alt=""/>
            </div>
          </div>

          <div className="shspree-signup-section">
            <form onSubmit={this.join}>
              <div id="enter-email-text" className="row">
                <div className="base-text text-center col-xs-8 col-xs-push-2 visible-md visible-lg">
                  Join and invite friends to shop and save with you in<br/>
                  <em>The Social Experience</em>. We just need your email to get started:
                </div>
                <div className="base-text text-center col-xs-8 col-xs-push-2 visible-xs visible-sm">
                  Join and invite friends to shop and save with you in <em>The Social Experience</em>. We just need your email to get started:
                </div>
              </div>

              <div className="row top-padding-sm bottom-padding-sm">
                <div className="col-xs-10 col-md-4 float-none margin--center">
                  <input
                    className="form-control input-lg"
                    type="text"
                    placeholder="Your name"
                    required
                    ref={input => {
                      this.nameInput = input;
                    }}
                  />
                </div>
              </div>

              <div className="row bottom-padding-sm">
                <div className="col-xs-10 col-md-4 float-none margin--center">
                  <input
                    className="form-control input-lg"
                    type="email"
                    placeholder="Your email"
                    required
                    ref={input => {
                      this.emailInput = input;
                    }}
                  />
                </div>
              </div>

              <div className="row bottom-padding-lg">
                <div className="col-xs-10 col-md-4 float-none margin--center text-center">
                  <button
                    type="submit"
                    role="button"
                    className="btn btn-shopping-spree-blue"
                  >
                    Get up to 25% off now
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    );
  }
}
