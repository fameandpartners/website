export function customizeReducer(state = {}, action) {
  switch (action.type) {
    case 'CUSTOMIZE_DRESS':
      return Object.assign({}, state, action.customize);
    case 'CUSTOMIZE_MAKING_OPTION':
      return Object.assign({}, state, action.customize);
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
