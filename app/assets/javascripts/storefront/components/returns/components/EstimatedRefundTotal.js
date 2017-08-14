import React, { PropTypes } from 'react';

const propTypes = {
  returnSubtotal: PropTypes.number.isRequired,
  storeCreditTotal: PropTypes.number.isRequired,
};

const EstimatedRefundTotal = ({ returnSubtotal, storeCreditTotal }) => (
  <div className="EstimatedRefundTotal">
    <div className="grid-right-noGutter">
      <div className="col-4_md-12">
        <div className="grid-noGutter">
          <div className="col-6">
            <p className="font-sans-serif u-margin-bottom-small">
              Estimated store credit:
            </p>
          </div>
          <div className="col-6">
            <p className="font-sans-serif u-right-text u-margin-bottom-small">
              ${Number(storeCreditTotal).toFixed(2) || 0.00}
            </p>
          </div>
        </div>
        <div className="grid-noGutter u-border-top">
          <div className="col-6">
            <p className="font-sans-serif u-margin-top-small u-margin-bottom-medium">
              Estimated refund:
            </p>
          </div>
          <div className="col-6">
            <p className="font-sans-serif u-margin-top-small u-right-text">
              ${Number(returnSubtotal).toFixed(2) || 0.00}
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
);

EstimatedRefundTotal.propTypes = propTypes;

export default EstimatedRefundTotal;
