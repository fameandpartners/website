import React from 'react';
import * as firebase from 'firebase';

export default class ChatBar extends React.Component
{
    constructor( props )
    {
        super( props );
        this.initializeFirebase();
        this.sendMessage = this.sendMessage.bind(this);
    }
    
    initializeFirebase()
    {
        if( !firebase.apps.length === 0 )
        {
            var config =
                {
                    apiKey: this.props.firebaseAPI,
                    authDomain: this.props.firebaseDatabase + ".firebaseapp.com",
                    databaseURL: "https://" + this.props.firebaseDatabase + ".firebaseio.com",
                    projectId: this.props.firebaseDatabase,
                    storageBucket: this.props.firebaseDatabase + ".appspot.com"
                }
            firebase.initializeApp( config );
        }
        
        this.chatsDB  = firebase.apps[0].database().ref( this.props.firebaseNodeId + "/chats" );
    }
    
    sendMessage()
    {
        this.textInput.value = "";
    }
    
    render()
    {
        return ( <div className="row chat-bar equal">
                 <div className="col-xs-10 no-right-gutter">
                 <input ref={(input) => { this.textInput = input; }} className="shoppingSpreeTextInput" type="text"></input>
                 </div>
                 <div className="col-xs-2 no-left-gutter">
                 <a onClick={this.sendMessage}className='center-block btn btn-black btn-lrg'>Send</a>
                 </div>
                 </div> );
    }
}

ChatBar.propTypes = {
    firebaseAPI: React.PropTypes.string.isRequired,
    firebaseDatabase: React.PropTypes.string.isRequired,
    firebaseNodeId: React.PropTypes.string.isRequired
}
