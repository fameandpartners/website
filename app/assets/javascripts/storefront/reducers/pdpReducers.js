import { assign } from 'lodash';

export function addonsReducer(state = {}, action) {
  switch (action.type) {
    case 'SET_ADDON_OPTIONS':
      return assign({}, state, { addonOptions: action.addonOptions });
    case 'SET_ADDON_BASE_LAYER':
      return assign({}, state, { baseSelected: action.baseSelected });
    default:
      return state;
  }
}

export function customizeReducer(state = {}, action) {
  switch (action.type) {
    case 'CUSTOMIZE_DRESS':
      return assign({}, state, action.customize);
    case 'CUSTOMIZE_MAKING_OPTION':
      return assign({}, state, action.customize);
    case 'TOGGLE_PDP_DRAWER':
      return assign({}, state, { drawerOpen: action.drawerName });
    case 'ADD_TO_BAG_PENDING':
      return assign({}, state, { addToBagPending: action.addToBagPending });
    default:
      return state;
  }
}

export function productReducer(state = {}, action) {
  return state;
}

export function imagesReducer(state = {}, action) {
  return state;
}

export function sizeChartReducer(state = {}, action) {
  return state;
}

export function discountReducer(state = {}, action) {
  return state;
}

export function productPathsReducer(state = {}, action) {
  return state;
}

export function lengthReducer(state = {}, action) {
  return state;
}

export function skirtChartReducer(state = {}, action) {
  return state;
}

export function siteVersionReducer(state = {}, action) {
  return state;
}

export function flagsReducer(state = {}, action) {
  return state;
}
