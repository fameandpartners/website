import React from 'react';
import * as firebase from 'firebase';

import TextMessage from './TextMessage';
import JoinedMessage from './JoinedMessage';
import DressMessage from './DressMessage';

export default class ChatList extends React.Component
{
    constructor( props )
    {
        super( props );
        this.addChatMessage = this.addChatMessage.bind(this);
        this.sameOwnerAsLastMessage = this.sameOwnerAsLastMessage.bind( this );
        this.initializeFirebase();
        this.state =
            {
                messages:  []
            };
    }

    sameOwnerAsLastMessage( email )
    {
        if( this.state.messages.length == 0 )
        {
            return false;
        } else
        {
            return this.state.messages[this.state.messages.length - 1].props.email == email;
        }
        
    }
    addChatMessage( data )
    { 
        switch( data.val().type )
        {
            case 'text':
            this.state.messages.push(<TextMessage key={data.key}
                                     text={data.val().value} 
                                     iconNumber={data.val().from.icon}
                                     name={data.val().from.name}
                                     email={data.val().from.email}
                                     sameOwnerAsLastMessage={this.sameOwnerAsLastMessage( data.val().from.email )} />)
            break;
            
            case 'welcome_message':
            break;
            
            case 'share_dress':
            this.state.messages.push(<DressMessage key={data.key}
                                     iconNumber={data.val().from.icon}
                                     name={data.val().from.name}
                                     email={data.val().from.email}
                                     sameOwnerAsLastMessage={this.sameOwnerAsLastMessage( data.val().from.email )}
                                     dress={data.val().value}
                                     />)
            break;
            
            case 'joined':
            this.state.messages.push(<JoinedMessage key={data.key}
                                     name={data.val().name}
                                     email={data.val().email}
                                     createdAt={data.val().created_at} />)
            
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
