import collect from 'collect.js'

export function getOrderArray(products) {
	const collection = collect(products);
	const grouped = collection.groupBy('trackingNumber');
	let trackingNumberArray = Object.keys(grouped.items)
	let orderArray = []
	for (var i = trackingNumberArray.length - 1; i >= 0; i--) {
	  orderArray.push(grouped.items[trackingNumberArray[i]])
	}
	return orderArray
}