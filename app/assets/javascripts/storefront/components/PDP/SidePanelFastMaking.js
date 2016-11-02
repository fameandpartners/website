import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';

// TODO: [WIP] This is just a placeholder. Valid logic for displaying the "express making" row properly is needed here.

class SidePanelFastMaking extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.onChange = this.onChange.bind(this);
  }

  onChange(event) {
    let customize = {};
    let makingOptionId = null;
    let makingOptions = this.props.product.available_options.table.making_options;

    if (event.target.checked && makingOptions.length) {
      makingOptionId = makingOptions[0].product_making_option.id;
    }

    customize.makingOptionId = makingOptionId;
    this.props.actions.customizeDress(customize);
  }

  render() {
    if (this.props.product.fast_making) {
      return (
        <div className="pdp-side-container pdp-side-container-fast-making checkbox-inline custom-form-element-thin form-small">
          <a href="javascript:;">
            <input type="checkbox" id="fast-making" onChange={this.onChange} />
            <label htmlFor="fast-making">
            <div className="c-card-customize__content__left">EXPRESS MAKING (6-9 days)</div>
            <div className="c-card-customize__content__right">$30</div>
            </label>
          </a>
        </div>
      );
    } else {
      return (
        <span></span>
      );
    }
  }
}

SidePanelFastMaking.propTypes = {
  product: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    product: state.product
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelFastMaking);
