/* eslint-disable */

import React from 'react';
import * as firebase from 'firebase';
import FirebaseComponent from './FirebaseComponent';

// Polyfills
import win from './windowPolyfill';

export default class ChatBar extends FirebaseComponent {
  constructor(props) {
    super(props);
    this.initializeFirebase();
    this.sendMessage = this.sendMessage.bind(this);
    this.addProductToFirebase = this.addProductToFirebase.bind(this);
    win.addToShoppingSpree = this.addProductToFirebase;
    this.detectEnterKey = this.detectEnterKey.bind(this);
  }

  addProductToFirebase(productID, productName, productDescription, productPrice,
    productImage, productUrl, color, customizations) {
    const newMessage = this.chatsDB.push();
    newMessage.set({ type: 'share_dress',
      value:
      {
        name: productName,
        price: productPrice,
        product_id: productID,
        url: productUrl,
        color: color,
        image: productImage,
        customizations,
        description: productDescription,
      },
      created_at: firebase.database.ServerValue.TIMESTAMP,
      from:
      {
        name: this.props.name,
        email: this.props.email,
        icon: this.props.icon,
      },
    },

                  );

    }

    initializeFirebase()
    {
        super.connectToFirebase();
        this.chatsDB  = firebase.apps[0].database().ref( this.props.firebaseNodeId + "/chats" );
    }

    sendMessage()
    {
        if( this.textInput.value.trim() !== "" )
        {
            this.createTextMessage( this.textInput.value, this.props.name, this.props.email, this.props.icon );
        }
        this.textInput.value = "";
    }

    detectEnterKey(e)
    {
        if( e.key === 'Enter' )
        {
            this.sendMessage();
        }
    }

    render()
    {
        return (
            <div className="chat-bar-container">
              <div className="chat-bar equal">
                <div className="col-xs-9 no-right-gutter no-left-gutter">
                  <input onKeyPress={this.detectEnterKey} ref={(input) => { this.textInput = input; }} className="shoppingSpreeTextInput" type="text"></input>
                </div>
                <div className="col-xs-3 no-left-gutter no-right-gutter">
                  <a onClick={this.sendMessage} className='btn btn-black'>Send</a>
                </div>
              </div>
            </div>
        );
    }
}

ChatBar.propTypes = {
    firebaseAPI: React.PropTypes.string.isRequired,
    firebaseDatabase: React.PropTypes.string.isRequired,
    firebaseNodeId: React.PropTypes.string.isRequired,
    name: React.PropTypes.string.isRequired,
    email: React.PropTypes.string.isRequired,
    icon: React.PropTypes.number.isRequired
}
