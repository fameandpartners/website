import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';
import {GetDressVariantId} from './utils';

class SidePanelColor extends SidePanel {
  constructor(props, context) {
    super(props, context);

    this.onChange = this.onChange.bind(this);
  }

  componentWillMount() {
    let customize = {};
    customize.color = {};
    customize.color.id = this.props.preselectedColorId;
    customize.color.name = this.props.preselectedColorName;
    customize.color.price = null;
    customize.color.presentation = this.props.defaultColors.reduce((color, index) => {
      if(color.option_value.id === this.props.preselectedColorId) {
        return color.option_value.presentation;
      }
    });
    this.props.actions.customizeDress(customize);
  }

  onChange(event) {
    let customize = {};
    customize.color = {};
    customize.color.id = event.currentTarget.dataset.id;
    customize.color.name = event.currentTarget.dataset.name;
    customize.color.presentation = event.currentTarget.dataset.presentation;
    customize.color.price = event.currentTarget.dataset.price;
    // search for dress variant id, this will work only for default color dresses
    // NOTE: we should check if this is even needed, since length
    // selection is required.
    customize.dressVariantId = GetDressVariantId(
      this.props.variants,
      customize.color.id,
      this.props.customize.size.id);
    this.props.actions.customizeDress(customize);
  }

  render() {
    const props = this.props;
    const menuState = this.state.active ? 'side-menu is-active' : 'side-menu';
    const triggerState = props.customize.color.id
      ? "c-card-customize__content is-selected" : "c-card-customize__content";

    const previewColor = "color-preview color-" + props.customize.color.name;

    const defaultColors = props.defaultColors.map((color, index) => {
      const itemState = props.customize.color.id == color.option_value.id
        ? "selector-color is-selected" : "selector-color";
      const swatch = "swatch color-" + color.option_value.name;
      return (
        <a href="#" className={itemState}
          onClick={this.onChange} key={index}
          data-id={color.option_value.id}
          data-presentation={color.option_value.presentation}
          data-name={color.option_value.name}
          data-price={props.customColorPrice}>
          <div className={swatch}></div>
          <div className="item-name">{color.option_value.presentation}</div>
        </a>
      );
    });

    const customColors = props.customColors.map((color, index) => {
      const itemState = props.customize.color.id == color.option_value.id
        ? "selector-color is-selected" : "selector-color";
      const swatch = "swatch color-" + color.option_value.name;
      return (
        <a href="#" className={itemState}
          onClick={this.onChange} key={index}
          data-id={color.option_value.id}
          data-presentation={color.option_value.presentation}
          data-name={color.option_value.name}
          data-price={props.customColorPrice}>
          <div className={swatch}></div>
          <div className="item-name">{color.option_value.presentation}</div>
        </a>
      );
    });
    return (
      <div className="side-container side-container-color">
        <a href="#"
          className={triggerState}
          onClick={this.openMenu}>
          <div className="c-card-customize__content__left">Color</div>
          <div className="c-card-customize__content__right txt-truncate-1">{props.customize.color.presentation}</div>
        </a>

        <div className={menuState}>
          <div className="text-right">
            <a href="#"
              className="btn-close lg"
              onClick={this.closeMenu}>
                <span className="hide-visually">Close Menu</span>
            </a>
          </div>
          <h2 className="h4 c-card-customize__header">
            Selected Color:
            <span> {props.customize.color.presentation}</span>
          </h2>
          <div className={previewColor}></div>
          <h3 className="h5 heading-secondary">Recommended Colors</h3>
          <div className="row">{defaultColors}</div>
          {(() => {
            if(customColors.length) {
              return (
                <div>
                  <h3 className="h5 heading-secondary">
                    Custom Colors&nbsp;&nbsp; +${parseFloat(props.customColorPrice)}
                  </h3>
                  <div className="row">{customColors}</div>
                </div>
              );
            }
          })()}
        </div>
      </div>
    );
  }
}

SidePanelColor.propTypes = {
  customize: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    defaultColors: state.product.available_options.table.colors.table.default,
    customColors: state.product.available_options.table.colors.table.extra,
    customColorPrice: state.product.available_options.table.colors.table.default_extra_price.price.amount,
    preselectedColorId: state.product.color_id,
    preselectedColorName: state.product.color_name,
    variants: state.product.available_options.table.variants
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelColor);
