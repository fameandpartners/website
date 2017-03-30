import React, {PropTypes,} from 'react';
import {connect,} from 'react-redux';
import {bindActionCreators,} from 'redux';
import {Scrollbars,} from 'react-custom-scrollbars';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';
import SidePanelSizeChart from './SidePanelSizeChart';
import {GetDressVariantId,} from './utils';

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

    this.closeMenu();
  }

  render() {
    const AUTO_HIDE = true;

    const ERROR = this.props.customize.size.error
      ? "c-card-customize__content__left error"
      : "c-card-customize__content__left";
    const MENU_STATE = this.state.active ? 'pdp-side-menu is-active' : 'pdp-side-menu';
    const TRIGGER_STATE = this.props.customize.size.id
      ? "c-card-customize__content is-selected" : "c-card-customize__content";

    const SIZES = this.props.defaultSizes.map((size, index) => {
      const ITEM_STATE = this.props.customize.size.id == size.table.id
        ? "selector-size is-selected" : "selector-size";
      return (
        <a href="javascript:;" className={ITEM_STATE}
          onClick={this.onChange} key={index}
          data-id={size.table.id} data-presentation={size.table.presentation}>
          {size.table.presentation}
        </a>
      );
    });

    return (
      <div className="pdp-side-container pdp-side-container-size">
        <a href="javascript:;"
          className={TRIGGER_STATE}
          onClick={this.openMenu}>
          <div className={ERROR}>Size Profile</div>
          <div className="c-card-customize__content__right">{this.props.customize.size.presentation}</div>
        </a>

        <div className={MENU_STATE}>
          <Scrollbars autoHide={AUTO_HIDE}>
            <div className="custom-scroll">
              <div className="text-right">
                <a href="javascript:;"
                  className="btn-close lg"
                  onClick={this.closeMenu}>
                    <span className="hide-visually">Close Menu</span>
                </a>
              </div>
              <h2 className="h4 c-card-customize__header">Choose your size</h2>
              <div className="row">{SIZES}</div>
              <SidePanelSizeChart />
            </div>
          </Scrollbars>
        </div>
      </div>
    );
  }
}

SidePanelSize.propTypes = {
  customize: PropTypes.object.isRequired,
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    defaultSizes: state.product.available_options.table.sizes.table.default,
    variants: state.product.available_options.table.variants,
    sizeChartVersion: state.product.size_chart,
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch),
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelSize);
