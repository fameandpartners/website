import axios from 'axios'

export const addProductToReturnArray = (product, currentArray) => {
  product['openEndedReturnReason'] = ''
  currentArray.push(product)
  const newReturnArray = [...new Set(currentArray)]
  let refundAmount = 0
  refundAmount = newReturnArray.reduce(function(sum, returnedProduct) {
    return sum + Number(returnedProduct.price);
  }, 0);
  const productID = product.id
  return {
    type: 'ADD_PRODUCT_TO_RETURN_ARRAY',
    payload: {
      returnArray: newReturnArray,
      returnSubtotal: refundAmount,
      productID: productID
    }
  }
};

export const removeProductFromReturnArray = (product, currentArray, refundAmount) => {
  let newReturnArray = []
  let newRefundAmount = refundAmount
  currentArray.filter(p => {
    if (p.id === product.id) {
      newRefundAmount = newRefundAmount - p.price
    } else {
      newReturnArray.push(p)
    }
    return true
  })
  newReturnArray = [...new Set(newReturnArray)]
  return {
    type: 'REMOVE_PRODUCT_FROM_RETURN_ARRAY',
    payload: {
      returnArray: newReturnArray,
      returnSubtotal: newRefundAmount
    }
  }
};

export const updatePrimaryReturnReason = (reason, product, returnArray) => {
  const newReturnArray = returnArray.map(p => {
    if (p.id === product.id) {
      p.primaryReturnReason = reason.option.id
      return p
    }
    return p
  })
  return {
    type: 'UPDATE_PRIMARY_RETURN_REASON',
    payload: newReturnArray
  }
};

export const updateOpenEndedReturnReason = (reason, product, returnArray) => {
  const newReturnArray = returnArray.map(p => {
    if (p.id === product.id) {
      p.openEndedReturnReason = reason
      return p
    }
    return p
  })
  const productID = product.id
  return {
    type: 'UPDATE_OPEN_ENDED_RETURN_REASON',
    payload: {
      returnArray: newReturnArray,
      productID: productID
    }
  }
};

export const getProductData = () => {
  return (dispatch) => {
    axios.get('https://85s0db362c.execute-api.us-west-2.amazonaws.com/dev')
      .then(function(response) {
        dispatch({ type: 'UPDATE_ORDER_DATA', payload: response.data })
      })
      .catch(function(error) {
        console.log(error)
      })
  }
}
