/* eslint-disable */

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
        this.removeToast = this.removeToast.bind(this);
    }

    addToast( data )
    {
        if( this.firstRead )
        {

            if( ( this.props.visible ) && (this.props.email != data.val().from.email ) )
            {
                this.state.toasts.unshift(<ToastTextMessage key={data.key}
                                          text={data.val().value}
                                          iconNumber={parseInt(data.val().from.icon)}
                                          name={data.val().from.name}
                                          email={data.val().from.email}
                                          removeToast={this.removeToast}/>);
                this.setState(
                    {
                        toasts: this.state.toasts
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

    removeToast( toast )
    {
        let index = -1;
        for( let i = 0; i < this.state.toasts.length; i++ )
        {
            if( this.state.toasts[i].props.key == toast.props.key )
            {
                index = i;
            }
        }
        this.state.toasts.splice( index, 1 );
        this.setState (
            {
                toasts: this.state.toasts
            }
        );

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
};
