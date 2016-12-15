import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';

export function setSelectedColors(selectedColors) {
  return {
    type: CollectionFilterSortConstants.SET_SELECTED_COLORS,
    selectedColors,
  };
}
export function setSelectedPrices(selectedPrices) {
  return {
    type: CollectionFilterSortConstants.SET_SELECTED_PRICES,
    selectedPrices,
  };
}
