import React from 'react';
import * as firebase from 'firebase';

export default class ChatList extends React.Component
{
    constructor( props )
    {
        super( props );
        this.initializeFirebase()
    }
 
    initializeFirebase()
    {
        var config =
            {
                apiKey: this.props.firebaseAPI,
                authDomain: this.props.firebaseDatabase + ".firebaseapp.com",
                databaseURL: "https://" + this.props.firebaseDatabase + ".firebaseio.com",
                projectId: this.props.firebaseDatabase,
                storageBucket: this.props.firebaseDatabase + ".appspot.com"
            }
        
        this.chatsDB  = firebase.initializeApp( config ).database().ref( this.props.firebaseNodeId + "/chats" );
    }
    
    render()
    {
        return(
                <div className="chat-list">
                <div className="chat-content">Test</div>
                </div> 
        )
    }
}


ChatList.propTypes = {
    firebaseAPI: React.PropTypes.string.isRequired,
    firebaseDatabase: React.PropTypes.string.isRequired,
    firebaseNodeId: React.PropTypes.string.isRequired
}
