import React from 'react';
import * as firebase from 'firebase';

import FirebaseComponent from './FirebaseComponent';

export default class AddToCartModal extends FirebaseComponent
{

    constructor( props )
    {
        super( props );
        this.close = this.close.bind( this );
    }

    close()
    {
    }
    
    render()
    {
        return(
            <div>
              <div className='shopping-spree-share-modal-background shopping-spree'>
              </div>
              <div className="shopping-spree-cart-modal">
                <div className="row" >
                  <div className="col-xs-2 col-xs-push-10">
                    <a className="btn-close med" alt="Close" onClick={this.close}></a>
                  </div>                      
                </div>
                <div className="row">
                  <div className="col-xs-6 col-xs-push-3 text-center">
                    Add to your cart!
                  </div>
                </div>
                <div className="row">
                  <div className="col-xs-6 col-xs-push-3 text-center">
                    Just tell us your height and size, and
                  </div>
                </div>
                <div className="row">
                  <div className="col-xs-6 col-xs-push-3 text-center">
                    we'll take care of your tailoring.
                  </div>
                </div>
              </div>
            </div>
        );
    }
}

AddToCartModal.propTypes = {
    firebaseAPI: React.PropTypes.string.isRequired,
    firebaseDatabase: React.PropTypes.string.isRequired,
    name: React.PropTypes.string,
    icon: React.PropTypes.number,
    email: React.PropTypes.string,
    firebaseId: React.PropTypes.string,
    dress: React.PropTypes.object.isRequired
};
