import React from 'react';
import * as firebase from 'firebase';

import TextMessage from './TextMessage';

export default class ChatList extends React.Component
{
    constructor( props )
    {
        super( props );
        this.addChatMessage = this.addChatMessage.bind(this);         
        this.initializeFirebase();
        this.state =
            {
                messages:  []
            };
    }

    addChatMessage( data )
    { 
        switch( data.val().type )
        {
            case 'text':
            this.state.messages.push(<TextMessage key={data.key}
                                     text={data.val().value} 
                                     iconNumber={data.val().from.icon}
                                     name={data.val().from.name}/>)
            break;
            
            case 'welcome_message':
            break;
            
            case 'share_dress':
            break;
            
            case 'joined':
            break;
            
            default:
            console.log( "unknown card type: " + data.val().type );

        }

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
        this.chatsDB.on( 'child_added', this.addChatMessage );
    }

    
    render()
    {
        return(
                <div className="chat-list">
                <div className="chat-content">
                <ul>
                {this.state.messages}
                </ul>
                </div>
                </div> 
        )
    }
}


ChatList.propTypes = {
    firebaseAPI: React.PropTypes.string.isRequired,
    firebaseDatabase: React.PropTypes.string.isRequired,
    firebaseNodeId: React.PropTypes.string.isRequired
}
