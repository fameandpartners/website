import React, { Component, PropTypes } from 'react';
import ProductContainer from '../containers/ProductContainer';
import getOrderArray from '../../../libs/getOrderArray';

const propTypes = {
  orderData: PropTypes.object,
};

const defaultProps = {
  orderData: {},
};

class OrderHistory extends Component {
  constructor(props) {
    super(props);
    const { orderData } = this.props;
    const { items } = orderData;
    this.state = {
      orderData,
      orderArray: getOrderArray(items),
    };
  }
  render() {
    const { orderData, orderArray } = this.state;
    const { shipDate, orderPlaced, number } = orderData;
    return (
      <div>
        <div className="grid-noGutter-center">
          <div className="col-9_md-12 u-no-padding-right">
            <div className="order__container">
              <p className="order-placed">
                Placed on {orderPlaced}
              </p>
              <p className="order-id">
                Order #{number}
              </p>
              <div className="Product__listItem__container">
                <p className="ship-date">Shipped {shipDate}</p>
                {
                 orderArray.map(order => {
                   return (
                    order.map(function(o, i){
                      const showHR = order.length === Number(i + 1);
                      const { id } = o;
                      return (
                        <div>
                          <ProductContainer
                            key={id}
                            product={o}
                            orderIndex={i}
                            showForm={false}
                            orderNumber={number}
                          />
                          <hr className={!showHR ? 'u-hide' : 'u-show'} />
                        </div>
                      );
                    })
                   );
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

OrderHistory.propTypes = propTypes;
OrderHistory.defaultProps = defaultProps;

export default OrderHistory;
