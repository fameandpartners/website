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
                  <div id="dress-one-image" className="col-md-4 col-xs-3 col-xs-push-1">
                    <img src="/images/shopping_spree/dresses/Dress1.jpg" alt=""/>
                  </div>
                  <div className="col-md-4">
                    <div className="row dress-one-text">
                      <div className="body-text col-md-12 text-center">Shop with your friends and get discounts</div>
                    </div>
                    <div className="row">
                      <div className="body-text col-md-12 text-center">the more you add to your cart</div>
                    </div>
                    
                  </div>
                  
                </div>
              </div>
            </div>                        
        );
    }   

}
