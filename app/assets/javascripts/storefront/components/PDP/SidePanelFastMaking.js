import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';

class MakingOption {
  constructor(id = null, price = 0) {
    this.price = price;
    this.id    = id;
  }

  get displayPrice() {
    let price = parseFloat(this.price) || 0;
    return price.toFixed(0);
  }
}

class SidePanelFastMaking extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.defaultMakingOption = new MakingOption();

    this.onChange = this.onChange.bind(this);
  }

  get fastMakingOption() {
    let makingOptions = this.props.product.available_options.table.making_options;
    if (makingOptions.length) {
      let fastMakingOption = makingOptions[0].product_making_option;
      return new MakingOption(fastMakingOption.id, fastMakingOption.price);
    } else {
      return this.defaultMakingOption;
    }
  }

  onChange(event) {
    let customize = {};

    if (event.target.checked) {
      customize.makingOption = this.fastMakingOption;
    } else {
      customize.makingOption = this.defaultMakingOption;
    }

    this.props.actions.customizeDress(customize);
  }

  render() {
    if (this.props.flags.fastMaking && this.props.product.fast_making) {
      return (
        <div className="pdp-side-container pdp-side-container-fast-making checkbox-inline custom-form-element-thin form-small">
          <a href="javascript:;">
            <input type="checkbox" id="fast-making" onChange={this.onChange} />
            <label htmlFor="fast-making">
            <div className="c-card-customize__content__left">
              EXPRESS MAKING (6-9 days)
              <div className="pdp-side-note">Only available for Recommended Colors</div>
            </div>
            <div className="c-card-customize__content__right">${this.fastMakingOption.displayPrice}</div>
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
  actions: PropTypes.object.isRequired,
  flags: PropTypes.object.isRequired,
  product: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    product: state.product,
    flags: state.flags
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelFastMaking);
