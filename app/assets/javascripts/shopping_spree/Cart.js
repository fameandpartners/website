import React from 'react';
import * as firebase from 'firebase';

import FirebaseComponent from './FirebaseComponent';
import CartItem from './CartItem';

export default class Cart extends FirebaseComponent
{
    constructor( props )
    {
        super(props);

        this.state =
            {
                discount: "0%",
                totalInSharedCart: 0,
                myItems: []

            };
        this.addToCart = this.addToCart.bind(this);
        this.recalculateDiscount = this.recalculateDiscount.bind(this);
    }
    
    addToCart( data, previousChildKey )
    {
        this.setState(
            {
                totalInSharedCart: this.state.totalInSharedCart + Math.round( parseFloat( data.val().dress.price ) )
            }
        );
        
        if( data.val().entry_for.email === this.props.email  )
        {
            this.setState(
                {
                    myItems: this.state.myItems.concat( [
                            <CartItem key={data.key} dress={data.val().dress} />] )
                }
            );
        }

        this.recalculateDiscount();
    }

    recalculateDiscount()
    {
        let discount = 0;

        if( this.state.totalInSharedCart > 200 )
        {
            discount = Math.ceil((this.state.totalInSharedCart - 200 ) / 100);
            if( discount > 30 )
            {
                discount = 30;
            }
        }

        this.setState(
            {
                discount: discount + "%"
            }
        );
    }

    startListeningToFirebase()
    {
        super.connectToFirebase();
        this.cartDB = firebase.apps[0].database().ref( this.props.firebaseNodeId + "/cart" );
        this.cartDB.on( 'child_added', this.addToCart );
    }



    stopListeningToFirebase()
    {
        this.cartDB.off( 'child_added', this.addToCart );        
    }
    
    componentWillMount()
    {
        this.startListeningToFirebase();             
    }

    componentWillUnmount()
    {
        this.stopListeningToFirebase();
    }
    
    render()
    {
        return(
            <div className="shopping-spree-cart">
              <div className="row header vertical-align">
                <div className="back-to-spree col-md-4 col-xs-8" onClick={this.props.transitionToChat}>
                  <div className="left-caret"></div>
                  <div className="back-to-spree-text shopping-spree-headline">
                    Back to spree
                  </div>
                </div>
                <div className="col-xs-6 col-md-4">
                  Your Bag
                </div>
                <div className="col-xs-4 col-md-4 text-center">
                  {this.state.discount} off
                </div>
              </div>
              <div className="row">
                <div className="no-left-gutter col-xs-push-1 col-xs-4">
                  Subtotal
                </div>
                <div className="no-right-gutter col-xs-push-1 col-xs-6 text-right">
                  $210.00
                </div>
              </div>
              
              <div className="row">
                <div className="no-left-gutter col-xs-push-1 col-xs-4">{this.state.discount} off
                </div>
                <div className="no-right-gutter col-xs-push-1 col-xs-6 text-right">
                  $43.00
                </div>
              </div>
              <div className="row">
                <div className="no-left-gutter col-xs-push-1 col-xs-4">
                  <strong>Total</strong>
                </div>
                <div className="no-right-gutter col-xs-push-1 col-xs-6 text-right">
                  <strong>$143.00</strong>
                </div>
              </div>
              
              <div className="row checkout-btn">
                <div className="no-right-gutter no-left-gutter col-xs-push-1 col-xs-10"><a className="center-block btn btn-black btn-lrg">Checkout</a></div>
              </div>
              <div className="shopping-spree-contents">
                <div className="row">
                  <div className="col-xs-18">
                    <ul className="cart-item-list">
                      {this.state.myItems}
                    </ul>
                  </div>
                </div>
              </div>
            </div>
        );
    }
}

Cart.propTypes = {
    firebaseAPI: React.PropTypes.string.isRequired,
    firebaseDatabase: React.PropTypes.string.isRequired,
    firebaseNodeId: React.PropTypes.string.isRequired,
    name: React.PropTypes.string.isRequired,
    email: React.PropTypes.string.isRequired
}
