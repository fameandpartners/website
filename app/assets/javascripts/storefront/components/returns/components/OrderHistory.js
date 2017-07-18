import React, {Component} from 'react';
import ReturnNavigation from './ReturnNavigation'
import ProductContainer from '../containers/ProductContainer.js'

class OrderHistory extends Component {
  constructor(props) {
    super(props)
    const {orderData, orderArray} = this.props
    this.state = {
        orderData: orderData,
        orderArray: orderArray
    }
  }
  render() {
    const {orderData, orderArray} = this.state
    const {shipDate, orderPlaced, orderID} = orderData
    return (
        <div>
          <div className="grid-noGutter">
              <div className="col-2_md-12">
                  <ReturnNavigation />
              </div>
              <div className="col-9_md-12 u-no-padding-right">
                  <div className="Order__Container">
                      <p className="order-placed">
                        Placed on {orderPlaced}
                      </p>
                      <p className="order-id">
                        Order #{orderID}
                      </p>
                      <div className="Product__listItem__container">
                        <p className="ship-date">Shipped {shipDate}</p>
                        {
                         orderArray.map(order => {
                            return (
                              order.map(function(o, i){
                                const showHR = order.length === Number(i + 1)
                                const {productOrderID} = o
                                return (
                                  <div>
                                    <ProductContainer 
                                      key={productOrderID} 
                                      product={o} 
                                      orderIndex={i}
                                      showForm={false}
                                    />
                                    <hr className={!showHR ? "u-hide" : "u-show"}/>
                                  </div>
                                )
                              })
                            )
                          })
                        }
                      </div>
                  </div>
              </div>              
          </div>
        </div>
    );
  }
}

export default OrderHistory;