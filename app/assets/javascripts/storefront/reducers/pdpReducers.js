export function customizeReducer(state = {}, action) {
  switch(action.type) {
    case 'SELECT_SIZE':
      return Object.assign({}, state, action.customize);
    case 'SELECT_LENGTH':
      return Object.assign({}, state, action.customize);
    default:
      return state;
  }
}

export function imageReducer(state = {}, action) {
  return state;
}

export function colorReducer(state = {}, action) {
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
