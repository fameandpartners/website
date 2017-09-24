import React from 'react';
import Drawer from './Drawer';
import Onboarding from './Onboarding';
import ShareModal from './ShareModal';
import AddToCartModal from './AddToCartModal';
import Cookies from 'universal-cookie';

export default class ShoppingSpree extends React.Component
{
    constructor( props )
    {
        super( props );
        
        this.cookies = new Cookies();
        this.setInitialState();
        
        this.doneOnboarding = this.doneOnboarding.bind(this);
        this.doneSharing = this.doneSharing.bind(this);
        this.showAddToCartModal = this.showAddToCartModal.bind(this);
        this.closeAddToCartModal = this.closeAddToCartModal.bind(this);
        this.doneShoppingSpree = this.doneShoppingSpree.bind(this);
        this.showShareModal = this.showShareModal.bind(this);
        this.startOnboarding = this.startOnboarding.bind(this);
        this.closeOnboarding = this.closeOnboarding.bind(this);
        window.startShoppingSpree = this.startOnboarding;
        
    }

    fetchAndClearStartingState()
    {
        let toReturn = this.cookies.get( 'shopping_spree_starting_state' );
        this.cookies.remove( 'shopping_spree_starting_state' );
        return toReturn;
    }
    
    setInitialState()
    {
        let startingState = this.fetchAndClearStartingState();
        let name = this.cookies.get('shopping_spree_name');
        let icon = parseInt(this.cookies.get('shopping_spree_icon'));
        let email = this.cookies.get('shopping_spree_email');
        let firebaseId = this.cookies.get('shopping_spree_id');
        
        let display = 'none' ;
        let minimize = false;
        
        if( startingState )
        {
            display = startingState;
        } else if( firebaseId  )
        {
            display = 'chat';
            minimize = true;
        };
        
        this.state =
            {
                display: display,
                name: name,
                email: email,
                icon: icon,
                firebaseNodeId: firebaseId,
                minimize: minimize,
                showAddToCartModal: false,
                dressAddingToCart: null
            };
    }
    
    startOnboarding()
    {
        console.log( 'start onboarding' );
        this.setState(
            {
                display: 'onboarding'
            }
        );
    }
    showAddToCartModal( dress )
    {
        this.setState(
            {
                showAddingToCartModal: true,
                dressAddingToCart: dress
            }
        );
    }

    closeAddToCartModal()
    {
        this.setState(
            {
                showAddingToCartModal: false,
                dressAddingToCart: null
            }
        );
    }

    doneShoppingSpree()
    {
        this.cookies.remove( 'shopping_spree_name' );
        this.cookies.remove( 'shopping_spree_email' );
        this.cookies.remove( 'shopping_spree_id' );
        this.setState(
            {
                display: 'none'
            }
        );
        
    }

    showShareModal()
    {
        this.setState(
            {
                display: 'share'
            }
        );
    }
    closeOnboarding()
    {
        this.setState(
            {
                display: 'none'
            }
        );
        
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
                    this.state.showAddingToCartModal && <AddToCartModal dress={this.state.dressAddingToCart} firebaseAPI={this.props.firebaseAPI} firebaseDatabase={this.props.firebaseDatabase} firebaseNodeId={this.state.firebaseNodeId} name={this.state.name} email={this.state.email} icon={this.state.icon} closeModal={this.closeAddToCartModal}/>
                        
                }
                {
                    this.state.display === 'chat' &&
                        <Drawer firebaseAPI={this.props.firebaseAPI} firebaseDatabase={this.props.firebaseDatabase} firebaseNodeId={this.state.firebaseNodeId} name={this.state.name} email={this.state.email} icon={this.state.icon} closed={this.state.minimize} showAddToCartModal={this.showAddToCartModal} doneShoppingSpree={this.doneShoppingSpree} showShareModal={this.showShareModal}/>
                        
                }
                {
                    this.state.display === 'share' &&
                        <ShareModal nextStep={this.doneSharing} firebaseNodeId={this.state.firebaseNodeId}/>
                }
            
                {
                    this.state.display === 'onboarding' &&
                        <Onboarding doneOnboarding={this.doneOnboarding} close={this.closeOnboarding}/>
                }
                </div>
        );
    }

    
}


ShoppingSpree.propTypes = {
    firebaseAPI: React.PropTypes.string.isRequired,
    firebaseDatabase: React.PropTypes.string.isRequired
};

ShoppingSpree.defaultProps = {
    name: null,
    icon: 0,
    email: null,
    firebaseId: null
};
