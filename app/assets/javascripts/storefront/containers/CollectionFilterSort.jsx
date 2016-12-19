import React, {Component, PropTypes,} from 'react';
import {connect,} from 'react-redux';
import {bindActionCreators,} from 'redux';
import autobind from 'auto-bind';
import * as CollectionFilterSortActions from '../actions/CollectionFilterSortActions';
import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';
import _ from 'underscore';
import {cleanCapitalizeWord,} from '../helpers/TextFormatting';
import {getUrlParameter,} from '../helpers/BOM';
import assign from 'object-assign';

//Libraries
import Resize from '../decorators/Resize.jsx';
import breakpoints from '../libs/breakpoints';

// Components
import ExpandablePanelItem from '../components/ExpandablePanelItem.jsx';

// Constants
const PRICES = [
  {
    id: '0-199',
    range: [0, 199,],
    presentation: '$0 - $199',
  },
  {
    id: '200-299',
    range: [200, 299,],
    presentation: '$200 - $299',
  },
  {
    id: '300-399',
    range: [300, 399,],
    presentation: '$300 - $399',
  },
];

//TODO: @elgrecode check if this is provided by backend in legacy version
const ORDERS = {
  newest: 'What\'s New',
  price_high: 'Price High to Low',
  price_low: 'Price Low to High',
};

function stateToProps(state) {
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
          order: collectionFilterSortStore.order,
          fastMaking: collectionFilterSortStore.fastMaking,
          selectedColors: collectionFilterSortStore.selectedColors,
          selectedPrices: collectionFilterSortStore.selectedPrices,
          selectedShapes: collectionFilterSortStore.selectedShapes,
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
     * Converts props into legacy filter object
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
        return assign({}, mainFilters, {
          price_min: selectedPrices.map(p => _.findWhere(PRICES, {id: p,}).range[0] ),
          price_max: selectedPrices.map(p => _.findWhere(PRICES, {id: p,}).range[1] ),
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
      if (typeof window === 'object' && window.ProductCollectionFilter__Instance && window.ProductCollectionFilter__Instance.update){
        const filterSorts = assign({}, this.props, update);
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
      this.props.clearAllCollectionFilterSorts();
      this.updateExternalProductCollection(CollectionFilterSortConstants.DEFAULTS);
    }

    handleColorSelection({name,}){
      const {selectedColors, setSelectedColors,} = this.props;
      let newColors = this.addOrRemoveFrom(selectedColors, name);
      setSelectedColors(newColors);

      this.updateExternalProductCollection({selectedColors: newColors,});
    }

    handlePriceSelection(id){
      const {selectedPrices, setSelectedPrices,} = this.props;
      let newPrices = [];
      return () => {
        if (id === 'all'){
          newPrices = PRICES.map(p => p.id);
          setSelectedPrices(newPrices);
        } else {
          newPrices = this.addOrRemoveFrom(selectedPrices, id).sort();
          setSelectedPrices(newPrices);
        }

        this.updateExternalProductCollection({selectedPrices: newPrices,});
      };
    }

    handleShapeSelection(shapeId){
      const {selectedShapes, setSelectedShapes, $$bodyShapes,} = this.props;
      let newShapes = [];
      return () => {
        if (shapeId.toLowerCase() === 'all'){
          newShapes = $$bodyShapes.toJS();
          setSelectedShapes(newShapes);
          this.updateExternalProductCollection({selectedShapes: [],});
        } else {
          newShapes = this.addOrRemoveFrom(selectedShapes, shapeId).sort();
          setSelectedShapes(newShapes);
          this.updateExternalProductCollection({selectedShapes: newShapes,});
        }
      };
    }

    handleOrderBy(order){
      const {orderProductsBy,} = this.props;
      return () => {
        orderProductsBy(order);
        this.updateExternalProductCollection({order: order,});
      };
    }

    handleFastMaking(){
      const {fastMaking, orderProductsBy, setFastMaking,} = this.props;
      return () => {
        setFastMaking(!fastMaking);
        this.updateExternalProductCollection({fastMaking: !fastMaking,});
      };
    }


    /**
     * RENDERERS, NOTE: Can be moved to separate components
     * ***************************************************
     */
    buildColorOption(color){
      const {selectedColors,} = this.props;
      const {name,} = color;
      return (
        <label className="ExpandablePanel__option ExpandablePanel__listColumn">
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
      const {selectedShapes,} = this.props;
      return (
        <label className="ExpandablePanel__option" name="shape">
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

    generateSelectedItemSpan(id, presentation, category){
      return (
        <span key={`${category}-${id}`} className="ExpandablePanel__selectedItem">{presentation}</span>
      );
    }

    generateColorSummary(selectedColorNames){
      const {$$colors, $$secondaryColors,} = this.props;
      const selectedColors = selectedColorNames.map( name => _.findWhere($$colors.toJS().concat($$secondaryColors.toJS()), {name,}));
      if (selectedColors.length === 0){
        return ( this.generateSelectedItemSpan('all', 'All Colors', 'color') );
      }

      return selectedColors.map( color =>
        this.generateSelectedItemSpan(color.id, color.presentation, 'color')
      );
    }

    generatePriceSummary(selectedPriceIds){
      const selectedPrices = selectedPriceIds.map( id => _.findWhere(PRICES, {id,}));
      if (PRICES.length === selectedPriceIds.length || selectedPriceIds.length === 0){ // All
        return ( this.generateSelectedItemSpan('all', 'All Prices', 'price') );
      }

      if (selectedPrices.length === 1 ||
         (selectedPrices.length == 2 && selectedPrices.indexOf(PRICES[1]) < 0)){ // Individual Elems
        return selectedPrices.map( p => this.generateSelectedItemSpan(p.id, p.presentation));
      }

      // Combined pricing
      const combinedSelectedPrices = selectedPrices.reduce((acc, c) => {return acc.concat(c.range);}, []);
      return selectedPrices.map( p =>
        this.generateSelectedItemSpan('combined', `$${Math.min(...combinedSelectedPrices)} - $${Math.max(...combinedSelectedPrices)}`)
      );
    }

    generateShapeSummary(selectedColorIds){
      const {$$bodyShapes, selectedShapes,} = this.props;
      if (selectedShapes.length === $$bodyShapes.toJS().length || selectedShapes.length === 0){ // All
        return ( this.generateSelectedItemSpan('all', 'All Shapes', 'shape') );
      }
      return this.props.selectedShapes.map( shape => // Individual Elems
        this.generateSelectedItemSpan(shape, cleanCapitalizeWord(shape, ['_',]), 'shape')
      );
    }


    render() {
        const {
          $$bodyShapes,
          $$colors,
          $$secondaryColors,
          order,
          fastMaking,
          selectedColors,
          selectedPrices,
          selectedShapes,
        } = this.props;
        return (
            <div className="CollectionFilterSort">
                <div className="FilterSort">
                    <div className="ExpandablePanel">
                        <div className="ExpandablePanel__heading">
                            <span className="ExpandablePanel__mainTitle">Filter & Sort by</span>
                            <a onClick={this.handleClearAll} className="ExpandablePanel__clearAll js-trigger-clear-all-filters" href="javascript:;">Clear All</a>
                        </div>

                        <ExpandablePanelItem
                          itemGroup={(
                            <div>
                              <div className="ExpandablePanel__name">
                                Sort
                              </div>
                              <div className="ExpandablePanel__selectedOptions">
                                <span className="ExpandablePanel__selectedItem">{ORDERS[order]}</span>
                              </div>
                            </div>
                          )}
                          revealedContent={(
                            <div className="ExpandablePanel__listOptions checkboxBlackBg">
                              <label className="ExpandablePanel__option" name="price_high">
                                <input
                                  onChange={this.handleOrderBy('price_high')}
                                  id="price_high"
                                  name="price_high"
                                  type="checkbox"
                                  value="true"
                                  checked={order === 'price_high'}
                                />
                                <span className="checkboxBlackBg__check">
                                  <span className="ExpandablePanel__optionName">Price high to low</span>
                                </span>
                              </label>
                              <label className="ExpandablePanel__option" name="price_low">
                                <input
                                  onChange={this.handleOrderBy('price_low')}
                                  id="price_low"
                                  name="price_low"
                                  type="checkbox"
                                  value="true"
                                  checked={order === 'price_low'}
                                />
                                <span className="checkboxBlackBg__check">
                                  <span className="ExpandablePanel__optionName">Price low to high</span>
                                </span>
                              </label>
                              <label className="ExpandablePanel__option" name="newest">
                                <input
                                  onChange={this.handleOrderBy('newest')}
                                  id="newest"
                                  name="newest"
                                  type="checkbox"
                                  value="true"
                                  checked={order === 'newest'}
                                />
                                <span className="checkboxBlackBg__check">
                                  <span className="ExpandablePanel__optionName">What's new</span>
                                </span>
                              </label>
                            </div>
                          )}
                        />

                        <ExpandablePanelItem
                          itemGroup={(
                            <div>
                              <div className="ExpandablePanel__name">
                                Color
                              </div>
                              <div className="ExpandablePanel__selectedOptions">
                                  {this.generateColorSummary(selectedColors)}
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
                                {this.generatePriceSummary(selectedPrices)}
                              </div>
                            </div>
                          )}
                          revealedContent={(
                            <div className="ExpandablePanel__listOptions checkboxBlackBg">
                              <label className="ExpandablePanel__option" name="price">
                                <input
                                  checked={selectedPrices.length === 3}
                                  className="js-filter-all"
                                  data-all="true"
                                  id="price-all"
                                  onChange={this.handlePriceSelection('all')}
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
                                      checked={selectedPrices.indexOf(PRICES[i].id) > - 1}
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
                                  {this.generateShapeSummary(selectedShapes)}
                              </div>
                            </div>
                          )}
                          revealedContent={(
                            <div className="ExpandablePanel__listOptions checkboxBlackBg">
                              <label className="ExpandablePanel__option" name="bodyshape">
                                <input
                                  onChange={this.handleShapeSelection('all')}
                                  checked={selectedShapes.length === $$bodyShapes.toJS().length}
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

                        <ExpandablePanelItem
                          itemGroup={(
                            <div className="checkboxBlackBg">
                              <label className="ExpandablePanel__option" name="bodyshape">
                                <input
                                  id="fast_making"
                                  checked={fastMaking}
                                  onChange={this.handleFastMaking()}
                                  name="fast_making"
                                  type="checkbox"
                                />
                                <span className="checkboxBlackBg__check">
                                  <span className="ExpandablePanel__optionName">EXPRESS MAKING (6 - 9 Days)</span>
                                </span>
                              </label>
                            </div>
                          )}
                        />

                    </div>
                </div>
            </div>
        );
    }
}

CollectionFilterSort.propTypes = {
    breakpoint: PropTypes.string,
    dispatch: PropTypes.func.isRequired,
    $$colors: PropTypes.array,
    $$secondaryColors: PropTypes.array,
    $$bodyShapes: PropTypes.array,
    fastMaking: PropTypes.bool,
    order: PropTypes.string,
    selectedColors: PropTypes.array,
    selectedPrices: PropTypes.array,
    selectedShapes: PropTypes.array,

    // Redux Actions
    clearAllCollectionFilterSorts: PropTypes.func,
    orderProductsBy: PropTypes.func,
    setFastMaking: PropTypes.func,
    setSelectedColors: PropTypes.func,
    setSelectedPrices: PropTypes.func,
    setSelectedShapes: PropTypes.func,
};

export default Resize(breakpoints)(connect(stateToProps, dispatchToProps)(CollectionFilterSort));

//<div className="ExpandablePanel__secondaryFiltersWrapper">
//     <div className="ExpandablePanelItem ExpandablePanelItem--secondary">
//         <div className="ExpandablePanel__name">
//             Secondary Filter 1
//         </div>
//     </div>
//     <div className="ExpandablePanelItem ExpandablePanelItem--secondary">
//         <div className="ExpandablePanel__name">
//             Secondary Filter 2
//         </div>
//     </div>
//     <div className="ExpandablePanelItem ExpandablePanelItem--secondary">
//         <div className="ExpandablePanel__name">
//             Secondary Filter 3
//         </div>
//     </div>
// </div>
