import React, {Component} from 'react';
import PropTypes from 'prop-types';
import {connect,} from 'react-redux';
import {bindActionCreators,} from 'redux';
import * as CollectionFilterSortActions from '../actions/CollectionFilterSortActions';
import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';
import {hasLegacyInstance,} from '../utilities/CollectionFilterSortUtilities';

function stateToProps(state, props) {
    // Which part of the Redux global state does our component want to receive as props?
    if (state.$$collectionFilterSortStore) {
        const {$$collectionFilterSortStore,} = state;
        return { order: $$collectionFilterSortStore.toJS().order, };
    }
    return {};
}
function dispatchToProps(dispatch) {
    return bindActionCreators(CollectionFilterSortActions, dispatch);
}

class CollectionSortMobile extends Component {
    constructor(props) {
        super(props);
        this.handleSelection = this.handleSelection.bind(this);
    }

    /**
      * Updates the legacy product collection and kills drawer
      * @param  {Object} update - param object to be assigned to previous filters
      */
    updateExternalProductCollection(update) {
        this.props.updateExternalLegacyFilters(update);
        this.slideDrawerCancel();
    }

    /**
     * Reaches into legacy application to control toggling of mobile filters
     * Ugly. I know. But this is how we sprinkle in react components with prexisting framework
     */
    slideDrawerCancel() {
        if (hasLegacyInstance()) {
            window.ProductCollectionFilter__Instance.toggleSort(false);
        }
    }

    handleSelection(order) {
        const {orderProductsBy,} = this.props;
        return () => {
            orderProductsBy(order);
            this.updateExternalProductCollection({order: order,});
        };
    }

    handleSortCancel() {
        return () => {
            this.slideDrawerCancel();
        };
    }

    render() {
        const {ORDERS,} = CollectionFilterSortConstants;
        const {order,} = this.props;
        return (
            <div className="CollectionSortMobile">
                <div className="ExpandablePanel__heading">
                    <span className="ExpandablePanel__mainTitle">Sort by</span>
                </div>
                <ul>
                    {Object.keys(ORDERS).map((orderKey) => {
                        return (
                            <li className={orderKey === order
                                ? 'is-active'
                                : ''} key={orderKey} onClick={this.handleSelection(orderKey)}>{ORDERS[orderKey]}</li>
                        );
                    })}
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
    order: PropTypes.string,
    orderProductsBy: PropTypes.func,
    updateExternalLegacyFilters: PropTypes.func,
};

export default connect(stateToProps, dispatchToProps)(CollectionSortMobile);
