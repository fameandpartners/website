import React, { PropTypes } from 'react';
import SimpleButton from './SimpleButton';

const propTypes = {
  handleSubmission: PropTypes.func.isRequired,
  returnSubtotal: PropTypes.number.isRequired,
};

const LineItem = ({ handleSubmission, returnSubtotal }) => (
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
        <div className="SimpleButton__wrapper" onClick={handleSubmission}>
          <SimpleButton
            buttonCopy="Start Return"
          />
        </div>
      </div>
    </div>
  </div>
);

LineItem.propTypes = propTypes;

export default LineItem;
