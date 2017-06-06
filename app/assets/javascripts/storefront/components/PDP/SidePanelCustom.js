import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Scrollbars } from 'react-custom-scrollbars';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';
import { trackEvent } from '../../libs/gaTracking'
import { openCustomizeMenuEvent, closeCustomizeMenuEvent, selectCustomizedOptionMenuEvent } from '../../libs/gaEventObjects'

class SidePanelCustom extends SidePanel {
  constructor(props, context) {
    super(props, context);

    this.onChange = this.onChange.bind(this);
    this.closeCustomizePanel = this.closeCustomizePanel.bind(this)
  }

  onChange(event) {
    const customize = {};
    customize.customization = {};
    if (this.props.customize.customization.id == event.currentTarget.dataset.id) {
      customize.customization.id = undefined;
      customize.customization.presentation = '';
      customize.customization.price = 0;
    } else {
      customize.customization.id = parseInt(event.currentTarget.dataset.id, 10);
      customize.customization.presentation = event.currentTarget.dataset.presentation;
      customize.customization.price = parseFloat(event.currentTarget.dataset.price);
    }
    console.log(event.currentTarget)
    this.props.actions.customizeDress(customize);
    let customizePrice = event.currentTarget.dataset.price
    if(customizePrice != "0") {
      customizePrice = customizePrice.substring(0, customizePrice.indexOf('.'));
      customizePrice = parseInt(customizePrice)
    }
    console.log("customizePrice", customizePrice)
    selectCustomizedOptionMenuEvent.value = customizePrice
    trackEvent(selectCustomizedOptionMenuEvent, true, event.currentTarget.dataset.key)
    this.closeMenu();
    trackEvent(closeCustomizeMenuEvent)
  }
  closeCustomizePanel() {
    this.closeMenu();
    trackEvent(closeCustomizeMenuEvent)
  }
  render() {
    const AUTO_HIDE = true;

    const menuState = this.state.active
      ? 'pdp-side-menu is-active'
      : 'pdp-side-menu';
    const triggerState = this.props.customize.customization.id
      ? 'c-card-customize__content is-selected'
      : 'c-card-customize__content';
    const customs = this.props.customOptions.map((option, index) => {
      const itemState = this.props.customize.customization.id == option.table.id
        ? 'selector-custom is-selected'
        : 'selector-custom';
      const price = parseFloat((
        option.table.display_price.money.fractional /
        option.table.display_price.money.currency.subunit_to_unit
      ));
      return (
        <a href="javascript:;" className={itemState} onClick={this.onChange} key={index} data-key={index} data-id={option.table.id} data-presentation={option.table.name} data-price={price}>
          <div className="item-name">
            {option.table.name}
            <div className="item-price">+${price}</div>
          </div>
          <div className="media-wrap">
            <img alt="option-image" src={option.table.image} />
          </div>
        </a>
      );
    });

    return (
      <div className="pdp-side-container pdp-side-container-custom">
        <a href="javascript:;" className={triggerState} onClick={this.openMenu}>
          <div 
            className="c-card-customize__content__left"
            onClick={() => trackEvent(openCustomizeMenuEvent)}
          >
            Customize
          </div>
          <div className="c-card-customize__content__right">
            {this.props.customize.customization.presentation}
          </div>
        </a>

        <div className={menuState}>
          <Scrollbars autoHide={AUTO_HIDE}>
            <div className="custom-scroll">
              <div className="text-right">
                <a href="javascript:;" className="btn-close med" onClick={this.closeCustomizePanel}>
                  <span className="hide-visually">Close Menu</span>
                </a>
              </div>
              <h2 className="h4 c-card-customize__header">Select your customization</h2>
              <div>{customs}</div>
            </div>
          </Scrollbars>
        </div>
      </div>
    );
  }
}

SidePanelCustom.propTypes = {
  customize: PropTypes.object.isRequired,
};

function mapStateToProps(state) {
  return {
    customize: state.customize,
    customOptions: state.product.available_options.table.customizations.table.all,
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch),
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelCustom);
