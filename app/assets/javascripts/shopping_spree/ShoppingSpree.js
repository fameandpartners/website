import React from 'react';
import Drawer from './Drawer';
import Onboarding from './Onboarding';

export default class ShoppingSpree extends React.Component
{
    constructor( props )
    {
        super( props );
        this.state =
            {
                showShareModal: false,
                location: 'onboarding',
                firebaseNodeId: '',
                name: '',
                email: ''
            };

        this.doneOnboarding = this.doneOnboarding.bind(this);
    }

    doneOnboarding( name, email, icon, shoppingSpreeId )
    {
        console.log( "Shopping Spree Id: " + shoppingSpreeId );
        this.setState(
            {
                location: 'chat',
                name: name,
                email: email,
                icon: icon,
                firebaseNodeId: shoppingSpreeId 
            }
        );
    }
    
    render()
    {
        return( 
                <div>
                {
                    this.state.location === 'chat' &&
                        <Drawer firebaseAPI={this.props.firebaseAPI} firebaseDatabase={this.props.firebaseDatabase} firebaseNodeId={this.state.firebaseNodeId}/>
                }
                {
                    this.state.location === 'onboarding' &&
                        <Onboarding doneOnboarding={this.doneOnboarding}/>
                }
                </div>
        );
    }

    
}


ShoppingSpree.propTypes = {
    firebaseAPI: React.PropTypes.string.isRequired,
    firebaseDatabase: React.PropTypes.string.isRequired
};
