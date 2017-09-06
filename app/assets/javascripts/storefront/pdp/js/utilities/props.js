import { assign } from 'lodash';

function reassignProps(props, newProps) {
  return assign({}, props, newProps);
}

export default { reassignProps };
