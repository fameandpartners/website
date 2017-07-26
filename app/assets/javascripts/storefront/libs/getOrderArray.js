import _ from 'lodash'

export function getOrderArray(items) {
	const grouped = _.groupBy(items, p => p.trackingNumber);
	let trackingNumberArray = Object.keys(grouped)
	let orderArray = []
	for (var i = trackingNumberArray.length - 1; i >= 0; i--) {
	  orderArray.push(grouped[trackingNumberArray[i]])
	}
	return orderArray
}