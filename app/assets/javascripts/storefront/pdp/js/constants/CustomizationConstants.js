import { assign } from 'lodash';
import mirrorCreator from 'mirror-creator';

const actionTypes = assign({},
  mirrorCreator([
    'ACTIVATE_COLOR_DRAWER',
    'ACTIVATE_CUSTOMIZATION_DRAWER',
    'CHANGE_CUSTOMIZATION_DRAWER',
    'SELECT_PRODUCT_COLOR',
    'UPDATE_CUSTOMIZATION_STYLE_SELECTION',
    'SET_ACTIVE_ADDON_IMAGE_LAYERS',
    'SET_ADDON_BASE_LAYER',
    'UPDATE_DRESS_SIZE_SELECTION',
    'UPDATE_MEASUREMENT_METRIC',
    'UPDATE_HEIGHT_SELECTION',
  ]),
);

const productCustomizationDrawers = assign({},
  mirrorCreator([
    'COLOR_CUSTOMIZE',
    'STYLE_CUSTOMIZE',
    'SIZE_CUSTOMIZE',
  ]),
);

const productCustomizationHeadlines = {
  COLOR_HEADLINE: 'Color',
  STYLE_HEADLINE: 'Design Customizations',
  SIZE_HEADLINE: 'Your Size',
};

export default assign({},
  actionTypes,
  productCustomizationDrawers,
  productCustomizationHeadlines,
);
