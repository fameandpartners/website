import React from 'react';
import * as firebase from 'firebase';

import ToastTextMessage from './ToastTextMessage';
import FirebaseComponent from './FirebaseComponent';

export default class Toast extends FirebaseComponent
{
    constructor( props )
    {
        super( props );
        this.firstRead = false;
        this.addToast = this.addToast.bind( this );
        this.state =
            {
                toasts: []
            } ;
    }

    addToast( data )
    {
        if( this.firstRead )
        {

            if( ( this.props.visible ) && (this.props.email != data.val().from.email ) )
            {
                this.setState(
                    {
                        toasts: this.state.toasts.concat([<ToastTextMessage key={data.key}
                                                           text={data.val().value} 
                                                           iconNumber={parseInt(data.val().from.icon)}
                                                           name={data.val().from.name}
                                                           email={data.val().from.email} />])
                    }
                );
            }
        } else
        {
            this.firstRead = true;
        }
    }
    
    startListeningToFirebase()
    {
        super.connectToFirebase();
        
        this.chatsDB  = firebase.apps[0].database().ref( this.props.firebaseNodeId + "/chats" );
        this.chatsDB.limitToLast(1).on( 'child_added', this.addToast );
    }

    stopListeningToFirebase()
    {
        this.chatsDB.off( 'child_added', this.addToast );
        this.fristRead = false;
    }
    
    componentWillMount()
    {
        this.startListeningToFirebase();             
    }

    componentWillUnmount()
    {
        this.stopListeningToFirebase();
    }


    componentWillReceiveProps(nextProps)
    {
        if (nextProps.visible === false )
        {
            this.setState(
                {
                    toasts: []
                }
            );
        }
    }
    
    render()
    {
        return(
            <div className="toast-container">
              <ul>
                {this.state.toasts}
              </ul>
            </div>
        );
    }
}

Toast.propTypes = {
    firebaseAPI: React.PropTypes.string.isRequired,
    firebaseDatabase: React.PropTypes.string.isRequired,
    firebaseNodeId: React.PropTypes.string.isRequired,
    visible: React.PropTypes.bool.isRequired,
    email: React.PropTypes.string.isRequired
    
}
