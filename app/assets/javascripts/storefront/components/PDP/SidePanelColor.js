import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Scrollbars } from 'react-custom-scrollbars';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';
import { GetDressVariantId, UpdateUrl } from './utils';
import _get from 'lodash/get';

class SidePanelColor extends SidePanel {
  constructor(props, context) {
    super(props, context);

    this.onChange = this.onChange.bind(this);
  }

  componentWillMount() {
    const customize = {};
    const productColors = this.props.defaultColors.concat(this.props.customColors);
    const preselectedColor = productColors.find(color => color.option_value.id === this.props.preselectedColorId);

    customize.color = {
      id: parseInt(this.props.preselectedColorId),
      name: this.props.preselectedColorName,
      price: 0,
      presentation: _get(preselectedColor, 'option_value.presentation')
    };
    this.props.actions.customizeDress(customize);
  }

  onChange(event) {
    const customize = {};
    customize.color = {
      id: parseInt(event.currentTarget.dataset.id),
      name: event.currentTarget.dataset.name,
      presentation: event.currentTarget.dataset.presentation,
      price: event.currentTarget.dataset.price
    };
    // search for dress variant id, this will work only for default color dresses
    // NOTE: we should check if this is even needed, since length
    // selection is required.
    customize.dressVariantId = GetDressVariantId(
      this.props.variants,
      customize.color.id,
      this.props.customize.size.id);

    this.props.actions.customizeDress(customize);
    this.props.actions.customizeMakingOption(customize);

    // update url
    UpdateUrl(customize.color.id, this.props.paths);

    // TODO: redo this
    // this is just very hacky way to connect this with wishlist_item_data
    document.getElementById('pdpWishlistColorId').value = this.props.customize.color.id;
    document.getElementById('pdpWishlistVariantId').value = customize.dressVariantId;

    this.closeMenu();
  }

  render() {
    const AUTO_HIDE = true;

    const props = this.props;
    const menuState = this.state.active ? 'pdp-side-menu is-active' : 'pdp-side-menu';
    const triggerState = props.customize.color.id
      ? 'c-card-customize__content is-selected' : 'c-card-customize__content';

    const previewColor = `color-preview color-${props.customize.color.name}`;

    const defaultColors = props.defaultColors.map((color, index) => {
      const itemState = props.customize.color.id == color.option_value.id
        ? 'selector-color is-selected' : 'selector-color';
      const swatch = `swatch color-${color.option_value.name}`;
      return (
        <a
          href="javascript:;" className={itemState}
          onClick={this.onChange} key={index}
          data-id={color.option_value.id}
          data-presentation={color.option_value.presentation}
          data-name={color.option_value.name}
          data-price="0"
        >
          <div className={swatch} />
          <div className="item-name">{color.option_value.presentation}</div>
        </a>
      );
    });

    const customColors = props.customColors.map((color, index) => {
      const itemState = props.customize.color.id == color.option_value.id
        ? 'selector-color is-selected' : 'selector-color';
      const swatch = `swatch color-${color.option_value.name}`;
      return (
        <a
          href="javascript:;" className={itemState}
          onClick={this.onChange} key={index}
          data-id={color.option_value.id}
          data-presentation={color.option_value.presentation}
          data-name={color.option_value.name}
          data-price={props.customColorPrice}
        >
          <div className={swatch} />
          <div className="item-name">{color.option_value.presentation}</div>
        </a>
      );
    });
    return (
      <div className="pdp-side-container pdp-side-container-color">
        <a
          href="javascript:;"
          className={triggerState}
          onClick={this.openMenu}
        >
          <div className="c-card-customize__content__left">Color</div>
          <div className="c-card-customize__content__right">{props.customize.color.presentation}</div>
        </a>

        <div className={menuState}>
          <Scrollbars autoHide={AUTO_HIDE}>
            <div className="custom-scroll">
              <div className="text-right">
                <a
                  href="javascript:;"
                  className="btn-close med"
                  onClick={this.closeMenu}
                >
                  <span className="hide-visually">Close Menu</span>
                </a>
              </div>
              <h2 className="h4 c-card-customize__header">
                Selected Color:
                <span> {props.customize.color.presentation}</span>
              </h2>
              <div className={previewColor} />
              <h3 className="h5 heading-secondary">Fame Recommends</h3>
              <div className="row">{defaultColors}</div>
              {(() => {
                if (customColors.length) {
                  return (
                    <div>
                      <h3 className="h5 heading-secondary">
                        Additional Colors&nbsp; +${parseFloat(props.customColorPrice)}
                      </h3>
                      <div className="row">{customColors}</div>
                    </div>
                  );
                }
              })()}
            </div>
          </Scrollbars>
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
    variants: state.product.available_options.table.variants,
    paths: state.paths
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelColor);
