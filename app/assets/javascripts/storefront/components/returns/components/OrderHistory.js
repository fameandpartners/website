import React, { Component, PropTypes } from 'react';
import ProductContainer from '../containers/ProductContainer';

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
    const cleanItems = items.map(i => i.line_item);
    this.state = {
      orderData,
      orderArray: cleanItems,
    };
  }
  render() {
    const { orderData, orderArray } = this.state;
    const { spree_order: spreeOrder } = orderData;
    const {
      date_iso_mdy: dateIsoMdy,
      number,
      return_eligible: returnEligible,
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
              <a href={`/orders/${number}`}>
                <span className="order-id font-sans-serif">
                  Order #{number}
                </span>
              </a>
              <div className="Product__listItem__container u-margin-top-small">
                {
                  returnRequestedArray.map((o, i) => {
                    const internationalCustomer = orderData.spree_order.international_customer;
                    const { id } = o;
                    return (
                      <div key={id}>
                        <ProductContainer
                          key={id}
                          product={o}
                          internationalCustomer={internationalCustomer}
                          orderData={orderData}
                          orderIndex={i}
                          showForm={false}
                          orderNumber={number}
                          returnRequested
                          returnEligible={returnEligible}
                          lastChild={i === (returnRequestedArray.length - 1)}
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
                    const internationalCustomer = orderData.spree_order.international_customer;
                    const { id } = o;
                    return (
                      <div key={id}>
                        <ProductContainer
                          key={id}
                          product={o}
                          internationalCustomer={internationalCustomer}
                          orderData={orderData}
                          orderIndex={i}
                          showForm={false}
                          returnEligible={returnEligible}
                          returnRequested={false}
                          orderNumber={number}
                          lastChild={i === (notRequestedArray.length - 1)}
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
