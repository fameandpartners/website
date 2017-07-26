export default function(state = null, action) {
    switch (action.type) {
        case 'UPDATE_ORDER_DATA':
        	return action.payload
        default:
            return state
    }
}
