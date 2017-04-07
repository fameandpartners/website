import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { find } from 'lodash';
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
    this.handleApply = this.handleApply.bind(this);
  }

  handleDressSizeSelection(event) {
    const customize = {};
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

  updateHeightSelection(height) {
    this.props.actions.customizeDress({ height });
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

  handleApply() {
    this.closeMenu();
  }

  handleMetricSwitch({ value }) {
    const CM_TO_INCHES = 2.54;
    const { heightValue } = this.props.customize.height;
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
    const ERROR = this.props.customize.size.error
      ? 'c-card-customize__content__left error'
      : 'c-card-customize__content__left';
    const displayString = height.heightValue && size.presentation
      ? `${height.heightValue} ${height.heightUnit} / ${size.presentation}`
      : '';

    return (
      <div>
        <div className={ERROR}>Size Profile</div>
        <div className="c-card-customize__content__right">
          { displayString }
        </div>
      </div>
    );
  }

  generateDressSizeSelections() {
    // NOTE: I'm still apalled that we're having to parse nested tables because
    // of Ruby's OpenStruct. Please note this is being done here.
    return this.props.defaultSizes.map((size) => {
      const ITEM_STATE = parseInt(this.props.customize.size.id, 10) === size.table.id
        ? 'selector-size is-selected' : 'selector-size';
      return (
        <a
          className={ITEM_STATE}
          onClick={this.handleDressSizeSelection}
          key={`size-${size.table.id}`}
          data-id={size.table.id}
          data-presentation={size.table.presentation}
        >
          {size.table.presentation}
        </a>
      );
    });
  }

  render() {
    const MENU_STATE = this.state.active ? 'pdp-side-menu is-active' : 'pdp-side-menu';
    const TRIGGER_STATE = this.props.customize.size.id
      ? 'c-card-customize__content is-selected' : 'c-card-customize__content';
    const SIZES = this.generateDressSizeSelections();
    const { customize } = this.props;

    return (
      <div className="pdp-side-container pdp-side-container-size">
        <a
          className={TRIGGER_STATE}
          onClick={this.openMenu}
        >
          {this.generateSizeProfileSummary()}
        </a>

        <div className={MENU_STATE}>
          <div className="custom-scroll">
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
                { customize.height.heightUnit === 'inch' ?
                  <Select
                    id="height-option-in"
                    onChange={this.handleInchChange}
                    className="sort-options"
                    options={this.generateOptions()}
                  /> :
                  <Input
                    id="height-option-cm"
                    type="number"
                    onChange={this.handleCMChange}
                    defaultValue={customize.height.heightValue}
                  />
                }
              </div>

              <div className="metric-container pull-left">
                <RadioToggle
                  id="some-radio-tog"
                  value={customize.height.heightUnit}
                  options={[
                    { label: 'inches', value: 'inch' },
                    { value: 'cm' },
                  ]}
                  onChange={this.handleMetricSwitch}
                />
              </div>
            </div>
          </div>

          <div className="size-selection">
            <h4>What's your dress size?</h4>
            <div className="row">{SIZES}</div>
            <SidePanelSizeChart />
            <div className="btn-wrap">
              <div onClick={this.handleApply} className="btn btn-black btn-lrg">Apply</div>
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
