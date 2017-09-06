import { assign } from 'lodash';
import mirrorCreator from 'mirror-creator';

const actionTypes = assign({},
  mirrorCreator([
    'SIZE_GUIDE',
    'MEASURING_TIPS',
  ]),
);

export default actionTypes;
