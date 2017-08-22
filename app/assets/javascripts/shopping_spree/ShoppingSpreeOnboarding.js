import React from 'react';

export default class ShoppingSpreeOnboarding extends React.Component
{
    constructor( props )
    {
        super( props );

        this.state = 
            {
                closed: true
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
                <div className="row">
                  <div className="col-xs-18 text-right">

                  </div>
                </div>

              </div>
            </div>                        
        );
    }   

}
