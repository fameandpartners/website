import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Motion, spring } from 'react-motion';

// Actions
import * as AppActions from '../../../actions/AppActions';

// Constants
import { NAVIGATION_CONTAINERS } from '../../../constants/AppConstants';

// Components
import IconSVG from '../../generic/IconSVG';
import ContainerDividerToggle from '../ContainerDividerToggle';
import SideMenuActionButtons from './SideMenuActionButtons';
import SideMenuSubNavigation from './SideMenuSubNavigation';
import Hamburger from '../header/Hamburger';

// Assets
import FameLogo from '../../../../svg/i-fame-logo.svg';

// CSS
import '../../../../css/components/SideMenu.scss';

function stateToProps(state) {
  // Which part of the Redux global state does our component want to receive as props?
  return {
    sideMenuOpen: state.$$appState.get('sideMenuOpen'),
  };
}

function dispatchToProps(dispatch) {
  const actions = bindActionCreators(AppActions, dispatch);
  return {
    activateSideMenu: actions.activateSideMenu,
  };
}


class SideMenu extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
    this.state = {
      subNavigationContainer: null,
    };
  }

  handleCloseMenu() {
    const { activateSideMenu } = this.props;
    activateSideMenu({ sideMenuOpen: false });
  }

  handleMenuActionClick(subNavigationContainer) {
    this.setState({ subNavigationContainer });
  }

  handleReturnClick() {
    this.setState({ subNavigationContainer: null });
  }

  render() {
    const { sideMenuOpen } = this.props;
    const { subNavigationContainer } = this.state;
    return (
      <Motion
        style={{
          x: spring(sideMenuOpen ? 0 : -20, {
            stiffness: 170,
            damping: 18,
            precision: 80,
          }),
        }}
      >
        {({ x }) =>
          <div
            className="SideMenu u-flex u-flex--col"
            style={{
              WebkitTransform: `translate3d(${x * 5}%, 0, 0)`,
              transform: `translate3d(${x * 5}%, 0, 0)`,
            }}
          >
            <div className="SideMenu__header header__wrapper">
              <Hamburger
                className="SideMenu__menu-btn u-position--absolute"
                isOpen
                handleClick={this.handleCloseMenu}
              />
              <div className="col-4 u-text-align--center">
                <IconSVG
                  svgPath={FameLogo.url}
                  width="200px"
                  height="26px"
                />
              </div>
            </div>

            <div className="SideMenu__contents u-flex u-flex--1">
              <div className="u-width--full">
                <ContainerDividerToggle
                  activeId={subNavigationContainer}
                  activationIdSet={[
                    NAVIGATION_CONTAINERS.SHOP_ALL,
                    NAVIGATION_CONTAINERS.WHO_WE_ARE,
                  ]}
                  leftContainerNode={
                    <SideMenuActionButtons
                      handleMenuActionClick={this.handleMenuActionClick}
                    />
                  }
                  rightContainerNode={(
                    <SideMenuSubNavigation
                      subNavigationContainer={
                        subNavigationContainer
                        || NAVIGATION_CONTAINERS.SHOP_ALL
                      }
                      handleReturnClick={this.handleReturnClick}
                    />
                  )}
                />

              </div>
            </div>
          </div>
        }
      </Motion>
    );
  }
}

SideMenu.propTypes = {
  activateSideMenu: PropTypes.func.isRequired,
  sideMenuOpen: PropTypes.bool,
};
SideMenu.defaultProps = {
  sideMenuOpen: false,
};
export default connect(stateToProps, dispatchToProps)(SideMenu);
