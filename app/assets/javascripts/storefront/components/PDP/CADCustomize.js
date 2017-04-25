import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { assign, findIndex } from 'lodash';
import PDPConstants from '../../constants/PDPConstants';
import * as pdpActions from '../../actions/PdpActions';

// Constants
const { DRAWERS } = PDPConstants;

function mapStateToProps(state) {
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
  baseSelected: PropTypes.number,
  isOpen: PropTypes.bool.isRequired,
  // Redux actions
  setAddonOptions: PropTypes.func.isRequired,
  setAddonBaseLayer: PropTypes.func.isRequired,
  toggleDrawer: PropTypes.func.isRequired,
};

const defaultProps = {
  baseSelected: null,
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
   * Computed count of active addonOptions
   * @return {Numbere} Count
   */
  get activeAddonsCount() {
    const { addonOptions } = this.props;
    return addonOptions.reduce((acc, val) => (val.active ? acc + 1 : acc), 0);
  }

  /**
   * Creates a numerical string for addons based on selection
   * @return {String|null} summary
   */
  addonsSummarySelectedOptions() {
    const activeOptions = this.activeAddonsCount;
    if (activeOptions) {
      return `${activeOptions} Customization${activeOptions > 1 ? 's' : ''}`;
    }
    return null;
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

  /**
   * Determines positioning and hide show of base layers
   * @return {Array[Node]}
   */
  generateBaseLayers() {
    const { baseImages, baseSelected } = this.props;
    return baseImages.map(({ url }, i) => {
      const isSelected = (
        i === baseSelected ||
        (i === baseImages.length - 1 && typeof baseSelected !== 'number')
      );
      return (
        <div
          key={`base-${url}`}
          className={`CAD--layer CAD--layer__base ${isSelected ? 'show' : 'hide'}`}
          style={{ backgroundImage: `url(${url})` }}
        />
      );
    });
  }

  /**
   * Determines positioning and hide show of addon layers
   * @return {Array[Node]}
   */
  generateAddonLayers() {
    const { addonOptions } = this.props;
    return addonOptions.map(a => (
      <div
        key={`addon-${a.id}`}
        className={`CAD--layer CAD--layer__addon ${a.active ? 'show' : 'hide'}`}
        style={{ backgroundImage: `url(${a.img})` }}
      />
    ));
  }

  /**
   * Creates selectable addon options
   * @return {Array[Node]} - addonOptionNodes
   */
  generateAddonOptions() {
    const { addonOptions } = this.props;

    return addonOptions.map((a) => {
      const displayPrice = parseFloat((
        a.price.money.fractional /
        a.price.money.currency.subunit_to_unit
      ));

      return (
        <li
          role="button"
          key={`addon-option-${a.id}`}
          className={`CAD--addon-list-item ${a.active ? 'is-selected' : ''}`}
          onClick={this.handleAddonSelection(a)}
        >
          <span className="name">{a.name}</span>
          <span className="price"> + ${displayPrice}</span>
        </li>
      );
    });
  }

  /**
   * Immutably creates new addon array, flipping switch on addons active state
   * @param  {Object} addon - addon selected or deselected
   * @return {Array} - newAddons
   */
  computeNewAddons(addon) {
    const { addonOptions } = this.props;
    const matchedIndex = findIndex(addonOptions, { id: addon.id });
    // NOTE: Mutable way to modify item in array (creating new array)
    const newAddons = [
      ...addonOptions.slice(0, matchedIndex),
      assign({}, addon, { active: !addon.active }),
      ...addonOptions.slice(matchedIndex + 1),
    ];
    return newAddons;
  }


  /**
   * Creates a binary code representation of addons selected
   * @param  {Array} addons - addons selected
   * @return {Array} code - ie [*, *, *, 1]
   */
  computeBaseCodeFromAddons(addons) {
    return addons.map(a => (a.active ? '1' : '*'));
  }

  /**
   * Determines what base layer to select based on code comparisons
   * @param  {Array} code - generated from active addons
   * @return {Number} index
   */
  chooseBaseLayerFromCode(code) {
    const { addonsBasesComputed } = this.props;
    const basesLength = addonsBasesComputed.length;

    for (let i = 0; i < basesLength; i += 1) {
      if (addonsBasesComputed[i].join() === code.join()) {
        return i;
      }
    }
    return null;
  }


  /**
   * Event handler for addon selection
   * @param  {Object} addon
   * @action -> setAddonOptions, setAddonBaseLayer
   */
  handleAddonSelection(addon) {
    const { setAddonOptions, setAddonBaseLayer } = this.props;
    return () => {
      const newAddons = this.computeNewAddons(addon);
      const newBaseCode = this.computeBaseCodeFromAddons(newAddons);
      setAddonOptions(newAddons);
      setAddonBaseLayer(this.chooseBaseLayerFromCode(newBaseCode));
    };
  }

  handleApply() {
    console.warn('apply customizations');
    this.closeMenu();
  }

  render() {
    const { isOpen } = this.props;
    let menuClass = 'pdp-side-menu';
    let selectedClass = 'c-card-customize__content';

    menuClass += isOpen ? ' is-active' : '';
    selectedClass += this.activeAddonsCount > 0 ? ' is-selected' : '';

    return (
      <div className="pdp-side-container pdp-side-container-custom CADCustomize">
        <a
          role="button"
          className={selectedClass}
          onClick={this.openMenu}
        >
          {this.generateAddonsSummary()}
        </a>

        <div className={menuClass}>
          <div className="text-right">
            <div
              role="button"
              className="btn-close med"
              onClick={this.closeMenu}
            >
              <span className="hide-visually">Close Menu</span>
            </div>
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
            <button onClick={this.handleApply} className="btn btn-black btn-lrg">
              Apply Customizations
            </button>
          </div>

        </div>
      </div>
    );
  }
}

CADCustomize.propTypes = propTypes;
CADCustomize.defaultProps = defaultProps;

export default connect(mapStateToProps, mapDispatchToProps)(CADCustomize);
