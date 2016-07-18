import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';

class SidePanelCustom extends SidePanel {
  constructor(props, context) {
    super(props, context);

    this.onChange = this.onChange.bind(this);
  }

  onChange(event) {
    let customize = {};
    customize.customization = {};

    if(this.props.customize.customization.id === event.currentTarget.dataset.id) {
      customize.customization.id = "";
      customize.customization.presentation = "";
      customize.customization.price = null;
    } else {
      customize.customization.id = event.currentTarget.dataset.id;
      customize.customization.presentation = event.currentTarget.dataset.presentation;
      customize.customization.price = parseFloat(event.currentTarget.dataset.price);
    }

    this.props.actions.customizeDress(customize);
  }

  render() {
    const menuState = this.state.active ? 'pdp-side-menu is-active' : 'pdp-side-menu';
    const triggerState = this.props.customize.customization.id
      ? "c-card-customize__content is-selected" : "c-card-customize__content";
    const customs = this.props.customOptions.map((option, index) => {
      const itemState = this.props.customize.customization.id == option.table.id
        ? "selector-custom is-selected" : "selector-custom";
      const price =
        parseFloat(option.table.display_price.money.fractional
        / option.table.display_price.money.currency.subunit_to_unit);
      return (
        <a href="#" className={itemState}
          onClick={this.onChange} key={index}
          data-id={option.table.id}
          data-presentation={option.table.name}
          data-price={price}>
          <div className="item-name">
            {option.table.name}
            <div className="item-price">+${price}</div>
          </div>
          <div className="media-wrap">
            <img src={option.table.image} />
          </div>
        </a>
      );
    });

    return (
      <div className="pdp-side-container pdp-side-container-custom">
        <a href="#"
          className={triggerState}
          onClick={this.openMenu}>
          <div className="c-card-customize__content__left">Customize</div>
          <div className="c-card-customize__content__right txt-truncate-1">{this.props.customize.customization.presentation}</div>
        </a>

        <div className={menuState}>
          <div className="text-right">
            <a href="#"
              className="btn-close lg"
              onClick={this.closeMenu}>
                <span className="hide-visually">Close Menu</span>
            </a>
          </div>
          <h2 className="h4 c-card-customize__header">Select your customization</h2>
          <div className="row">{customs}</div>
        </div>
      </div>
    );
  }
}

SidePanelCustom.propTypes = {
  customize: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    customOptions: state.product.available_options.table.customizations.table.all
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelCustom);
