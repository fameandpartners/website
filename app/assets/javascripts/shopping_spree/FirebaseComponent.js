import React from 'react';
import * as firebase from 'firebase';

export default class FirebaseComponent extends React.Component
{
    constructor( props )
    {
        super( props );
    }
    
    connectToFirebase()
    {
        if( firebase.apps.length === 0 )
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
    }    
}
