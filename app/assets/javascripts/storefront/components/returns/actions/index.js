const csrfToken = document.querySelector('meta[name="csrf-token"]') ? document.querySelector('meta[name="csrf-token"]').content : '';
const contentType = 'application/json';

const request = require('superagent');

export const addProductToReturnArray = (product, currentArray) => {
  const newProduct = product;
  const newArray = currentArray.slice(0);
  newProduct.openEndedReturnReason = '';
  newArray.push(newProduct);
  let refundAmount = 0;
  refundAmount = newArray.reduce((sum, returnedProduct) =>
    sum + Number(returnedProduct.price), 0);
  const productID = product.id;
  return {
    type: 'ADD_PRODUCT_TO_RETURN_ARRAY',
    payload: {
      returnArray: newArray,
      returnSubtotal: refundAmount,
      productID,
    },
  };
};

export const removeProductFromReturnArray = (product, currentArray, refundAmount) => {
  const newReturnArray = [];
  let newRefundAmount = refundAmount;
  currentArray.filter((p) => {
    if (p.id === product.id) {
      newRefundAmount -= p.price;
    } else {
      newReturnArray.push(p);
    }
    return true;
  });
  return {
    type: 'REMOVE_PRODUCT_FROM_RETURN_ARRAY',
    payload: {
      returnArray: newReturnArray,
      returnSubtotal: newRefundAmount,
    },
  };
};

export const setReturnLoadingState = ({ isLoading }) => ({
  type: 'SET_RETURN_LOADING_STATE',
  payload: { isLoading },
});

export const setReturnReasonErrors = ({ returnRequestErrors }) => ({
  type: 'SET_RETURN_REASON_ERRORS',
  payload: { returnRequestErrors },
});

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
    payload: { newReturnArray, productID: product.id },
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

export const getProductData = (guestReturn, email, orderID) => (dispatch) => {
  if (guestReturn) {
    request
      .get(`/api/v1/guest/order?email=${email}&order_number=${orderID}`)
      .end((err, res) => {
        if (err) {
          console.log(err);
        } else {
          console.log(res);
          const response = JSON.parse(res.text);
          const guestOrderArray = [response.returns_processes];
          dispatch({ type: 'UPDATE_ORDER_DATA', payload: guestOrderArray });
        }
      });
  } else {
    request
      .get('/api/v1/orders')
      .end((err, res) => {
        if (err) {
          console.log('ERROR getting order data', err);
        } else {
          const response = JSON.parse(res.text);
          console.log(response);
          dispatch({ type: 'UPDATE_ORDER_DATA', payload: response.returns_processes });
        }
      });
  }
};


export const submitReturnRequest = ({ order, returnsObj, guestEmail }) => (dispatch) => {
  console.log(csrfToken);
  console.log(contentType);
  request
    .post('/api/v1/submit_return')
    .send(returnsObj)
    .set('Accept', contentType)
    .set('X-CSRF-Token', csrfToken)
    .end((err, res) => {
      if (err) {
        console.log(err);
        dispatch(setReturnLoadingState({ isLoading: false }));
        if (err.response && err.response.data) {
          dispatch({
            type: 'SET_RETURN_RESPONSE_ERRORS',
            payload: { error: err.response.data },
          });
        }
      } else {
        console.log(res);
        const response = JSON.parse(res.text);
        dispatch(setReturnLoadingState({ isLoading: false }));
        dispatch({ type: 'POPULATE_LOGISTICS_DATA',
          payload: {
            requiresViewOrdersRefresh: true,
            order,
            line_items: response.message,
            guestEmail,
          },
        });
      }
    });
};

export const setGuestEmail = guestEmail => ({
  type: 'SET_GUEST_EMAIL',
  payload: guestEmail,
});

export const populateLogisticsData = ({ order, lineItems }) => ({
  type: 'POPULATE_LOGISTICS_DATA',
  payload: {
    order,
    line_items: lineItems,
  },
});
