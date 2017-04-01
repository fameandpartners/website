import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Scrollbars } from 'react-custom-scrollbars';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';
import Select from '../shared/Select.jsx';
import RadioGroup from '../shared/RadioGroup.jsx';
import Radio from '../shared/Radio.jsx';
import SidePanelSizeChart from './SidePanelSizeChart';
import { GetDressVariantId } from './utils';

class SidePanelSize extends SidePanel {
  constructor(props, context) {
    super(props, context);
    this.state = {
      ftHeightChosen: undefined,
      metricOption: 'in',
    };
    this.onChange = this.onChange.bind(this);
    this.generateOptions = this.generateOptions.bind(this);
    this.handleHeightChange = this.handleHeightChange.bind(this);
    this.handleMetricSwitch = this.handleMetricSwitch.bind(this);
  }

  onChange(event) {
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
      customize.size.id);
    this.props.actions.customizeDress(customize);

    this.closeMenu();
  }

  handleHeightChange({ option }) {
    this.setState({ ftHeightChosen: option.id });
  }

  handleMetricSwitch({ value }) {
    this.setState({ metricOption: value });
  }

  generateOptions() {
    const options = [];
    for (let i = 0; i < 20; i++) {
      const ft = 5 + Math.floor(i / 12);
      options.push({
        id: i,
        name: (<span><b>{ft}</b>ft <b>{i % 12}</b>in</span>),
        active: i == this.state.ftHeightChosen,
      });
    }
    return options;
  }

  render() {
    const AUTO_HIDE = true;

    const ERROR = this.props.customize.size.error
      ? 'c-card-customize__content__left error'
      : 'c-card-customize__content__left';
    const MENU_STATE = this.state.active ? 'pdp-side-menu is-active' : 'pdp-side-menu';
    const TRIGGER_STATE = this.props.customize.size.id
      ? 'c-card-customize__content is-selected' : 'c-card-customize__content';

    const SIZES = this.props.defaultSizes.map((size, index) => {
      const ITEM_STATE = this.props.customize.size.id == size.table.id
        ? 'selector-size is-selected' : 'selector-size';
      return (
        <a
          href="javascript:;" className={ITEM_STATE}
          onClick={this.onChange} key={index}
          data-id={size.table.id} data-presentation={size.table.presentation}
        >
          {size.table.presentation}
        </a>
      );
    });

    return (
      <div className="pdp-side-container pdp-side-container-size">
        <a
          href="javascript:;"
          className={TRIGGER_STATE}
          onClick={this.openMenu}
        >
          <div className={ERROR}>Size Profile</div>
          <div className="c-card-customize__content__right">{this.props.customize.size.presentation}</div>
        </a>

        <div className={MENU_STATE}>
          <Scrollbars autoHide={AUTO_HIDE}>
            <div className="custom-scroll">
              <div className="text-right">
                <a
                  href="javascript:;"
                  className="btn-close med"
                  onClick={this.closeMenu}
                >
                  <span className="hide-visually">Close Menu</span>
                </a>
              </div>
              <h2 className="h4 c-card-customize__header">Create a Size Profile</h2>
              <p>Enter your height and size information so we can ensure you get a better fit</p>

              <h3>Choose your height</h3>
              <div className="height-selection clearfix">
                <div className="select-container pull-left">
                  { this.state.metricOption === 'in' ?
                    <Select
                      id="height-options"
                      onChange={this.handleHeightChange}
                      label="Height"
                      className="sort-options"
                      options={this.generateOptions()}
                    /> :
                    <input placeholder="cm" />
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

            <h3>Choose your size</h3>
            <div className="row">{SIZES}</div>
            <SidePanelSizeChart />
          </Scrollbars>
        </div>
      </div>
    );
  }
}

SidePanelSize.propTypes = {
  customize: PropTypes.object.isRequired,
};

function mapStateToProps(state, ownProps) {
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
