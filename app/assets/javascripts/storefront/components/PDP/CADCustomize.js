import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { assign, findIndex } from 'lodash';
import PDPConstants from '../../constants/PDPConstants';
import * as pdpActions from '../../actions/PdpActions';

// Constants
const { DRAWERS } = PDPConstants;

function mapStateToProps(state) {
  console.log('state', state);
  return {
    addonOptions: state.addons.addonOptions,
    addonsBasesComputed: state.addons.addonsBasesComputed,
    baseImages: state.addons.baseImages,
    baseSelected: state.addons.baseSelected,
    isOpen: state.customize.drawerOpen === DRAWERS.CAD_CUSTOMIZE,
  };
}

function mapDispatchToProps(dispatch) {
  // Binds our dispatcher to Redux calls
  const actions = bindActionCreators(pdpActions, dispatch);
  const { setAddonOptions, setAddonBaseLayer, toggleDrawer } = actions;

  return {
    setAddonBaseLayer,
    setAddonOptions,
    toggleDrawer,
  };
}

const propTypes = {
  addonOptions: PropTypes.array.isRequired,
  addonsBasesComputed: PropTypes.array.isRequired,
  baseImages: PropTypes.array.isRequired,
  isOpen: PropTypes.bool.isRequired,
  // Redux actions
  setAddonOptions: PropTypes.func.isRequired,
  setAddonBaseLayer: PropTypes.func.isRequired,
  toggleDrawer: PropTypes.func.isRequired,
};

class CADCustomize extends Component {
  constructor(props, context) {
    super(props, context);
    this.openMenu = this.openMenu.bind(this);
    this.closeMenu = this.closeMenu.bind(this);
    this.generateBaseLayers = this.generateBaseLayers.bind(this);
    this.generateAddonLayers = this.generateAddonLayers.bind(this);
    this.generateAddonOptions = this.generateAddonOptions.bind(this);
    this.computeNewAddons = this.computeNewAddons.bind(this);
    this.handleApply = this.handleApply.bind(this);
  }

  openMenu() {
    const { toggleDrawer } = this.props;
    toggleDrawer(DRAWERS.CAD_CUSTOMIZE);
  }

  closeMenu() {
    const { toggleDrawer } = this.props;
    toggleDrawer(null);
  }

  /**
   * Creates a readable string for size summary based on units
   * @return {String} summary
   */
  addonsSummarySelectedOptions() {
    return '';
  }

  /**
   * Generates a description of addons selected
   * @return {Node} addonsSummary
   */
  generateAddonsSummary() {
    return (
      <div>
        <a className="c-card-customize__content__left">Customize It</a>
        <div className="c-card-customize__content__right">
          {this.addonsSummarySelectedOptions()}
        </div>
      </div>
    );
  }

  generateBaseLayers() {
    const { baseImages, baseSelected } = this.props;
    return baseImages.map((b, i) => {
      const isSelected = (i === baseSelected || (i === baseImages.length - 1 && !baseSelected));
      return (
        <div
          key={`base-${i}`}
          className={`CAD--layer CAD--layer__base ${isSelected ? 'show' : 'hide'}`}
          style={{ backgroundImage: `url(${b})` }}
        />
      );
    });
  }

  generateAddonLayers() {
    const { addonOptions } = this.props;
    return addonOptions.map((a, i) => (
      <div
        key={`addon-${i}`}
        className={`CAD--layer CAD--layer__addon ${a.active ? 'show' : 'hide'}`}
        style={{ backgroundImage: `url(${a.img})` }}
      />
    ));
  }

  generateAddonOptions() {
    const { customizationOptions } = this.props;
    const { addonOptions } = this.props;
    return addonOptions.map(a => (
      <li
        className={`CAD--addon-list-item ${a.active ? 'is-selected' : ''}`}
        onClick={this.handleAddonSelection(a)}
      >
        <span className="name">{a.name}</span>
        <span className="price">{a.price}</span>
      </li>
    ));
  }

  computeNewAddons(addon) {
    const { addonOptions } = this.props;
    const matchedIndex = findIndex(addonOptions, { id: addon.id });
    // NOTE: Mutable way to modify item in array
    const newAddons = [
      ...addonOptions.slice(0, matchedIndex),
      assign({}, addon, { active: !addon.active }),
      ...addonOptions.slice(matchedIndex + 1),
    ];
    return newAddons;
  }

  computeBaseCodeFromAddons(newAddons) {
    return newAddons.map(a => a.active ? '1' : '*');
  }

  chooseBaseLayerFromCode(code) {
    const { addonsBasesComputed, setAddonBaseLayer } = this.props;
    const basesLength = addonsBasesComputed.length;

    for (let i = 0; i < basesLength; i += 1) {
      if (addonsBasesComputed[i].join() === code.join()) {
        setAddonBaseLayer(i);
        break;
      }
    }
  }


  handleAddonSelection(addon) {
    const { setAddonOptions } = this.props;
    return () => {
      const newAddons = this.computeNewAddons(addon);
      const newBaseCode = this.computeBaseCodeFromAddons(newAddons);
      setAddonOptions(newAddons);
      this.chooseBaseLayerFromCode(newBaseCode);
    };
  }

  handleApply() {

  }

  render() {
    const { isOpen } = this.props;
    let menuClass = 'pdp-side-menu';
    const selectedClass = 'c-card-customize__content';
    menuClass += isOpen ? ' is-active' : '';

    return (
      <div className="pdp-side-container pdp-side-container-custom CADCustomize">
        <div
          className={selectedClass}
          onClick={this.openMenu}
        >
          {this.generateAddonsSummary()}
        </div>

        <div className={menuClass}>
          <div className="text-right">
            <a
              className="btn-close med"
              onClick={this.closeMenu}
            >
              <span className="hide-visually">Close Menu</span>
            </a>
          </div>
          <h2 className="h4 c-card-customize__header textAlign--left">Customize It</h2>
          <p>
            Select as many as you want
          </p>

          <div className="CAD--layer-wrapper">
            { this.generateBaseLayers() }
            { this.generateAddonLayers() }
          </div>

          <div className="CAD--addon-option-select">
            { this.generateAddonOptions() }
          </div>

          <div className="btn-wrap">
            <div onClick={this.handleApply} className="btn btn-black btn-lrg">
              Apply Customizations
            </div>
          </div>

        </div>
      </div>
    );
  }
}

CADCustomize.propTypes = propTypes;

export default connect(mapStateToProps, mapDispatchToProps)(CADCustomize);
