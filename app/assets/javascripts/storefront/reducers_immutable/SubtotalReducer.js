export default function(state = 0, action) {
    switch (action.type) {
        case 'ADD_PRODUCT_TO_RETURN_ARRAY':
        	return action.payload.returnSubtotal
        case 'REMOVE_PRODUCT_FROM_RETURN_ARRAY':
        	return action.payload.returnSubtotal
        default:
            return state
    }
}
