import {assign,} from 'lodash';

const COLLECTION_EVENTS = assign({},
  { COLLECTION_COLOR_FILTER_OPEN: {
      category: "Category",
      action: "Filter Pane Open - Color",
    },

    COLLECTION_STYLE_FILTER_OPEN: {
      category: "Category",
      action: "Filter Pane Open - Style",
    },

    COLLECTION_PRICE_FILTER_OPEN: {
      category: "Category",
      action: "Filter Pane Open - Price",
    },

    COLLECTION_BODYSHAPE_FILTER_OPEN: {
      category: "Category",
      action: "Filter Pane Open - Bodyshape",
    },

    COLLECTION_FASTMAKING_FILTER_OPEN: {
      category: "Category",
      action: "Filter Pane Open - Fast Making",
    },

    COLLECTION_COLOR_FILTER_SELECTION: {
      category: "Category",
      action: "Filter Select - Color",
    },

    COLLECTION_STYLE_FILTER_SELECTION: {
      category: "Category",
      action: "Filter Select - Style",
    },

    COLLECTION_PRICE_FILTER_SELECTION: {
      category: "Category",
      action: "Filter Select - Price",
    },

    COLLECTION_BODYSHAPE_FILTER_SELECTION: {
      category: "Category",
      action: "Filter Select - Bodyshape",
    },

    COLLECTION_FASTMAKING_FILTER_SELECTION: {
      category: "Category",
      action: "Filter Select - Fast Making",
    },

    COLLECTION_SORT_SELECTION: {
      category: "Category",
      action: "Sort Select",
    },
  }
);

export default COLLECTION_EVENTS;
