/* eslint-disable */

import React from 'react';
import PropTypes from 'prop-types';
import * as firebase from 'firebase';
import FirebaseComponent from './FirebaseComponent';

// Polyfills
import win from './windowPolyfill';

export default class ChatBar extends FirebaseComponent {
  constructor(props) {
    super(props);
    this.sendMessage = this.sendMessage.bind(this);
    this.addProductToFirebase = this.addProductToFirebase.bind(this);
    win.addToShoppingSpree = this.addProductToFirebase;
    this.detectEnterKey = this.detectEnterKey.bind(this);

  }

  addProductToFirebase(productID,
                       productVariantId,
                       productName,
                       productDescription,
                       productPrice,
                       productImage,
                       productUrl,
                       color,
                       customizations) {
    this.createShareDressMessage(this.props.name,
                                 this.props.email,
                                 this.props.icon,
                                 productID,
                                 productVariantId,
                                 productName,
                                 productDescription,
                                 productPrice,
                                 productImage,
                                 productUrl,
                                 color,
                                 customizations);
     this.props.transitionToChat();

  }

    componentDidMount()
    {

    }
    
    initializeFirebase()
    {
        this.connectToFirebase();
        this.chatsDB  = firebase.apps[0].database().ref( this.props.firebaseNodeId + "/chats" );
    }

    sendMessage()
    {
        this.initializeFirebase();                
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
                  <input placeholder="Share and shop!" onKeyPress={this.detectEnterKey} ref={(input) => { this.textInput = input; }} className="shoppingSpreeTextInput" type="text"></input>
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
    firebaseAPI: PropTypes.string.isRequired,
    firebaseDatabase: PropTypes.string.isRequired,
    firebaseNodeId: PropTypes.string.isRequired,
    name: PropTypes.string.isRequired,
    email: PropTypes.string.isRequired,
    icon: PropTypes.number.isRequired,
    transitionToChat: PropTypes.func.isRequired,
}
