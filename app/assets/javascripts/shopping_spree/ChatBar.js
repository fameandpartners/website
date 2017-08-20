import React from 'react';
import * as firebase from 'firebase';
import FirebaseComponent from './FirebaseComponent';
 
export default class ChatBar extends FirebaseComponent
{
    constructor( props )
    {
        super( props );
        this.initializeFirebase();
        this.sendMessage = this.sendMessage.bind(this);
    }
    
    initializeFirebase()
    {
        super.connectToFirebase()
        this.chatsDB  = firebase.apps[0].database().ref( this.props.firebaseNodeId + "/chats" );
    }
    
    sendMessage()
    {
        let newMessage = this.chatsDB.push();
        newMessage.set( { type: 'text',
                          value: this.textInput.value,
                          created_at: firebase.database.ServerValue.TIMESTAMP,
                          from:
                          {
                              name: this.props.name,
                              email: this.props.email,
                              icon: this.props.icon
                          }
                        }
                      );
        this.textInput.value = "";        
    } 

    render()
    {
        return ( <div className="row chat-bar equal">
                 <div className="col-xs-10 no-right-gutter">
                 <input ref={(input) => { this.textInput = input; }} className="shoppingSpreeTextInput" type="text"></input>
                 </div>
                 <div className="col-xs-2 no-left-gutter">
                 <a onClick={this.sendMessage} className='center-block btn btn-black btn-lrg'>Send</a>
                 </div>
                 </div> );
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