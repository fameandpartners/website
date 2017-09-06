import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import SearchBarExpander from '../../generic/SearchBarExpander';

// Assets
import Carat from '../../../../svg/carat.svg';
import SearchIcon from '../../../../svg/i-search.svg';

// Constants
import { NAVIGATION_CONTAINERS } from '../../../constants/AppConstants';

// Components
import IconSVG from '../../generic/IconSVG';

// CSS
import '../../../../css/components/SideMenuActionButtons.scss';


class SideMenuActionButtons extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
    this.state = {
      searchBarActive: false,
    };
  }

  handleSearchIconClick() {
    this.setState({ searchBarActive: true });
  }

  handleSearchIconClickClose() {
    this.setState({ searchBarActive: false });
  }

  bindActionClick(subNavigationContainer) {
    const { handleMenuActionClick } = this.props;
    return () => {
      handleMenuActionClick(subNavigationContainer);
    };
  }

  render() {
    const { searchBarActive } = this.state;

    return (
      <div>
        <div className="SideMenuActionButtons__body u-center u-position--relative">
          <ul>
            <li
              className="u-cursor--pointer"
              onClick={this.bindActionClick(NAVIGATION_CONTAINERS.SHOP_ALL)}
              role="button"
            >
              <span className="SideMenuActionButtons--mr-caret-bump">Shop all</span>
              <span className="u-position--relative u-u-display--inline">
                <IconSVG
                  svgPath={Carat.url}
                  className="SideMenuActionButtons__caret--right"
                  width="10px"
                  height="10px"
                />
              </span>
            </li>
            <li
              className="u-cursor--pointer"
              onClick={this.bindActionClick(NAVIGATION_CONTAINERS.WHO_WE_ARE)}
              role="button"
            >
              <span className="SideMenuActionButtons--mr-caret-bump">Who We Are</span>
              <span>
                <IconSVG
                  svgPath={Carat.url}
                  className="SideMenuActionButtons__caret--right u-position--inherit"
                  width="10px"
                  height="10px"
                />
              </span>
            </li>
            <li><span>Account</span></li>
            <li className="u-mb-normal">
              <span>Orders</span>
            </li>
            <li>
              <span
                className="SideMenuActionButtons__icon-wrapper"
                onClick={this.handleSearchIconClick}
              >
                <IconSVG
                  className="SearchBarExpander__icon u-cursor--pointer u-position--absolute"
                  svgPath={SearchIcon.url}
                  width="18px"
                  height="26px"
                />
              </span>
              <SearchBarExpander
                handleSearchIconClick={this.handleSearchIconClick}
                onBlur={this.handleSearchIconClickClose}
                isActive={searchBarActive}
              />
            </li>
          </ul>
        </div>
      </div>
    );
  }
}

SideMenuActionButtons.propTypes = {
  handleMenuActionClick: PropTypes.func.isRequired,
};

export default SideMenuActionButtons;
