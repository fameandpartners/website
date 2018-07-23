/* eslint-disable */
import React from 'react';
import { Link } from 'react-router';
import { maxBy } from 'lodash';
import autoBind from 'auto-bind';
import ProductContainer from '../containers/ProductContainer';
import SimpleButton from './SimpleButton';
import win from '../../../polyfills/windowPolyfill';

// const propTypes = {
//   orderData: PropTypes.array.isRequired,
//   logisticsData: PropTypes.shape({
//     final_return_by_date: PropTypes.string,
//     line_item_id: PropTypes.number,
//     item_return_label: PropTypes.shape({
//       carrier: PropTypes.string,
//       id: PropTypes.number,
//       label_image_url: PropTypes.string,
//       label_pdf_url: PropTypes.string,
//       label_url: PropTypes.string,
//       updated_at: PropTypes.string,
//     }),
//   }).isRequired,
// };


function extractLineItemFromOrders(orders, lineItemId) {
  let match = {};
  orders.forEach((o) => {
    o.items.forEach((li) => {
      if (li.line_item.id === Number(lineItemId)) {
        match = li.line_item;
      }
    });
  });
  return match;
}

function findOrderFromLineItem(orders, lineItemId) {
  let match = {};
  orders.forEach((o) => {
    o.items.forEach((li) => {
      if (li.line_item.id === Number(lineItemId)) {
        match = o.spree_order;
      }
    });
  });
  return match;
}

/* eslint-disable react/prefer-stateless-function */
class Confirmation extends React.PureComponent {
  constructor(props) {
    super(props);
    autoBind(this);
  }
  printPage() {
    win.print();
  }
  render() {
    const { logisticsData, orderData } = this.props;
    const latestLineItem = logisticsData.line_items[0];
    const currentOrder = findOrderFromLineItem(orderData, latestLineItem.line_item_id);
    const internationalCustomer = currentOrder.international_customer;
    const isAustralian = currentOrder.is_australian;
    return (
      <div className="instructions__container">
        <p className="orders-link-container hide-for-print">
          <Link to="/" className="orders-link">
            Back to Orders
          </Link>
        </p>
        <div className="instructions__body">
          <div className="instructions__header">
            <p className="headline font-sans-serif">
              {internationalCustomer
                ? <span>We have emailed you instructions.</span>
                : <span>We have emailed you a return label and shipping instructions.</span>
              }
              <br />
              Ship your return by {logisticsData.final_return_by_date}
            </p>
            { !internationalCustomer ?
              <ul className="label-list hide-for-print hide-for-mobile">
                <li>
                  <a
                    rel="noreferrer noopener"
                    target="_blank"
                    href={latestLineItem.item_return_label.label_url}
                  >
                    Print Label
                  </a>
                </li>
              </ul>
              : null
            }
          </div>
          <hr className="hide-for-mobile" />
          <div>
            {
              internationalCustomer ?
                <div className="Confirmation__text-box">
                  <h3 className="list-title font-sans-serif">Please mail your package to</h3>
                  { isAustralian ?
                    <p className="font-sans-serif">
                      Reply Paid: 86373 <br />
                      Fame and Partners – Returns <br />
                      C/O - Next Logistics <br />
                      Warehouse 1A, 35-47 Stennett Road <br />
                      Ingleburn, NSW 2565 <br />
                      Australia
                   </p>
                   :
                    <p className="font-sans-serif">
                      Fame and Partners – Returns <br />
                      C/O - Newgistics <br />
                      1200 Worldwide Boulevard <br />
                      Hebron, KY 41048
                    </p>
                 }
                </div>
                :
                <div />
            }

            <div className="Confirmation__text-box">
              <h3 className="list-title font-sans-serif">Instructions for mailing your package</h3>
              {internationalCustomer && isAustralian
              ? (
                <ol className="list">
                  <li>
                    <p className="list-text font-sans-serif">Print this document.</p>
                  </li>
                  <li>
                    <p className="list-text font-sans-serif">
                      Fold document in half as indicated on the form, and place on
                      <br className="hide-for-mobile" />
                      your return package (this will serve as your prepaid return label).
                    </p>
                  </li>
                  <li>
                    <p className="list-text font-sans-serif">
                      Drop off at your nearest post office and ship!
                    </p>
                  </li>
                </ol>

              )
              : null
            }
              {internationalCustomer && !isAustralian
            ? (
              <ol className="list">
                <li>
                  <p className="list-text font-sans-serif">Package your dress</p>
                </li>
                <li>
                  <p className="list-text font-sans-serif">
                    Follow your postal service’s labeling instructions.
                  </p>
                </li>
              </ol>
            )
            : null
          }
            </div>

            <div className="Confirmation__text-box">
              {internationalCustomer ? null :
              (
                <ol className="list">
                  <li>
                    <p className="list-text font-sans-serif">Print/Cutout the SmartLabel&reg; below.</p>
                  </li>
                  <li>
                    <p className="list-text font-sans-serif">Package the item(s) and Return Form,
                      seal securely with tape. Affix the SmartLabel&reg; to the package.
                    </p>
                  </li>
                  <li>
                    <p className="list-text font-sans-serif">
                      Drop your return anywhere in the U.S. Mail
                      location—in your mailbox, at work, or at a Post Office without
                      waiting in line.&nbsp;
                      <a
                        href="https://tools.usps.com/go/POLocatorAction!input.action"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="link u-textDecoration--underline"
                      >
                      Locate Post Office.
                      </a>
                    </p>
                  </li>
                </ol>
              )
            }
              { latestLineItem.item_return_label && !internationalCustomer ?
                <img
                  src={latestLineItem.item_return_label.label_image_url}
                  alt="Shipping Label"
                  className="Confirmation__shipping-label"
                /> : null
            }

              <h3 className="list-title Confirmation__packaging-slip font-sans-serif">Packing Slip</h3>
              <ul className="list__packing-slip">
                <li>
                  <p
                    className="list-text font-sans-serif"
                  >
                    <span
                      onClick={this.printPage}
                      className="u-textDecoration--underline u-cursor--pointer"
                    >
                      Print
                    </span>&nbsp;
                    and cut out your packing slip below.
                  </p>
                </li>
                <li>
                  <p className="list-text font-sans-serif">Include the packing slip inside your return package.</p>
                </li>
              </ul>
            </div>

          </div>
          <hr className="dotted-line" />

          <div>
            <p className="font-sans-serif u-no-margin">Order #{logisticsData.order_number}</p>
            {logisticsData.line_items.map((li, i) => {
              const lineItem = extractLineItemFromOrders(orderData, li.line_item_id);
              return (
                <ProductContainer
                  confirmationPage
                  key={li.line_item_id}
                  product={lineItem}
                  lastChild={i === (logisticsData.line_items.length - 1)}
                />
              );
            })}
          </div>
          <div className="u-margin-top-large u-margin-bottom-large hide-for-print">
            <SimpleButton
              buttonCopy="Continue Shopping"
              link="/dresses"
              withLink
            />
          </div>
        </div>
      </div>
    );
  }
}

// Confirmation.propTypes = propTypes;

export default Confirmation;
