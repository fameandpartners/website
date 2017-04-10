import React, { PropTypes, Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { assign, find } from 'lodash';
import * as pdpActions from '../../actions/PdpActions';
import PDPConstants from '../../constants/PDPConstants';
import SidePanelSizeChart from './SidePanelSizeChart';
import { GetDressVariantId } from './utils';

// Shared Components
import Select from '../shared/Select';
import Input from '../shared/Input';
import RadioToggle from '../shared/RadioToggle';

// Constants
const { DRAWERS, INCH_SIZES, UNITS } = PDPConstants;

class SidePanelSize extends Component {
  constructor(props, context) {
    super(props, context);
    this.openMenu = this.openMenu.bind(this);
    this.closeMenu = this.closeMenu.bind(this);
    this.handleDressSizeSelection = this.handleDressSizeSelection.bind(this);
    this.generateInchesOptions = this.generateInchesOptions.bind(this);
    this.updateHeightSelection = this.updateHeightSelection.bind(this);
    this.handleInchChange = this.handleInchChange.bind(this);
    this.handleCMChange = this.handleCMChange.bind(this);
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

  /**
   * Validates errors for Size Profile
   * @return {Boolean} isValid ?
   */
  validateErrors() {
    const { height, size } = this.props.customize;
    if (!(height.heightValue && height.heightUnit && size.id)) { // Errors present
      const errors = {};
      if (!height.heightValue) { errors.height = true; }
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
    const inches = (selection.ft * 12) + selection.inch;

    this.updateHeightSelection({
      heightId: option.id,
      heightValue: inches,
      heightUnit: UNITS.INCH,
    });
  }

  /**
   * Handler for changes of CM metric
   */
  handleCMChange({ value }) {
    this.updateHeightSelection({
      heightValue: value,
      heightUnit: UNITS.CM,
    });
  }

  /**
   * Handler for size profile applying
   */
  handleSizeProfileApply() {
    const { customize } = this.props;
    if (this.validateErrors()) {
      if (customize.addToBagPending) { return this.props.addToBagCallback(); }
      this.closeMenu();
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
    const { heightValue } = height;
    if (value === UNITS.CM && heightValue) { // CM selected
      const newVal = Math.round(heightValue * CM_TO_INCHES);
      this.handleCMChange({ value: newVal });
    } else if (value === UNITS.INCH && heightValue) { // INCH selected
      const totalInches = Math.round(heightValue / CM_TO_INCHES);
      const option = find(INCH_SIZES, { totalInches });
      if (option) {
        this.handleInchChange({
          option: {
            id: option.id,
          },
        });
      }
    }
  }

  /**
   * Handles the toggling of a metric switch
   * @param  {String} {value} (CM|INCH)
   */
  handleMetricSwitch({ value }) {
    this.updateHeightSelection({ heightUnit: value });
    this.handleUnitConversionUpdate(value);
  }

  /**
   * Helper method to generate the option and min/max extremas
   * @param  {Number} i
   * @param  {Number} ft
   * @param  {Number} inch
   * @param  {Boolean} last
   * @return {Node} maxOption
   */
  minMaxExtremeInchOption(i, ft, inch, last) {
    return (
      <div>
        <span className="amt">{ft}</span>
        <span className="metric">'</span>
        <span className="amt amt--last">{inch}</span>
        <span className="metric">"</span>
        { last ?
          <span> & over</span> :
          <span> & under</span>
        }
      </div>
    );
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
    const totalSizes = INCH_SIZES.length;
    return INCH_SIZES.map(({ ft, inch }, i) => ({
      id: i,
      name: (i === 0 || i === totalSizes - 1) ?
        this.minMaxExtremeInchOption(i, ft, inch, i === totalSizes - 1) :
        this.defaultInchOption(i, ft, inch),
      active: i === height.heightId,
    }));
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
    const { height, size } = this.props.customize;
    return (
      <div>
        <div className="c-card-customize__content__left">Size Profile</div>
        <div className="c-card-customize__content__right">
          {this.sizeSummaryUnitSelection(
            height.heightValue, height.heightUnit, size.presentation,
          )}
        </div>
      </div>
    );
  }

  generateDressSizeSelections() {
    // NOTE: I'm still apalled that we're having to parse nested tables because
    // of Ruby's OpenStruct. Please note this is being done here.
    const { size, errors } = this.props.customize;
    return this.props.defaultSizes.map((s) => {
      let itemClassName = parseInt(size.id, 10) === s.table.id
        ? 'selector-size is-selected' : 'selector-size';
      itemClassName += errors.size ? ' has-error' : '';
      return (
        <span
          className={itemClassName}
          onClick={this.handleDressSizeSelection}
          key={`size-${s.table.id}`}
          data-id={s.table.id}
          data-presentation={s.table.presentation}
        >
          {s.table.presentation}
        </span>
      );
    });
  }

  render() {
    const { addToBagPending, height, size, errors, drawerOpen } = this.props.customize;
    const MENU_STATE = drawerOpen === DRAWERS.SIZE_PROFILE ? 'pdp-side-menu is-active' : 'pdp-side-menu';
    const TRIGGER_STATE = size.id ?
    'c-card-customize__content is-selected' :
    'c-card-customize__content';
    const SIZES = this.generateDressSizeSelections();

    return (
      <div className="pdp-side-container pdp-side-container-size">
        <a
          className={TRIGGER_STATE}
          onClick={this.openMenu}
        >
          {this.generateSizeProfileSummary()}
        </a>

        <div className={MENU_STATE}>
          <div className="text-right">
            <a
              className="btn-close med"
              onClick={this.closeMenu}
            >
              <span className="hide-visually">Close Menu</span>
            </a>
          </div>
          <h2 className="h4 c-card-customize__header">Create a Size Profile</h2>
          <p>
          Enter your height and size information so we can ensure
          you'll get the best fit possible
          </p>

          <div className="height-selection clearfix">
            <h4>How tall are you?</h4>
            <div className="select-container pull-left">
              { height.heightUnit === 'inch' ?
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
                  defaultValue={height.heightValue}
                />
              }
            </div>

            <div className="metric-container pull-left">
              <RadioToggle
                id="some-radio-tog"
                value={height.heightUnit}
                options={[
                  { label: 'inches', value: 'inch' },
                  { value: 'cm' },
                ]}
                onChange={this.handleMetricSwitch}
              />
            </div>
          </div>

          <div className="size-selection">
            <h4>What's your dress size?</h4>
            <div className="size-row">{SIZES}</div>
            <SidePanelSizeChart />
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

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelSize);
