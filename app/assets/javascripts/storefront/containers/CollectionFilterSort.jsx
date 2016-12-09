import React, {Component, PropTypes} from 'react';
import {connect} from 'react-redux';
// import * as CollectionFilterSortActions from '../actions/CollectionFilterSortActions'

//Libraries
import Resize from '../decorators/Resize.jsx';
import breakpoints from '../libs/breakpoints';

// Components
import ExpandablePanelItem from '../components/ExpandablePanelItem.jsx';

function stateToProps(state) {
    // Which part of the Redux global state does our component want to receive as props?
    if (state.$$collectionFilterSortStore) {
        return {
          $$colors: state.$$collectionFilterSortStore.get('$$colors'),
          $$secondaryColors: state.$$collectionFilterSortStore.get('$$secondaryColors')
        };
    }
    return {};
}

class CollectionFilterSort extends Component {
    constructor(props) {
        super(props);
    }

    buildColorOption(color){
      const {name} = color;
      return (
        <label className="ExpandablePanel__option ExpandablePanel__listColumn" name={name}>
          <input
            data-all="false"
            id={`color-${name}`}
            name={`color-${name}`} type="checkbox" value={name}/>
            <span className="ExpandablePanel__optionColorFallback"></span>
            <span className={`ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-${name}`}></span>
            <span className="ExpandablePanel__optionName">{name}</span>
        </label>
      );
    }

    render() {
        const {dispatch, $$colors, $$secondaryColors} = this.props;

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
                                <span className="ExpandablePanel__selectedItem">What's new!!</span>
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
                                  <span className="ExpandablePanel__selectedItem">Black</span>
                                  <span className="ExpandablePanel__selectedItem">White</span>
                                  <span className="ExpandablePanel__selectedItem">Red</span>
                                  <span className="ExpandablePanel__selectedItem">Silver</span>
                                  <span className="ExpandablePanel__selectedItem">Grey</span>
                                  <span className="ExpandablePanel__selectedItem">Green</span>
                              </div>
                            </div>
                          )}
                          revealedContent={(
                            <div>
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
                                  <span className="ExpandablePanel__selectedItem">$0 - 199</span>
                                  <span className="ExpandablePanel__selectedItem">$200 - $299</span>
                              </div>
                            </div>
                          )}
                          revealedContent={(
                            <div>
                              <label className="ExpandablePanel__option" name="price"><input checked="checked" className="js-filter-all" data-all="true" id="price-all" name="price-all" type="checkbox" value="all"/>
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">All prices</span>
                                  </span>
                              </label>
                              <label className="ExpandablePanel__option" name="price"><input data-all="false" data-pricemax="199" data-pricemin="0" id="price-0-199" name="price" type="checkbox" value="0"/>
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">$0 - $199</span>
                                  </span>
                              </label>
                              <label className="ExpandablePanel__option" name="price"><input data-all="false" data-pricemax="299" data-pricemin="200" id="price-200-299" name="price" type="checkbox" value="200"/>
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">$200 - $299</span>
                                  </span>
                              </label>
                              <label className="ExpandablePanel__option" name="price"><input data-all="false" data-pricemax="399" data-pricemin="300" id="price-300-399" name="price" type="checkbox" value="300"/>
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">$300 - $399</span>
                                  </span>
                              </label>
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
                            <div>
                              <label className="ExpandablePanel__option" name="bodyshape"><input checked="checked" className="js-filter-all" data-all="true" id="shapes-all" name="shapes-all" type="checkbox" value="all"/>
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">All shapes</span>
                                  </span>
                              </label>
                              <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-apple" name="shape-apple" type="checkbox" value="apple"/>
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">apple</span>
                                  </span>
                              </label>
                              <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-athletic" name="shape-athletic" type="checkbox" value="athletic"/>
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">athletic</span>
                                  </span>
                              </label>
                              <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-column" name="shape-column" type="checkbox" value="column"/>
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">column</span>
                                  </span>
                              </label>
                              <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-hour_glass" name="shape-hour_glass" type="checkbox" value="hour_glass"/>
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">hour glass</span>
                                  </span>
                              </label>
                              <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-pear" name="shape-pear" type="checkbox" value="pear"/>
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">pear</span>
                                  </span>
                              </label>
                              <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-petite" name="shape-petite" type="checkbox" value="petite"/>
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">petite</span>
                                  </span>
                              </label>
                              <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-strawberry" name="shape-strawberry" type="checkbox" value="strawberry"/>
                                  <span className="checkboxBlackBg__check">
                                      <span className="ExpandablePanel__optionName">strawberry</span>
                                  </span>
                              </label>
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
    $$colors: PropTypes.object,
    $$secondaryColors: PropTypes.object
};

export default Resize(breakpoints)(connect(stateToProps)(CollectionFilterSort));
