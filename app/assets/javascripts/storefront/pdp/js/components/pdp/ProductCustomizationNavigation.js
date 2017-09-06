import React, { PureComponent } from 'react';
import autoBind from 'react-autobind';
import PropTypes from 'prop-types';
import classnames from 'classnames';

// Constants
import {
  COLOR_CUSTOMIZE,
  STYLE_CUSTOMIZE,
  SIZE_CUSTOMIZE,
} from '../../constants/CustomizationConstants';

// CSS
import '../../../css/components/ProductCustomizationNavigation.scss';

class ProductCustomizationNavigation extends PureComponent {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  handleDrawerSelection(drawerName) {
    return () => {
      this.props.handleDrawerSelection(drawerName);
    };
  }

  render() {
    const { productCustomizationDrawer } = this.props;
    return (
      <div className="ProductCustomizationNavigation__nav">
        <div className="grid-middle u-height--full u-position--absolute">
          <ul className="ProductCustomizationNavigation__nav-list u-uppercase u-text-align-right">
            <li
              onClick={this.handleDrawerSelection(COLOR_CUSTOMIZE)}
              className="ProductCustomizationNavigation__nav-item u-cursor--pointer"
            >
              <span
                className={classnames(
                { 'ProductCustomizationNavigation__nav-item--active': productCustomizationDrawer === COLOR_CUSTOMIZE },
              )}
              >
                Color
              </span>
            </li>
            <li
              onClick={this.handleDrawerSelection(STYLE_CUSTOMIZE)}
              className="ProductCustomizationNavigation__nav-item u-cursor--pointer"
            >
              <span
                className={classnames(
                'ProductCustomizationNavigation__nav-item u-cursor--pointer',
                { 'ProductCustomizationNavigation__nav-item--active': productCustomizationDrawer === STYLE_CUSTOMIZE },
              )}
              >Design&nbsp;Customizations</span>
            </li>
            <li
              onClick={this.handleDrawerSelection(SIZE_CUSTOMIZE)}
              className="ProductCustomizationNavigation__nav-item u-cursor--pointer"
            >
              <span
                className={classnames(
                'ProductCustomizationNavigation__nav-item u-cursor--pointer',
                { 'ProductCustomizationNavigation__nav-item--active': productCustomizationDrawer === SIZE_CUSTOMIZE },
              )}
              >Your&nbsp;Size</span>
            </li>
          </ul>
        </div>
      </div>
    );
  }
}

ProductCustomizationNavigation.propTypes = {
  productCustomizationDrawer: PropTypes.string.isRequired,
  handleDrawerSelection: PropTypes.func.isRequired,
};

ProductCustomizationNavigation.defaultProps = {};


export default ProductCustomizationNavigation;
