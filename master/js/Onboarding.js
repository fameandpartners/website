import React from 'react';
import request from 'superagent';
import PropTypes from 'prop-types';

export default class Onboarding extends React.Component {
  constructor(props) {
    super(props);
    this.join = this.join.bind(this);
  }


  join() {
    const context = this;
    request.post('/shopping_sprees')
            .set('Content-Type', 'application/json')
            .send(
      {
        name: this.nameInput.value,
        email: this.emailInput.value,
        shoppingSpreeId: this.props.shoppingSpreeId,
      },
            ).end((error, response) => {
              context.props.doneOnboarding(response.body.name,
                                                  response.body.email,
                                                  response.body.icon,
                                                  response.body.id);
            },
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
          <span
            className="btn-close med"
            alt="Close"
            onClick={this.props.close}
          />
          <div id="top-headline" className="welcome-headline row">
            <div className="col-xs-12 text-center">
                    Welcome to
                  </div>
          </div>
          <div id="bottom-headline" className="welcome-headline row">
            <div className="col-xs-12 text-center">
                    Partner Shop.
                  </div>
          </div>

          <div id="dress-one" className="row equal">
            <div
              id="dress-image-one"
              className="col-md-4 col-md-pull-0 col-xs-8 col-xs-pull-2 dress-image-left"
            >
              <img src="/images/shopping_spree/dresses/Dress1.jpg" alt="" />
            </div>
            <div className="col-md-4 col-md-pull-0 col-xs-4 col-xs-pull-4">
              <div className="row dress-one-text">
                <div className="body-text col-md-12 text-center vertical-align">
                  Shop with your friends and get discounts the more you add to your cart
                </div>
              </div>
              <div className="row dress-one-text-two desktop">
                <div className="body-text col-md-12 text-center">Invite your friends</div>
              </div>
              <div className="row">
                <div className="body-text col-md-12 text-center">to shop with you</div>
              </div>
            </div>
          </div>

          <div id="dress-two" className="row equal">
            <div
              className="col-md-4 col-md-push-4 col-xs-4 col-xs-push-2 text-center vertical-align"
            >
              <div className="body-text mobile">
                      Invite your friends to shop with you
                    </div>
              <div className="body-text desktop">
                      You and your friends can add items to your shopping spree
                    </div>
            </div>
            <div
              id="dress-two-image"
              className="col-md-push-4 col-md-4 col-xs-8 col-xs-push-2  dress-image-right"
            >
              <img src="/images/shopping_spree/dresses/Dress2.jpg" alt="" />
            </div>
          </div>

          <div id="dress-three" className="row equal">
            <div className="col-md-4 col-md-pull-0 col-xs-8 col-xs-pull-2 dress-image-left">
              <img src="/images/shopping_spree/dresses/Dress3.jpg" alt="" />
            </div>
            <div className="col-md-4 col-md-pull-0 col-xs-4 col-xs-pull-3 vertical-align">
              <div className="body-text text-center mobile">
                      You and your friends can add items to your shopping spree
                    </div>
              <div className="row">
                <div className="body-text text-center col-md-12 desktop">
                  Checkout with discounts up to
                </div>
                <div className="body-text col-md-12 text-center desktop dress-three-percent-text">
                  30%
                </div>
              </div>
            </div>
          </div>

          <div id="mobile-text" className="row mobile">
            <div className="body-text text-center col-md-12">
                    Checkout with discounts up to
                  </div>
            <div className="col-md-12">
              <div className="body-text text-center dress-three-percent-text">
                      30%
                    </div>
            </div>
          </div>

          <div id="enter-email-text" className="row">
            <div className="base-text text-center col-xs-8 col-xs-push-2">
                    Enter your name and email to start!
                  </div>
          </div>

          <div className="row top-padding-sm bottom-padding-sm">
            <div className="col-xs-12 col-lg-2 col-lg-push-5">
              <input
                className="form-control input-lg"
                type="text"
                placeholder="Enter your name"
                ref={(input) => { this.nameInput = input; }}
              />
            </div>
          </div>

          <div className="row bottom-padding-sm">
            <div className="col-xs-12 col-lg-2 col-lg-push-5">
              <input
                className="form-control input-lg"
                type="text"
                placeholder="Enter your email"
                ref={(input) => { this.emailInput = input; }}
              />
            </div>
          </div>

          <div className="row">
            <div className="col-xs-12 col-lg-2 col-lg-push-5 no-gutter-mobile">
              <a
                onClick={this.join}
                className="btn btn-lrg btn-black btn-block"
              >
                  Start Shopping Spree
              </a>
            </div>
          </div>

        </div>

      </div>
    );
  }

}


Onboarding.propTypes = {
  shoppingSpreeId: PropTypes.string.isRequired,
  close: PropTypes.func.isRequired,
};

Onboarding.defaultProps = {
  nextStep: null,
};
