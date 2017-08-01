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
    const cleanItems = [];
    items.map(i => cleanItems.push(i.line_item));
    this.state = {
      orderData,
      orderArray: cleanItems,
    };
  }
  render() {
    const { orderData, orderArray } = this.state;
    const { spree_order } = orderData;
    const { date_iso_mdy, number } = spree_order;
    return (
      <div>
        <div className="grid-noGutter-center-spaceAround">
          <div className="col-10_md-12 u-no-padding-right">
            <div className="order__container">
              <p className="order-placed u-margin-bottom-small">
                Placed on {date_iso_mdy}
              </p>
              <p className="order-id u-margin-bottom-small">
                Order #{number}
              </p>
              <div className="Product__listItem__container">
                {
                    orderArray.map((o, i) => {
                      const { id } = o;
                      return (
                        <div key={id}>
                          <div className="grid-noGutter-center">
                            <div className="col-11_md-9_sm-5_xs-9">
                              <p className={i === 0 ? 'u-show u-margin-bottom-none u-heavyFont u-margin-top-small ship-date' : 'u-hide'} >Shipped {date_iso_mdy}</p>
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
