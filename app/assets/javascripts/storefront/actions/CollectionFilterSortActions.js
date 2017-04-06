import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';

export function applyTemporaryFilters(temporaryFilters) {
  return {
    type: CollectionFilterSortConstants.APPLY_TEMPORARY_FILTERS,
    temporaryFilters,
  };
}
export function clearAllCollectionFilters() {
  return {
    type: CollectionFilterSortConstants.CLEAR_ALL_COLLECTION_FILTERS,
  };
}
export function setFastMaking(fastMaking) {
  return {
    type: CollectionFilterSortConstants.SET_FAST_MAKING,
    fastMaking,
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
export function setSelectedStyles(selectedStyles) {
  return {
    type: CollectionFilterSortConstants.SET_SELECTED_STYLES,
    selectedStyles,
  };
}
export function setTemporaryFilters(temporaryFilters) {
  return {
    type: CollectionFilterSortConstants.SET_TEMPORARY_FILTERS,
    temporaryFilters,
  };
}
export function orderProductsBy(order) {
  return {
    type: CollectionFilterSortConstants.ORDER_PRODUCTS_BY,
    order,
  };
}
export function updateExternalLegacyFilters(update) {
  return {
    type: CollectionFilterSortConstants.UPDATE_EXTERNAL_LEGACY_FILTERS,
    update,
  };
}
