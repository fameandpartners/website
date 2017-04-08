import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { assign, find } from 'lodash';
import * as pdpActions from '../../actions/PdpActions';
import PDPConstants from '../../constants/PDPConstants';
import SidePanel from './SidePanel';
import SidePanelSizeChart from './SidePanelSizeChart';
import { GetDressVariantId } from './utils';

// Shared Components
import Select from '../shared/Select';
import Input from '../shared/Input';
import RadioToggle from '../shared/RadioToggle';


class SidePanelSize extends SidePanel {
  constructor(props, context) {
    super(props, context);
    this.state = {
      ftHeight: undefined,
      cmHeightChosen: undefined,
      metricOption: 'in',
    };
    this.handleDressSizeSelection = this.handleDressSizeSelection.bind(this);
    this.generateOptions = this.generateOptions.bind(this);
    this.updateHeightSelection = this.updateHeightSelection.bind(this);
    this.handleInchChange = this.handleInchChange.bind(this);
    this.handleCMChange = this.handleCMChange.bind(this);
    this.handleMetricSwitch = this.handleMetricSwitch.bind(this);
    this.handleSizeProfileApply = this.handleSizeProfileApply.bind(this);
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

  handleInchChange({ option }) {
    const selection = PDPConstants.INCH_SIZES[option.id];
    const inches = (selection.ft * 12) + selection.inch;

    this.updateHeightSelection({
      heightId: option.id,
      heightValue: inches,
      heightUnit: 'inch',
    });
  }

  handleCMChange({ value }) {
    this.updateHeightSelection({
      heightValue: value,
      heightUnit: 'cm',
    });
  }

  handleSizeProfileApply() {
    if (this.validateErrors()) {
      this.closeMenu();
    }
  }

  handleMetricSwitch({ value }) {
    const CM_TO_INCHES = 2.54;
    const { height } = this.props.customize;
    const { heightValue } = height;
    const convertedMetric = { heightUnit: value };
    if (value === 'cm' && heightValue) {
      convertedMetric.heightValue = Math.round(heightValue * CM_TO_INCHES);
    } else if (value === 'inch' && heightValue) {
      const totalInches = Math.round(heightValue / CM_TO_INCHES);
      const inchSizeObj = find(PDPConstants.INCH_SIZES, {
        totalInches,
      });
      if (typeof inchSizeObj.id === 'number') {
        convertedMetric.heightValue = totalInches;
        convertedMetric.heightId = inchSizeObj.id;
      }
    }

    this.updateHeightSelection(convertedMetric);
  }

  generateOptions() {
    const { height } = this.props.customize;
    return PDPConstants.INCH_SIZES.map(({ ft, inch }, i) => ({
      id: i,
      name: (
        <div>
          <span className="amt">{`${ft}`}</span>
          <span className="metric">ft</span>
          <span className="amt amt--last">{`${inch}`}</span>
          <span className="metric">in</span>
        </div>
      ),
      active: i === height.heightId,
    }));
  }

  generateSizeProfileSummary() {
    const { height, size } = this.props.customize;
    const displayString = height.heightValue && size.presentation
      ? `${height.heightValue} ${height.heightUnit} / ${size.presentation}`
      : '';

    return (
      <div>
        <div className="c-card-customize__content__left">Size Profile</div>
        <div className="c-card-customize__content__right">
          { displayString }
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

  render() {
    const { height, size, errors } = this.props.customize;
    const MENU_STATE = this.state.active ? 'pdp-side-menu is-active' : 'pdp-side-menu';
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
                  options={this.generateOptions()}
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
            <div className="row">{SIZES}</div>
            <SidePanelSizeChart />
            <div className="btn-wrap">
              <div onClick={this.handleSizeProfileApply} className="btn btn-black btn-lrg">Apply</div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

SidePanelSize.propTypes = {
  customize: PropTypes.object.isRequired,
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
