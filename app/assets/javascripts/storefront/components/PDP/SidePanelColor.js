import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';

class SidePanelColor extends SidePanel {
  constructor(props, context) {
    super(props, context);

    this.state = {
      customize: {
        color: {
          id: this.props.preselectedColor.id,
          presentation: this.props.preselectedColor.presentation,
          name: this.props.preselectedColor.name
        }
      }
    };

    this.props.actions.selectColor(this.state.customize);
    this.onChange = this.onChange.bind(this);
  }

  onChange(event) {
    let customize = this.state.customize;
    customize.color.id = event.currentTarget.dataset.id;
    customize.color.presentation = event.currentTarget.dataset.presentation;
    customize.color.name = event.currentTarget.dataset.name;
    this.setState({customize});
    this.props.actions.selectColor(this.state.customize);
  }

  render() {
    const menuState = this.state.active ? 'side-menu is-active' : 'side-menu';
    const triggerState = this.props.customize.color.id
      ? "c-card-customize__content is-selected" : "c-card-customize__content";

    const previewColor = "color-preview color-" + this.props.customize.color.name;

    const defaultColors = this.props.defaultColors.map((color, index) => {
      const itemState = this.props.customize.color.id == color.option_value.id
        ? "selector-color is-selected" : "selector-color";
      const swatch = "swatch color-" + color.option_value.name;
      return (
        <a href="#" className={itemState}
          onClick={this.onChange} key={index}
          data-id={color.option_value.id}
          data-presentation={color.option_value.presentation}
          data-name={color.option_value.name}>
          <div className={swatch}></div>
          <div className="item-name">{color.option_value.presentation}</div>
        </a>
      );
    });
    const customColors = this.props.customColors.map((color, index) => {
      const itemState = this.props.customize.color.id == color.option_value.id
        ? "selector-color is-selected" : "selector-color";
      const swatch = "swatch color-" + color.option_value.name;
      return (
        <a href="#" className={itemState}
          onClick={this.onChange} key={index}
          data-id={color.option_value.id}
          data-presentation={color.option_value.presentation}
          data-name={color.option_value.name}>
          <div className={swatch}></div>
          <div className="item-name">{color.option_value.presentation}</div>
        </a>
      );
    });
    const customColorPrice =
      parseInt(this.props.customColorPrice.money.fractional
      / this.props.customColorPrice.money.currency.subunit_to_unit);
    return (
      <div className="side-container side-container-color">
        <a href="#"
          className={triggerState}
          onClick={this.openMenu}>
          <div className="c-card-customize__content__left">Color</div>
          <div className="c-card-customize__content__right">{this.props.customize.color.presentation}</div>
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
            <span> {this.props.customize.color.presentation}</span>
          </h2>
          <div className={previewColor}></div>
          <h3 className="h5 heading-secondary">Recommended Colors</h3>
          <div className="row">{defaultColors}</div>
          {(() => {
            if(customColors.length) {
              return (
                <div>
                  <h3 className="h5 heading-secondary">
                    Custom Colors&nbsp;&nbsp; +${customColorPrice}
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
  customize: PropTypes.object.isRequired,
  actions: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    defaultColors: state.defaultColors,
    customColors: state.customColors,
    customColorPrice: state.customColorPrice,
    preselectedColor: state.preselectedColor
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelColor);
