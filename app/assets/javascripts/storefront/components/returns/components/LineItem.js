import React, { PropTypes } from 'react';
import { Link } from 'react-router';
import Button from './Button';
import SimpleButton from './SimpleButton';

const propTypes = {
  returnSubtotal: PropTypes.number.isRequired,
};

const LineItem = ({ returnSubtotal }) => (
  <div className="LineItem grid-center">
    <div className="col-12_md-4_sm-10">
      <p>
       Refund subtotal: ${Number(returnSubtotal).toFixed(2) || 0.00}
      </p>
      <p>
       Shipping: $0.00
      </p>
      <hr />
    </div>
    <div className="col-12_md-4_sm-10">
      <p className="total">
       Total estimated refund: ${Number(returnSubtotal).toFixed(2) || 0.00}
      </p>
      <SimpleButton
        buttonCopy="Start Return"
        link="/"
        localLink
      />
    </div>
  </div>
);

LineItem.propTypes = propTypes;

export default LineItem;
