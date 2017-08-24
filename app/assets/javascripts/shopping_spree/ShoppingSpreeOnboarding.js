import React from 'react';

export default class ShoppingSpreeOnboarding extends React.Component
{
    constructor( props )
    {
        super( props );

        this.state = 
            {
                closed: false
            };

        this.close = this.close.bind(this);
        this.open = this.open.bind(this);
        window.startShoppingSpree = this.open;
    }

    close()
    {
        this.setState(
            {
                closed: true
            }
        );
    }

    open()
    {
        this.setState(
            {
                closed: false
            }
        );
    }
    
    render()
    {
        return(
            <div id="shopping-spree-modal" className="shopping-spree-onboarding modal modal animated bounceIn" role="dialog" aria-hidden="true" style={this.state.closed ? {display: 'none'} : {display: 'block'}}>
              <div id="shopping-spree-modal-content" className="container">
                <a className="btn-close med" alt="Close" onClick={this.close}></a>              
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
              </div>
            </div>                        
        );
    }   

}
