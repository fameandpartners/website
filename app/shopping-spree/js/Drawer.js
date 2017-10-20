/* eslint-disable */
import React from 'react';
import PropTypes from 'prop-types';
import ChatList from './ChatList';
import ChatBar from './ChatBar';
import Cart from './Cart';
import Toast from './Toast';

export default class Drawer extends React.Component
{

    constructor(props)
    {
        super(props);

        this.state =
            {
                closed: this.props.closed,
                display: 'chat',
                firebaseAPI: props.firebaseAPI,
                firebaseDatabase: props.firebaseDatabase,
                firebaseNodeId: props.firebaseNodeId,
                name: props.name,
                email: props.email,
                icon: props.icon,
                currentDiscount: null
            };
        this.handleToggle = this.handleToggle.bind(this);
        this.transitionToCart = this.transitionToCart.bind(this);
        this.transitionToChat = this.transitionToChat.bind(this);
        this.updateDiscountOnDrawer = this.updateDiscountOnDrawer.bind(this);
    }

    updateDiscountOnDrawer(newDiscount) {
        this.setState({
            currentDiscount: newDiscount
        });
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
                closed: false,
                display: 'chat'
            });
    }

    render()
    {
        const {
            currentDiscount,
        } = this.state;

        if( this.state.firebaseNodeId  && this.state.name && this.state.email )
        {
            return (
                <div className={"shopping-spree-wrapper " + (this.state.closed && this.state.display !== 'cart' ? 'collapsed' : 'open')}>
                  <div className={"shopping-spree-container container" + (this.state.display !== 'cart' ? " hidden" : "") }>
                    <Cart transitionToChat={this.transitionToChat}
                          firebaseAPI={this.state.firebaseAPI}
                          firebaseDatabase={this.state.firebaseDatabase}
                          firebaseNodeId={this.state.firebaseNodeId}
                          name={this.state.name}
                          email={this.state.email}
                          updateDiscount={this.updateDiscountOnDrawer}
                          doneShoppingSpree={this.props.doneShoppingSpree}
                          />
                  </div>

                  <div className={"shopping-spree-container container " + (this.state.closed ? 'collapsed' : 'open') + (this.state.display === 'cart' ? " hidden" : "")}>
                    { this.state.closed ?
                        <div className="row header">
                              <div role="button" className="u-width--full" onClick={this.handleToggle}>
                                    <div className="col-xs-10 text-left">Clique</div>
                                        <div className="col-xs-2"><span onClick={this.transitionToCart} className="icon icon-bag"></span></div>
                                  </div>
                            </div>
                            :
                            <div className="row header">
                                  <div role="button" className="u-width--full" onClick={this.handleToggle}>
                                        <div className="col-xs-2">
                                              <i className={"toggle-btn " + (this.state.closed ? "closed-caret" : "open-caret")}  onClick={this.handleToggle}></i>
                                            </div>
                                            <div className="col-xs-8 text-center">
                                                  Clique&nbsp;
                                                      {
                                                      currentDiscount
                                                          ? `${currentDiscount} off`
                                                          : null
                                                      }
                                                </div>
                                                <div className="col-xs-2"><span onClick={this.transitionToCart} className="icon icon-bag"></span></div>
                                      </div>
                                </div>
                            }
                            <ChatList
                              firebaseAPI={this.state.firebaseAPI}
                              firebaseDatabase={this.state.firebaseDatabase}
                              firebaseNodeId={this.state.firebaseNodeId}
                              showAddToCartModal={this.props.showAddToCartModal}
                              name={this.state.name}
                              doneShoppingSpree={this.props.doneShoppingSpree}
                              updateExitModalStatus={this.props.updateExitModalStatus}
                              showShareModal={this.props.showShareModal}
                              /> 
                            <ChatBar
                              firebaseAPI={this.state.firebaseAPI}
                              firebaseDatabase={this.state.firebaseDatabase}
                              firebaseNodeId={this.state.firebaseNodeId}
                              name={this.state.name}
                              email={this.state.email}
                              icon={this.state.icon}
                              transitionToChat={this.transitionToChat}
                              />
                            
                  </div>
                  <Toast
                    firebaseAPI={this.state.firebaseAPI}
                    firebaseDatabase={this.state.firebaseDatabase}
                    firebaseNodeId={this.state.firebaseNodeId}
                    visible={this.state.closed}
                    email={this.state.email}
                    />
                </div>
            );
        } else
        {
            return <div></div>;
        }

    }
}

Drawer.propTypes = {
    firebaseAPI: PropTypes.string.isRequired,
    firebaseDatabase: PropTypes.string.isRequired,
    firebaseNodeId: PropTypes.string.isRequired,
    name: PropTypes.string.isRequired,
    email: PropTypes.string.isRequired,
    icon: PropTypes.number.isRequired,
    closed: PropTypes.bool.isRequired,
    showAddToCartModal: PropTypes.func.isRequired,
    doneShoppingSpree: PropTypes.func.isRequired,
    showShareModal: PropTypes.func.isRequired
};
