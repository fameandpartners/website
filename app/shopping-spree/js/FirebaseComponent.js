/* eslint-disable */

import React from 'react';
import * as firebase from 'firebase';

export default class FirebaseComponent extends React.Component
{
    constructor( props )
    {
        super( props );
        this.firebaseNodeId = this.props.firebaseNodeId;
    }

    calculateDiscount( total )
    {
        let initialDiscount = (total - 200) / 100;
        initialDiscount = Math.round( initialDiscount );
        if( initialDiscount < 0 )
        {
            return 0;
        } else if( initialDiscount > 30 )
        {
            return 30;
        } else
        {
            return initialDiscount;
        }
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

    createNewShoppingSpree()
    {
        let ref = this.databaseRef('').push();
        ref.set( { members: [],
                   chats: [],
                   created_at:
                   firebase.database.ServerValue.TIMESTAMP } );
        this.firebaseNodeId = ref.key;
        
        return ref.key
    }
    
    createFamebotMessage( text )
    {
        this.createTextMessage( text, 'Fame Bot', 'help@fameandpartners.com', 20 );
    }

    createFamebotShareDressMessage( productID,
                                    productName,
                                    productDescription,
                                    productPrice,
                                    productImage,
                                    productUrl,
                                    color,
                                    customizations )
    {
        this.createShareDressMessage( 'Fame Bot',
                                      'help@fameandpartners.com',
                                      20,
                                      productID,
                                      productName,
                                      productDescription,
                                      productPrice,
                                      productImage,
                                      productUrl,
                                      color,
                                      customizations
                                    );
    }


    createShareDressMessage( name,
                             email,
                             icon,
                             productID,
                             productName,
                             productDescription,
                             productPrice,
                             productImage,
                             productUrl,
                             color,
                             customizations )
    {
        let newMessage = this.databaseRef( 'chats' ).push();
        newMessage.set({ type: 'share_dress',
                         value:
                         {
                             name: productName,
                             price: productPrice,
                             product_id: productID,
                             url: productUrl,
                             color: color,
                             image: productImage,
                             customizations,
                             description: productDescription,
                         },
                         created_at: firebase.database.ServerValue.TIMESTAMP,
                         from:
                         {
                             name: name,
                             email: email,
                             icon: icon,
                         },
                       },

                      );
        
    }
    

    createTextMessage( text, name, email, icon )
    {
        let newMessage = this.databaseRef( 'chats' ).push();
        newMessage.set( { type: 'text',
                          value: text,
                          created_at: firebase.database.ServerValue.TIMESTAMP,
                          from:
                          {
                              name: name,
                              email: email,
                              icon: icon
                          }
                        }
                      );
        
    }

    databaseRef( name )
    {
        return firebase.apps[0].database().ref( this.firebaseNodeId + "/" + name )
    }
    
}
