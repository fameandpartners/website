import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';

export function clearAllCollectionFilterSorts() {
  return {
    type: CollectionFilterSortConstants.CLEAR_ALL_COLLECTION_FILTER_SORTS,
  };
}
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
export function setSelectedShapes(selectedShapes) {
  return {
    type: CollectionFilterSortConstants.SET_SELECTED_SHAPES,
    selectedShapes,
  };
}
