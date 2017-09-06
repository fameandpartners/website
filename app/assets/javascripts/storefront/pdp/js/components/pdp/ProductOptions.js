import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import autoBind from 'react-autobind';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { find } from 'lodash';

// Utilities
import { formatCents } from '../../utilities/accounting';
import {
  addonSelectionDisplayText,
  calculateSubTotal,
  sizingDisplayText,
} from '../../utilities/pdp';

// Constants
import CustomizationConstants from '../../constants/CustomizationConstants';

// UI components
import ProductOptionsRow from './ProductOptionsRow';
import ProductSecondaryActions from './ProductSecondaryActions';

// Actions
import * as CustomizationActions from '../../actions/CustomizationActions';
// CSS
import '../../../css/components/ProductOptions.scss';

// UI Components
import AddToCartButton from './AddToCartButton';


function stateToProps(state) {
  // Which part of the Redux global state does our component want to receive as props?
  const selectedColor = state.$$customizationState.get('selectedColor');
  const addons = state.$$customizationState.get('addons');

  return {
    // PRODUCT
    productId: state.$$productState.get('productId'),
    productTitle: state.$$productState.get('productTitle'),
    productCentsBasePrice: state.$$productState.get('productCentsBasePrice'),
    $$productImages: state.$$productState.get('productImages'),

    // COLOR
    colorId: selectedColor.get('id'),
    colorName: selectedColor.get('presentation'),
    colorCentsTotal: selectedColor.get('centsTotal'),
    colorHexValue: selectedColor.get('hexValue'),

    // SELECTIONS
    addonOptions: addons ? addons.get('addonOptions').toJS() : null,
    selectedDressSize: state.$$customizationState.get('selectedDressSize'),
    selectedHeightValue: state.$$customizationState.get('selectedHeightValue'),
    selectedMeasurementMetric: state.$$customizationState.get('selectedMeasurementMetric'),
    selectedStyleCustomizations: state.$$customizationState.get('selectedStyleCustomizations').toJS(),
  };
}


function dispatchToProps(dispatch) {
  const { activateCustomizationDrawer } = bindActionCreators(CustomizationActions, dispatch);
  return { activateCustomizationDrawer };
}

class ProductOptions extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  retrieveSelectedAddonOptions() {
    const { addonOptions, selectedStyleCustomizations } = this.props;
    return addonOptions.filter(a => selectedStyleCustomizations.indexOf(a.id) > -1);
  }

  generateColorSelectionNode() {
    const {
      colorCentsTotal,
      colorName,
      colorHexValue,
    } = this.props;

    return (
      <span>
        <span>{colorName}</span>&nbsp;
        { colorCentsTotal
          ? <span>+{formatCents(colorCentsTotal, 0)}</span>
          : null
        }
        <span
          style={{ background: colorHexValue }}
          className="ProductOptions__color-swatch u-display--inline-block"
        />
      </span>
    );
  }

  generateAddonSelectionNode() {
    const selectedOptions = this.retrieveSelectedAddonOptions();
    const displayText = addonSelectionDisplayText({ selectedAddonOptions: selectedOptions });

    return (
      <span>{displayText}</span>
    );
  }

  generateSizingNode() {
    const {
      selectedHeightValue,
      selectedMeasurementMetric,
      selectedDressSize,
    } = this.props;
    const sizingInformation = sizingDisplayText({
      selectedDressSize,
      selectedHeightValue,
      selectedMeasurementMetric,
    });

    return sizingInformation ? (
      <span>
        {sizingInformation}
      </span>
    ) : null;
  }

  calculateSubTotal() {
    const {
      productCentsBasePrice,
      colorCentsTotal,
    } = this.props;

    const selectedAddonOptions = this.retrieveSelectedAddonOptions();
    return calculateSubTotal({ colorCentsTotal, productCentsBasePrice, selectedAddonOptions });
  }

  /**
   * Activates a drawer to a specific drawer type
   * @param  {String} drawer
   */
  handleProductOptionClick(drawer) {
    return () => {
      this.props.activateCustomizationDrawer({
        productCustomizationDrawer: drawer,
      });
    };
  }

  /**
   * Checks for our current color amongst images and returns that image, or default
   * @return {String} imageUrl
   */
  findColorSpecificFirstImageUrl() {
    const { $$productImages, colorId } = this.props;
    const productImages = $$productImages.toJS();
    const hasMatch = find(productImages, { colorId });
    return hasMatch ? hasMatch.bigImg : productImages[0].bigImg;
  }

  render() {
    const {
      productTitle,
      selectedStyleCustomizations,
      selectedDressSize,
      selectedHeightValue,
    } = this.props;

    return (
      <div className="ProductOptions grid-12-noGutter">
        <div className="ProductOptions__primary-image-container brick col-6">
          <img className="u-width--full" alt="dress1" src={this.findColorSpecificFirstImageUrl()} />
        </div>
        <div className="ProductOptions__col grid-middle col-6 u-center">
          <div className="ProductOptions__container">
            <div className="ProductOptions__content u-mb-normal typography">
              <ProductOptionsRow
                heading
                leftNode={<h1 className="u-display--inline h4">{productTitle}</h1>}
                rightNode={
                  <span className="h4">
                    {this.calculateSubTotal()}
                  </span>
                }
              />
              <ProductOptionsRow
                leftNode={<span>Color</span>}
                leftNodeClassName="u-uppercase"
                optionIsSelected
                rightNode={this.generateColorSelectionNode()}
                handleClick={this.handleProductOptionClick(CustomizationConstants.COLOR_CUSTOMIZE)}
              />
              <ProductOptionsRow
                leftNode={<span>Design Customizations</span>}
                leftNodeClassName="u-uppercase"
                optionIsSelected={!!selectedStyleCustomizations.length}
                rightNode={this.generateAddonSelectionNode()}
                handleClick={this.handleProductOptionClick(CustomizationConstants.STYLE_CUSTOMIZE)}
              />
              <ProductOptionsRow
                leftNode={<span>Your size</span>}
                leftNodeClassName="u-uppercase"
                optionIsSelected={!!(selectedDressSize && selectedHeightValue)}
                rightNode={this.generateSizingNode()}
                handleClick={this.handleProductOptionClick(CustomizationConstants.SIZE_CUSTOMIZE)}
              />
            </div>
            <div className="ProductOptions__ctas grid-1">
              <AddToCartButton showTotal={false} shouldActivateCartDrawer />
            </div>
            <div className="ProductOptions__additional-info u-mb-normal">
              <p>
                $5 of each sale funds a women&apos;s empowerment charity.&nbsp;
                <a className="link link--static">Learn more</a>
              </p>
              <p className="u-mb-small">
                Complimentary shipping and returns.&nbsp;
                <a className="link link--static">Learn more</a>
              </p>
              <ProductSecondaryActions />
            </div>
          </div>
        </div>
      </div>
    );
  }
}

ProductOptions.propTypes = {
  //* Redux Properties
  // PRODUCT
  $$productImages: ImmutablePropTypes.listOf(ImmutablePropTypes.contains({
    id: PropTypes.number,
    colorId: PropTypes.number,
    smallImg: PropTypes.string,
    bigImg: PropTypes.string,
    height: PropTypes.number,
    width: PropTypes.number,
    position: PropTypes.number,
  })).isRequired,
  productTitle: PropTypes.string.isRequired,
  productCentsBasePrice: PropTypes.number.isRequired,
  // COLOR
  colorId: PropTypes.number.isRequired,
  colorCentsTotal: PropTypes.number,
  colorName: PropTypes.string.isRequired,
  colorHexValue: PropTypes.string.isRequired,
  // ADDONS
  addonOptions: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
      name: PropTypes.string,
    }),
  ),
  selectedDressSize: PropTypes.number,
  selectedHeightValue: PropTypes.number,
  selectedMeasurementMetric: PropTypes.string.isRequired,
  selectedStyleCustomizations: PropTypes.arrayOf(PropTypes.number).isRequired,
  //* Redux Actions
  activateCustomizationDrawer: PropTypes.func.isRequired,
};

ProductOptions.defaultProps = {
  addonOptions: [],
  colorCentsTotal: 0,
  selectedDressSize: null,
  selectedHeightValue: null,
};

export default connect(stateToProps, dispatchToProps)(ProductOptions);
