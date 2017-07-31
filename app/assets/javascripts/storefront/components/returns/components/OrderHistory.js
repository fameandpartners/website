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
        <div className="grid-noGutter-center-spaceAround">
          <div className="col-10_md-12 u-no-padding-right">
            <div className="order__container">
              <p className="order-placed u-margin-bottom-small">
                Placed on {orderPlaced}
              </p>
              <p className="order-id u-margin-bottom-small">
                Order #{number}
              </p>
              <div className="Product__listItem__container">
                {
                 orderArray.map(order => (
                    order.map((o, i) => {
                      const { id } = o;
                      return (
                        <div>
                          <div className="grid-noGutter-center">
                            <div className="col-11_md-9_sm-5_xs-9">
                              <p className={i === 0 ? 'u-show u-margin-bottom-none u-heavyFont u-margin-top-small' : 'u-hide'} >Shipped {shipDate}</p>
                            </div>
                          </div>
                          <ProductContainer
                            key={id}
                            product={o}
                            orderIndex={i}
                            showForm={false}
                            orderNumber={number}
                          />
                        </div>
                      );
                    })
                   ))
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
