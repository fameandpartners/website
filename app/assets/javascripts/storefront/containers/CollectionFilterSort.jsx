import React, {Component, PropTypes,} from 'react';
import {connect,} from 'react-redux';
import {bindActionCreators,} from 'redux';
import autobind from 'auto-bind';
import * as CollectionFilterSortActions from '../actions/CollectionFilterSortActions';
import _ from 'underscore';

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
          selectedColors: collectionFilterSortStore.selectedColors,
          selectedPrices: collectionFilterSortStore.selectedPrices,
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

    handleColorSelection({id,}){
      let newSelectedColors = [];
      const {selectedColors, setSelectedColors,} = this.props;
      setSelectedColors(this.addOrRemoveFrom(selectedColors, id));
    }

    handlePriceSelection(id){
      const {selectedPrices, setSelectedPrices,} = this.props;
      return () => {
        if (id === 'all'){ setSelectedPrices(PRICES.map(p => p.id));}
        else { setSelectedPrices(this.addOrRemoveFrom(selectedPrices, id));}
      };
    }

    buildColorOption(color){
      const {name,} = color;
      return (
        <label className="ExpandablePanel__option ExpandablePanel__listColumn">
          <input id={`color-${name}`} type="checkbox" value={name} onChange={this.handleColorSelection.bind(this, color)} />
            <span className="ExpandablePanel__optionColorFallback"></span>
            <span className={`ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-${name}`}></span>
            <span className="ExpandablePanel__optionName">{name}</span>
        </label>
      );
    }

    buildCheckboxOption(shape){
      return (
        <label className="ExpandablePanel__option" name="shape">
          <input
            data-all="false"
            id={`shape-${shape}`}
            name={`shape-${shape}`}
            type="checkbox"
            value={shape}
          />
            <span className="checkboxBlackBg__check">
                <span className="ExpandablePanel__optionName">{shape}</span>
            </span>
        </label>
      );
    }

    generateSelectedItemSpan(id, presentation, category){
      return (
        <span key={`${category}-${id}`} className="ExpandablePanel__selectedItem">{presentation}</span>
      );
    }

    generateColorSummary(selectedColorIds){
      const {$$colors, $$secondaryColors,} = this.props;
      const selectedColors = selectedColorIds.map( id => _.findWhere($$colors.toJS().concat($$secondaryColors.toJS()), {id,}));
      return selectedColors.map((color)=>{
        return ( this.generateSelectedItemSpan(color.id, color.presentation, 'color') );
      });
    }

    generatePriceSummary(selectedPriceIds){
      if (PRICES.length === selectedPriceIds.length){
        return ( this.generateSelectedItemSpan('all', 'All Prices', 'price') );
      }
      const selectedPrices = selectedPriceIds.map( id => _.findWhere(PRICES, {id,}));
      return selectedPrices.map((price)=>{
        return ( this.generateSelectedItemSpan(price.id, price.presentation) );
      });
    }

    render() {
        const {
          dispatch,
          $$bodyShapes,
          $$colors,
          $$secondaryColors,
          selectedColors,
          selectedPrices,
        } = this.props;
        console.log('this.props ever render', this.props);

        return (
            <div className="CollectionFilterSort">
                <div className="FilterSort">
                    <div className="ExpandablePanel">
                        <div className="ExpandablePanel__heading">
                            <span className="ExpandablePanel__mainTitle">R.Filter & sort by</span>
                            <a className="ExpandablePanel__clearAll js-trigger-clear-all-filters" href="javascript:;">Clear All</a>
                        </div>

                        <ExpandablePanelItem
                          itemGroup={(
                            <div>
                              <div className="ExpandablePanel__name">
                                Sort
                              </div>
                              <div className="ExpandablePanel__selectedOptions">
                                <span className="ExpandablePanel__selectedItem">What's new</span>
                              </div>
                            </div>
                          )}
                          revealedContent={(
                            <div>
                              <label className="ExpandablePanel__option" name="sort-price-high"><input id="sort-price-high" name="sort-price-high" type="checkbox" value="true"/>
                                <span className="checkboxBlackBg__check">
                                  <span className="ExpandablePanel__optionName">Price High</span>
                                </span>
                              </label>
                              <label className="ExpandablePanel__option" name="sort-price-low"><input id="sort-price-low" name="sort-price-low" type="checkbox" value="true"/>
                                <span className="checkboxBlackBg__check">
                                  <span className="ExpandablePanel__optionName">Price Low</span>
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
                                <div className="ExpandablePanel__moreOptions">
                                  <a className="js-trigger-see-more" href="javascript:;">More Colors & Patterns</a>
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
                              {PRICES.map( p => {
                                return (
                                  <label key={`price-${p.id}`} className="ExpandablePanel__option" name="price">
                                    <input
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
                            </div>
                          )}
                          revealedContent={(
                            <div className="ExpandablePanel__listOptions checkboxBlackBg">
                              <label className="ExpandablePanel__option" name="bodyshape"><input checked="checked" className="js-filter-all" data-all="true" id="shapes-all" name="shapes-all" type="checkbox" value="all"/>
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">All shapes</span>
                                  </span>
                              </label>
                              {$$bodyShapes.toJS().map((shape)=>{
                                return this.buildCheckboxOption(shape);
                              })}
                            </div>
                          )}
                        />


                        <div className="ExpandablePanel__secondaryFiltersWrapper">
                            <div className="ExpandablePanelItem ExpandablePanelItem--secondary">
                                <div className="ExpandablePanel__name">
                                    Secondary Filter 1
                                </div>
                            </div>
                            <div className="ExpandablePanelItem ExpandablePanelItem--secondary">
                                <div className="ExpandablePanel__name">
                                    Secondary Filter 2
                                </div>
                            </div>
                            <div className="ExpandablePanelItem ExpandablePanelItem--secondary">
                                <div className="ExpandablePanel__name">
                                    Secondary Filter 3
                                </div>
                            </div>
                        </div>
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
    selectedColors: PropTypes.array,
    selectedPrices: PropTypes.array,

    // Redux Actions
    setSelectedColors: PropTypes.func,
    setSelectedPrices: PropTypes.func,
};

export default Resize(breakpoints)(connect(stateToProps, dispatchToProps)(CollectionFilterSort));
