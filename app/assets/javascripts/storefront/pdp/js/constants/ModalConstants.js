import { assign } from 'lodash';
import mirrorCreator from 'mirror-creator';

const actionTypes = assign({},
  mirrorCreator([
    'ACTIVATE_MODAL',
  ]),
);

const modalIds = assign({},
  mirrorCreator([
    'COLOR_SELECTION_MODAL',
    'STYLE_SELECTION_MODAL',
    'SIZE_SELECTION_MODAL',
    'FABRIC_MODAL',
    'FORGOT_PASSWORD_MODAL',
    'LOG_IN_MODAL',
    'SHARE_MODAL',
    'SIGN_UP_MODAL',
    'SIZE_GUIDE_MODAL',
  ]),
);

export default assign(
  {},
  actionTypes,
  modalIds,
);
