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
        let display = 'onboarding';
        let minimize = false;
        if( this.props.firebaseId  )
        {
            display = 'chat';
            minimize = true;
        };
        
        this.state =
            {
                display: display,
                name: this.props.name,
                email: this.props.email,
                icon: this.props.icon,
                firebaseNodeId: this.props.firebaseId,
                minimize: minimize,
                showAddToCartModal: false,
                dressAddingToCart: null
            };

        this.doneOnboarding = this.doneOnboarding.bind(this);
        this.doneSharing = this.doneSharing.bind(this);
        this.showAddToCartModal = this.showAddToCartModal.bind(this);
        this.closeAddToCartModal = this.closeAddToCartModal.bind(this);
        this.doneShoppingSpree = this.doneShoppingSpree.bind(this);
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
        let cookies = new Cookies();
        cookies.remove( 'shopping_spree_name' );
        cookies.remove( 'shopping_spree_email' );
        cookies.remove( 'shopping_spree_id' );
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
                        <Drawer firebaseAPI={this.props.firebaseAPI} firebaseDatabase={this.props.firebaseDatabase} firebaseNodeId={this.state.firebaseNodeId} name={this.state.name} email={this.state.email} icon={this.state.icon} closed={this.state.minimize} showAddToCartModal={this.showAddToCartModal} doneShoppingSpree={this.doneShoppingSpree}/>
                        
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
};
