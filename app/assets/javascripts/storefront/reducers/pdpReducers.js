export function customizeReducer(state = {}, action) {
  switch(action.type) {
    case 'SELECT_SIZE':
      return Object.assign({}, state, action.customize);
    case 'SELECT_LENGTH':
      return Object.assign({}, state, action.customize);
    case 'SELECT_COLOR':
      return Object.assign({}, state, action.customize);
    default:
      return state;
  }
}

export function imageReducer(state = {}, action) {
  return state;
}

export function defaultColorReducer(state = {}, action) {
  return state;
}

export function customColorReducer(state = {}, action) {
  return state;
}

export function customColorPriceReducer(state = {}, action) {
  return state;
}

export function defaultSizesReducer(state = {}, action) {
  return state;
}

export function lengthReducer(state = {}, action) {
  return state;
}

export function sizeChartReducer(state = {}, action) {
  return state;
}

export function skirtChartReducer(state = {}, action) {
  return state;
}

export function preselectedColorReducer(state = {}, action) {
  return state;
}
