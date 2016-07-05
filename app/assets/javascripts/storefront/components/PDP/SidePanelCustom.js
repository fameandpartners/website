import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';

class SidePanelCustom extends SidePanel {
  constructor(props, context) {
    super(props, context);

    this.state = {
      customize: {custom: {id: '', presentation: '', price: ''}}
    };

    this.onChange = this.onChange.bind(this);
  }

  onChange(event) {
    // toggle option
    let customize = this.state.customize;
    if(this.props.customize.custom.id === event.currentTarget.dataset.id) {
      customize.custom.id = "";
      customize.custom.presentation = "";
      customize.custom.price = "";
    } else {
      customize.custom.id = event.currentTarget.dataset.id;
      customize.custom.presentation = event.currentTarget.dataset.presentation;
      customize.custom.price = event.currentTarget.dataset.price;
    }
    this.setState({customize});
    this.props.actions.selectSize(this.state.customize);
  }

  render() {
    const menuState = this.state.active ? 'side-menu is-active' : 'side-menu';
    const triggerState = this.props.customize.custom.id
      ? "c-card-customize__content is-selected" : "c-card-customize__content";
    const customs = this.props.customOptions.map((option, index) => {
      const itemState = this.props.customize.custom.id == option.table.id
        ? "selector-custom is-selected" : "selector-custom";
      const price =
        parseInt(option.table.display_price.money.fractional
        / option.table.display_price.money.currency.subunit_to_unit);
      return (
        <a href="#" className={itemState}
          onClick={this.onChange} key={index}
          data-id={option.table.id}
          data-presentation={option.table.name}
          data-price={option.table.display_price.money.fractional}>
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
      <div className="side-container side-container-custom">
        <a href="#"
          className={triggerState}
          onClick={this.openMenu}>
          <div className="c-card-customize__content__left">Customize</div>
          <div className="c-card-customize__content__right txt-truncate-1">{this.props.customize.custom.presentation}</div>
        </a>

        <div className={menuState}>
          <div className="text-right">
            <a href="#"
              className="btn-close lg"
              onClick={this.closeMenu}>
                <span className="hide-visually">Close Menu</span>
            </a>
          </div>
          <h2 className="h4 c-card-customize__header">Choose your skirt length</h2>
          <div className="row">{customs}</div>
        </div>
      </div>
    );
  }
}

SidePanelCustom.propTypes = {
  customize: PropTypes.object.isRequired,
  customOptions: PropTypes.array.isRequired,
  actions: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    customOptions: state.customOptions
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelCustom);
