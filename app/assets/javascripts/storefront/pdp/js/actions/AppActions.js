import AppConstants from '../constants/AppConstants';

export function activateSideMenu({ sideMenuOpen }) {
  return {
    type: AppConstants.ACTIVATE_SIDE_MENU,
    sideMenuOpen,
  };
}

export function setShareableQueryParams({ color, customizations }) {
  return {
    type: AppConstants.SET_SHAREABLE_QUERY_PARAMS,
    color,
    customizations,
  };
}

export default {
  activateSideMenu,
  setShareableQueryParams,
};
