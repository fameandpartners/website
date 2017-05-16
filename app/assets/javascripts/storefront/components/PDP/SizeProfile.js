import React, { PropTypes, Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { assign, find } from 'lodash';
import * as pdpActions from '../../actions/PdpActions';
import PDPConstants from '../../constants/PDPConstants';
import { noScrollBody } from '../../helpers/DOM';
import SidePanelSizeChart from './SidePanelSizeChart';
import { GetDressVariantId } from './utils';

// Libraries
import Resize from '../../decorators/Resize.jsx';
import breakpoints from '../../libs/PDPBreakpoints';

// Shared Components
import Select from '../shared/Select';
import Input from '../shared/Input';
import RadioToggle from '../shared/RadioToggle';

// Constants
const { DRAWERS, INCH_SIZES, UNITS, MIN_CM, MAX_CM } = PDPConstants;

class SidePanelSize extends Component {
  constructor(props, context) {
    super(props, context);
    this.openMenu = this.openMenu.bind(this);
    this.closeMenu = this.closeMenu.bind(this);
    this.handleDressSizeSelection = this.handleDressSizeSelection.bind(this);
    this.generateInchesOptions = this.generateInchesOptions.bind(this);
    this.updateHeightSelection = this.updateHeightSelection.bind(this);
    this.hasHeightError = this.hasHeightError.bind(this);
    this.handleInchChange = this.handleInchChange.bind(this);
    this.handleCMChange = this.handleCMChange.bind(this);
    this.applyTemporaryFilters = this.applyTemporaryFilters.bind(this);
    this.handleSizeProfileApply = this.handleSizeProfileApply.bind(this);
    this.handleUnitConversionUpdate = this.handleUnitConversionUpdate.bind(this);
    this.handleMetricSwitch = this.handleMetricSwitch.bind(this);
  }

  openMenu() {
    const { actions } = this.props;
    actions.toggleDrawer(DRAWERS.SIZE_PROFILE);
  }

  closeMenu() {
    const { actions } = this.props;
    this.validateErrors();
    actions.addToBagPending(false);
    actions.toggleDrawer(null);
  }

  updateCustomize(newCustomize) {
    const { actions, customize } = this.props;
    actions.customizeDress(assign({}, customize, newCustomize));
  }

  updateHeightSelection(newHeight) {
    const { height, errors } = this.props.customize;
    this.props.actions.customizeDress({
      errors: assign({}, errors, { height: false }),
      height: assign({}, height, newHeight),
    });
  }

  hasHeightError() {
    const { height } = this.props.customize;
    return (
      !(height.temporaryHeightValue && height.temporaryHeightUnit) || // Not Present
      (height.temporaryHeightUnit === UNITS.CM &&
      (height.temporaryHeightValue < MIN_CM || height.temporaryHeightValue > MAX_CM))
    );
  }

  /**
   * Validates errors for Size Profile
   * @return {Boolean} isValid ?
   */
  validateErrors() {
    const { size } = this.props.customize;
    const errors = {};

    if (this.hasHeightError() || !size.id) {
      if (this.hasHeightError()) { errors.height = true; }
      if (!size.id) { errors.size = true; }
      this.updateCustomize({ errors });
      return false;
    }
    return true;
  }

  handleDressSizeSelection(event) {
    const { errors } = this.props.customize;
    const customize = {};
    customize.errors = assign({}, errors, { size: false });
    customize.size = {};
    customize.size.id = event.currentTarget.dataset.id;
    customize.size.presentation = event.currentTarget.dataset.presentation;
    // search for dress variant id, this will work only for default color dresses
    // NOTE: we should check if this is even needed, since length
    // selection is required.
    customize.dressVariantId = GetDressVariantId(
      this.props.variants,
      this.props.customize.color.id,
      customize.size.id,
    );

    this.props.actions.customizeDress(customize);
  }

  /**
   * Handles for changes of INCH metric
   * @param  {Object} {option} - Select dropdown's option chosen
   */
  handleInchChange({ option }) {
    const selection = INCH_SIZES[option.id];

    if (selection) {
      const inches = (selection.ft * 12) + selection.inch;
      this.updateHeightSelection({
        temporaryHeightId: option.id,
        temporaryHeightValue: inches,
        temporaryHeightUnit: UNITS.INCH,
      });
    } else {
      this.updateHeightSelection({
        temporaryHeightId: null,
        temporaryHeightValue: null,
        temporaryHeightUnit: UNITS.INCH,
      });
    }
  }

  /**
   * Handler for changes of CM metric
   */
  handleCMChange({ value }) {
    const digitCount = (value.length) ? value.length : 0;
    const numVal = parseInt(value, 10);

    if (typeof numVal === 'number') {
      this.updateHeightSelection({
        temporaryHeightValue: numVal,
        temporaryHeightUnit: UNITS.CM,
      });
    }
  }

  applyTemporaryFilters() {
    const { height } = this.props.customize;
    this.updateHeightSelection({
      heightId: height.temporaryHeightId,
      heightValue: height.temporaryHeightValue,
      heightUnit: height.temporaryHeightUnit,
    });
  }

  /**
   * Handler for size profile applying
   */
  handleSizeProfileApply() {
    const { customize } = this.props;
    if (this.validateErrors()) {
      this.applyTemporaryFilters();
      this.closeMenu();
      if (customize.addToBagPending) {
        setTimeout(() => {
          // Ugly I know, but this is temporary workaround to hook into previous functionality
          this.props.addToBagCallback();
        }, 300);
      }
    }
    return null;
  }

  /**
   * Converts unit values on the fly
   * @param  {String} value (CM|INCH)
   */
  handleUnitConversionUpdate(value) {
    const CM_TO_INCHES = 2.54;
    const { height } = this.props.customize;
    const { temporaryHeightValue } = height;
    if (value === UNITS.CM && temporaryHeightValue) { // CM selected
      const newVal = Math.round(temporaryHeightValue * CM_TO_INCHES);
      this.handleCMChange({ value: newVal });
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

  /**
   * Handles the toggling of a metric switch
   * @param  {String} {value} (CM|INCH)
   */
  handleMetricSwitch({ value }) {
    this.updateHeightSelection({ temporaryHeightUnit: value });
    this.handleUnitConversionUpdate(value);
  }

  /**
   * Helper method to generate normal option for Select
   * @param  {Number} i
   * @param  {Nunber} ft
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
    const { height } = this.props.customize;
    return INCH_SIZES.map(({ ft, inch, totalInches }, i) => ({
      id: i,
      name: this.defaultInchOption(i, ft, inch),
      meta: totalInches,
      active: i === height.temporaryHeightId,
    }));
  }

  /**
   * Generates the inches options for the Select dropdown
   * @return {Object} options
   */
  generateErrorMessage({ height, size }, inline = false) {
    if (height || size) {
      if (!height) {
        return 'Select a size';
      } else if (!size) {
        return 'Enter a valid height';
      }
      return inline ? 'Enter valid height and size' : 'Enter a valid height and select a size';
    }
    return null;
  }

  /**
   * Creates a readable string for size summary based on units
   * @param  {Number} heightValue
   * @param  {String} heightUnit {CM|INCH}
   * @param  {String} sizePresentation - dress
   * @return {String} summary
   */
  sizeSummaryUnitSelection(heightValue, heightUnit, sizePresentation) {
    if (heightValue && sizePresentation) {
      if (heightUnit === UNITS.INCH) {
        const ft = Math.floor(heightValue / 12);
        const inch = heightValue % 12;
        return `${ft}ft ${inch}in / ${sizePresentation}`;
      }
      return `${heightValue} ${heightUnit.toLowerCase()} / ${sizePresentation}`;
    }

    return '';
  }

  /**
   * Generates a description of height and dress size solection
   * @return {Node} profileSummary
   */
  generateSizeProfileSummary() {
    const { customize } = this.props;
    const { height, size } = customize;
    const hasErrors = (customize.errors.height || customize.errors.size);
    return (
      <div>
        <a className={`c-card-customize__content__left ${hasErrors ? 'error-wrap' : ''}`}>Size Profile</a>
        { hasErrors ?
          <span className="error selection c-card-customize__content__right">
            {this.generateErrorMessage(customize.errors, true)}
          </span>
          :
          <div className="c-card-customize__content__right">
            {this.sizeSummaryUnitSelection(
              height.heightValue, height.heightUnit, size.presentation,
            )}
          </div>
        }
      </div>
    );
  }

  generateDressSizeSelections() {
    // NOTE: I'm still apalled that we're having to parse nested tables because
    // of Ruby's OpenStruct. Please note this is being done here.
    const { size, errors } = this.props.customize;
    return this.props.defaultSizes.map((s) => {
      let itemClassName = parseInt(size.id, 10) === s.table.id
        ? 'selector-size no-select is-selected' : 'selector-size noselect';
      itemClassName += errors.size ? ' has-error' : '';
      return (
        <a
          className={itemClassName}
          onClick={this.handleDressSizeSelection}
          key={`size-${s.table.id}`}
          data-id={s.table.id}
          data-presentation={s.table.presentation}
        >
          {s.table.presentation}
        </a>
      );
    });
  }

  componentDidUpdate() {
    if (this.props.breakpoint === 'mobile'
    && this.props.customize.drawerOpen === PDPConstants.DRAWERS.SIZE_PROFILE) {
      noScrollBody(true);
    } else {
      noScrollBody(false);
    }
  }

  render() {
    const { addToBagPending, height, size, errors, drawerOpen } = this.props.customize;
    const MENU_STATE = drawerOpen === DRAWERS.SIZE_PROFILE ? 'pdp-side-menu is-active' : 'pdp-side-menu';
    const TRIGGER_STATE = size.id && height.heightValue ?
    'c-card-customize__content is-selected' :
    'c-card-customize__content';
    const SIZES = this.generateDressSizeSelections();

    return (
      <div className="pdp-side-container pdp-side-container-size">
        <div
          className={TRIGGER_STATE}
          onClick={this.openMenu}
        >
          {this.generateSizeProfileSummary()}
        </div>

        <div className={MENU_STATE}>
          <div className="text-right">
            <a
              className="btn-close med"
              onClick={this.closeMenu}
            >
              <span className="hide-visually">Close Menu</span>
            </a>
          </div>
          <h2 className="h4 c-card-customize__header textAlign--left">Create a Personal Size Profile</h2>
          <p>
            Just tell us your height and size, and we'll take care of the tailoring.
          </p>

          <div className="height-selection clearfix">
            <h4>How tall are you?</h4>
            <p>Tell the truth–you don't need to add height for heels.</p>
            <div className="select-container pull-left">
              { height.temporaryHeightUnit === 'inch' ?
                <Select
                  error={errors.height}
                  id="height-option-in"
                  onChange={this.handleInchChange}
                  className="sort-options"
                  options={this.generateInchesOptions()}
                /> :
                <Input
                  error={errors.height}
                  id="height-option-cm"
                  type="number"
                  onChange={this.handleCMChange}
                  defaultValue={height.temporaryHeightValue}
                />
              }
            </div>

            <div className="metric-container pull-left">
              <RadioToggle
                id="metric"
                value={height.temporaryHeightUnit}
                options={[
                  { label: 'inches', value: 'inch' },
                  { value: 'cm' },
                ]}
                onChange={this.handleMetricSwitch}
              />
            </div>
          </div>

          <div className="size-selection">
            <h4>What's your size?</h4>
            <div className="size-row">{SIZES}</div>
            <SidePanelSizeChart />
            <div className="error-filler-height">
              {errors.height || errors.size ?
                <div className="error-wrap">
                  <span className="error-message">{this.generateErrorMessage(errors)}</span>
                </div> : null
              }
            </div>
            <div className="btn-wrap">
              <div onClick={this.handleSizeProfileApply} className="btn btn-black btn-lrg">
                Save {addToBagPending ? 'and Add To Bag' : ''}
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

SidePanelSize.propTypes = {
  breakpoint: PropTypes.string,
  customize: PropTypes.object.isRequired,
  actions: PropTypes.object,
  addToBagCallback: PropTypes.func,
};

function mapStateToProps(state) {
  return {
    customize: state.customize,
    defaultSizes: state.product.available_options.table.sizes.table.default,
    variants: state.product.available_options.table.variants,
    sizeChartVersion: state.product.size_chart,
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch),
  };
}

export default Resize(breakpoints)(connect(mapStateToProps, mapDispatchToProps)(SidePanelSize));
