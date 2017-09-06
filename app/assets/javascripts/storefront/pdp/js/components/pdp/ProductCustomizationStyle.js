import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { find, findIndex, uniqBy } from 'lodash';
import { bindActionCreators } from 'redux';
import autoBind from 'react-autobind';
import classnames from 'classnames';

// Utilities
import { addOrRemoveFrom } from '../../utilities/array';

// Components
import ButtonCol from '../generic/ButtonCol';
import ProductCustomization from './ProductCustomization';

// Actions
import * as CustomizationActions from '../../actions/CustomizationActions';
import * as ModalActions from '../../actions/ModalActions';

// CSS
import '../../../css/components/ProductCustomizationStyle.scss';

function stateToProps(state) {
  const addons = state.$$customizationState.get('addons').toJS();
  return {
    addonLayerImages: addons.addonLayerImages,
    addonOptions: addons.addonOptions,
    addonsLayersComputed: addons.addonsLayersComputed,
    addonsBasesComputed: addons.addonsBasesComputed,
    baseImages: addons.baseImages,
    baseSelected: addons.baseSelected,
    isLegacyCADCustomizations: addons.isLegacyCADCustomizations,
    productCustomizationDrawer: state.$$customizationState.get('productCustomizationDrawer'),
    selectedAddonImageLayers: addons.selectedAddonImageLayers,
    temporaryStyleCustomizations: state.$$customizationState.get('temporaryStyleCustomizations').toJS(),
  };
}

function dispatchToProps(dispatch) {
  const {
    changeCustomizationDrawer,
    updateCustomizationStyleSelection,
    setAddonBaseLayer,
    setActiveAddonImageLayers,
  } = bindActionCreators(CustomizationActions, dispatch);
  const { activateModal } = bindActionCreators(ModalActions, dispatch);

  return {
    activateModal,
    changeCustomizationDrawer,
    setAddonBaseLayer,
    setActiveAddonImageLayers,
    updateCustomizationStyleSelection,
  };
}

class ProductCustomizationStyle extends Component {
  constructor(props, context) {
    super(props, context);
    autoBind(this);
  }

  /**
   * Computed count of active addonOptions
   * @return {Number} Count
   */
  get activeAddonsCount() {
    const { addonOptions } = this.props;
    return addonOptions.reduce((acc, val) => (val.active ? acc + 1 : acc), 0);
  }

  handleDrawerSelection(productCustomizationDrawer) {
    this.props.changeCustomizationDrawer({ productCustomizationDrawer });
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
          className={classnames(
            'ProductCustomizationStyle__cad-layer ProductCustomizationStyle__cad-layer__base',
            { 'ProductCustomizationStyle__cad-layer--selected': isSelected },
          )}
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
          className={classnames(
            'ProductCustomizationStyle__cad-layer',
            { 'ProductCustomizationStyle__cad-layer--selected': isSelected },
          )}
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
    const { addonOptions, temporaryStyleCustomizations } = this.props;

    return addonOptions.map((a) => {
      const displayPrice = parseFloat((
        a.price.money.fractional /
        a.price.money.currency.subunit_to_unit
      ));

      return (
        <li
          className="u-width--full"
          role="button"
          key={`addon-option-${a.id}`}
        >
          <div className="u-mb-small">
            <ButtonCol
              tall
              className="u-width--full"
              left={<span>{a.description}</span>}
              right={<span>+ ${displayPrice}</span>}
              isSelected={temporaryStyleCustomizations.indexOf(a.id) > -1}
              handleClick={this.handleAddonSelection(a)}
            />
          </div>
        </li>
      );
    });
  }

  /**
   * Immutably creates new addon array, flipping switch on addons active state
   * @param  {Object} addon - addon selected or deselected
   * @return {Array} - newAddons
   */
  computeActivenessOfAddons(activeAddonIdArray) {
    const { addonOptions } = this.props;
    return addonOptions.map(a => ({
      id: a.id,
      active: activeAddonIdArray.indexOf(a.id) > -1,
    }));
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
   * @param  {Array} singleLayerMatchCode
   * @return {Array} fullCode
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

  generateLegacyCADLayers() {
    const { addonOptions, temporaryStyleCustomizations } = this.props;
    const addonOptionMatch = find(addonOptions, { id: temporaryStyleCustomizations[0] });

    if (addonOptionMatch) {
      return (
        <div
          key={`addon-layer-image-${addonOptionMatch.name}`}
          className={classnames(
            'ProductCustomizationStyle__cad-layer',
            'ProductCustomizationStyle__cad-layer--legacy',
            {
              'ProductCustomizationStyle__cad-layer--selected': true,
            },
        )}
          style={{ backgroundImage: `url(${addonOptionMatch.img})` }}
        />
      );
    }
    return (
      /* eslint-disable max-len */
      <div
        className="ProductCustomizationStyle__cad-layer ProductCustomizationStyle__cad-layer--legacy"
      />
    );
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
   * Activates an array of active ids
   * @param  {ArrayOf(Number)} newAddonIds - ids to be activated
   * @action -> updateCustomizationStyleSelection, setActiveAddonImageLayers, setAddonBaseLayer
   */
  activateAddonIdLayers(newAddonIds) {
    const {
      isLegacyCADCustomizations,
      setActiveAddonImageLayers,
      setAddonBaseLayer,
      updateCustomizationStyleSelection,
    } = this.props;
    const newAddons = this.computeActivenessOfAddons(newAddonIds);
    const newLayerCode = this.computeLayerCodeFromAddons(newAddons);

    updateCustomizationStyleSelection({ temporaryStyleCustomizations: newAddonIds });

    if (!isLegacyCADCustomizations) {
      // NEW CAD LAYERS NEED SWAPPING OF BASES AND LAYERS
      setActiveAddonImageLayers(this.findAddonCodeMatches((newLayerCode)));
      setAddonBaseLayer(this.chooseBaseLayerFromCode(newLayerCode));
    }
  }


  /**
   * Event handler for addon selection
   * NOTE: We have to be mindful of Legacy CAD Customizations which do not have addon layers
   * @param  {Object} addon
   * @action -> activateAddonIdLayers
   */
  handleAddonSelection(addon) {
    const { isLegacyCADCustomizations, temporaryStyleCustomizations } = this.props;
    return () => {
      let newAddonIds = [];
      if (isLegacyCADCustomizations) {
        const currentHasInstanceOf = temporaryStyleCustomizations.indexOf(addon.id) > -1;
        newAddonIds = currentHasInstanceOf ? [] : [addon.id]; // ONLY ONE MAX ALLOWED
      } else {
        newAddonIds = addOrRemoveFrom(temporaryStyleCustomizations, addon.id);
      }

      this.activateAddonIdLayers(newAddonIds);
    };
  }

  /**
   * Handle clearing of addon selections
   * @action -> activateAddonIdLayers
   */
  handleClearAddonSelections() {
    this.activateAddonIdLayers([]);
  }

  render() {
    const {
      clearAll,
      hasNavItems,
      isLegacyCADCustomizations,
      productCustomizationDrawer,
    } = this.props;

    return (
      <ProductCustomization
        hasNavItems={hasNavItems}
        handleDrawerSelection={this.handleDrawerSelection}
        productCustomizationDrawer={productCustomizationDrawer}
      >

        <div className="ProductCustomizationStyle__content">
          <div className="ProductCustomizationStyle__layer-wrapper u-center u-position--relative">
            { isLegacyCADCustomizations
              ? this.generateLegacyCADLayers()
              : [this.generateBaseLayers(), this.generateAddonLayers().reverse()]
            }
          </div>

          <div className="ProductCustomizationStyle__addon-options">
            <div className="u-text-align--right float--right u-width--full u-mb-small">
              { clearAll ?
                (
                  <span
                    onClick={this.handleClearAddonSelections}
                    className="link link--static"
                  >
                    Clear All
                  </span>
                )
                : null
              }
            </div>
            { this.generateAddonOptions() }
          </div>
        </div>
      </ProductCustomization>
    );
  }
}

/* eslint-disable react/forbid-prop-types */
ProductCustomizationStyle.propTypes = {
  // Normal Props
  clearAll: PropTypes.bool,
  hasNavItems: PropTypes.bool,
  // Redux Props
  addonLayerImages: PropTypes.array,
  addonOptions: PropTypes.array.isRequired,
  addonsLayersComputed: PropTypes.array,
  addonsBasesComputed: PropTypes.array,
  baseImages: PropTypes.array,
  baseSelected: PropTypes.number,
  isLegacyCADCustomizations: PropTypes.bool.isRequired,
  productCustomizationDrawer: PropTypes.string,
  selectedAddonImageLayers: PropTypes.array,
  temporaryStyleCustomizations: PropTypes.arrayOf(PropTypes.number),
  // Redux actions
  changeCustomizationDrawer: PropTypes.func.isRequired,
  updateCustomizationStyleSelection: PropTypes.func.isRequired,
  setAddonBaseLayer: PropTypes.func.isRequired,
  setActiveAddonImageLayers: PropTypes.func.isRequired,
};

ProductCustomizationStyle.defaultProps = {
  // Normal Props
  clearAll: true,
  // Redux Props
  addonLayerImages: null,
  addonsLayersComputed: null,
  addonsBasesComputed: null,
  baseImages: null,
  baseSelected: null,
  hasNavItems: true,
  selectedAddonImageLayers: [],
  selectedColorId: '',
  productCustomizationDrawer: null,
  temporaryStyleCustomizations: [],
};

/* eslint-disable max-len */
export default connect(stateToProps, dispatchToProps)(ProductCustomizationStyle);
