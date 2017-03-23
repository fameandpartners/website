import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';
export function convertURLPrices(priceMax = []){
  let prices = [];
  if (priceMax.indexOf('199') > -1){ prices.push(CollectionFilterSortConstants.PRICES[0].id); }
  if (priceMax.indexOf('299') > -1){ prices.push(CollectionFilterSortConstants.PRICES[1].id); }
  if (priceMax.indexOf('399') > -1){ prices.push(CollectionFilterSortConstants.PRICES[2].id); }
  return prices;
}
