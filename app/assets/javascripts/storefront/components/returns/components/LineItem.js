import React, { PropTypes } from 'react';
import { Link } from 'react-router';
import Button from './Button';
import SimpleButton from './SimpleButton';

const propTypes = {
  returnSubtotal: PropTypes.number.isRequired,
};

const LineItem = ({ returnSubtotal }) => (
  <div className="LineItem">
    <div className="grid-center">
      <div className="col-12_md-12_sm-10">
        <p>
         Refund subtotal: ${Number(returnSubtotal).toFixed(2) || 0.00}
        </p>
        <p>
         Shipping: $0.00
        </p>
        <hr />
      </div>
    </div>
    <div className="grid-right">
      <div className="col-4_md-12_sm-12">
        <p className="total">
         Total estimated refund: ${Number(returnSubtotal).toFixed(2) || 0.00}
        </p>
        <SimpleButton
          buttonCopy="Start Return"
          link="/return-confirmation"
          localLink
        />
      </div>
    </div>
  </div>
);

LineItem.propTypes = propTypes;

export default LineItem;
