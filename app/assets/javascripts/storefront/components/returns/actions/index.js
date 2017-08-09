const csrfToken = document.querySelector('meta[name="csrf-token"]') ? document.querySelector('meta[name="csrf-token"]').content : '';
const contentType = 'application/json';

$.ajaxSetup({
  headers: {
    'X-CSRF-Token': csrfToken,
  },
});

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
    $.ajax({
      url: `/api/v1/guest/order?email=${email}&order_number=${orderID}`,
      accepts: {
        'Content-Type': contentType,
      },
    })
    .success((res) => {
      console.log(res);

      const guestOrderArray = [res.returns_processes];
      dispatch({ type: 'UPDATE_ORDER_DATA', payload: guestOrderArray });
    })
    .error((err) => {
      console.log(err);
    });
  } else {
    $.ajax({
      url: '/api/v1/orders',
      accepts: {
        'Content-Type': contentType,
      },
    })
    .success((res) => {
      console.log(res);

      dispatch({ type: 'UPDATE_ORDER_DATA', payload: res.returns_processes });
    })
    .error((err) => {
      console.log(err);
    });
  }
};


export const submitReturnRequest = ({ order, returnsObj, guestEmail }) => (dispatch) => {
  console.log(csrfToken);
  console.log(contentType);
  $.ajax({
    url: '/api/v1/submit_return',
    dataType: 'script',
    accepts: {
      'Content-Type': contentType,
    },
    method: 'POST',
    data: returnsObj,
  })
  .success((res) => {
    console.log(res);


    dispatch(setReturnLoadingState({ isLoading: false }));
    dispatch({ type: 'POPULATE_LOGISTICS_DATA',
      payload: {
        requiresViewOrdersRefresh: true,
        order,
        line_items: res.message,
        guestEmail,
      },
    });
  })
  .error((err) => {
    console.log(err);

    dispatch(setReturnLoadingState({ isLoading: false }));
    if (err && err.responseText) {
      const error = JSON.parse(err.responseText);

      dispatch({
        type: 'SET_RETURN_RESPONSE_ERRORS',
        payload: { error },
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
