/* eslint-disable */
import React from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import autobind from 'auto-bind';
import * as CollectionFilterSortActions from '../actions/CollectionFilterSortActions';
import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';
import {assign, find} from 'lodash';
import {cleanCapitalizeWord} from '../helpers/TextFormatting';
import {hasLegacyInstance} from '../utilities/CollectionFilterSortUtilities';
import pluralize from 'pluralize';

//Libraries
import Resize from '../decorators/Resize.jsx';
import breakpoints from '../libs/breakpoints';

// Tracking
import {trackEvent,} from '../libs/gaTracking';
import COLLECTION_EVENTS from '../constants/CollectionFilterSortEvents.js';

// Components
import ExpandablePanelItem from '../components/ExpandablePanelItem.jsx';

// Constants
const {PRICES, FILTER_DEFAULTS,} = CollectionFilterSortConstants;

function stateToProps(state, props) {
    // Which part of the Redux global state does our component want to receive as props?
    if (state.$$collectionFilterSortStore) {
        const {$$collectionFilterSortStore,} = state;
        const collectionFilterSortStore = $$collectionFilterSortStore.toJS();
        return {
          // Immutable Defaults
          $$colors: $$collectionFilterSortStore.get('$$colors'),
          $$bodyShapes: $$collectionFilterSortStore.get('$$bodyShapes'),
          $$bodyStyles: $$collectionFilterSortStore.get('$$bodyStyles'),
          // Mutable props
          isDrawerLayout: props.isDrawerLayout,
          filters: assign({},
            {
              order: collectionFilterSortStore.order,
              fastMaking: collectionFilterSortStore.fastMaking,
              selectedColors: collectionFilterSortStore.selectedColors,
              selectedPrices: collectionFilterSortStore.selectedPrices,
              selectedShapes: collectionFilterSortStore.selectedShapes,
              selectedStyles: collectionFilterSortStore.selectedStyles,
            },
            // Include temporary filters if we are in a drawer
            (props.isDrawerLayout) ? collectionFilterSortStore.temporaryFilters : {}
          ),
          temporaryFilters: collectionFilterSortStore.temporaryFilters,
        };
    }
    return {};
}
function dispatchToProps(dispatch){ return bindActionCreators(CollectionFilterSortActions, dispatch); }


class CollectionFilterSort extends React.Component {
    constructor(props) {
        super(props);
        autobind(this);
    }

    /**
     * IMMUTABLE Removes option in array if present, adds to end if not
     * @param  {Array} selectedOptions
     * @param  {String} val
     * @return {Array} new array of values
     */
    addOrRemoveFrom(selectedOptions, changeOption){
      let newSelections = [];
      const selectedOptionIndex = selectedOptions.indexOf(changeOption);
      if (selectedOptionIndex > -1){
        newSelections = [
          ...selectedOptions.slice(0, selectedOptionIndex),
          ...selectedOptions.slice(selectedOptionIndex + 1),
        ];
      } else {
        newSelections = selectedOptions.concat(changeOption);
      }
      return newSelections;
    }

    trackSelection(eventName, selectionFilter){
      trackEvent(assign({},
        COLLECTION_EVENTS[eventName],
        {label: selectionFilter,} // dynamic based on filter value
      ));
    }

    handleFilterOpening(eventName){
      return (isOpen) => {
        if (isOpen){ trackEvent(COLLECTION_EVENTS[eventName]); }
      };
    }

    /**
     * Reaches into legacy application to control toggling of mobile filters
     * Ugly. I know. But this is how we sprinkle in react components with prexisting framework
     */
    handleFilterCancel(){
      return () => {
        if (hasLegacyInstance()){
          this.props.setTemporaryFilters({});
          window.ProductCollectionFilter__Instance.toggleFilters();
      }};
    }

    handleFilterApply(){
      const {
        applyTemporaryFilters,
        setTemporaryFilters,
        temporaryFilters,
      } = this.props;
      return () => {
        applyTemporaryFilters(temporaryFilters);
        setTemporaryFilters({});
        this.props.updateExternalLegacyFilters(temporaryFilters);
        if (hasLegacyInstance()){ window.ProductCollectionFilter__Instance.toggleFilters(false); }
      };
    }

    /**
     * FILTER/SORT Action Handlers
     **********************************
     */
    handleClearAll(){
      const {
        clearAllCollectionFilters,
        isDrawerLayout,
        setTemporaryFilters,
        updateExternalLegacyFilters,
      } = this.props;

      if (isDrawerLayout){
        setTemporaryFilters(FILTER_DEFAULTS);
      } else {
        clearAllCollectionFilters();
        updateExternalLegacyFilters(FILTER_DEFAULTS);
      }
    }

    handleColorSelection({name,}){
      const {
        isDrawerLayout,
        filters,
        setSelectedColors,
        setTemporaryFilters,
        temporaryFilters,
        updateExternalLegacyFilters,
      } = this.props;
      let newColors = this.addOrRemoveFrom(filters.selectedColors, name);

      if (isDrawerLayout){ // mobile, temporary setting
        setTemporaryFilters(assign({}, temporaryFilters, {
          selectedColors: newColors,
        }));
      } else {
        setSelectedColors(newColors);
        updateExternalLegacyFilters({selectedColors: newColors,});
      }

      this.trackSelection('COLLECTION_COLOR_FILTER_SELECTION', name);
    }

    updatePrice(newPrices){
      const {
        isDrawerLayout,
        setSelectedPrices,
        setTemporaryFilters,
        temporaryFilters,
        updateExternalLegacyFilters,
      } = this.props;

      if (isDrawerLayout){ // mobile, temporary setting
        setTemporaryFilters(assign({}, temporaryFilters, {
          selectedPrices: newPrices,
        }));
      } else {
        setSelectedPrices(newPrices);
        updateExternalLegacyFilters({selectedPrices: newPrices,});
      }

    }

    handlePriceSelection(id){
      const { isDrawerLayout, filters, setSelectedPrices, } = this.props;
      return () => {
        const newPrices = this.addOrRemoveFrom(filters.selectedPrices, id).sort();
        this.trackSelection('COLLECTION_PRICE_FILTER_SELECTION', id);
        this.updatePrice(newPrices);
      };
    }

    updateStyles(newStyles){
      const {
        isDrawerLayout,
        setSelectedStyles,
        setTemporaryFilters,
        temporaryFilters,
      } = this.props;

      if (isDrawerLayout){ // mobile version
        setTemporaryFilters(assign({}, temporaryFilters, {
          selectedStyles: newStyles,
        }));
      } else {
        setSelectedStyles(newStyles);
        this.props.updateExternalLegacyFilters({
          selectedStyles: newStyles,
        });
      }

    }

    handleStyleSelection(style){
      let newStyles = [];
      return () => {
        const styleId = style.permalink;
        const newStyles = this.addOrRemoveFrom(this.props.filters.selectedStyles, styleId).sort();
        this.trackSelection('COLLECTION_STYLE_FILTER_SELECTION', styleId);
        this.updateStyles(newStyles);
      };
    }

    updateShapes(newShapes){
      const {
        $$bodyShapes,
        isDrawerLayout,
        setSelectedShapes,
        setTemporaryFilters,
        temporaryFilters,
        updateExternalLegacyFilters,
      } = this.props;
      if (isDrawerLayout){ // mobile, temporary setting
        setTemporaryFilters(assign({}, temporaryFilters, {
          selectedShapes: newShapes,
        }));
      } else {
        setSelectedShapes(newShapes);
        updateExternalLegacyFilters({
          selectedShapes: newShapes.length === $$bodyShapes.toJS().length
            ? []
            : newShapes,
        });
      }

    }

    handleShapeSelection(shapeId){
      return () => {
        const newShapes = this.addOrRemoveFrom(this.props.filters.selectedShapes, shapeId).sort();
        this.trackSelection('COLLECTION_BODYSHAPE_FILTER_SELECTION', shapeId);
        this.updateShapes(newShapes);
      };
    }


    handleFastMaking(){
      const {
        filters,
        isDrawerLayout,
        setFastMaking,
        setTemporaryFilters,
        temporaryFilters,
      } = this.props;
      const {fastMaking,} = filters;
      const newFastMaking = {fastMaking: !fastMaking,};

      return () => {
        if (isDrawerLayout){
          setTemporaryFilters(assign({}, temporaryFilters, newFastMaking));
        } else {
          setFastMaking(!fastMaking);
          this.props.updateExternalLegacyFilters(newFastMaking);
        }

        // this.trackSelection('COLLECTION_FASTMAKING_FILTER_SELECTION', !fastMaking);
      };
    }


    /**
     * RENDERERS
     * ***************************************************
     */
    buildColorOption(color){
      const {selectedColors,} = this.props.filters;
      const {name,id,} = color;
      const inverse = name.toLowerCase().indexOf('white') > -1 ? 'inverse' : '';
      return (
        <label key={`color-${id}`} className="ExpandablePanel__option ExpandablePanel__listColumn">
          <input
            id={`color-${name}`}
            type="checkbox"
            value={name}
            checked={selectedColors.indexOf(name) > -1}
            onChange={this.handleColorSelection.bind(this, color)}
          />
          <span className="ExpandablePanel__optionColorFallback" />
          <span className={`ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick ${inverse} color-${name}`} />
          <span className="ExpandablePanel__optionName">{name}</span>
        </label>
      );
    }

    buildShapeOptions(shape, i){
      const {selectedShapes,} = this.props.filters;
      return (
        <label key={`shape-${shape}`} className="ExpandablePanel__option ExpandablePanel__listColumn" name="shape">
          <input
            onChange={this.handleShapeSelection(shape)}
            checked={selectedShapes.indexOf(shape) > -1}
            data-all="false"
            id={`shape-${shape}`}
            name={`shape-${shape}`}
            type="checkbox"
            value={shape}
          />
            <span className="checkboxBlackBg__check">
                <span className="ExpandablePanel__optionName">{cleanCapitalizeWord(shape, ['_',])}</span>
            </span>
        </label>
      );
    }

    buildStyleOptions(style){
      const {selectedStyles,} = this.props.filters;
      return (
        <label key={`style-${style.permalink}`} className="ExpandablePanel__option ExpandablePanel__listColumn" name="style">
          <input
            onChange={this.handleStyleSelection(style)}
            checked={selectedStyles.indexOf(style.permalink) > -1}
            data-all="false"
            id={`style-${style.permalink}`}
            name={`style-${style.permalink}`}
            type="checkbox"
            value={style.name}
          />
            <span className="checkboxBlackBg__check">
                <span className="ExpandablePanel__optionName">{style.name}</span>
            </span>
        </label>
      );
    }

    generateSelectedItemSpan(id, presentation, category='elem'){
      return (
        <span key={`${category}-${id}`} className="ExpandablePanel__selectedItem">{presentation}</span>
      );
    }

    generateColorSummary(selectedColorNames){
      const selectedColors = selectedColorNames.map( name =>
        find(this.props.$$colors.toJS(), { name, })
      );
      const selectedCount = selectedColors.length;

      if (selectedCount === 0){
        return ( this.generateSelectedItemSpan('all', 'All Colors', 'color') );
      }

      return ( this.generateSelectedItemSpan('colors-selected', pluralize('Color', selectedCount, true), 'color') );
    }

    generatePriceSummary(selectedPriceIds){
      const selectedPrices = selectedPriceIds.map( id => find(PRICES, {id: id,}) );
      if (PRICES.length === selectedPriceIds.length || selectedPriceIds.length === 0){ // All
        return ( this.generateSelectedItemSpan('all', 'All Prices', 'price') );
      }

      if (selectedPrices.length === 1 ||
         (selectedPrices.length == 2 && selectedPrices.indexOf(PRICES[1]) < 0)){ // Individual Elems
        return selectedPrices.map( p => this.generateSelectedItemSpan(p.id, p.presentation));
      }

      // Combined pricing
      const combinedSelectedPrices = selectedPrices.reduce((acc, c) => {return acc.concat(c.range);}, []);
      return this.generateSelectedItemSpan(
        'combined',
        `$${Math.min(...combinedSelectedPrices)} - $${Math.max(...combinedSelectedPrices)}`
      );
    }

    generateShapeSummary(){
      const {$$bodyShapes, filters,} = this.props;
      const selectedCount = filters.selectedShapes.length;

      if (selectedCount === $$bodyShapes.toJS().length || selectedCount === 0){ // All
        return ( this.generateSelectedItemSpan('all', 'All Shapes', 'shape') );
      }

      return ( this.generateSelectedItemSpan('shapes-selected', pluralize('Shape', selectedCount, true), 'bodyshapes') );
    }

    generateStyleSummary(){
      const {$$bodyStyles, filters,} = this.props;
      const selectedCount = filters.selectedStyles.length;
      if (selectedCount === $$bodyStyles.toJS().length || selectedCount === 0){ // All
        return ( this.generateSelectedItemSpan('all', 'All Styles', 'style') );
      }

      return ( this.generateSelectedItemSpan('styles-selected', pluralize('Style', selectedCount, true), 'styles') );
    }


    render() {
        const {
          $$bodyShapes,
          $$bodyStyles,
          $$colors,
          isDrawerLayout,
          filters,
        } = this.props;

        return (
            <div className="CollectionFilterSort">
                <div className="FilterSort">
                    <div className="ExpandablePanel--wrapper">
                        <div className="ExpandablePanel__heading">
                            <span className="ExpandablePanel__mainTitle">{isDrawerLayout ? 'Filter' : 'Filter by'}</span>
                            <div className="ExpandablePanel__clearAllWrapper">
                              <a onClick={this.handleClearAll} className="ExpandablePanel__clearAll js-trigger-clear-all-filters" href="javascript:;">Clear All</a>
                            </div>
                        </div>

                        <ExpandablePanelItem
                          openedByDefault
                          openPanelCallback={this.handleFilterOpening('COLLECTION_COLOR_FILTER_OPEN')}
                          itemGroup={(
                            <div>
                              <div className="ExpandablePanel__name">
                                Color
                              </div>
                              <div className="ExpandablePanel__selectedOptions">
                                  {this.generateColorSummary(filters.selectedColors)}
                              </div>
                            </div>
                          )}
                          revealedContent={(
                            <div className="ExpandablePanel__listOptions ExpandablePanel__listOptions--panelColors clearfix">
                              <div className="ExpandablePanel__listTwoColumns">
                                  {
                                    $$colors.toJS().map(c => {
                                      return this.buildColorOption(c);
                                    })
                                  }
                              </div>
                            </div>
                          )}
                        />

                        <ExpandablePanelItem
                          openedByDefault={!!filters.selectedStyles.length}
                          openPanelCallback={this.handleFilterOpening('COLLECTION_STYLE_FILTER_OPEN')}
                          itemGroup={(
                            <div>
                              <div className="ExpandablePanel__name">
                                  Style
                              </div>
                              <div className="ExpandablePanel__selectedOptions">
                                  {this.generateStyleSummary()}
                              </div>
                            </div>
                          )}
                          revealedContent={(
                            <div className="ExpandablePanel__listOptions checkboxBlackBg clearfix">
                              <div className="ExpandablePanel__listTwoColumns">
                                {$$bodyStyles.toJS().map(this.buildStyleOptions)}
                              </div>
                            </div>
                          )}
                        />

                        <ExpandablePanelItem
                          openedByDefault={!!filters.selectedShapes.length}
                          openPanelCallback={this.handleFilterOpening('COLLECTION_BODYSHAPE_FILTER_OPEN')}
                          itemGroup={(
                            <div>
                              <div className="ExpandablePanel__name">
                                  Bodyshape
                              </div>
                              <div className="ExpandablePanel__selectedOptions">
                                  {this.generateShapeSummary()}
                              </div>
                            </div>
                          )}
                          revealedContent={(
                            <div className="ExpandablePanel__listOptions checkboxBlackBg clearfix">
                              <div className="ExpandablePanel__listTwoColumns">
                                {$$bodyShapes.toJS().map(this.buildShapeOptions)}
                              </div>
                            </div>
                          )}
                        />

                        <ExpandablePanelItem
                          openedByDefault={!!filters.selectedPrices.length}
                          openPanelCallback={this.handleFilterOpening('COLLECTION_PRICE_FILTER_OPEN')}
                          itemGroup={(
                            <div>
                              <div className="ExpandablePanel__name">
                                  Price
                              </div>
                              <div className="ExpandablePanel__selectedOptions">
                                {this.generatePriceSummary(filters.selectedPrices)}
                              </div>
                            </div>
                          )}
                          revealedContent={(
                            <div className="ExpandablePanel__listOptions checkboxBlackBg clearfix">
                              <div>
                                {PRICES.map( (p, i) => {
                                  return (
                                    <label key={`price-${p.id}`} className="ExpandablePanel__option" name="price">
                                      <input
                                        checked={filters.selectedPrices.indexOf(PRICES[i].id) > - 1}
                                        data-pricemin={p.range[0]}
                                        data-pricemax={p.range[1]}
                                        id={`price-${p.id}}`}
                                        onChange={this.handlePriceSelection(p.id)}
                                        name="price"
                                        type="checkbox"
                                        value={p.range[0]}
                                      />
                                        <span className="checkboxBlackBg__check">
                                            <span className="ExpandablePanel__optionName">{p.presentation}</span>
                                        </span>
                                    </label>
                                  );
                                })}
                              </div>
                            </div>
                          )}
                        />
                    </div>

                    {isDrawerLayout ?
                      <div className="ExpandablePanel__action">
                        <div className="ExpandablePanel__filterTriggers--cancel-apply">
                          <a onClick={this.handleFilterCancel()} className="ExpandablePanel__btn ExpandablePanel__btn--secondary">Cancel</a>
                          <a onClick={this.handleFilterApply()} className="ExpandablePanel__btn">Apply</a>
                        </div>
                      </div> : null
                    }
                </div>
            </div>
        );
    }
}

// CollectionFilterSort.propTypes = {
//     breakpoint: PropTypes.string,
//     isDrawerLayout: PropTypes.bool,
//     dispatch: PropTypes.func,
//     $$colors: PropTypes.object,
//     $$bodyShapes: PropTypes.object,
//     $$bodyStyles: PropTypes.object,
//     filters: PropTypes.object,
//     temporaryFilters: PropTypes.object,
//
//     // Redux Actions
//     applyTemporaryFilters: PropTypes.func,
//     clearAllCollectionFilters: PropTypes.func,
//     setFastMaking: PropTypes.func,
//     setSelectedColors: PropTypes.func,
//     setSelectedPrices: PropTypes.func,
//     setSelectedShapes: PropTypes.func,
//     setSelectedStyles: PropTypes.func,
//     setTemporaryFilters: PropTypes.func,
//     updateExternalLegacyFilters: PropTypes.func,
// };

export default Resize(breakpoints)(connect(stateToProps, dispatchToProps)(CollectionFilterSort));
