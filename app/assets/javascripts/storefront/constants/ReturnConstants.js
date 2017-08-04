import { assign } from 'lodash';
// import mirrorCreator from 'mirror-creator';

const returnRoutes = {
  HOME: '/',
  ORDERS: '/view-orders',
  CONFIRMATION: '/return-confirmation',
};

const constants = assign({}, { RETURN_ROUTES: returnRoutes });

export default constants;
