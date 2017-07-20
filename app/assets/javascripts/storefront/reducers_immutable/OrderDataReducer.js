let localDataObject = {
    shipDate: '05/13/2017',
    orderPlaced: '7/27/2017',
    orderID: 'R457401873',
    products: [
      {
        productName: 'The Carlotta Dress',
        usSize: '6',
        auSize: '10',
        color: 'White and black pinstripe',
        height: '5ft 6in',
        price: 229,
        image: 'http://placehold.it/180x180?text=Carlotta',
        customProduct: false,
        returnWindowEnd: '6/26/2017',
        orderPlaced: '7/27/2017',
        trackingNumber: '123',
        productOrderID: 342,
        primaryReturnReason: "DELIVERY_ISSUES",
      },
      {
        productName: 'The Tania Dress',
        usSize: '6',
        auSize: '10',
        color: 'Red',
        height: '5ft 6in',
        price: 199,
        image: 'http://placehold.it/180x180?text=Tania',
        customProduct: false,
        returnWindowEnd: '5/28/2017',
        orderPlaced: '5/27/2017',
        trackingNumber: '123',
        productOrderID: 502,
        primaryReturnReason: "DELIVERY_ISSUES",
      },
      {
        productName: 'The Cohen Shirt',
        usSize: '6',
        auSize: '10',
        color: 'Red',
        height: '5ft 6in',
        price: 99,
        image: 'http://placehold.it/180x180?text=Cohen',
        customProduct: true,
        returnWindowEnd: '6/24/2017',
        orderPlaced: '7/27/2017',
        trackingNumber: '123',
        productOrderID: 999,
        primaryReturnReason: "DELIVERY_ISSUES",
      },
      {
        productName: 'The Torrance Dress',
        usSize: '6',
        auSize: '10',
        color: 'Red',
        height: '5ft 6in',
        price: 99,
        image: 'http://placehold.it/180x180?text=Cohen',
        customProduct: false,
        returnWindowEnd: '6/28/2017',
        orderPlaced: '7/27/2017',
        trackingNumber: '456',
        productOrderID: 231,
        primaryReturnReason: "DELIVERY_ISSUES",
      }
    ]
}
export default function(state = localDataObject, action) {
    switch (action.type) {
        case 'UPDATE_ORDER_DATA':
        	return action.payload
        default:
            return state
    }
}
