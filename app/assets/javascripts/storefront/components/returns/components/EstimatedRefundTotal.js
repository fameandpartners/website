import React, { PropTypes } from 'react';

const propTypes = {
  returnSubtotal: PropTypes.number.isRequired,
};

const EstimatedRefundTotal = ({ returnSubtotal }) => (
  <div className="EstimatedRefundTotal">
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
      </div>
    </div>
  </div>
);

EstimatedRefundTotal.propTypes = propTypes;

export default EstimatedRefundTotal;
