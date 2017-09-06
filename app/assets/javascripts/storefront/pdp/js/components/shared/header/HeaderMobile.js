import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

// Actions
import * as AppActions from '../../../actions/AppActions';
import * as CartActions from '../../../actions/CartActions';

// CSS
import '../../../../css/components/HeaderMobile.scss';

// Components
import Hamburger from './Hamburger';

// Assets
import ShoppingBagIcon from '../../../../svg/i-shopping-bag.svg';

function stateToProps(state) {
  // Which part of the Redux global state does our component want to receive as props?
  return {
    cartItems: state.$$cartState.get('lineItems'),
    cartItemCount: state.$$cartState.get('lineItems').size,
    sideMenuOpen: state.$$appState.get('sideMenuOpen'),
  };
}

function dispatchToProps(dispatch) {
  const appActions = bindActionCreators(AppActions, dispatch);
  const cartActions = bindActionCreators(CartActions, dispatch);
  return {
    activateSideMenu: appActions.activateSideMenu,
    activateCartDrawer: cartActions.activateCartDrawer,
  };
}

class HeaderMobile extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  handleMenuClick() {
    const { activateSideMenu, sideMenuOpen } = this.props;
    activateSideMenu({ sideMenuOpen: !sideMenuOpen });
  }

  handleShoppingBagClick() {
    const { activateCartDrawer } = this.props;
    activateCartDrawer({ cartDrawerOpen: true });
  }

  render() {
    const { cartItemCount, headerTitle } = this.props;
    return (
      <header className="Header HeaderMobile u-width--full">
        <div className="layout-container">
          <nav className="grid-noGutter">
            <div className="col-2">
              <Hamburger
                isOpen={false}
                handleClick={this.handleMenuClick}
              />
            </div>
            <div className="col">
              {headerTitle}
            </div>
            <ul className="col-2 u-text-align--right">
              <li onClick={this.handleShoppingBagClick} className="Header__action">
                { cartItemCount > 0
                  ? <span className="Header__cart-count">{cartItemCount}</span>
                  : null
                }
                <img
                  src={ShoppingBagIcon.url}
                  alt="Shopping Bag Icon"
                  width="26px"
                  height="26px"
                />
              </li>
            </ul>
          </nav>
        </div>
      </header>
    );
  }
}

HeaderMobile.propTypes = {
  headerTitle: PropTypes.string,
  // Redux Props
  cartItemCount: PropTypes.number,
  sideMenuOpen: PropTypes.bool,
  // Redux Actions
  activateCartDrawer: PropTypes.func.isRequired,
  activateSideMenu: PropTypes.func.isRequired,
};

HeaderMobile.defaultProps = {
  cartItemCount: 0,
  headerTitle: '',
  sideMenuOpen: false,
};

export default connect(stateToProps, dispatchToProps)(HeaderMobile);
