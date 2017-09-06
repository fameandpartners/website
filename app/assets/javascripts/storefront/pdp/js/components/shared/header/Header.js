import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

// Constants
import { NAVIGATION_CONTAINERS } from '../../../constants/AppConstants';

// Actions
import * as CartActions from '../../../actions/CartActions';

// Components
import HeaderActionButtons from './HeaderActionButtons';
import HeaderNavigation from './HeaderNavigation';
import IconSVG from '../../generic/IconSVG';

// CSS
import '../../../../css/components/Header.scss';

// Assets
import FameLogo from '../../../../svg/i-fame-logo.svg';

function stateToProps(state) {
  // Which part of the Redux global state does our component want to receive as props?
  return {
    cartItems: state.$$cartState.get('lineItems'),
    cartItemCount: state.$$cartState.get('lineItems').size,
    cartDrawerOpen: state.$$cartState.get('cartDrawerOpen'),
  };
}

function dispatchToProps(dispatch) {
  const { activateCartDrawer } = bindActionCreators(CartActions, dispatch);
  return { activateCartDrawer };
}

class Header extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
    this.state = {
      searchBarActive: false,
      openNavItem: null,
    };
  }

  handleAnimationEnd() {
    this.setState({ openNavItem: null });
  }

  handleLinkMouseOver(openNavItem) {
    return () => {
      this.setState({ openNavItem });
    };
  }

  handleShoppingBagClick() {
    const { activateCartDrawer, cartDrawerOpen } = this.props;
    activateCartDrawer({ cartDrawerOpen: !cartDrawerOpen });
  }

  handleSearchBarBlur() {
    this.setState({ searchBarActive: false });
  }

  handleSearchOpenClick() {
    this.setState({ searchBarActive: true });
  }

  render() {
    const { isHovering } = this.props;
    const { openNavItem } = this.state;

    return (
      <header className="Header u-position--relative u-width--full">
        <div className="layout-container Header__content-padding">
          <nav className="grid-12-noGutter">
            <ul className="col-4 textAlign--left">
              <li onMouseOver={this.handleLinkMouseOver(NAVIGATION_CONTAINERS.SHOP_ALL)}>
                <span className="Header__link" role="link">Shop all</span>
              </li>
              <li onMouseOver={this.handleLinkMouseOver(NAVIGATION_CONTAINERS.WHO_WE_ARE)}>
                <span className="Header__link" href="#about">Who we are</span>
              </li>
            </ul>
            <div className="col-4 u-text-align--center">
              <IconSVG
                svgPath={FameLogo.url}
                width="200px"
                height="26px"
              />
            </div>

            <HeaderActionButtons />
          </nav>
        </div>

        <HeaderNavigation
          isActive={isHovering}
          openNavItem={openNavItem}
          handleAnimationEnd={this.handleAnimationEnd}
        />
      </header>
    );
  }
}

Header.propTypes = {
  // Decorator Props
  isHovering: PropTypes.bool,
  // Redux Props
  cartDrawerOpen: PropTypes.bool,
  // Redux Actions
  activateCartDrawer: PropTypes.func.isRequired,
};

Header.defaultProps = {
  isHovering: false,
  cartItemCount: 0,
  cartDrawerOpen: false,
};

export default connect(stateToProps, dispatchToProps)(Header);
