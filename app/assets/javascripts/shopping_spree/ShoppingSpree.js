import React from 'react';
import Drawer from './Drawer';
import Onboarding from './Onboarding';
import ShareModal from './ShareModal';

export default class ShoppingSpree extends React.Component
{
    constructor( props )
    {
        super( props );
        let display = 'onboarding';
        if( this.props.firebaseId  )
        {
            display = 'chat';
        }
        
        this.state =
            {
                display: display,
                firebaseNodeId: '',
                name: this.props.name,
                email: this.props.email,
                icon: this.props.icon,
                firebaseNodeId: this.props.firebaseId
            };

        this.doneOnboarding = this.doneOnboarding.bind(this);
        this.doneSharing = this.doneSharing.bind(this);
    }

    doneOnboarding( email, name, icon, shoppingSpreeId )
    {
        this.setState(
            {
                display: 'share',
                name: name,
                email: email,
                icon: icon,
                firebaseNodeId: shoppingSpreeId 
            }
        );
    }

    doneSharing()
    {
        this.setState(
            {
                display: 'chat'
            }
        );
    }
    render()
    {
        return( 
                <div>
                {
                    this.state.display === 'chat' &&
                        <Drawer firebaseAPI={this.props.firebaseAPI} firebaseDatabase={this.props.firebaseDatabase} firebaseNodeId={this.state.firebaseNodeId} name={this.state.name} email={this.state.email} icon={this.state.icon}/>
                }
                {
                    this.state.display === 'share' &&
                        <ShareModal nextStep={this.doneSharing} firebaseNodeId={this.state.firebaseNodeId}/>
                }
            
                {
                    this.state.display === 'onboarding' &&
                        <Onboarding doneOnboarding={this.doneOnboarding}/>
                }
                </div>
        );
    }

    
}


ShoppingSpree.propTypes = {
    firebaseAPI: React.PropTypes.string.isRequired,
    firebaseDatabase: React.PropTypes.string.isRequired,
    name: React.PropTypes.string,
    icon: React.PropTypes.number,
    email: React.PropTypes.string,
    firebaseId: React.PropTypes.string
};

ShoppingSpree.defaultProps = {
    name: null,
    icon: 0,
    email: null,
    firebaseId: null
}
