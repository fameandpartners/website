import React, { PropTypes } from 'react';
import { Link } from 'react-router';
import ProductContainer from '../containers/ProductContainer';
import Button from './Button';

const propTypes = {
  returnArray: PropTypes.array,
  internationalCustomer: PropTypes.bool,
};

const defaultProps = {
  returnArray: PropTypes.array,
  internationalCustomer: PropTypes.bool,
};


const Confirmation = ({ returnArray, internationalCustomer }) => (
  <div className="instructions__container">
    <Link to="/" className="orders-link">Back to Orders</Link>
    <div className="instructions__body">
      <p className="headline">
We have emailed you your label and instructions <br />Return your items by MM/DD/YYYY
      </p>
      <ul className="label-list hide-for-mobile">
        <li>
          <a href="#">Print Label</a>
        </li>
        <li>
          <a href="#">Email Label</a>
        </li>
      </ul>
      <hr className="hide-for-mobile" />
      <div>
        {
          internationalCustomer ?
            <div>
              <p className="list-title"> Please mail your package to</p>
              <p>Fame and Partners Returns <br />PO Box. 12345 <br />Los Angeles
, CA 90013
              </p>
            </div>
            :
            <div />
         }
        <p className="list-title">Instructions for mailing your package</p>
        <ul className="list">
          <li>
            <p className="list-text">Print and cut out the shipping label</p>
          </li>
          <li>
            <p className="list-text">Make sure there are no barcodes or
tracking numbers on your package
            </p>
          </li>
          <li>
            <p className="list-text">Securely affix this label to your package.</p>
          </li>
          <li>
            <p className="list-text">Take to the nearest US post office for drop off.
 <a href="#" className="link">Locate nearest post office</a>
            </p>
          </li>
        </ul>
        <img
          src="http://placehold.it/610x410?text=Shipping Label"
          alt="Shipping Label"
          className={internationalCustomer ? 'u-hide' : 'shipping-label hide-for-mobile'}
        />
        <p className="list-title">Packing Slip</p>
        <ul className="list">
          <li>
            <p className="list-text">Print and cut out the packing slip</p>
          </li>
          <li>
            <p className="list-text">Include inside your return package</p>
          </li>
        </ul>
      </div>
      <hr />

      <div>
        <p>Order #1231</p>
        {returnArray.map((p) => {
          const { id } = p;
          return <ProductContainer confirmationPage key={id} product={p} />;
        })}
      </div>
      <div className="button__container">
        <Button primary noMargin>
          <Link className="u-white-text button-link" to="/">Continue Shopping</Link>
        </Button>
      </div>
    </div>
  </div>
);

Confirmation.propTypes = propTypes;
Confirmation.defaultProps = defaultProps;


export default Confirmation;
