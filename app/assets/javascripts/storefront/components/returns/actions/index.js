import { assign } from 'lodash';

/* global $, document */
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

export const clearReturnProductArray = () => ({
  type: 'CLEAR_PRODUCT_FROM_RETURN_ARRAY',
});

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

export const setHasRequestedOrders = ({ hasRequestedOrders }) => ({
  type: 'SET_HAS_REQUESTED_ORDERS',
  payload: { hasRequestedOrders },
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
    .done((res) => {
      const guestOrderArray = [res];
      dispatch({ type: 'UPDATE_ORDER_DATA', payload: guestOrderArray });
    })
    .fail((err) => {
      console.log(err);
    })
    .always(() => {
      dispatch(setReturnLoadingState({ isLoading: false }));
    });
  } else {
    $.ajax({
      url: '/api/v1/orders',
      accepts: {
        'Content-Type': contentType,
      },
    })
    .done((res) => {
      dispatch({ type: 'UPDATE_ORDER_DATA', payload: res.returns_processes });
    })
    .fail((err) => {
      console.log(err);
    })
    .always(() => {
      dispatch(setReturnLoadingState({ isLoading: false }));
    });
  }
};


export const submitReturnRequest = ({ order, returnsObj, guestEmail }) => (dispatch) => {
  const updatedReturnsObj = assign({}, returnsObj, {
    email: guestEmail,
  });

  $.ajax({
    url: '/api/v1/submit_return',
    dataType: 'json',
    accepts: {
      'Content-Type': contentType,
    },
    method: 'POST',
    data: updatedReturnsObj,
  })
  .done((res) => {
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
  .fail((err) => {
    dispatch(setReturnLoadingState({ isLoading: false }));
    if (err && err.responseText) {
      const error = JSON.parse(err.responseText);
      /* eslint-disable no-console */
      console.log(`Error Code: ${error.error_code}`);

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
