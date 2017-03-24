import React, {Component, PropTypes,} from 'react';
import {connect,} from 'react-redux';
import assign from 'object-assign';
import {bindActionCreators,} from 'redux';
import * as CollectionFilterSortActions from '../actions/CollectionFilterSortActions';
import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';
import {convertPropsIntoLegacyFilter,} from '../utilities/CollectionFilterSortUtilities';

function stateToProps(state, props) {
    // Which part of the Redux global state does our component want to receive as props?
    if (state.$$collectionFilterSortStore) {
        const {$$collectionFilterSortStore,} = state;
        const collectionFilterSortStore = $$collectionFilterSortStore.toJS();
        return {
          // Immutable Defaults
          $$colors: $$collectionFilterSortStore.get('$$colors'),
          $$bodyShapes: $$collectionFilterSortStore.get('$$bodyShapes'),
          filters: assign({}, {
            order: collectionFilterSortStore.order,
            fastMaking: collectionFilterSortStore.fastMaking,
            selectedColors: collectionFilterSortStore.selectedColors,
            selectedPrices: collectionFilterSortStore.selectedPrices,
            selectedShapes: collectionFilterSortStore.selectedShapes,
            selectedStyles: collectionFilterSortStore.selectedStyles,
          }, collectionFilterSortStore.temporaryFilters),
        };
    }
    return {};
}
function dispatchToProps(dispatch){ return bindActionCreators(CollectionFilterSortActions, dispatch); }

class CollectionSortMobile extends Component {
    constructor(props) {
        super(props);
        this.handleSelection = this.handleSelection.bind(this);
    }

    /**
     * Helper to check if there is a LEGACY instance of product collection js.
     */
    hasLegacyInstance(){
      return typeof window === 'object' && window.ProductCollectionFilter__Instance && window.ProductCollectionFilter__Instance.update;
    }

     /**
      * Updates the legacy product collection
      * @param  {Object} update - param object to be assigned to previous filters
      */
     updateExternalProductCollection(update){
       const {filters, $$colors, $$bodyShapes, $$bodyStyles,} = this.props;
       if (this.hasLegacyInstance()){
         const filterSorts = assign({}, this.props.filters, update);
         const legacyFilterSorts = convertPropsIntoLegacyFilter(filterSorts, {$$colors, $$bodyShapes, $$bodyStyles,});
         window.ProductCollectionFilter__Instance.update(legacyFilterSorts);
         this.slideDrawerCancel();
       }
     }

     /**
     * Reaches into legacy application to control toggling of mobile filters
     * Ugly. I know. But this is how we sprinkle in react components with prexisting framework
     */
    slideDrawerCancel(){
      if (this.hasLegacyInstance()) {
        window.ProductCollectionFilter__Instance.toggleSort();
      }
    }

    handleSelection(order) {
      const {orderProductsBy,} = this.props;
      return () => {
        orderProductsBy(order);
        this.updateExternalProductCollection({order: order,});
      };
    }

    handleSortCancel(){
      return () => { this.slideDrawerCancel(); };
    }

    render() {
      const { ORDERS, } = CollectionFilterSortConstants;
      const { filters, } = this.props;
      return (
          <div className="CollectionSortMobile">
              <div className="ExpandablePanel__heading">
                  <span className="ExpandablePanel__mainTitle">Sort by</span>
              </div>
            <ul>
              {
                Object.keys(ORDERS).map((orderKey) => {
                  return (
                    <li
                      className={orderKey === filters.order ? 'is-active' : ''}
                      key={orderKey}
                      onClick={this.handleSelection(orderKey)}
                    >{ORDERS[orderKey]}</li>
                  );
                })
              }
            </ul>
            <div className="ExpandablePanel__action">
                <div className="ExpandablePanel__filterTriggers--cancel-apply">
                    <a onClick={this.handleSortCancel()} className="ExpandablePanel__btn ExpandablePanel__btn--secondary">Cancel</a>
                </div>
            </div>
          </div>
      );
    }
}

CollectionSortMobile.propTypes = {
  filters: PropTypes.object,
  $$colors: PropTypes.object,
  $$bodyShapes: PropTypes.object,
  $$bodyStyles: PropTypes.object,
  orderProductsBy: PropTypes.func,
};

export default connect(stateToProps, dispatchToProps)(CollectionSortMobile);
