export const addProductToReturnArray = (product, currentArray) => {
	console.log("PRODUCT", product)
	product['openEndedReturnReason'] = ''
	currentArray.push(product)
	// Remove duplicates
	const newReturnArray = [...new Set(currentArray)]
	// Calculate Return Total
	let refundAmount = 0
	refundAmount = newReturnArray.reduce(function(sum, product) {
	  return sum + product.price;	  
	}, 0);
	const productID = product.productOrderID
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
		if(p.productOrderID === product.productOrderID) {
			newRefundAmount = newRefundAmount - p.price
		}
		else {
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
		if(p.productOrderID === product.productOrderID) {
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

export const updateSecondaryReturnReason = (reason, product, returnArray) => {
	const newReturnArray = returnArray.map(p => {
		if(p.productOrderID === product.productOrderID) {
			p.secondaryReturnReason = reason
			return p
		}
		return p
	})
	return {
		type: 'UPDATE_SECONDARY_RETURN_REASON',
		payload: newReturnArray
	}
};
export const updateOpenEndedReturnReason = (reason, product, returnArray) => {
	const newReturnArray = returnArray.map(p => {
		if(p.productOrderID === product.productOrderID) {
			p.openEndedReturnReason = reason
			return p
		}
		return p
	})
	const productID = product.productOrderID
	return {
		type: 'UPDATE_OPEN_ENDED_RETURN_REASON',
		payload: {
			returnArray: newReturnArray,
			productID: productID
		}
	}
};
