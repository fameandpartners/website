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
                <div className="welcome-headline row">
                  <div className="col-xs-12 text-center">
                    Partner Shop.
                  </div>
                </div>
                
                <div id="dress-one" className="row">
                  <div className="col-md-4 col-xs-8 col-xs-pull-2 dress-image-left">
                    <img src="/images/shopping_spree/dresses/Dress1.jpg" alt=""/>
                  </div>
                  <div className="col-md-4 col-xs-4 col-xs-pull-4">
                    <div className="row dress-one-text">
                      <div className="body-text col-md-12 text-center">
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
                  <div className="col-md-push-4 col-md-4 desktop">
                    <div id="dress-two-text" className="row">
                      <div className="body-text col-md-12 text-center">You and your</div>
                    </div>
                    <div className="row">
                      <div className="body-text col-md-12 text-center">friends can add</div>
                    </div>
                    <div className="row">
                      <div className="body-text col-md-12 text-center">items to your</div>
                    </div>
                    <div className="row">
                      <div className="body-text col-md-12 text-center">shopping spree</div>
                    </div>                    
                  </div>
                  <div className="col-md-4 col-xs-4 col-xs-push-2 text-center mobile vertical-align">
                    <div className="body-text">
                      Invite your friends to shop with you
                    </div>
                  </div>
                  <div id="dress-two-image" className="col-md-push-4 col-xs-8 col-xs-push-2 col-md-8 dress-image-right">
                    <img src="/images/shopping_spree/dresses/Dress2.jpg" alt=""/>
                  </div>
                </div>

                <div id="dress-three" className="row equal">
                  <div className="col-md-4 col-xs-8 col-xs-pull-2 dress-image-left">
                    <img src="/images/shopping_spree/dresses/Dress3.jpg" alt=""/>
                  </div>
                  <div className="col-md-4 col-xs-4 col-xs-pull-3 mobile vertical-align">
                    <div className="body-text text-center">
                      You and your friends can add items to your shopping spree
                    </div>
                  </div>
                  <div className="col-md-4 col-xs-4 col-xs-pull-4 desktop">
                    <div className="row dress-three-text">
                      <div className="body-text col-md-12 text-center">Checkout with</div>
                    </div>
                    <div className="row">
                      <div className="body-text col-md-12 text-center">discounts up to</div>
                    </div>
                    <div className="row">
                      <div id="dress-three-percent-text" className="body-text col-md-12 text-center">30%</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>                        
        );
    }   

}
