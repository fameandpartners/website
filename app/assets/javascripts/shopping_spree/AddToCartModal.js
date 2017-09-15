import React from 'react';
import * as firebase from 'firebase';

import FirebaseComponent from './FirebaseComponent';
import SizeButton from './SizeButton';

export default class AddToCartModal extends FirebaseComponent
{

    constructor( props )
    {
        super( props );
        this.state =
            {
                selectedSize: null
            };
        
        this.sizeSelected = this.sizeSelected.bind( this );
    }

    
    sizeSelected( size )
    {
        this.setState( { selectedSize: size } );
        console.log( size + " selected" );
    }

    generateSizeRow( startSize, endSize )
    {
        let sizeRows = [];
        for( let i = startSize; i <= endSize; i+= 2 )
        {
            sizeRows.push( <SizeButton key={i.toString()} size={i.toString()} selectedSize={this.state.selectedSize} selectionCallback={this.sizeSelected}/> );
            
        }

        for( let i = sizeRows.length; i < 5; i += 1 )
        {
            sizeRows.push( <div key={endSize + i } className="size-box-hidden"></div> );
        }
        
        return( <div className="row">
                  <div className="col-xs-8 col-xs-push-1">
                    <div className="size-row">{sizeRows}</div>
                  </div>
                </div>
              );
    }
    
    render()
    {
        return(
            <div>
              <div className='shopping-spree-share-modal-background shopping-spree'>
              </div>
              <div className="shopping-spree-cart-modal shopping-spree">
                <a className="btn-close med" alt="Close" onClick={this.props.closeModal}></a>                
                <div className="row">
                  <div id="add-to-cart-headline" className="col-xs-12 text-center shopping-spree-big-headline">
                    Add to your cart!
                  </div>
                </div>
                
                <div className="row modal-sub-headline">
                  <div className="col-xs-12 text-center">
                    Just tell us your height and size, and
                  </div>
                </div>
                
                <div className="row">
                  <div className="col-xs-12 text-center">
                    we'll take care of your tailoring.
                  </div>
                </div>
                
                <div className="row height-select-text">
                  <div className="col-xs-11 col-xs-push-1">
                    What's your Height?
                  </div>
                </div>
                
                <div className="row"> 
                  <div className="col-xs-8 col-md-6 col-xs-push-1">
                    <select className="height-select">
                      <option disabled selected value>Select</option>
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
                
                <div className="row height-select-text">
                  <div className="col-xs-11 col-xs-push-1">
                    What's Your Dress Size?
                  </div>
                </div>
                { this.generateSizeRow( 0, 8 ) }
                { this.generateSizeRow( 10, 18 ) }
                { this.generateSizeRow( 20, 26 ) }
                <div className="row">
                  <div className="col-xs-11 col-xs-push-1">
                    <a className="shopping-spree-link" href="https://www.fameandpartners.com/size-guide" target="_blank">View Sizing Guide</a>
                  </div>
                </div>
                <div className="row add-to-cart-button">
                  <div className="col-xs-10 col-xs-push-1">
                    <a  className="btn btn-lrg btn-black btn-block">Add to your cart</a>
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
    dress: React.PropTypes.object.isRequired,
    closeModal: React.PropTypes.func.isRequired
};
