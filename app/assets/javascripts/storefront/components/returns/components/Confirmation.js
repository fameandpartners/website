import React, { PropTypes } from 'react';
import { Link } from 'react-router';
import ProductContainer from '../containers/ProductContainer';
import SimpleButton from './SimpleButton';

const propTypes = {
  returnArray: PropTypes.array,
  internationalCustomer: PropTypes.bool,
};

const defaultProps = {
  returnArray: [],
  internationalCustomer: false,
};


const Confirmation = ({ returnArray, internationalCustomer }) => (
  <div className="instructions__container">
    <p className="orders-link-container"><Link to="/" className="orders-link">
      Back to Orders</Link></p>
    <div className="instructions__body">
      <p className="headline">
        We’ve emailed you a return label and shipping instructions.
        <br />Ship your return by MM/DD/YYYY
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
              <p className="list-title"> <b>Please mail your package to</b></p>
              <p>Fame and Partners – Returns <br /> 15905 Commerce Way <br />
              Cerritos, CA, 90703</p>
            </div>
            :
            <div />
         }
        <p className="list-title"><b>Instructions for mailing your package</b></p>
        <ul className={!internationalCustomer ? 'u-hide' : 'list'}>
          <li>
            <p className="list-text">Package your dress</p>
          </li>
          <li>
            <p className="list-text">Follow your postal service’s labeling instructions.
            </p>
          </li>
        </ul>
        <ul className={internationalCustomer ? 'u-hide' : 'list'}>
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
              waiting in line. <a
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
          src="http://placehold.it/610x410?text=Shipping Label"
          alt="Shipping Label"
          className={internationalCustomer ? 'u-hide' : 'shipping-label hide-for-mobile'}
        />
        <p className="list-title"><b>Packing Slip</b></p>
        <ul className="list">
          <li>
            <p className="list-text">Print and cut out your packing slip</p>
          </li>
          <li>
            <p className="list-text">Include the packing slip inside your return package.</p>
          </li>
        </ul>
      </div>
      <hr className="dotted-line" />

      <div>
        <p>Order #1231</p>
        {returnArray.map((p) => {
          const { id } = p;
          return <ProductContainer confirmationPage key={id} product={p} />;
        })}
      </div>
      <div className="u-margin-bottom-large">
        <SimpleButton
          buttonCopy="Continue Shopping"
          link="/"
          localLink
        />
      </div>
    </div>
  </div>
);

Confirmation.propTypes = propTypes;
Confirmation.defaultProps = defaultProps;

export default Confirmation;
