import SlayConstants from '../constants/SlayItForwardConstants';

export const initialState = {
  hasScrolled: false
};

export default function slayItForwardReducer(state = initialState, action) {
  switch(action.type) {
    case SlayConstants.SLAY_HAS_SCROLLED:
      return Object.assign({}, state, action.customize);
    default:
      return state;
  }
}
