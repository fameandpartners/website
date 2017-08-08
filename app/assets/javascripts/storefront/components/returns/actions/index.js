import axios from 'axios';

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

export const getProductData = (guestReturn, email, orderID) => (dispatch) => {
  if (guestReturn) {
    axios.get(`/api/v1/guest/order?email=${email}&order_number=${orderID}`)
      .then((response) => {
        const guestOrderArray = [response.data];
        dispatch({ type: 'UPDATE_ORDER_DATA', payload: guestOrderArray });
      })
      .catch((error) => {
        console.log(error);
      });
  } else {
    axios.get('/api/v1/orders')
      .then((response) => {
        dispatch({ type: 'UPDATE_ORDER_DATA', payload: response.data.returns_processes });
      })
      .catch((error) => {
        console.log('ERROR getting order data', error);
        // window.location = '/guest-returns';
      });
  }
};


export const submitReturnRequest = ({ order, returnsObj, guestEmail }) => (dispatch) => {
  axios.post('/api/v1/submit_return', returnsObj)
    .then((response) => {
      dispatch(setReturnLoadingState({ isLoading: false }));
      dispatch({ type: 'POPULATE_LOGISTICS_DATA',
        payload: {
          requiresViewOrdersRefresh: true,
          order,
          line_items: response.data.message,
          guestEmail,
        },
      });
    })
    .catch((error) => {
      dispatch(setReturnLoadingState({ isLoading: false }));
      dispatch({
        type: 'SET_RETURN_RESPONSE_ERRORS',
        payload: { error },
      });
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
