import _ from 'lodash'

export default function getOrderArray(items) {
	const grouped = _.groupBy(items, p => p.trackingNumber);
	let trackingNumberArray = Object.keys(grouped)
	let orderArray = []
	trackingNumberArray.map(i => orderArray.push(grouped[trackingNumberArray[i]]))
	return orderArray 
}
