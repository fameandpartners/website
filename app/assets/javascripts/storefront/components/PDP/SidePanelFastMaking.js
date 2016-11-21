import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';
import {MakingOption, defaultMakingOption} from './models/MakingOption';

class SidePanelFastMaking extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = { checked: false };

    this.onChange = this.onChange.bind(this);
  }

  get fastMakingOption() {
    let makingOptions = this.props.product.available_options.table.making_options;
    if (makingOptions.length) {
      let fastMakingOption = makingOptions[0].product_making_option;
      return new MakingOption({id: fastMakingOption.id, price: fastMakingOption.price});
    } else {
      return defaultMakingOption;
    }
  }

  // Custom colors always have prices bigger than 0
  get canFastMake() {
    let isCustomColorSelected = this.props.customize.color.price > 0;
    return !isCustomColorSelected;
  }

  get isFastMaking() {
    return this.state.checked && this.canFastMake;
  }

  onChange(event) {
    let enableFastMaking = event.target.checked && this.canFastMake;

    let makingOption = enableFastMaking ? this.fastMakingOption : defaultMakingOption;
    this.props.actions.customizeMakingOption({makingOption: makingOption});

    this.setState({checked: enableFastMaking});
  }

  render() {
    if (this.props.flags.fastMaking && this.props.product.fast_making) {
      return (
        <div className="pdp-side-container pdp-side-container-fast-making checkbox-inline custom-form-element-thin form-small">
          <a href="javascript:;">
            <input type="checkbox" id="fast-making" checked={this.isFastMaking} onChange={this.onChange} />
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
  customize: PropTypes.object.isRequired,
  flags: PropTypes.object.isRequired,
  product: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    product: state.product,
    flags: state.flags,
    customize: state.customize
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelFastMaking);
