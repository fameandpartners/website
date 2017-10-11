/* eslint-disable */
import React from 'react';
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
                currentDiscount: null,
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
                display: 'chat'
            });
    }

    render()
      {
        const {
          currentDiscount,
        } = this.state;

        return (
            <div className={"shopping-spree-wrapper " + (this.state.closed ? 'collapsed' : 'open')}>
              <div className={"shopping-spree-container container" + (this.state.display !== 'cart' ? " hidden" : "") }>
                <Cart transitionToChat={this.transitionToChat}
                      firebaseAPI={this.state.firebaseAPI}
                      firebaseDatabase={this.state.firebaseDatabase}
                      firebaseNodeId={this.state.firebaseNodeId}
                      name={this.state.name}
                      email={this.state.email}
                      updateDiscount={this.updateDiscountOnDrawer}
                      />
              </div>

              <div className={"shopping-spree-container container " + (this.state.closed ? 'collapsed' : 'open') + (this.state.display === 'cart' ? " hidden" : "")}>
                <div className="row header">
                  <div role="button" className="u-width--full" onClick={this.handleToggle}>
                    <div className="col-xs-2">
                      <i className={"toggle-btn " + (this.state.closed ? "closed-caret" : "open-caret")}  onClick={this.handleToggle}></i>
                    </div>
                      <div className="col-xs-8 text-center">
                        Shopping Spree&nbsp;
                        {
                          currentDiscount
                          ? `${currentDiscount} off`
                          : null
                        }
                      </div>
                      <div className="col-xs-2"><span onClick={this.transitionToCart} className="icon icon-bag"></span></div>
                    </div>
                </div>
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


    }
}

Drawer.propTypes = {
    firebaseAPI: React.PropTypes.string.isRequired,
    firebaseDatabase: React.PropTypes.string.isRequired,
    firebaseNodeId: React.PropTypes.string.isRequired,
    name: React.PropTypes.string.isRequired,
    email: React.PropTypes.string.isRequired,
    icon: React.PropTypes.number.isRequired,
    closed: React.PropTypes.bool.isRequired,
    showAddToCartModal: React.PropTypes.func.isRequired,
    doneShoppingSpree: React.PropTypes.func.isRequired,
    showShareModal: React.PropTypes.func.isRequired
};
