import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as pdpActions from '../../actions/PdpActions';
import { MakingOption, defaultMakingOption } from './models/MakingOption';

class SidePanelFastMaking extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.canFastMake = this.canFastMake.bind(this);
    this.fastMakingOption = this.fastMakingOption.bind(this);
    this.isFastMaking = this.isFastMaking.bind(this);
    this.onChange = this.onChange.bind(this);
    this.sidePanelClass = this.sidePanelClass.bind(this);
  }

  sidePanelClass() {
    const classes = [
      'pdp-side-container',
      'pdp-side-container-fast-making',
      'checkbox-inline',
      'custom-form-element-thin',
      'form-small'
    ];

    if (!this.canFastMake()) {
      classes.push('disabled');
    }

    if (this.props.customize.makingOption.error) {
      classes.push('validation-error');
    }

    return classes.join(' ');
  }

  fastMakingOption() {
    const makingOptions = this.props.product.available_options.table.making_options;
    if (makingOptions.length) {
      const fastMakingOption = makingOptions[0].product_making_option;
      return new MakingOption({ id: fastMakingOption.id, price: fastMakingOption.price });
    }
    return defaultMakingOption;
  }

  // Custom colors always have prices bigger than 0
  canFastMake() {
    const isCustomColorSelected = this.props.customize.color.price > 0;
    return !isCustomColorSelected;
  }

  isFastMaking() {
    const isFastMaking = this.props.customize.makingOption.id && this.canFastMake();
    return !!isFastMaking;
  }

  onChange(event) {
    const enableFastMaking = event.target.checked && this.canFastMake();

    const makingOption = enableFastMaking ? this.fastMakingOption() : defaultMakingOption;
    this.props.actions.customizeMakingOption({ makingOption });
  }

  render() {
    if (this.props.flags.fastMaking && this.props.product.fast_making) {
      return (
        <div className={this.sidePanelClass()}>
          <a href="javascript:;">
            <input type="checkbox" id="fast-making" checked={this.isFastMaking()} onChange={this.onChange} />
            <label htmlFor="fast-making">
              <div className="c-card-customize__content__left">
              EXPRESS MAKING (4-6 business days)
              <div className="pdp-side-note">
                <i className="fa fa-info-circle" /> Only available for Recommended Colors
              </div>
              </div>
              <div className="c-card-customize__content__right">${this.fastMakingOption().displayPrice}</div>
            </label>
          </a>
        </div>
      );
    }
    return (
      <span />
    );
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
