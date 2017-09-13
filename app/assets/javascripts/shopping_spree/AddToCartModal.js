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
              <div className="shopping-spree-cart-modal shopping-spree">
                <div className="row" >
                  <div className="col-xs-2 col-xs-push-10">
                    <a className="btn-close med" alt="Close" onClick={this.close}></a>
                  </div>                      
                </div>
                <div className="row">
                  <div className="col-xs-6 col-xs-push-3 text-center shopping-spree-big-headline">
                    Add to your cart!
                  </div>
                </div>
                <div className="row modal-sub-headline">
                  <div className="col-xs-6 col-xs-push-3 text-center">
                    Just tell us your height and size, and
                  </div>
                </div>
                <div className="row">
                  <div className="col-xs-6 col-xs-push-3 text-center">
                    we'll take care of your tailoring.
                  </div>
                </div>
                <div className="row height-select-text">
                  <div className="col-xs-11 col-xs-push-1">
                    What's your Height?
                  </div>
                </div>
                <div className="row"> 
                  <div className="col-xs-4 col-xs-push-1">
                    <select className="height-select">
                      <option disabled selected value></option>
                      <option value="58">4ft 10in</option>
                      <option value="59">4ft 11in</option>
                      <option value="60">5ft 0in</option>
                      <option value="61">5ft 1in</option>
                      <option value="62">5ft 2in</option>
                      <option value="63">5ft 3in</option>
                      <option value="64">5ft 4in</option>
                      <option value="65">5ft 5in</option>
                      <option value="66">5ft 6in</option>
                      <option value="67">5ft 7in</option>
                      <option value="68">5ft 8in</option>
                      <option value="69">5ft 9in</option>
                      <option value="70">5ft 10in</option>
                      <option value="71">5ft 11in</option>
                      <option value="72">6ft 0in</option>
                      <option value="73">6ft 1in</option>
                      <option value="74">6ft 2in</option>
                      <option value="75">6ft 3in</option>
                      <option value="76">6ft 4in</option>
                    </select>
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
