import CollectionFilterSortConstants from '../constants/CollectionFilterSortConstants';

export function setSelectedColors(selectedColors, dispatch) {
  return {
    type: CollectionFilterSortConstants.SET_SELECTED_COLORS,
    selectedColors
  };
}
