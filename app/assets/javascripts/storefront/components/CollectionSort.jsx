import React, {Component, PropTypes,} from 'react';
import {connect,} from 'react-redux';
import {bindActionCreators,} from 'redux';
import * as CollectionFilterSortActions from '../actions/CollectionFilterSortActions';
import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';
import autobind from 'auto-bind';
import assign from 'object-assign';
import _find from 'lodash/find';
import {getUrlParameter,} from '../helpers/BOM';
import Select from './shared/Select.jsx';

const {PRICES, ORDERS,} = CollectionFilterSortConstants;

function stateToProps(state, props) {
    // Which part of the Redux global state does our component want to receive as props?
    if (state.$$collectionFilterSortStore) {
        const {$$collectionFilterSortStore,} = state;
        const collectionFilterSortStore = state.$$collectionFilterSortStore.toJS();
        return {
            // Immutable Defaults
            $$colors: $$collectionFilterSortStore.get('$$colors'),
            $$bodyShapes: $$collectionFilterSortStore.get('$$bodyShapes'),
            // Mutable props
            filters: assign({}, {
                order: collectionFilterSortStore.order,
                fastMaking: collectionFilterSortStore.fastMaking,
                selectedColors: collectionFilterSortStore.selectedColors,
                selectedPrices: collectionFilterSortStore.selectedPrices,
                selectedShapes: collectionFilterSortStore.selectedShapes,
            }, collectionFilterSortStore.temporaryFilters),
        };
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

    /**
     * Helper to check if there is a LEGACY instance of product collection js.
     */
    hasLegacyInstance() {
        return typeof window === 'object' && window.ProductCollectionFilter__Instance && window.ProductCollectionFilter__Instance.update;
    }

    /**
     * UGLY necessity
     * Converts props into legacy filter object for consumption by legacy AJAX
     * @param  {Object} props
     * @return {Object}
     */
    convertPropsIntoLegacyFilter({fastMaking, order, selectedShapes, selectedColors, selectedPrices,}) {
        const mainFilters = {
            bodyshape: selectedShapes.length === this.props.$$bodyShapes.toJS().length
                ? []
                : selectedShapes,
            color: selectedColors.length === this.props.$$colors.length
                ? []
                : selectedColors,
            fast_making: fastMaking
                ? [true,]
                : undefined,
            order,
            q: getUrlParameter('q').replace(/\+/g, " "),
        };

        if (selectedPrices.length !== PRICES.length) {
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
    updateExternalProductCollection(update) {
        if (this.hasLegacyInstance()) {
            const filterSorts = assign({}, this.props.filters, update);
            const legacyFilterSorts = this.convertPropsIntoLegacyFilter(filterSorts);
            window.ProductCollectionFilter__Instance.update(legacyFilterSorts);
        }
    }

    handleChange({option,}) {
        this.props.orderProductsBy(option.id);
        this.updateExternalProductCollection({order: option.id,});
    }

    generateOptions() {
        return Object.keys(ORDERS).map((sortKey) => ({
            id: sortKey,
            name: ORDERS[sortKey],
            displayText: `Sort By: ${ORDERS[sortKey]}`,
            active: this.props.filters.order === sortKey,
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
    breakpoint: PropTypes.string,
    isDrawerLayout: PropTypes.bool,
    $$colors: PropTypes.object,
    $$bodyShapes: PropTypes.object,
    filters: PropTypes.object,

    // Redux Actions
    orderProductsBy: PropTypes.func,
};

export default connect(stateToProps, dispatchToProps)(CollectionSort);
