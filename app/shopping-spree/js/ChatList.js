/* eslint-disable */
import React from 'react';
import PropTypes from 'prop-types';
import * as firebase from 'firebase';

import TextMessage from './TextMessage';
import JoinedMessage from './JoinedMessage';
import DressMessage from './DressMessage';
import FirebaseComponent from './FirebaseComponent';
import win from './windowPolyfill';

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
        let toConcat = null;
        switch( data.val().type )
        {
            case 'text':
            case 'discount':
            toConcat = [<TextMessage key={data.key}
                        text={data.val().value}
                        iconNumber={parseInt(data.val().from.icon)}
                        name={data.val().from.name}
                        email={data.val().from.email}
                        sameOwnerAsLastMessage={this.sameOwnerAsLastMessage( data.val().from.email )} />];
            break;

            case 'welcome_message':
            break;

            case 'share_dress':
            toConcat = 
                [<DressMessage key={data.key}
                 iconNumber={data.val().from.icon}
                 name={data.val().from.name}
                 email={data.val().from.email}
                 sameOwnerAsLastMessage={this.sameOwnerAsLastMessage( data.val().from.email )}
                 dress={data.val().value}
                 showAddToCartModal={this.props.showAddToCartModal}
                 />];
            break;

            case 'joined':
            toConcat = [
                    <JoinedMessage key={data.key}
                name={data.val().from.name}
                email={data.val().from.email}
                createdAt={data.val().created_at} />
            ];
            break;
            default:
            console.log( "unknown card type: " + data.val().type );

        }
        if( toConcat != null )
        {
            this.state.messages = this.state.messages.concat(toConcat);
            this.setState(
                {
                    messages: this.state.messages,
                    updateCount: this.state.updateCount + 1
                }
            );
        }
    }

    scrollToBottom ()
    {
        this.bottomOfChat.scrollIntoView( { behavior: "instant", block: "end" } );
    }

    printError( error )
    {
        console.log( 'Chat List got error' );
        console.log( error );
    }
    startListeningToFirebase()
    {
        super.connectToFirebase();

        this.chatsDB  = firebase.apps[0].database().ref( this.props.firebaseNodeId + "/chats" );
        this.chatsDB.on( 'child_added', this.addChatMessage, this.printError );
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

    exit()
    {
        console.log( 'exit' );
    }
    render()
    {
        return(
            <div className="chat-list">
              <div className="row chat-header">
                <div className="col-xs-4 header-name">
                  {this.props.name}
                </div>
                <div className="col-xs-8 header-name text-right">
                  <span className="chat-list-exit link" onClick={this.props.doneShoppingSpree} role="button">
                    Exit
                  </span>
                  <span className="link" onClick={this.props.showShareModal} role="button">
                    Add more friends!
                  </span>
                </div>

              </div>
              <div className="row">
                <div className="chat-content">
                  <ul>
                    {this.state.messages}
                  </ul>
                  <div style={{ float:"left", clear: "both" }} ref={(el) => { this.bottomOfChat = el; }} >
                  </div>
                </div>
              </div>
            </div>
        );
    }
}


ChatList.propTypes = {
    firebaseAPI: PropTypes.string.isRequired,
    firebaseDatabase: PropTypes.string.isRequired,
    firebaseNodeId: PropTypes.string.isRequired,
    showAddToCartModal: PropTypes.func.isRequired,
    name: PropTypes.string.isRequired,
    doneShoppingSpree: PropTypes.func.isRequired,
    showShareModal: PropTypes.func.isRequired
};
