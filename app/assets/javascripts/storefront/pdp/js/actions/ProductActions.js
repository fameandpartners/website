import CustomizationConstants from '../constants/CustomizationConstants';

export function activateColorDrawer({ isActive }) {
  return {
    type: CustomizationConstants.ACTIVATE_COLOR_DRAWER,
    isActive,
  };
}

export default {
  activateColorDrawer,
};
