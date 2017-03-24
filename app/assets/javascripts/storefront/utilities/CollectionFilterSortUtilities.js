import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';
import assign from 'object-assign';
import _find from 'lodash/find';
import {getUrlParameter,} from '../helpers/BOM';
const {PRICES,} = CollectionFilterSortConstants;

export function convertURLPrices(priceMax = []){
  let prices = [];
  if (priceMax.indexOf('199') > -1){ prices.push(CollectionFilterSortConstants.PRICES[0].id); }
  if (priceMax.indexOf('299') > -1){ prices.push(CollectionFilterSortConstants.PRICES[1].id); }
  if (priceMax.indexOf('399') > -1){ prices.push(CollectionFilterSortConstants.PRICES[2].id); }
  return prices;
}

/**
 * UGLY necessity
 * Converts props into legacy filter object for consumption by legacy AJAX
 * @param  {Object} props
 * @return {Object}
 */
export function convertPropsIntoLegacyFilter(
  {fastMaking, order, selectedColors, selectedShapes, selectedStyles, selectedPrices,},
  {$$bodyShapes, $$bodyStyles, $$colors,})
{
  const mainFilters = {
    style: selectedStyles.length === $$bodyStyles.toJS().length ? [] : selectedStyles,
    bodyshape: selectedShapes.length === $$bodyShapes.toJS().length ? [] : selectedShapes,
    color_group: selectedColors.length === $$colors.length ? [] : selectedColors,
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
