export default function(state = [], action) {
    switch (action.type) {
        case 'ADD_PRODUCT_TO_RETURN_ARRAY':
            return action.payload.returnArray
        case 'REMOVE_PRODUCT_FROM_RETURN_ARRAY':
            return action.payload.returnArray
        case 'UPDATE_PRIMARY_RETURN_REASON':
            return action.payload
        case 'UPDATE_OPEN_ENDED_RETURN_REASON':
            return action.payload.returnArray
        default:
            return state
    }
}
