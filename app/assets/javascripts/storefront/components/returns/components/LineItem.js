import React, { PropTypes } from 'react';
import { Link } from 'react-router';
import Button from './Button';

const propTypes = {
  returnSubtotal: PropTypes.string.isRequired,
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
      <p className="total">
       Total estimated refund: ${Number(returnSubtotal).toFixed(2) || 0.00}
      </p>
      <Button primary noMargin>
        <Link to="/return-confirmation" className="u-white-text button-link">
         Start Return
       </Link>
      </Button>
    </div>
  </div>
);

LineItem.propTypes = propTypes;

export default LineItem;
