import React from 'react';
import ChatList from './ChatList'
import ChatBar from './ChatBar';


export default class Drawer extends React.Component
{
    
    constructor(props)
    {
        super(props);

        this.state =
        {
            closed: true,
            display: 'chat',
            firebaseAPI: props.firebaseAPI,
            firebaseDatabase: props.firebaseDatabase,
            firebaseNodeId: props.firebaseNodeId
            
            
        };
        this.handleToggle = this.handleToggle.bind(this);
        this.transitionToCart = this.transitionToCart.bind(this);
        this.transitionToChat = this.transitionToChat.bind(this);
        
    }

    handleToggle()
    {
        this.setState( { closed: !this.state.closed } );
    }

    transitionToCart()
    {
        this.setState(
        {
            display: 'cart'
        });
    }
    
    transitionToChat()
    {
        this.setState(
        {
            display: 'chat'
        });
    }
    
    render()
    {
        return (
            <div>
            <div className={"shopping-spree-container container" + (this.state.display !== 'cart' ? " hidden" : "") }>
            <div className="row header vertical-align">
            <div className="back-to-spree col-xs-5" onClick={this.transitionToChat}>
            Back to spree
            </div>
            <div className="col-xs-10" onClick={this.transitionToChat}>
            Your Bag
            </div>
            <div className="col-xs-3" onClick={this.transitionToChat}>
            23% off
            </div>
            
            </div>
            </div>
            
            <div className={"shopping-spree-container container " + (this.state.closed ? 'collapsed' : '') + (this.state.display === 'cart' ? " hidden" : "")}>
            <div className="full-toggle-btn" onClick={this.handleToggle}></div>
            <div className="row header vertical-align">
            <div className="col-xs-2">
            <i className={"toggle-btn " + (this.state.closed ? "closed-caret" : "open-caret")}  onClick={this.handleToggle}></i>
            </div>
            <div className="col-xs-8 text-center">Shopping Spree</div>
            <div className="col-xs-3"><span onClick={this.transitionToCart} className="icon icon-bag"></span></div>
            </div>
            <div className="row">
            <ChatList
            firebaseAPI={this.state.firebaseAPI}
            firebaseDatabase={this.state.firebaseDatabase}
            firebaseNodeId={this.state.firebaseNodeId}
            />
            </div>
            <ChatBar
            firebaseAPI={this.state.firebaseAPI}
            firebaseDatabase={this.state.firebaseDatabase}
            firebaseNodeId={this.state.firebaseNodeId}
            name='Doug'
            email='dougs@fameandpartners.com'
            icon='14'
            />
            </div>
            </div>
        );
        

    }
}

Drawer.propTypes = {
    firebaseAPI: React.PropTypes.string.isRequired,
    firebaseDatabase: React.PropTypes.string.isRequired,
    firebaseNodeId: React.PropTypes.string.isRequired
}
