import _ from 'lodash'

export function getOrderArray(products) {
	const grouped = _.groupBy(products, p => p.trackingNumber);
	let trackingNumberArray = Object.keys(grouped)
	let orderArray = []
	for (var i = trackingNumberArray.length - 1; i >= 0; i--) {
	  orderArray.push(grouped[trackingNumberArray[i]])
	}
	return orderArray
}