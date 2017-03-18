import React, {Component, PropTypes} from 'react';
import {connect,} from 'react-redux';
import {bindActionCreators,} from 'redux';
import * as CollectionFilterSortActions from '../actions/CollectionFilterSortActions';
import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';

function stateToProps(state, props) {
    // Which part of the Redux global state does our component want to receive as props?
    if (state.$$collectionFilterSortStore) {
        const {$$collectionFilterSortStore,} = state;
        const collectionFilterSortStore = $$collectionFilterSortStore.toJS();
        return {
          order: collectionFilterSortStore.order,
        };
    }
    return {};
}
function dispatchToProps(dispatch){ return bindActionCreators(CollectionFilterSortActions, dispatch); }

class CollectionSortMobile extends Component {
    constructor(props) {
        super(props);
        console.log('props within CollectionSortMobile', props);
        this.handleSelection = this.handleSelection.bind(this);
    }

    /**
     * Helper to check if there is a LEGACY instance of product collection js.
     */
    hasLegacyInstance(){
      return typeof window === 'object' && window.ProductCollectionFilter__Instance && window.ProductCollectionFilter__Instance.update;
    }

    handleSelection(selection) {
      return () => {
        console.log('clicking selection!', selection);
      }
    }
    /**
     * Reaches into legacy application to control toggling of mobile filters
     * Ugly. I know. But this is how we sprinkle in react components with prexisting framework
     */
    handleSortCancel(){
      return () => {
        if (this.hasLegacyInstance()) {
          window.ProductCollectionFilter__Instance.toggleSort();
      }};
    }

    render() {
      const { ORDERS } = CollectionFilterSortConstants;
      return (
          <div className='CollectionSortMobile'>
              <div className="ExpandablePanel__heading">
                <span className="ExpandablePanel__mainTitle">Sort by</span>
              </div>
            <ul>
              {
                Object.keys(ORDERS).map((orderKey) => {
                  return (<li key={orderKey} onClick={this.handleSelection(orderKey)}>{ORDERS[orderKey]}</li>)
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

CollectionSortMobile.propTypes = {};

export default connect(stateToProps, dispatchToProps)(CollectionSortMobile);
