import React, {Component, PropTypes,} from 'react';
import {connect,} from 'react-redux';
import {bindActionCreators,} from 'redux';
import * as CollectionFilterSortActions from '../actions/CollectionFilterSortActions';
import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';
import autobind from 'auto-bind';
import _find from 'lodash/find';
import Select from './shared/Select.jsx';

const {ORDERS,} = CollectionFilterSortConstants;

function stateToProps(state, props) {
    // Which part of the Redux global state does our component want to receive as props?
    if (state.$$collectionFilterSortStore) {
        const {$$collectionFilterSortStore,} = state;
        const collectionFilterSortStore = state.$$collectionFilterSortStore.toJS();
        return { order: collectionFilterSortStore.order, };
    }
    return {};
}
function dispatchToProps(dispatch) {
    return bindActionCreators(CollectionFilterSortActions, dispatch);
}

class CollectionSort extends Component {
    constructor(props) {
        super(props);
        autobind(this);
    }

    handleChange({option,}) {
        this.props.orderProductsBy(option.id);
        this.props.updateExternalLegacyFilters({order: option.id,});
    }

    generateOptions() {
        return Object.keys(ORDERS).map((sortKey) => ({
            id: sortKey,
            name: ORDERS[sortKey],
            displayText: `Sort By: ${ORDERS[sortKey]}`,
            active: this.props.order === sortKey,
        }));
    }

    render() {
        return (
            <div className="CollectionSort">
                <Select
                  id="collection-sort-options"
                  onChange={this.handleChange}
                  label="Sort By"
                  className="sort-options"
                  options={this.generateOptions()}
                />
            </div>
        );
    }
}

CollectionSort.propTypes = {
    order: PropTypes.string,

    // Redux Actions
    orderProductsBy: PropTypes.func,
    updateExternalLegacyFilters: PropTypes.func,
};

export default connect(stateToProps, dispatchToProps)(CollectionSort);
