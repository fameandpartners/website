import React, { PureComponent } from 'react';
import autoBind from 'react-autobind';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { find } from 'lodash';

// Constants
import {
  CM_TO_INCHES,
  US_SIZES,
  AU_SIZES,
  INCH_SIZES,
  UNITS,
  // TODO: Will be used for error validations
  // MIN_CM,
  // MAX_CM,
} from '../../constants/ProductConstants';
import ModalConstants from '../../constants/ModalConstants';

// Actions
import CustomizationActions from '../../actions/CustomizationActions';
import ModalActions from '../../actions/ModalActions';

// UI Components
import ProductCustomization from './ProductCustomization';
import Select from '../form/Select';
import Input from '../form/Input';
import RadioToggle from '../form/RadioToggle';
import Button from '../generic/Button';

// CSS
import '../../../css/components/ProductCustomizationSize.scss';

function stateToProps(state) {
  return {
    isUSSiteVersion: state.$$appState.get('siteVersion') === 'us',
    productCustomizationDrawer: state.$$customizationState.get('productCustomizationDrawer'),
    temporaryMeasurementMetric: state.$$customizationState.get('temporaryMeasurementMetric'),
    temporaryHeightValue: state.$$customizationState.get('temporaryHeightValue'),
    temporaryDressSize: state.$$customizationState.get('temporaryDressSize'),
  };
}

function dispatchToProps(dispatch) {
  const {
    changeCustomizationDrawer,
    updateMeasurementMetric,
    updateHeightSelection,
    updateDressSizeSelection,
  } = bindActionCreators(CustomizationActions, dispatch);

  const modalActions = bindActionCreators(ModalActions, dispatch);

  return {
    changeCustomizationDrawer,
    updateMeasurementMetric,
    updateHeightSelection,
    updateDressSizeSelection,
    activateModal: modalActions.activateModal,
  };
}


class ProductCustomizationStyle extends PureComponent {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  handleDrawerSelection(productCustomizationDrawer) {
    this.props.changeCustomizationDrawer({ productCustomizationDrawer });
  }

  /**
   * Handler for changes of CM metric
   * @param  {Number|String} value
   */
  handleCMChange({ value }) {
    const { updateHeightSelection } = this.props;
    const numVal = parseInt(value, 10);

    if (typeof numVal === 'number' && !Number.isNaN(numVal)) {
      updateHeightSelection({
        temporaryHeightValue: numVal,
        temporaryHeightUnit: UNITS.CM,
      });
    }
  }

  /**
   * Handles for changes of INCH metric
   * @param  {Object} {option} - Select dropdown's option chosen
   */
  handleInchChange({ option }) {
    const { updateHeightSelection } = this.props;
    const selection = INCH_SIZES[option.id];

    if (selection) {
      const inches = (selection.ft * 12) + selection.inch;
      updateHeightSelection({
        temporaryHeightValue: inches,
      });
    }
  }

  /**
   * Handles the toggling of a metric switch
   * @param  {String} {value} (CM|INCH)
   */
  handleMetricSwitch({ value }) {
    const { updateMeasurementMetric } = this.props;
    updateMeasurementMetric({ temporaryMeasurementMetric: value });
    this.handleUnitConversionUpdate(value);
  }

  /**
   * Converts unit values on the fly
   * @param  {String} value (CM|INCH)
   */
  handleUnitConversionUpdate(value) { // value
    const { temporaryHeightValue } = this.props;
    if (value === UNITS.CM && temporaryHeightValue) { // CM selected
      const newVal = Math.round(temporaryHeightValue * CM_TO_INCHES);
      this.handleCMChange({
        value: newVal,
      });
    } else if (value === UNITS.INCH && temporaryHeightValue) { // INCH selected
      const totalInches = Math.round(temporaryHeightValue / CM_TO_INCHES);
      const option = find(INCH_SIZES, { totalInches });

      this.handleInchChange({
        option: {
          id: option ? option.id : null,
        },
      });
    }
  }

  handleDressSizeSelection(s) {
    return () => {
      this.props.updateDressSizeSelection({ temporaryDressSize: s });
    };
  }

  handleViewSizeGuideClick() {
    /* eslint-disable no-console */
    console.log('Show Size Guide!');
    this.props.activateModal({ modalId: ModalConstants.SIZE_GUIDE_MODAL });
  }

  /**
   * Helper method to generate normal option for Select
   * @param  {Number} i
   * @param  {Number} ft
   * @param  {Number} inch
   * @return {Node} defaultOption
   */
  defaultInchOption(i, ft, inch) {
    return (
      <div>
        <span className="amt">{ft}</span>
        <span className="metric">ft</span>
        <span className="amt amt--last">{inch}</span>
        <span className="metric">in</span>
      </div>
    );
  }

  /**
   * Generates the inches options for the Select dropdown
   * @return {Object} options
   */
  generateInchesOptions() {
    return INCH_SIZES.map(({ ft, inch, totalInches }, i) => ({
      id: i,
      name: this.defaultInchOption(i, ft, inch),
      meta: totalInches,
      active: totalInches === this.props.temporaryHeightValue,
    }));
  }

  render() {
    const {
      hasNavItems,
      productCustomizationDrawer,
      isUSSiteVersion,
      temporaryDressSize,
      temporaryMeasurementMetric,
      temporaryHeightValue,
    } = this.props;
    const SIZES = isUSSiteVersion ? US_SIZES : AU_SIZES;

    return (
      <ProductCustomization
        hasNavItems={hasNavItems}
        handleDrawerSelection={this.handleDrawerSelection}
        productCustomizationDrawer={productCustomizationDrawer}
      >
        <div className="ProductCustomizationSize__layout-container typography">
          <div className="u-mb-big">
            <h3 className="h3">
              Let’s make it fit.
            </h3>
            <p>
              Just tell us your height and size, and we&apos;ll take care of the tailoring.
            </p>
          </div>

          <div className="ProductCustomizationSize__height u-mb-normal">
            <p className="textAlign--left">How tall are you?</p>
            <div className="grid">
              <div className="col-8">
                { temporaryMeasurementMetric === UNITS.INCH ?
                  <Select
                    id="height-option-in"
                    className="sort-options"
                    options={this.generateInchesOptions()}
                    onChange={this.handleInchChange}
                  /> :
                  <Input
                    id="height-option-cm"
                    type="number"
                    focusOnMount
                    onChange={this.handleCMChange}
                    defaultValue={temporaryHeightValue}
                  />
                }
              </div>

              <div className="col">
                <RadioToggle
                  id="metric"
                  value={temporaryMeasurementMetric}
                  options={[
                      { value: UNITS.INCH },
                      { label: 'cm', value: UNITS.CM },
                  ]}
                  onChange={this.handleMetricSwitch}
                />
              </div>
            </div>

          </div>

          <div>
            <p className="textAlign--left">What&apos;s your size?</p>
            <div className="ProductCustomizationSize__size grid-12">
              { SIZES.map(s => (
                <div key={s} className="col-3">
                  <Button
                    tertiary
                    selected={s === temporaryDressSize}
                    square
                    text={s}
                    handleClick={this.handleDressSizeSelection(s)}
                  />
                </div>
              ))}
              <span
                className="link link--static"
                onClick={this.handleViewSizeGuideClick}
              >
                View Size Guide
              </span>
            </div>
          </div>
        </div>
      </ProductCustomization>
    );
  }
}

ProductCustomizationStyle.propTypes = {
  // Passed Props
  hasNavItems: PropTypes.bool.isRequired,
  // Redux Props
  activateModal: PropTypes.func.isRequired,
  productCustomizationDrawer: PropTypes.string.isRequired,
  isUSSiteVersion: PropTypes.bool.isRequired,
  temporaryDressSize: PropTypes.number,
  temporaryMeasurementMetric: PropTypes.string,
  temporaryHeightValue: PropTypes.number,
  // Redux Actions
  changeCustomizationDrawer: PropTypes.func.isRequired,
  updateMeasurementMetric: PropTypes.func.isRequired,
  updateDressSizeSelection: PropTypes.func.isRequired,
  updateHeightSelection: PropTypes.func.isRequired,
};

ProductCustomizationStyle.defaultProps = {
  hasNavItems: true,
  selectedColorId: '',
  temporaryDressSize: null,
  temporaryMeasurementMetric: null,
  temporaryHeightValue: null,
};


export default connect(stateToProps, dispatchToProps)(ProductCustomizationStyle);
