import React, { PropTypes } from 'react';

const propTypes = {
  returnSubtotal: PropTypes.number.isRequired,
};

const EstimatedRefundTotal = ({ returnSubtotal }) => (
  <div className="EstimatedRefundTotal">
    <div className="grid-center u-margin-bottom-medium">
      <div className="col-12_md-4_sm-10">
        <p
          className="font-sans-serif"
        >
         Refund subtotal: ${Number(returnSubtotal).toFixed(2) || 0.00}
        </p>
        <p className="font-sans-serif">
         Shipping: $0.00
        </p>
      </div>
    </div>
    <div className="grid-right">
      <div className="col-4_md-12_sm-12">
        <p className="font-sans-serif total">
          <span className="u-full-length-border-top u-position-relative">
             Total estimated refund: ${Number(returnSubtotal).toFixed(2) || 0.00}
          </span>
        </p>
      </div>
    </div>
  </div>
);

EstimatedRefundTotal.propTypes = propTypes;

export default EstimatedRefundTotal;
