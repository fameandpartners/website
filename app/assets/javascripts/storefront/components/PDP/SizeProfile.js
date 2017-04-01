import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Scrollbars } from 'react-custom-scrollbars';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';
import SidePanelSizeChart from './SidePanelSizeChart';
import { GetDressVariantId } from './utils';

// Shared Components
import Select from '../shared/Select.jsx';
import Radio from '../shared/Radio.jsx';
import Input from '../shared/Input';
import RadioGroup from '../shared/RadioGroup.jsx';

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
    this.handleInchChange = this.handleInchChange.bind(this);
    this.handleCMChange = this.handleCMChange.bind(this);
    this.handleMetricSwitch = this.handleMetricSwitch.bind(this);
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
    this.closeMenu();
  }

  handleInchChange({ option }) {
    this.setState({ ftHeight: option.id });
  }

  handleCMChange({ value }) {
    this.setState({ cmHeight: parseInt(value, 10) });
  }

  handleMetricSwitch({ value }) {
    this.setState({ metricOption: value });
  }

  generateOptions() {
    const options = [];
    for (let i = 0; i < 20; i += 1) {
      const ft = 5 + Math.floor(i / 12);
      options.push({
        id: i,
        name: (
          <div>
            <span className="amt">{ft}</span>
            <span className="metric">ft</span>
            <span className="amt amt--last">{i % 12}</span>
            <span className="metric">in</span>
          </div>
        ),
        active: i === this.state.ftHeight,
      });
    }
    return options;
  }

  generateDressSizeSelections() {
    // NOTE: I'm still apalled that we're having to parse nested tables because
    // of Ruby's OpenStruct. Please note this is being done here.
    return this.props.defaultSizes.map((size) => {
      const ITEM_STATE = this.props.customize.size.id === size.table.id
        ? 'selector-size is-selected' : 'selector-size';
      return (
        <a
          className={ITEM_STATE}
          onClick={this.handleDressSizeSelection}
          key={`size-${size.table.id}`}
          data-id={size.table.id} data-presentation={size.table.presentation}
        >
          {size.table.presentation}
        </a>
      );
    });
  }

  render() {
    const AUTO_HIDE = true;

    const ERROR = this.props.customize.size.error
      ? 'c-card-customize__content__left error'
      : 'c-card-customize__content__left';
    const MENU_STATE = this.state.active ? 'pdp-side-menu is-active' : 'pdp-side-menu';
    const TRIGGER_STATE = this.props.customize.size.id
      ? 'c-card-customize__content is-selected' : 'c-card-customize__content';

    const SIZES = this.generateDressSizeSelections();

    return (
      <div className="pdp-side-container pdp-side-container-size">
        <a
          className={TRIGGER_STATE}
          onClick={this.openMenu}
        >
          <div className={ERROR}>Size Profile</div>
          <div className="c-card-customize__content__right">
            {this.props.customize.size.presentation}
          </div>
        </a>

        <div className={MENU_STATE}>
          <Scrollbars autoHide={AUTO_HIDE}>
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
                  { this.state.metricOption === 'in' ?
                    <Select
                      id="height-options"
                      onChange={this.handleInchChange}
                      className="sort-options"
                      options={this.generateOptions()}
                    /> :
                    <Input
                      type="number"
                      onChange={this.handleCMChange}
                    />
                  }
                </div>

                <div className="metric-container pull-left">
                  <RadioGroup
                    name="metricOptions"
                    selectedValue={this.state.metricOption}
                    onChange={this.handleMetricSwitch}
                  >
                    <Radio display="Inches" value="in" />
                    <Radio display="cm" value="cm" />
                  </RadioGroup>
                </div>
              </div>
            </div>

            <div className="size-selection">
              <h4>What's your dress size?</h4>
              <div className="row">{SIZES}</div>
              <SidePanelSizeChart />
            </div>
          </Scrollbars>
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
