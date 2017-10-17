/* eslint-disable */

import React from 'react';
import PropTypes from 'prop-types';
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

  checkoutOneItem( position )
  {
    if( position >= this.state.myItems.length )
    {
      this.props.doneShoppingSpree();
      window.location = '/checkout';
    } else
    {
      let dress = this.state.myItems[position].props.dress;
      let context = this;
      request.post('/user_cart/products')
        .send(
          {
            variant_id: dress.product_variant_id,
            dress_variant_id: dress.product_variant_id,
            size: "US" + dress.size + "/AU" + (parseInt(dress.size) + 4),
            color_id: dress.color['id'],
            height_value: dress.height,
            height_unit: 'inch',
            shopping_spree_total: this.state.totalInSharedCart,
            shopping_spree_item_count: this.state.myItems.length
          }
        ).end((error, response) => {
          context.checkoutOneItem( position + 1 );
          console.log( response.body );

        } );
    }
  }

  checkout()
  {
    this.checkoutOneItem( 0 );
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
        this.recalculateDiscount();
        this.createFamebotMessage(
          "Oh No! " + this.props.name + " just removed an item from their cart.  You are now getting " + this.calculateDiscount({totalItems: this.state.myItems.length}) +  "% off", "discount",
          "discount", // type
        );
    }

    recalculateDiscount(count)
    {
        let discount = this.calculateDiscount({
          totalItems: count || this.state.myItems.length
        });

        this.setState(
            {
                discount: discount + "%",
                totalOff: (discount / 100.0) * this.state.totalInMyCart
            }
        );

        this.props.updateDiscount(discount);
    }

    valueAdded(data){
      this.recalculateDiscount
    }

    startListeningToFirebase()
    {
        super.connectToFirebase();
        this.cartDB = firebase.apps[0].database().ref( this.props.firebaseNodeId + "/cart" );
        this.cartDB.on( 'child_added', this.addToCart );
        this.cartDB.on( 'value', (data) => { this.recalculateDiscount(Object.keys(data.val()).length) });
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
                      Back to Clique
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
    firebaseAPI: PropTypes.string.isRequired,
    firebaseDatabase: PropTypes.string.isRequired,
    firebaseNodeId: PropTypes.string.isRequired,
    name: PropTypes.string.isRequired,
    email: PropTypes.string.isRequired,
    updateDiscount: PropTypes.func.isRequired
}
