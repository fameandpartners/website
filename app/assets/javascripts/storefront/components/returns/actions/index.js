import axios from 'axios';
import setReturnWindow from '../../../libs/setReturnWindow';
import { assign } from 'lodash';

export const addProductToReturnArray = (product, currentArray) => {
  product.openEndedReturnReason = '';
  currentArray.push(product);
  let refundAmount = 0;
  refundAmount = currentArray.reduce((sum, returnedProduct) =>
    sum + Number(returnedProduct.price), 0);
  const productID = product.id;
  return {
    type: 'ADD_PRODUCT_TO_RETURN_ARRAY',
    payload: {
      returnArray: currentArray,
      returnSubtotal: refundAmount,
      productID,
    },
  };
};

export const removeProductFromReturnArray = (product, currentArray, refundAmount) => {
  let newReturnArray = [];
  let newRefundAmount = refundAmount;
  currentArray.filter((p) => {
    if (p.id === product.id) {
      newRefundAmount -= p.price;
    } else {
      newReturnArray.push(p);
    }
    return true;
  });
  newReturnArray = [...new Set(newReturnArray)];
  return {
    type: 'REMOVE_PRODUCT_FROM_RETURN_ARRAY',
    payload: {
      returnArray: newReturnArray,
      returnSubtotal: newRefundAmount,
    },
  };
};

export const updatePrimaryReturnReason = (reason, product, returnArray) => {
  const newReturnArray = returnArray.map((p) => {
    if (p.id === product.id) {
      p.primaryReturnReason = reason.option.id;
      return p;
    }
    return p;
  });
  return {
    type: 'UPDATE_PRIMARY_RETURN_REASON',
    payload: newReturnArray,
  };
};

export const updateOpenEndedReturnReason = (reason, product, returnArray) => {
  const newReturnArray = returnArray.map((p) => {
    if (p.id === product.id) {
      p.openEndedReturnReason = reason;
      return p;
    }
    return p;
  });
  const productID = product.id;
  return {
    type: 'UPDATE_OPEN_ENDED_RETURN_REASON',
    payload: {
      returnArray: newReturnArray,
      productID,
    },
  };
};

export const getProductData = () => (dispatch) => {
  axios.get('/api/v1/orders')
    .then((response) => {
      console.log('response', response);
      dispatch({ type: 'UPDATE_ORDER_DATA', payload: response.data.returns_processes });
    })
    .catch((error) => {
      console.log(error);
    });
};

export const submitReturnRequest = ({ order, returnsObj }) => (dispatch) => {
  axios.post('/api/v1/submit_return', returnsObj)
    .then((response) => {
      // TODO: dispatch(Stop Loading Event)
      dispatch({ type: 'POPULATE_LOGISTICS_DATA',
        payload: {
          order,
          line_items: response.data.message,
        } });
    })
    .catch((error) => {
      console.log(error);
    });
};

export const populateLogisticsData = ({ order, lineItems }) => {
  console.log('popu', order);
  console.log('popu', lineItems);
  return {
    type: 'POPULATE_LOGISTICS_DATA',
    payload: {
      order,
      lineItems,
    },
  };
};
