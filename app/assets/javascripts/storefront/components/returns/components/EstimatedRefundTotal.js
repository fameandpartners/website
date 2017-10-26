import React from 'react';
import PropTypes from 'prop-types';

const propTypes = {
  refundCashTotal: PropTypes.number.isRequired,
  storeCreditTotal: PropTypes.number.isRequired,
};

const EstimatedRefundTotal = ({ refundCashTotal, storeCreditTotal }) => (
  <div className="EstimatedRefundTotal">
    <div className="grid-right-noGutter">
      <div className="col-4_md-12">
        { storeCreditTotal ?
          <div className="grid-noGutter">
            <div className="col-6">
              <p className="font-sans-serif u-left-text u-margin-bottom-small">
                Estimated store credit:
              </p>
            </div>
            <div className="col-6">
              <p className="font-sans-serif u-right-text u-margin-bottom-small">
                ${Number(storeCreditTotal).toFixed(2) || 0.00}
              </p>
            </div>
          </div>
        : null
        }

        { refundCashTotal ?
          <div className="grid-noGutter">
            <div className="col-6">
              <p className="font-sans-serif u-left-text u-margin-bottom-small">
                Estimated cash credit:
              </p>
            </div>
            <div className="col-6">
              <p className="font-sans-serif u-right-text u-margin-bottom-small">
                ${Number(refundCashTotal).toFixed(2) || 0.00}
              </p>
            </div>
          </div>
        : null
        }


        <div className="grid-noGutter u-border-top">
          <div className="col-6">
            <p className="EstimatedRefundTotal__total u-left-text font-sans-serif u-margin-top-small u-margin-bottom-medium">
              Estimated total refund:
            </p>
          </div>
          <div className="col-6">
            <p className="EstimatedRefundTotal__total font-sans-serif u-margin-top-small u-right-text">
              ${Number(refundCashTotal + storeCreditTotal).toFixed(2) || 0.00}
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
);

EstimatedRefundTotal.propTypes = propTypes;

export default EstimatedRefundTotal;
