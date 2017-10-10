/* eslint-disable */
import React from 'react';
import request from 'superagent';
import FirebaseComponent from './FirebaseComponent';

export default class Onboarding extends FirebaseComponent
{
    constructor( props )
    {
        super( props );
        this.join = this.join.bind(this);
    }

    join()
    {
        let context = this;

 
        this.connectToFirebase();
        let shoppingSpreeId = this.createNewShoppingSpree();
        this.createFamebotMessage( 'You can post items here and chat with your friends' )
        this.createFamebotMessage( "Here's something to get you started!" )
        this.createFamebotShareDressMessage( 1481,
                                             "The Maritza Dress",
                                             "<p>Dotted from head to toe. The Maritza is a light georgette maxi dress in a dotted print featuring tie detailing at the back, side cut-outs, and a tiered, ruffled skirt. It has an invisible zipper and hook and eye closure.</p>",
                                             409,
                                             "https://d1msb7dh8kb0o9.cloudfront.net/spree/products/35873/original/fprv1026p-black_and_white_spot-front.jpg?1494461867",
                                             "/dresses/the-maritza-dress-1481",
                                             {
                                                 "id": 415,
                                                 "name": "black-and-white-spot",
                                                 "presentation": "Black and White Spot",
                                                 "price": 0
                                             },
                                             null
                                           )
        
        context.props.doneOnboarding( this.nameInput.value,
                                      this.emailInput.value,
                                      Math.floor(Math.random() * 20),
                                      shoppingSpreeId );
        
    }

    render()
    {
        return(
                <div id="shopping-spree-modal" className="shopping-spree shopping-spree-onboarding modal modal animated bounceIn" role="dialog" aria-hidden="true">
              <div id="shopping-spree-modal-content" className="container">
                <a className="btn-close med" alt="Close" onClick={this.props.close}></a>
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
                  <div id="dress-image-one" className="col-md-4 col-md-pull-0 col-xs-8 col-xs-pull-2 dress-image-left">
                    <img src="/images/shopping_spree/dresses/Dress1.jpg" alt=""/>
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
                  <div className="col-md-4 col-md-push-4 col-xs-4 col-xs-push-2 text-center vertical-align">
                    <div className="body-text mobile">
                      Invite your friends to shop with you
                    </div>
                    <div className="body-text desktop">
                      You and your friends can add items to your shopping spree
                    </div>
                  </div>
                  <div id="dress-two-image" className="col-md-push-4 col-md-4 col-xs-8 col-xs-push-2  dress-image-right">
                    <img src="/images/shopping_spree/dresses/Dress2.jpg" alt=""/>
                  </div>
                </div>

                <div id="dress-three" className="row equal">
                  <div className="col-md-4 col-md-pull-0 col-xs-8 col-xs-pull-2 dress-image-left">
                    <img src="/images/shopping_spree/dresses/Dress3.jpg" alt=""/>
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

                <div className="shspree-signup-section">
                  <div id="enter-email-text" className="row">
                    <div className="base-text text-center col-xs-8 col-xs-push-2">
                      Enter your name and email to start!
                    </div>
                  </div>

                  <div className="row top-padding-sm bottom-padding-sm">
                    <div className="col-xs-12 col-lg-5 float-none margin--center">
                      <input className="form-control input-lg" type="text" placeholder="Enter your name" ref={(input) => { this.nameInput = input; }}></input>
                    </div>
                  </div>

                  <div className="row bottom-padding-sm">
                    <div className="col-xs-12 col-lg-5 float-none margin--center">
                      <input className="form-control input-lg" type="text" placeholder="Enter your email" ref={(input) => { this.emailInput = input; }}></input>
                    </div>
                  </div>

                  <div className="row">
                    <div  className="col-xs-12 col-lg-5 float-none margin--center">
                      <a onClick={this.join} className="btn btn-lrg btn-black btn-block">Start Shopping Spree</a>
                    </div>
                  </div>
                </div>

              </div>
            </div>
        );
    }

}
