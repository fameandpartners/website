import { assign } from 'lodash';
// import mirrorCreator from 'mirror-creator';

const returnRoutes = {
  HOME: '/',
  ORDERS: '/view-orders',
  CONFIRMATION: '/return-confirmation',
};

export default assign({}, { RETURN_ROUTES: returnRoutes });
