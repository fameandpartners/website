/* eslint-disable */
import React from 'react';
import ProductContainer from '../containers/ProductContainer';

// const propTypes = {
//   orderData: PropTypes.object,
// };

const defaultProps = {
  orderData: {},
};

class OrderHistory extends React.Component {
  constructor(props) {
    super(props);
    const { orderData } = this.props;
    const { items } = orderData;
    let cleanItems = items.map(i => i.line_item);
    cleanItems = cleanItems.filter(i => i.products_meta.name !== 'RETURN_INSURANCE');
    this.state = {
      orderData,
      orderArray: cleanItems,
    };
  }
  render() {
    const { orderData, orderArray } = this.state;
    const { order: spreeOrder } = orderData;
    const {
      number,
      return_eligible: returnEligible,
    } = spreeOrder;

    const dateIsoMdy = new Date(spreeOrder.created_at).toLocaleDateString();

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
                    const internationalCustomer = spreeOrder.ship_address.country !== 'United States';
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
                    const internationalCustomer = spreeOrder.ship_address.country !== 'United States';
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

// OrderHistory.propTypes = propTypes;
OrderHistory.defaultProps = defaultProps;

export default OrderHistory;
