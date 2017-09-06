import { assign } from 'lodash';
import mirrorCreator from 'mirror-creator';

const actionTypes = assign({},
  mirrorCreator([
    'UPDATE_CUSTOMIZATION_STYLE_SELECTION',
    'SET_ACTIVE_ADDON_IMAGE_LAYERS',
    'SET_ADDON_BASE_LAYER',
  ]),
);
export default assign({}, actionTypes);
