import React, {Component, PropTypes,} from 'react';
import {connect,} from 'react-redux';
import {bindActionCreators,} from 'redux';
import autobind from 'auto-bind';
import * as CollectionFilterSortActions from '../actions/CollectionFilterSortActions';
import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';
import _find from 'lodash/find';
import {cleanCapitalizeWord,} from '../helpers/TextFormatting';
import {getUrlParameter,} from '../helpers/BOM';
import assign from 'object-assign';

//Libraries
import Resize from '../decorators/Resize.jsx';
import breakpoints from '../libs/breakpoints';

// Components
import ExpandablePanelItem from '../components/ExpandablePanelItem.jsx';

// Constants
const {PRICES,DEFAULTS,} = CollectionFilterSortConstants;

function stateToProps(state, props) {
    // Which part of the Redux global state does our component want to receive as props?
    if (state.$$collectionFilterSortStore) {
        const {$$collectionFilterSortStore,} = state;
        const collectionFilterSortStore = $$collectionFilterSortStore.toJS();
        return {
          // Immutable Defaults
          $$colors: $$collectionFilterSortStore.get('$$colors'),
          $$secondaryColors: $$collectionFilterSortStore.get('$$secondaryColors'),
          $$bodyShapes: $$collectionFilterSortStore.get('$$bodyShapes'),
          // Mutable props
          isDrawerLayout: props.isDrawerLayout,
          filters: assign({}, {
            order: collectionFilterSortStore.order,
            fastMaking: collectionFilterSortStore.fastMaking,
            selectedColors: collectionFilterSortStore.selectedColors,
            selectedPrices: collectionFilterSortStore.selectedPrices,
            selectedShapes: collectionFilterSortStore.selectedShapes,
          }, collectionFilterSortStore.temporaryFilters),
          temporaryFilters: collectionFilterSortStore.temporaryFilters,
        };
    }
    return {};
}
function dispatchToProps(dispatch){ return bindActionCreators(CollectionFilterSortActions, dispatch); }


class CollectionFilterSort extends Component {
    constructor(props) {
        super(props);
        autobind(this);
    }

    /**
     * Helper to check if there is a LEGACY instance of product collection js.
     */
    hasLegacyInstance(){
      return typeof window === 'object' && window.ProductCollectionFilter__Instance && window.ProductCollectionFilter__Instance.update;
    }

    /**
     * UGLY necessity
     * Converts props into legacy filter object for consumption by legacy AJAX
     * @param  {Object} props
     * @return {Object}
     */
    convertPropsIntoLegacyFilter({fastMaking, order, selectedShapes, selectedColors, selectedPrices,}){
      const mainFilters = {
        bodyshape: selectedShapes.length === this.props.$$bodyShapes.toJS().length ? [] : selectedShapes,
        color: selectedColors.length === this.props.$$colors.length ? [] : selectedColors,
        fast_making: fastMaking ? [true,] : undefined,
        order,
        q: getUrlParameter('q').replace(/\+/g," "),
      };

      if (selectedPrices.length !== PRICES.length){
        let getPrice = (price, index) => _find(PRICES, {id: price,}).range[index];

        return assign({}, mainFilters, {
          price_min: selectedPrices.map(p => getPrice(p, 0)),
          price_max: selectedPrices.map(p => getPrice(p, 1)),
        });
      } else {
        return mainFilters;
      }
    }


    /**
     * Updates the legacy product collection
     * @param  {Object} update - param object to be assigned to previous filters
     */
    updateExternalProductCollection(update){
      if (this.hasLegacyInstance()){
        const filterSorts = assign({}, this.props.filters, update);
        const legacyFilterSorts = this.convertPropsIntoLegacyFilter(filterSorts);
        window.ProductCollectionFilter__Instance.update(legacyFilterSorts);
      }
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

    /**
     * FILTER/SORT Action Handlers
     **********************************
     */
    handleClearAll(){
      const {clearAllCollectionFilterSorts, isDrawerLayout, setTemporaryFilters,} = this.props;
      clearAllCollectionFilterSorts();
      if (isDrawerLayout){ setTemporaryFilters({}); }
      else { this.updateExternalProductCollection(DEFAULTS); }
    }

    handleColorSelection({name,}){
      const {isDrawerLayout, filters, setSelectedColors, setTemporaryFilters, temporaryFilters,} = this.props;
      let newColors = this.addOrRemoveFrom(filters.selectedColors, name);
      if (isDrawerLayout){
        setTemporaryFilters(assign({}, temporaryFilters, {selectedColors: newColors,}));
      } else {
        setSelectedColors(newColors);
        this.updateExternalProductCollection({selectedColors: newColors,});
      }
    }

    updatePrice(newPrices){
      const {isDrawerLayout, setSelectedPrices, setTemporaryFilters, temporaryFilters,} = this.props;
      if (isDrawerLayout){ // mobile version
        setTemporaryFilters(assign({}, temporaryFilters, {selectedPrices: newPrices,}));
      } else {
        setSelectedPrices(newPrices);
        this.updateExternalProductCollection({selectedPrices: newPrices,});
      }
    }

    handleAllPriceSelection(){
      const {isDrawerLayout, filters, setSelectedPrices,} = this.props;
      const newPrices = PRICES.map(p => p.id);
      this.updatePrice(newPrices);
    }

    handlePriceSelection(id){
      const {isDrawerLayout, filters, setSelectedPrices,} = this.props;
      return () => {
        const newPrices = this.addOrRemoveFrom(filters.selectedPrices, id).sort();
        this.updatePrice(newPrices);
      };
    }

    handleAllSelectedShapes(){
      const {$$bodyShapes, isDrawerLayout, setSelectedShapes, setTemporaryFilters, temporaryFilters,} = this.props;
      const newShapes = $$bodyShapes.toJS();
      return () => {
        if (isDrawerLayout){ // mobile version
          setTemporaryFilters(assign({}, temporaryFilters, {selectedShapes: newShapes,}));
        } else {
          setSelectedShapes(newShapes);
          this.updateExternalProductCollection({selectedShapes: [],});
        }
      };
    }

    handleShapeSelection(shapeId){
      const {$$bodyShapes, isDrawerLayout, filters, setSelectedShapes, setTemporaryFilters, temporaryFilters,} = this.props;
      let newShapes = [];
      return () => {
        const newShapes = this.addOrRemoveFrom(filters.selectedShapes, shapeId).sort();
        if (isDrawerLayout){ // mobile version
          setTemporaryFilters(assign({}, temporaryFilters, {selectedShapes: newShapes,}));
        } else {
          setSelectedShapes(newShapes);
          this.updateExternalProductCollection({selectedShapes: newShapes,});
        }
      };
    }

    handleOrderBy(order){
      const {isDrawerLayout, orderProductsBy, setTemporaryFilters, temporaryFilters,} = this.props;
      return () => {
        if (isDrawerLayout){
          setTemporaryFilters(assign({}, temporaryFilters, {order: order,}));
        } else {
          orderProductsBy(order);
          this.updateExternalProductCollection({order: order,});
        }
      };
    }

    handleFastMaking(){
      const {
        filters,
        isDrawerLayout,
        orderProductsBy,
        setFastMaking,
        setTemporaryFilters,
        temporaryFilters,
      } = this.props;
      const {fastMaking,} = filters;
      return () => {
        if (isDrawerLayout){
          setTemporaryFilters(assign({}, temporaryFilters, {fastMaking: !fastMaking,}));
        } else {
          setFastMaking(!fastMaking);
          this.updateExternalProductCollection({fastMaking: !fastMaking,});
        }
      };
    }

    /**
     * Reaches into legacy application to control toggling of mobile filters
     * Ugly. I know. But this is how we sprinkle in react components with prexisting framework
     */
    handleFilterCancel(){
      return () => {
        if (this.hasLegacyInstance()){
          this.props.setTemporaryFilters({});
          window.ProductCollectionFilter__Instance.toggleFilters();
      }};
    }

    handleFilterApply(){
      const {applyTemporaryFilters, temporaryFilters,} = this.props;
      return () => {
        applyTemporaryFilters(temporaryFilters);
        this.updateExternalProductCollection(temporaryFilters);
      };
    }


    /**
     * RENDERERS, NOTE: Can be moved to separate components
     * ***************************************************
     */
    buildColorOption(color){
      const {selectedColors,} = this.props.filters;
      const {name,id,} = color;
      return (
        <label key={`color-${id}`} className="ExpandablePanel__option ExpandablePanel__listColumn">
          <input
            id={`color-${name}`}
            type="checkbox"
            value={name}
            checked={selectedColors.indexOf(name) > -1}
            onChange={this.handleColorSelection.bind(this, color)}
          />
          <span className="ExpandablePanel__optionColorFallback"></span>
          <span className={`ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-${name}`}></span>
          <span className="ExpandablePanel__optionName">{name}</span>
        </label>
      );
    }

    buildShapeOptions(shape, i){
      const {selectedShapes,} = this.props.filters;
      return (
        <label key={`shape-${shape}`} className="ExpandablePanel__option" name="shape">
          <input
            onChange={this.handleShapeSelection(shape)}
            checked={selectedShapes.indexOf(shape) > -1 || selectedShapes.indexOf('all') > -1}
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

    generateSelectedItemSpan(id, presentation, category='elem'){
      return (
        <span key={`${category}-${id}`} className="ExpandablePanel__selectedItem">{presentation}</span>
      );
    }

    generateColorSummary(selectedColorNames){
      const {$$colors, $$secondaryColors,} = this.props;
      const selectedColors = selectedColorNames.map( name => _find($$colors.toJS().concat($$secondaryColors.toJS()), {name: name,}) );
      if (selectedColors.length === 0){
        return ( this.generateSelectedItemSpan('all', 'All Colors', 'color') );
      }

      return selectedColors.map( color =>
        this.generateSelectedItemSpan(color.id, color.presentation, 'color')
      );
    }

    generatePriceSummary(selectedPriceIds){
      const selectedPrices = selectedPriceIds.map( id => _find(PRICES, {id: id,}) );
      if (PRICES.length === selectedPriceIds.length || selectedPriceIds.length === 0){ // All
        return ( this.generateSelectedItemSpan('all', 'All Prices', 'price') );
      }

      if (selectedPrices.length === 1 ||
         (selectedPrices.length == 2 && selectedPrices.indexOf(PRICES[1]) < 0)){ // Individual Elems
        return selectedPrices.map( p => this.generateSelectedItemSpan(p.id, p.presentation));
      }

      // Combined pricing
      const combinedSelectedPrices = selectedPrices.reduce((acc, c) => {return acc.concat(c.range);}, []);
      return this.generateSelectedItemSpan('combined', `$${Math.min(...combinedSelectedPrices)} - $${Math.max(...combinedSelectedPrices)}`);

    }

    generateShapeSummary(selectedColorIds){
      const {$$bodyShapes, filters,} = this.props;
      if (filters.selectedShapes.length === $$bodyShapes.toJS().length || filters.selectedShapes.length === 0){ // All
        return ( this.generateSelectedItemSpan('all', 'All Shapes', 'shape') );
      }
      return filters.selectedShapes.map( shape => // Individual Elems
        this.generateSelectedItemSpan(shape, cleanCapitalizeWord(shape, ['_',]), 'shape')
      );
    }


    render() {
        const {
          $$bodyShapes,
          $$colors,
          $$secondaryColors,
          isDrawerLayout,
          filters,
        } = this.props;
        return (
            <div className="CollectionFilterSort">
                <div className="FilterSort">
                    <div className="ExpandablePanel">
                        <div className="ExpandablePanel__heading">
                            <span className="ExpandablePanel__mainTitle">{isDrawerLayout ? 'Filter' : 'Filter & Sort by'}</span>
                            <div className="ExpandablePanel__clearAllWrapper">
                              <a onClick={this.handleClearAll} className="ExpandablePanel__clearAll js-trigger-clear-all-filters" href="javascript:;">Clear All</a>
                            </div>
                        </div>

                        <ExpandablePanelItem
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
                            <div className="ExpandablePanel__listOptions ExpandablePanel__listOptions--panelColors">
                              <div>
                                <div className="ExpandablePanel__listTwoColumns">
                                    {
                                      $$colors.toJS().map(c => {
                                        return this.buildColorOption(c);
                                      })
                                    }
                                </div>
                              </div>
                              <div className="ExpandablePanel__moreOptionsList">
                                  <div className="ExpandablePanel__listOptions ExpandablePanel__listOptions--twoColumns ExpandablePanel__listOptions--panelColors">
                                    {
                                      $$secondaryColors.toJS().map(c => {
                                        return this.buildColorOption(c);
                                      })
                                    }
                                  </div>
                              </div>
                            </div>
                          )}
                        />


                        <ExpandablePanelItem
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
                            <div className="ExpandablePanel__listOptions checkboxBlackBg">
                              <label className="ExpandablePanel__option" name="price">
                                <input
                                  checked={filters.selectedPrices.length === 3}
                                  className="js-filter-all"
                                  data-all="true"
                                  id="price-all"
                                  onChange={this.handleAllPriceSelection}
                                  name="price-all"
                                  type="checkbox"
                                  value="all"
                                />
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">All prices</span>
                                  </span>
                              </label>
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
                          )}
                        />


                        <ExpandablePanelItem
                          itemGroup={(
                            <div>
                              <div className="ExpandablePanel__name">
                                  Bodyshape
                              </div>
                              <div className="ExpandablePanel__selectedOptions">
                                  {this.generateShapeSummary(filters.selectedShapes)}
                              </div>
                            </div>
                          )}
                          revealedContent={(
                            <div className="ExpandablePanel__listOptions checkboxBlackBg">
                              <label className="ExpandablePanel__option" name="bodyshape">
                                <input
                                  onChange={this.handleAllSelectedShapes()}
                                  checked={filters.selectedShapes.length === $$bodyShapes.toJS().length}
                                  data-all="true"
                                  id="shapes-all"
                                  name="shapes-all"
                                  type="checkbox"
                                />
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">All shapes</span>
                                  </span>
                              </label>
                              {$$bodyShapes.toJS().map(this.buildShapeOptions)}
                            </div>
                          )}
                        />


                        <div className="ExpandablePanel__secondaryFiltersWrapper">
                          <ExpandablePanelItem
                            isSecondaryFilter
                            itemGroup={(
                              <div>
                                <div className="ExpandablePanel__name">
                                    Delivery Date
                                </div>
                                <div className="ExpandablePanel__selectedOptions">
                                </div>
                              </div>
                            )}
                            revealedContent={(
                              <div className="ExpandablePanel__listOptions checkboxBlackBg">
                                <label className="ExpandablePanel__option" name="deliverydate">
                                  <input
                                    id="fast_making"
                                    checked={filters.fastMaking}
                                    onChange={this.handleFastMaking()}
                                    name="fast_making"
                                    type="checkbox"
                                  />
                                  <span className="checkboxBlackBg__check">
                                    <span className="ExpandablePanel__optionName">Express Making (6 - 9 Days)</span>
                                  </span>
                                </label>
                              </div>
                            )}
                          />
                        </div>

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

CollectionFilterSort.propTypes = {
    breakpoint: PropTypes.string,
    isDrawerLayout: PropTypes.bool,
    dispatch: PropTypes.func,
    $$colors: PropTypes.object,
    $$secondaryColors: PropTypes.object,
    $$bodyShapes: PropTypes.object,
    filters: PropTypes.object,
    temporaryFilters: PropTypes.object,

    // Redux Actions
    applyTemporaryFilters: PropTypes.func,
    clearAllCollectionFilterSorts: PropTypes.func,
    orderProductsBy: PropTypes.func,
    setFastMaking: PropTypes.func,
    setSelectedColors: PropTypes.func,
    setSelectedPrices: PropTypes.func,
    setSelectedShapes: PropTypes.func,
    setTemporaryFilters: PropTypes.func,
};

export default Resize(breakpoints)(connect(stateToProps, dispatchToProps)(CollectionFilterSort));
