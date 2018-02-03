import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { assign, findIndex, uniqBy } from 'lodash';
import PDPConstants from '../../constants/PDPConstants';
import * as pdpActions from '../../actions/PdpActions';
import { trackEvent } from '../../libs/gaTracking';
import { openCustomizeMenuEvent, selectCustomizedOptionMenuEvent, closeCustomizeMenuEvent, applyCustomizeMenuEvent } from '../../libs/gaEventObjects';

// Constants
const { DRAWERS } = PDPConstants;

function mapStateToProps(state) {
  return {
    addonLayerImages: state.addons.addonLayerImages,
    selectedAddonImageLayers: state.addons.selectedAddonImageLayers,
    addonOptions: state.addons.addonOptions,
    addonsLayersComputed: state.addons.addonsLayersComputed,
    addonsBasesComputed: state.addons.addonsBasesComputed,
    baseImages: state.addons.baseImages,
    baseSelected: state.addons.baseSelected,
    isOpen: state.customize.drawerOpen === DRAWERS.CAD_CUSTOMIZE,
  };
}

function mapDispatchToProps(dispatch) {
  // Binds our dispatcher to Redux calls
  const actions = bindActionCreators(pdpActions, dispatch);
  const { setAddonOptions, setAddonBaseLayer, setActiveAddonImageLayers, toggleDrawer } = actions;

  return {
    setAddonBaseLayer,
    setActiveAddonImageLayers,
    setAddonOptions,
    toggleDrawer,
  };
}

const propTypes = {
  addonLayerImages: PropTypes.array.isRequired,
  selectedAddonImageLayers: PropTypes.array.isRequired,
  addonOptions: PropTypes.array.isRequired,
  addonsLayersComputed: PropTypes.array.isRequired,
  addonsBasesComputed: PropTypes.array.isRequired,
  baseImages: PropTypes.array.isRequired,
  baseSelected: PropTypes.number,
  isOpen: PropTypes.bool.isRequired,
  // Redux actions
  setAddonOptions: PropTypes.func.isRequired,
  setAddonBaseLayer: PropTypes.func.isRequired,
  setActiveAddonImageLayers: PropTypes.func.isRequired,
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
    this.computeNewAddons = this.computeNewAddons.bind(this);
    this.generateBaseLayers = this.generateBaseLayers.bind(this);
    this.generateAddonLayers = this.generateAddonLayers.bind(this);
    this.generateAddonOptions = this.generateAddonOptions.bind(this);
    this.sendCustomizationsToAnalytics = this.sendCustomizationsToAnalytics.bind(this);
  }

  openMenu() {
    const { toggleDrawer } = this.props;
    toggleDrawer(DRAWERS.CAD_CUSTOMIZE);
  }

  sendCustomizationsToAnalytics() {
    const { toggleDrawer, addonOptions } = this.props;
    addonOptions.map((c, i) => {
      if (c.active) {
        selectCustomizedOptionMenuEvent.value = (c.price.money.fractional / 100);
        trackEvent(selectCustomizedOptionMenuEvent, true, i);
      }
      return false;
    });
    toggleDrawer(null);
    trackEvent(applyCustomizeMenuEvent);
  }
  closeMenu() {
    const { toggleDrawer } = this.props;
    toggleDrawer(null);
    trackEvent(closeCustomizeMenuEvent);
  }

  /**
   * Computed count of active addonOptions
   * @return {Number} Count
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
        <a
          className="c-card-customize__content__left"
          onClick={() => trackEvent(openCustomizeMenuEvent)}
        >
          Customize It
        </a>
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
          className={`CAD--layer CAD--layer__base ${isSelected ? ' is-selected' : ''}`}
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
    const { addonLayerImages, selectedAddonImageLayers } = this.props;

    return addonLayerImages.map((a) => {
      const isSelected = findIndex(selectedAddonImageLayers, { position: a.position }) > -1;
      return (
        <div
          key={`addon-layer-image-${a.name}`}
          className={`CAD--layer CAD--layer__addon ${isSelected ? 'is-selected' : ''}`}
          style={{ backgroundImage: `url(${a.url})` }}
        />
      );
    });
  }

  /**
   * Creates selectable addon options
   * @return {Array[Node]} - addonOptionNodes
   */
  generateAddonOptions() {
    const { addonOptions } = this.props;

    
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
  computeLayerCodeFromAddons(addons) {
    return addons.map(a => (a.active ? '1' : '*'));
  }


  /**
   * Generates a single layer code for a particular "on" index
   * @param  {Number} onIndex
   * @return {Array} singleLayerCode
   */
  generateSingleLayerCodeAtIndex(onIndex) {
    const singleOnLayerCode = ['*', '*', '*', '*'];
    singleOnLayerCode[onIndex] = '1';
    return singleOnLayerCode;
  }


  /**
   * Reduces matches for a given subset based on position
   * @param  {Array} matches (AT MOST 2, currently)
   * @return {Object} highest priority image from subset
   */
  reduceMatchesBasedOnPriority(matches) {
    return matches.reduce((accum, curr) => {
      // accum is current highest priority winner, this is NOT based on position,
      // but on specificity of bit_array (higher wins)
      const accumSpecificity = accum.image.bit_array
            .reduce((total, bit) => (bit ? total + 1 : total), 0);
      const currSpecificity = curr.image.bit_array
            .reduce((total, bit) => (bit ? total + 1 : total), 0);

      return accumSpecificity >= currSpecificity ? accum : curr;
    }, matches[0]);
  }

  /**
   * Finds a subset of matches
   * @param  {[type]} code [description]
   * @return {[type]}      [description]
   */
  findHighestPriorityMatch(singleLayerMatchCode, fullCode) {
    const { addonsLayersComputed, addonLayerImages } = this.props;
    const addonLayerLength = addonsLayersComputed.length;
    const singleMatchingAddonLayers = [];

    // Do we have matches for SINGLE LAYER   [***1]
    for (let i = 0; i < addonLayerLength; i += 1) {
      /* eslint-disable no-new */
      const singleMatchRegex = new RegExp(singleLayerMatchCode.join().replace(/\*/g, '.+'));
      const fullCodeMatchRegex = new RegExp(addonsLayersComputed[i].join().replace(/\*/g, '.+'));
      if (addonsLayersComputed[i].join().match(singleMatchRegex) != null // single match
      && fullCode.join().match(fullCodeMatchRegex) != null// We have a full match
    ) {
        singleMatchingAddonLayers.push({ i, image: addonLayerImages[i] });
      }
    }

    return this.reduceMatchesBasedOnPriority(singleMatchingAddonLayers);
  }

  /**
   * Finds addon layers that match the full code
   * @param  {Array} fullCode - i.e. ['1', '1', '1', '1']
   * @return {Array} matches - unique matches ordered by priority
   */
  findAddonCodeMatches(fullCode) {
    const matches = [];

    // Iterate over code ['*', '*', '1', '1'] and determine what matches we have
    fullCode.forEach((layerSelection, i) => {
      if (layerSelection === '1') { // active
        const singleLayerMatchCode = this.generateSingleLayerCodeAtIndex(i);
        matches.push(this.findHighestPriorityMatch(singleLayerMatchCode, fullCode));
      }
    });

    if (matches && matches.length > 0) {
      return uniqBy(matches, 'i').filter(m => m).map(m => m.image);
    }
    return [];
  }

  /**
   * Determines what BASE layer to select based on code comparisons
   * @param  {Array} code - generated from active addons
   * @return {Number} index
   */
  chooseBaseLayerFromCode(code) {
    const { addonsBasesComputed } = this.props;
    const basesLength = addonsBasesComputed.length;

    for (let i = 0; i < basesLength; i += 1) {
      /* eslint-disable no-new */
      const regexp = new RegExp(addonsBasesComputed[i].join().replace(/\*/g, '.+'));
      if (code.join().match(regexp) != null) {
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
    const { setAddonOptions, setActiveAddonImageLayers, setAddonBaseLayer } = this.props;
    return () => {
      const newAddons = this.computeNewAddons(addon);
      const newLayerCode = this.computeLayerCodeFromAddons(newAddons);
      setAddonOptions(newAddons); // Customization activation
      setActiveAddonImageLayers(this.findAddonCodeMatches((newLayerCode))); // Addon image activate
      setAddonBaseLayer(this.chooseBaseLayerFromCode(newLayerCode)); // Addon base layer active
    };
  }

  render() {
    const { isOpen } = this.props;
    let menuClass = 'pdp-side-menu';
    let selectedClass = 'c-card-customize__content';

    menuClass += isOpen ? ' is-active' : '';
    selectedClass += this.activeAddonsCount > 0 ? ' is-selected' : '';

    return (
      <div className="pdp-side-container pdp-side-container-custom CADCustomize">
        <div
          role="button"
          className={selectedClass}
          onClick={this.openMenu}
        >
          {this.generateAddonsSummary()}
        </div>

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
          <p className="no-margin-bottom">
            Select as many as you want
          </p>

          <div className="CAD--layer-wrapper">
            { this.generateBaseLayers() }
            { this.generateAddonLayers().reverse() }
          </div>

          <div className="CAD--addon-option-select">
            { this.generateAddonOptions() }
          </div>

          <div className="btn-wrap">
            <button onClick={this.sendCustomizationsToAnalytics} className="btn btn-black btn-lrg">
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
