import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';
import SidePanelSizeChart from './SidePanelSizeChart';
import {GetDressVariantId} from './utils';

class SidePanelSize extends SidePanel {
  constructor(props, context) {
    super(props, context);

    this.onChange = this.onChange.bind(this);
  }

  onChange(event) {
    let customize = {};
    customize.size = {};
    customize.size.id = event.currentTarget.dataset.id;
    customize.size.presentation = event.currentTarget.dataset.presentation;
    // search for dress variant id, this will work only for default color dresses
    // NOTE: we should check if this is even needed, since length
    // selection is required.
    customize.dressVariantId = GetDressVariantId(
      this.props.variants,
      this.props.customize.color.id,
      customize.size.id);
    this.props.actions.customizeDress(customize);
  }

  render() {
    const menuState = this.state.active ? 'side-menu is-active' : 'side-menu';
    const triggerState = this.props.customize.size.id
      ? "c-card-customize__content is-selected" : "c-card-customize__content";
    const sizes = this.props.defaultSizes.map((size, index) => {
      const itemState = this.props.customize.size.id == size.table.id
        ? "selector-size is-selected" : "selector-size";
      return (
        <a href="#" className={itemState}
          onClick={this.onChange} key={index}
          data-id={size.table.id} data-presentation={size.table.presentation}>
          {size.table.presentation}
        </a>
      );
    });

    return (
      <div className="side-container side-container-size">
        <a href="#"
          className={triggerState}
          onClick={this.openMenu}>
          <div className="c-card-customize__content__left">Dresses Size</div>
          <div className="c-card-customize__content__right txt-truncate-1">{this.props.customize.size.presentation}</div>
        </a>

        <div className={menuState}>
          <div className="text-right">
            <a href="#"
              className="btn-close lg"
              onClick={this.closeMenu}>
                <span className="hide-visually">Close Menu</span>
            </a>
          </div>
          <h2 className="h4 c-card-customize__header">Choose your size</h2>
          <div className="row">{sizes}</div>
          <SidePanelSizeChart />
        </div>
      </div>
    );
  }
}

SidePanelSize.propTypes = {
  customize: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    defaultSizes: state.defaultSizes,
    variants: state.variants
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelSize);
