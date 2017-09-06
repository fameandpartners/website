import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import classnames from 'classnames';

// Actions
import * as CartActions from '../../../actions/CartActions';

// Components
import CancelOut from '../CancelOut';
import SearchBarExpander from '../../generic/SearchBarExpander';
import IconSVG from '../../generic/IconSVG';

// CSS
import '../../../../css/components/Header.scss';

// Assets
import ShoppingBagIcon from '../../../../svg/i-shopping-bag.svg';
import AccountIcon from '../../../../svg/i-account.svg';
import SearchIcon from '../../../../svg/i-search.svg';

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

  handleShoppingBagClick() {
    const { activateCartDrawer, cartDrawerOpen } = this.props;
    activateCartDrawer({ cartDrawerOpen: !cartDrawerOpen });
  }

  handleSearchBarClose() {
    this.setState({ searchBarActive: false });
  }

  handleSearchOpenClick() {
    this.setState({ searchBarActive: true });
  }

  render() {
    const { cartItemCount } = this.props;
    const { searchBarActive } = this.state;

    return (
      <ul className="col-4 u-text-align--right">
        { searchBarActive ? null : (
          <li className="Header__action">
            <IconSVG
              svgPath={AccountIcon.url}
              width="18px"
              height="26px"
              onClick={this.handleSearchOpenClick}
            />
          </li>
        )}

        <li
          className={classnames(
          'Header__action',
          { 'Header__action--active-search-left': searchBarActive },
        )}
        >
          <span
            className="Header__icon-click-wrapper"
            role="button"
            onClick={this.handleSearchOpenClick}
          >
            <IconSVG
              svgPath={SearchIcon.url}
              width="18px"
              height="26px"
            />
          </span>
        </li>

        <li>
          <SearchBarExpander
            isActive={searchBarActive}
            onBlur={this.handleSearchBarClose}
          />
        </li>

        <li
          className={classnames(
            'Header__action',
            { 'Header__action--active-search-right': searchBarActive },
          )}
        >
          { cartItemCount > 0 && !searchBarActive
            ? <span className="Header__cart-count">{cartItemCount}</span>
            : null
          }
          { searchBarActive
            ? <CancelOut onClick={this.handleSearchBarClose} />
            : (
              <span
                className="Header__icon-click-wrapper"
                role="button"
                onClick={this.handleShoppingBagClick}
              >
                <IconSVG
                  svgPath={ShoppingBagIcon.url}
                  width="18px"
                  height="26px"
                />
              </span>
            )
          }
        </li>
      </ul>
    );
  }
}

Header.propTypes = {
  // Redux Props
  cartItemCount: PropTypes.number,
  cartDrawerOpen: PropTypes.bool,
  // Redux Actions
  activateCartDrawer: PropTypes.func.isRequired,
};

Header.defaultProps = {
  cartItemCount: 0,
  cartDrawerOpen: false,
};

export default connect(stateToProps, dispatchToProps)(Header);
