import React, { PureComponent } from 'react';
import autoBind from 'react-autobind';
import PropTypes from 'prop-types';
import classnames from 'classnames';

// UI Components
import ProductCustomizationNavigation from './ProductCustomizationNavigation';

class ProductCustomization extends PureComponent {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  render() {
    const {
      children,
      hasNavItems,
      handleDrawerSelection,
      productCustomizationDrawer,
    } = this.props;

    return (
      <div className="ProductCustomization u-height--full u-flex--col">
        <div className="ProductCustomization__header">
          { hasNavItems
            ? (
              <div className="grid-12">
                <div className="col-2">
                  <ProductCustomizationNavigation
                    handleDrawerSelection={handleDrawerSelection}
                    productCustomizationDrawer={productCustomizationDrawer}
                  />
                </div>
              </div>
            )
            : null
          }
        </div>
        <div
          className={classnames(
            [
              'ProductCustomization__wrapper',
              'u-overflow-y--scroll u-text-align--center u-flex--1',
            ],
        )}
        >

          <div className="grid-center-noGutter">
            <div
              className={classnames(
                'ProductCustomization__content col-6_sm-10',
              )}
            >
              { children }
            </div>
          </div>
        </div>
      </div>
    );
  }
}

ProductCustomization.propTypes = {
  // Normal Props
  children: PropTypes.node.isRequired,
  hasNavItems: PropTypes.bool,
  productCustomizationDrawer: PropTypes.string,
  handleDrawerSelection: PropTypes.func.isRequired,
};

ProductCustomization.defaultProps = {
  hasNavItems: true,
  productCustomizationDrawer: null,
  selectedColorId: '',
};


export default ProductCustomization;
