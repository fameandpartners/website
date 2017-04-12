import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';
import { assign, find, } from 'lodash';
import { getUrlParameter, decodeQueryParams, } from '../helpers/BOM';
const { PRICES, } = CollectionFilterSortConstants;

/**
 * Helper to check if there is a LEGACY instance of product collection js.
 */
export function hasLegacyInstance() {
  return typeof window === 'object' && window.ProductCollectionFilter__Instance && window.ProductCollectionFilter__Instance.update;
}

/**
 * Ugly necessity to convert into legacy filter/sorting mechanism
 * @param  {Object} updatedFilters (state)
 */
export function updateExternalLegacyFilters(updatedFilters) {
  const legacyFilterSorts = convertIntoLegacyFilters(updatedFilters);
  if (hasLegacyInstance()) {
    window.ProductCollectionFilter__Instance.update(legacyFilterSorts);
  }
}

/**
 * Builds white-listed filter sorting hydrated props from url
 * @return {Object} props
 */
export function buildWhiteListedFilterSortProps() {
  if (typeof window === 'object' && typeof window.CollectionFilterData === 'object') {
    // Converting legacy filtering from url
    let filterSorts = {};
    const queryObj = decodeQueryParams();

    // Whitelisting query params for hydration
    if (queryObj.order) {
      filterSorts.order = queryObj.order;
    }
    if (queryObj.fast_making) {
      filterSorts.fastMaking = true;
    }
    if (queryObj.price_min && queryObj.price_max) {
      filterSorts.selectedPrices = convertURLPrices(queryObj.price_max);
    }
    // Array options
    if (queryObj.bodyshape) {
      filterSorts.selectedShapes = Array.isArray(queryObj.bodyshape)
        ? queryObj.bodyshape
        : [queryObj.bodyshape,];
    }
    if (queryObj.style) {
      filterSorts.selectedStyles = Array.isArray(queryObj.style)
        ? queryObj.style
        : [queryObj.style,];
    }
    if (queryObj.color_group) {
      filterSorts.selectedColors = Array.isArray(queryObj.color_group)
        ? queryObj.color_group
        : [queryObj.color_group,];
    }
    return assign({}, window.CollectionFilterData, filterSorts);
  }

  return {};
}

/**
 * Converts store/state into white-listed legacy filter object for consumption by legacy AJAX
 * @param  {Object} updateFilters (state)
 * @return {Object} legacyFilterSorts
 */
function convertIntoLegacyFilters({
  fastMaking,
  order,
  selectedColors,
  selectedShapes,
  selectedStyles,
  selectedPrices,
  $$bodyShapes,
  $$bodyStyles,
  $$colors,
}) {
  const mainFilters = {
    style: selectedStyles.length === $$bodyStyles.length
      ? []
      : selectedStyles,
    bodyshape: selectedShapes.length === $$bodyShapes.length
      ? []
      : selectedShapes,
    color_group: selectedColors.length === $$colors.length
      ? []
      : selectedColors,
    fast_making: fastMaking
      ? [true,]
      : undefined,
    order,
    q: getUrlParameter('q').replace(/\+/g, " "),
  };

  if (selectedPrices.length !== PRICES.length) {
    let getPrice = (price, index) => find(PRICES, {id: price,}).range[index];

    return assign({}, mainFilters, {
      price_min: selectedPrices.map(p => getPrice(p, 0)),
      price_max: selectedPrices.map(p => getPrice(p, 1)),
    });
  } else {
    return mainFilters;
  }
}

/**
 * Converts Pricing URL to digestable prices for app
 * @param  {Array}  [priceMax=[]] [description]
 * @return {[type]}               [description]
 */
function convertURLPrices(priceMax = []) {
  let prices = [];
  if (priceMax.indexOf('199') > -1) {
    prices.push(CollectionFilterSortConstants.PRICES[0].id);
  }
  if (priceMax.indexOf('299') > -1) {
    prices.push(CollectionFilterSortConstants.PRICES[1].id);
  }
  if (priceMax.indexOf('399') > -1) {
    prices.push(CollectionFilterSortConstants.PRICES[2].id);
  }
  return prices;
}
