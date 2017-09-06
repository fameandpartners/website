import CustomizationConstants from '../constants/CustomizationConstants';

export function activateCustomizationDrawer({ isActive = true, productCustomizationDrawer }) {
  return {
    type: CustomizationConstants.ACTIVATE_CUSTOMIZATION_DRAWER,
    isActive,
    productCustomizationDrawer,
  };
}

export function changeCustomizationDrawer({ productCustomizationDrawer }) {
  return {
    type: CustomizationConstants.CHANGE_CUSTOMIZATION_DRAWER,
    productCustomizationDrawer,
  };
}

export function selectProductColor({ selectedColor, temporaryColor }) {
  return {
    type: CustomizationConstants.SELECT_PRODUCT_COLOR,
    selectedColor,
    temporaryColor,
  };
}

export function updateMeasurementMetric({ selectedMeasurementMetric, temporaryMeasurementMetric }) {
  return {
    type: CustomizationConstants.UPDATE_MEASUREMENT_METRIC,
    selectedMeasurementMetric,
    temporaryMeasurementMetric,
  };
}

export function updateHeightSelection({
  temporaryHeightValue,
  selectedHeightValue,
}) {
  return {
    type: CustomizationConstants.UPDATE_HEIGHT_SELECTION,
    selectedHeightValue,
    temporaryHeightValue,
  };
}

export function updateDressSizeSelection({ temporaryDressSize, selectedDressSize }) {
  return {
    type: CustomizationConstants.UPDATE_DRESS_SIZE_SELECTION,
    selectedDressSize,
    temporaryDressSize,
  };
}

export function updateCustomizationStyleSelection({
  temporaryStyleCustomizations,
  selectedStyleCustomizations,
}) {
  return {
    type: CustomizationConstants.UPDATE_CUSTOMIZATION_STYLE_SELECTION,
    selectedStyleCustomizations,
    temporaryStyleCustomizations,
  };
}

export function setActiveAddonImageLayers(addonImageLayers) {
  return { type: CustomizationConstants.SET_ACTIVE_ADDON_IMAGE_LAYERS, addonImageLayers };
}

export function setAddonBaseLayer(baseSelected) {
  return { type: CustomizationConstants.SET_ADDON_BASE_LAYER, baseSelected };
}

export default {
  activateCustomizationDrawer,
  changeCustomizationDrawer,
  selectProductColor,
  updateCustomizationStyleSelection,
  setActiveAddonImageLayers,
  setAddonBaseLayer,
  updateMeasurementMetric,
  updateHeightSelection,
  updateDressSizeSelection,
};
