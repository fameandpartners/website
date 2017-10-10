import React from 'react';
import Drawer from './Drawer';
import Onboarding from './Onboarding';
import ShareModal from './ShareModal';
import AddToCartModal from './AddToCartModal';
import Cookies from 'universal-cookie';

export default class ShoppingSpree extends React.Component
{
    constructor(props)
    {
        super(props);
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
        this.hideZopim = this.hideZopim.bind(this);        
        window.startShoppingSpree = this.startOnboarding;
    }

    fetchAndClearStartingState()
    {
        const toReturn = this.cookies.get('shopping_spree_starting_state');
        this.cookies.remove('shopping_spree_starting_state');
        return toReturn;
    }

    setInitialState()
    {
        const startingState = this.fetchAndClearStartingState();
        const name = this.cookies.get('shopping_spree_name');
        const icon = parseInt(this.cookies.get('shopping_spree_icon'));
        const email = this.cookies.get('shopping_spree_email');
        const firebaseId = this.cookies.get('shopping_spree_id');

        let display = 'none';
        let minimize = false;

        if (startingState)
        {
            display = startingState;
        } else if (firebaseId)
        {
            display = 'chat';
            minimize = true;
        }

        this.state =
            {
                display,
                name,
                email,
                icon,
                firebaseNodeId: firebaseId,
                minimize,
                showAddToCartModal: false,
                dressAddingToCart: null,
            };
    }

    startOnboarding()
    {
        this.setState(
            {
                display: 'onboarding',
            },
        );
    }
    showAddToCartModal(dress)
    {
        this.setState(
            {
                showAddingToCartModal: true,
                dressAddingToCart: dress,
            },
        );
    }

    closeAddToCartModal()
    {
        this.setState(
            {
                showAddingToCartModal: false,
                dressAddingToCart: null,
            },
        );
    }

    doneShoppingSpree()
    {
        this.cookies.remove('shopping_spree_name');
        this.cookies.remove('shopping_spree_email');
        this.cookies.remove('shopping_spree_id');
        this.setState(
            {
                display: 'none',
            },
        );
    }

    showShareModal()
    {
        this.setState(
            {
                display: 'share',
            },
        );
    }
    
    closeOnboarding()
    {
        this.setState(
            {
                display: 'none',
            },
        );
    }

    doneOnboarding(email, name, icon, shoppingSpreeId)
    {
        this.cookies.set('shopping_spree_name', name);
        this.cookies.set('shopping_spree_icon', icon);
        this.cookies.set('shopping_spree_email', email);
        this.cookies.set('shopping_spree_id', shoppingSpreeId);
        
        this.setState(
            {
                display: 'share',
                name,
                email,
                icon,
                firebaseNodeId: shoppingSpreeId,
            },
        );
    }

    doneSharing()
    {
        this.setState(
            {
                display: 'chat',
            },
        );
    }

    hideZopim()
    {
        if( window.$zopim && window.$zopim.livechat )
        {
            window.$zopim.livechat.hideAll();
        } else
        {
            window.requestAnimationFrame( this.hideZopim );
        }
    }

    componentDidMount()
    {
        this.hideZopim();
    }
    
    render()
    {
        return (
                <div>
                {
                    this.state.showAddingToCartModal && <AddToCartModal dress={this.state.dressAddingToCart} firebaseAPI={this.props.firebaseAPI} firebaseDatabase={this.props.firebaseDatabase} firebaseNodeId={this.state.firebaseNodeId} name={this.state.name} email={this.state.email} icon={this.state.icon} closeModal={this.closeAddToCartModal} />

                }
            {
                this.state.display === 'chat' &&
                    <Drawer firebaseAPI={this.props.firebaseAPI} firebaseDatabase={this.props.firebaseDatabase} firebaseNodeId={this.state.firebaseNodeId} name={this.state.name} email={this.state.email} icon={this.state.icon} closed={this.state.minimize} showAddToCartModal={this.showAddToCartModal} doneShoppingSpree={this.doneShoppingSpree} showShareModal={this.showShareModal} />

            }
            {
                this.state.display === 'share' &&
                    <ShareModal nextStep={this.doneSharing} firebaseNodeId={this.state.firebaseNodeId} />
            }

            {
                this.state.display === 'onboarding' &&
                    <Onboarding firebaseDatabase={this.props.firebaseDatabase} doneOnboarding={this.doneOnboarding} close={this.closeOnboarding} shoppingSpreeId={this.state.firebaseNodeId} />
            }
            </div>
        );
    }


}


ShoppingSpree.propTypes = {
    firebaseAPI: React.PropTypes.string.isRequired,
    firebaseDatabase: React.PropTypes.string.isRequired,
};

ShoppingSpree.defaultProps = {
    name: null,
    icon: 0,
    email: null,
    firebaseId: null,
};
