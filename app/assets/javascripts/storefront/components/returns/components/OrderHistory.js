import React, { Component, PropTypes } from 'react';
import moment from 'moment';
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
    getOrderArray(cleanItems);
    this.state = {
      orderData,
      orderArray: cleanItems,
    };
  }
  render() {
    const { orderData, orderArray } = this.state;
    const { spree_order: spreeOrder } = orderData;
    const {
      projected_delivery_date: projectedDeliveryDate,
      date_iso_mdy: dateIsoMdy,
      number,
    } = spreeOrder;

    const notRequestedArray = orderArray.filter(i => !i.returns_meta);
    const returnRequestedArray = orderArray.filter(i => i.returns_meta);

    return (
      <div>
        <div className="grid-noGutter-center-spaceAround">
          <div className="col-10_md-12 u-no-padding">
            <div className="order__container">
              <p className="order-placed u-margin-bottom-small font-sans-serif">
                Order placed on {dateIsoMdy}
              </p>
              <p className="order-id u-margin-bottom-small font-sans-serif">
                Order #{number}
              </p>
              <div className="Product__listItem__container">
                {
                  returnRequestedArray.map((o, i) => {
                    const { id } = o;
                    return (
                      <div key={id}>

                        { i === 0 ?
                          <p className="u-heavyFont ship-date font-sans-serif">
                                Expected Delivery on {moment(projectedDeliveryDate).calendar()}
                          </p>
                          :
                          null
                        }
                        <ProductContainer
                          key={id}
                          product={o}
                          orderData={orderData}
                          orderIndex={i}
                          showForm={false}
                          orderNumber={number}
                          returnEligible={false}
                        />
                        { (i === returnRequestedArray.length - 1
                          && orderArray.length > returnRequestedArray.length) ?
                            <hr />
                          : null
                        }
                      </div>
                    );
                  })
                }
                {
                  notRequestedArray.map((o, i) => {
                    const { id } = o;
                    return (
                      <div key={id}>
                        { i === 0 ?
                          <p className="u-heavyFont ship-date font-sans-serif">
                              Expected Delivery on {moment(projectedDeliveryDate).calendar()}
                          </p>
                        :
                        null
                      }
                        <ProductContainer
                          key={id}
                          product={o}
                          orderData={orderData}
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
