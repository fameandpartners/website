import React from 'react';
import * as firebase from 'firebase';

import TextMessage from './TextMessage';
import JoinedMessage from './JoinedMessage';
import DressMessage from './DressMessage';
import FirebaseComponent from './FirebaseComponent';

export default class ChatList extends FirebaseComponent
{
    constructor( props )
    {
        super( props );
        this.addChatMessage = this.addChatMessage.bind(this);
        this.sameOwnerAsLastMessage = this.sameOwnerAsLastMessage.bind( this );
        this.scrollToBottom = this.scrollToBottom.bind(this);
        this.state =
            {
                messages:  [],
                updateCount: 0
            };
    }

    sameOwnerAsLastMessage( email )
    {
        if( this.state.messages.length === 0 )
        {
            return false;
        } else
        {
            return this.state.messages[this.state.messages.length - 1].props.email === email;
        }
        
    }
    addChatMessage( data )
    { 
        switch( data.val().type )
        {
            case 'text':
            this.setState(
                {
                    messages:
                    this.state.messages.concat([<TextMessage key={data.key}
                                                text={data.val().value} 
                                                iconNumber={data.val().from.icon}
                                                name={data.val().from.name}
                                                email={data.val().from.email}
                                                sameOwnerAsLastMessage={this.sameOwnerAsLastMessage( data.val().from.email )} />]),
                    updateCount: this.state.updateCount + 1
                }
            );
            break;
            
            case 'welcome_message':
            break;
            
            case 'share_dress':
            this.setState(
                {
                    messages: 
                    this.state.messages.concat([<DressMessage key={data.key}
                                                iconNumber={data.val().from.icon}
                                                name={data.val().from.name}
                                                email={data.val().from.email}
                                                sameOwnerAsLastMessage={this.sameOwnerAsLastMessage( data.val().from.email )}
                                                dress={data.val().value}
                                                />]),
                    updateCount: this.state.updateCount + 1

                }
            );
            break;
            
            case 'joined':
            this.setState(
                {
                    messages:
                    this.state.messages.concat(
                        [
                                <JoinedMessage key={data.key}
                            name={data.val().name}
                            email={data.val().email}
                            createdAt={data.val().created_at} />
                        ]
                    ),
                    updateCount: this.state.updateCount + 1
                    
                }
            );
            
            break;
            
            
            default:
            console.log( "unknown card type: " + data.val().type );

        }



    }

    scrollToBottom ()
    {
        this.bottomOfChat.scrollIntoView( { behavior: "smooth" } );
    }
    
    startListeningToFirebase()
    {
        super.connectToFirebase();

        this.chatsDB  = firebase.apps[0].database().ref( this.props.firebaseNodeId + "/chats" );
        this.chatsDB.on( 'child_added', this.addChatMessage );
    }

    stopListeningToFirebase()
    {
        this.chatsDB.off( 'child_added', this.addChatMessage );        
    }

    componentDidUpdate()
    {
        this.scrollToBottom();
    }

    componentWillMount()
    {
        this.startListeningToFirebase();             
    }

    componentWillUnmount()
    {
        this.stopListeningToFirebase();
    }
    
    componentDidMount()
    {
        this.scrollToBottom();
    }
    render()
    {
        return(
                <div className="chat-list">
                <div className="chat-content">
                <ul>
                {this.state.messages}
                </ul>
                <div style={{ float:"left", clear: "both" }} ref={(el) => { this.bottomOfChat = el; }} >
                </div>
                
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