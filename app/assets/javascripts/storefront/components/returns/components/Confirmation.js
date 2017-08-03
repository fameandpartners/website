import React, { PropTypes } from 'react';
import { Link } from 'react-router';
import ProductContainer from '../containers/ProductContainer';
import SimpleButton from './SimpleButton';

const propTypes = {
  orderData: PropTypes.object,
  logisticsData: PropTypes.shape({
    line_item_id: PropTypes.number,
    item_return_label: PropTypes.shape({
      carrier: PropTypes.string,
      id: PropTypes.number,
      item_return_id: PropTypes.number,
      label_image_url: PropTypes.string,
      label_pdf_url: PropTypes.string,
      label_url: PropTypes.string,
      updated_at: PropTypes.string,
    }),
  }).isRequired,
};


function extractLineItemFromOrders(orders, lineItemId) {
  let match = {};
  orders.forEach((o) => {
    o.items.forEach((li) => {
      if (li.line_item.id === lineItemId) {
        match = li.line_item;
      }
    });
  });
  return match;
}


const Confirmation = ({ orderData, logisticsData }) => (
  <div className="instructions__container">
    <p className="orders-link-container hide-for-print">
      <Link to="/" className="orders-link">
        Back to Orders
      </Link>
    </p>
    <div className="instructions__body">
      <div className="instructions__header">
        <p className="headline">
      We’ve emailed you a return label and shipping instructions.
      <br />Ship your return by {logisticsData.final_return_by_date}
        </p>
        <ul className="label-list hide-for-print">
          <li>
            <a href="#">Print Label</a>
          </li>
          <li>
            <a href="#">Email Label</a>
          </li>
        </ul>
      </div>
      <hr className="hide-for-mobile" />
      <div>
        {
            logisticsData.internationalCustomer ?
              <div>
                <p className="list-title"> <b>Please mail your package to</b></p>
                <p>Fame and Partners – Returns <br /> 15905 Commerce Way <br />
              Cerritos, CA, 90703</p>
              </div>
              :
              <div />
          }
        <p className="list-title"><b>Instructions for mailing your package</b></p>
        <ul className={!logisticsData.internationalCustomer ? 'u-hide' : 'list'}>
          <li>
            <p className="list-text">Package your dress</p>
          </li>
          <li>
            <p className="list-text">Follow your postal service’s labeling instructions.
              </p>
          </li>
        </ul>
        <ul className={logisticsData.internationalCustomer ? 'u-hide' : 'list'}>
          <li>
            <p className="list-text">Print/Cutout the SmartLabel&reg; below. </p>
          </li>
          <li>
            <p className="list-text">Package the item(s) and Return Form,
              seal securely with tape. Affix the SmartLabel&reg; to the package.
              </p>
          </li>
          <li>
            <p className="list-text">Drop your return anywhere in the U.S. Mail
              location—in your mailbox, at work, or at a Post Office without
              waiting in line.&nbsp;
                <a
                  href="https://tools.usps.com/go/POLocatorAction!input.action"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="link u-underline"
                >
                  Locate Post Office.
                </a></p>
          </li>
        </ul>
        <img
          src={logisticsData.line_items[0].item_return_label.label_image_url}
          alt="Shipping Label"
          className={logisticsData.internationalCustomer ? 'u-hide' : 'Confirmation__shipping-label'}
        />
        <p className="list-title Confirmation__packaging-slip"><b>Packing Slip</b></p>
        <ul className="list">
          <li>
            <p className="list-text">Print and cut out your packing slip below</p>
          </li>
          <li>
            <p className="list-text">Include the packing slip inside your return package.</p>
          </li>
        </ul>
      </div>
      <hr className="dotted-line" />

      <div>
        <p className="u-no-margin">Order #{logisticsData.order_number}</p>
        {logisticsData.line_items.map((li) => {
          const lineItem = extractLineItemFromOrders(orderData, li.line_item_id);
          return <ProductContainer confirmationPage key={li.line_item_id} product={lineItem} />;
        })}
      </div>
      <div className="u-margin-bottom-large hide-for-print">
        <SimpleButton
          buttonCopy="Continue Shopping"
          link="/"
          localLink
          withLink
        />
      </div>
    </div>
  </div>
  );

Confirmation.propTypes = propTypes;

export default Confirmation;
