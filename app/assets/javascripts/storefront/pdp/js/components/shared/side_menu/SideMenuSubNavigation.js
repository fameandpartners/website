import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
// import { Motion, spring } from 'react-motion';

// Components
import FadeIn from '../../generic/FadeIn';
import ShopAllNavigationMobile from '../navigation/ShopAllNavigationMobile';
import WhoWeAreNavigationMobile from '../navigation/WhoWeAreNavigationMobile';

// Constants
import { NAVIGATION_CONTAINERS } from '../../../constants/AppConstants';

// Actions
import * as AppActions from '../../../actions/AppActions';

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
      searchBarActive: false,
    };
  }

  generateSideMenuSubNavigationContents() {
    const { subNavigationContainer, handleReturnClick } = this.props;
    switch (subNavigationContainer) {
      case NAVIGATION_CONTAINERS.SHOP_ALL:
        return (
          <FadeIn key={NAVIGATION_CONTAINERS.SHOP_ALL}>
            <ShopAllNavigationMobile
              handleReturnClick={handleReturnClick}
            />
          </FadeIn>
        );
      case NAVIGATION_CONTAINERS.WHO_WE_ARE:
        return (
          <FadeIn key={NAVIGATION_CONTAINERS.WHO_WE_ARE}>
            <WhoWeAreNavigationMobile
              handleReturnClick={handleReturnClick}
            />
          </FadeIn>
        );
      default:
        return null;
    }
  }

  render() {
    return (
      <div>
        {this.generateSideMenuSubNavigationContents()}
      </div>
    );
  }
}

SideMenu.propTypes = {
  subNavigationContainer: PropTypes.string,
  handleReturnClick: PropTypes.func.isRequired,
};

SideMenu.defaultProps = {
  subNavigationContainer: null,
};
export default connect(stateToProps, dispatchToProps)(SideMenu);
