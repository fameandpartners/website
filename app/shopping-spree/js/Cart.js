/* eslint-disable */

import React from 'react';
import * as firebase from 'firebase';

import FirebaseComponent from './FirebaseComponent';
import CartItem from './CartItem';
import request from 'superagent';

export default class Cart extends FirebaseComponent
{
    constructor( props )
    {
        super(props);

        this.state =
            {
                discount: "0%",
                totalInSharedCart: 0,
                totalInMyCart: 0,
                myItems: [],
                totalOff: 0

            };
        this.addToCart = this.addToCart.bind(this);
        this.recalculateDiscount = this.recalculateDiscount.bind(this);
        this.deleteItem = this.deleteItem.bind(this);
        this.checkout = this.checkout.bind(this);
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
                            <CartItem key={data.key} firebaseKey={data.key} dress={data.val().dress} delete={this.deleteItem}/>] ),
                    totalInMyCart: this.state.totalInMyCart + Math.round(data.val().dress.price)
                }
            );
        }
        this.recalculateDiscount();
    }

    checkout()
    {
        for( let i = 0 ;  this.state.myItems.length; i++ )
        {
            let dress = this.state.myItems[i].props.dress;
            console.log( this.state.myItems[i].props.dress );
            request.post('/user_cart/products')
                .send(
                    { 
                        variant_id: dress.product_variant_id,
                        dress_variant_id: dress.product_variant_id,
                        size: "US" + dress.size + "/AU" + (parseInt(dress.size) + 4),
                        color_id: dress.color['id'],
                        height_value: dress.height,
                        height_unit: 'inch'
                    }
                ).end((error, response) => {
                    console.log( response.body );
                } );
        }
    }

    deleteItem( firebaseKey )
    {
        let index = -1;
        for( let i = 0; i < this.state.myItems.length && index === -1; i++ )
        {
            if( this.state.myItems[i].props.firebaseKey == firebaseKey )
            {
                index = i;
            }
        }
        this.state.myItems.splice( index, 1 );
        this.setState (
            {
                myItems: this.state.myItems
            }
        );

        this.cartDB.child( firebaseKey ).remove();
    }

    recalculateDiscount()
    {
        let discount = this.calculateDiscount( this.state.totalInSharedCart );

        this.setState(
            {
                discount: discount + "%",
                totalOff: (discount / 100.0) * this.state.totalInMyCart
            }
        );

        this.props.updateDiscount(this.state.discount);
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
                <div className="header__inner">
                <div className="back-to-spree col-md-4 col-xs-4" onClick={this.props.transitionToChat}>
                <div className="left-caret"></div>
                <div className="back-to-spree-text shopping-spree-headline">
                    Back to spree
                </div>
                </div>
                <div className="col-xs-4 col-md-4 text-center">
                  Your Bag
                </div>
                <div className="col-xs-4 col-md-4 text-right">
                  {this.state.discount} off
                </div>
                </div>
              </div>

              <div className="row">
                <div className="no-left-gutter col-xs-push-1 col-xs-4">{this.state.discount} off
            </div>
                <div className="no-right-gutter col-xs-push-1 col-xs-6 text-right">
                ${this.state.totalOff.toFixed(2)}
            </div>
                </div>
                <div className="row">
                <div className="no-left-gutter col-xs-push-1 col-xs-4">
                <strong>Total</strong>
                </div>
                <div className="no-right-gutter col-xs-push-1 col-xs-6 text-right">
                <strong>${(this.state.totalInMyCart - this.state.totalOff).toFixed(2)}</strong>
                </div>
              </div>

              <div className="row checkout-btn">
                <div className="no-right-gutter no-left-gutter col-xs-push-1 col-xs-10"><a onClick={this.checkout} className="center-block btn btn-black btn-lrg">Checkout</a></div>
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
    email: React.PropTypes.string.isRequired,
    updateDiscount: React.PropTypes.func.isRequired
}
