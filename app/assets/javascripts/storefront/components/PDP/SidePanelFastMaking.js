import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';

class SidePanelFastMaking extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.onChange = this.onChange.bind(this);
    this.onClick = this.onClick.bind(this);
  }

  onChange(event) {
    let customize = {};
    let makingOption = { price: 0 };
    let makingOptions = this.props.product.available_options.table.making_options;

    if (event.target.checked && makingOptions.length) {
      makingOption = { price: 21.0 } || makingOptions[0].product_making_option;
    }

    customize.makingOption = makingOption;
    this.props.actions.customizeDress(customize);
  }

  onClick(event) {
    let fastMakingState = {};
    fastMakingState.isChecked = !this.props.fastMakingState.isChecked;
    this.props.actions.changeFastMakingState(fastMakingState);
  }

  render() {
    if (this.props.flags.fastMaking
        && this.props.product.fast_making) {
      return (
        <div className="pdp-side-container pdp-side-container-fast-making checkbox-inline custom-form-element-thin form-small">
          <a href="javascript:;">
            <input type="checkbox" id="fast-making" onChange={this.onChange} onClick={this.onClick} checked={this.props.fastMakingState.isChecked} defaultChecked={this.props.fastMakingState.isChecked} />
            <label htmlFor="fast-making">
            <div className="c-card-customize__content__left">
              EXPRESS MAKING (6-9 days)
              <div className="pdp-side-note">Only available for Recommended Colors</div>
            </div>
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
    product: state.product,
    flags: state.flags,
    fastMakingState: state.fastMakingState
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelFastMaking);
