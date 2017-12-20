/* eslint-disable */

// NOTE: Using this dummy component b/c importing SVGs alone is problematic.

import React from 'react';
import PropTypes from 'prop-types';

class CartIcon extends React.PureComponent {
  render() {
    const {
      dark,
    } = this.props;

    let fillColor = '#fff';

    if (dark) {
      fillColor = '#222';
    }

    return (
      <svg width="18px" height="22px" viewBox="0 0 20 23" xmlns="http://www.w3.org/2000/svg">
        <title>1495001373_cart2-21</title>
        <g fillRule="nonzero" fill={fillColor}>
          <path d="M17.38 5.385a.36.36 0 0 0-.362-.358H2.538c-.2 0-.362.16-.364.39L.728 21.132a.36.36 0 0 0 .362.358h17.376a.36.36 0 0 0 .361-.344L17.38 5.385zM19.55 21.1a1.084 1.084 0 0 1-1.084 1.106H1.09c-.6 0-1.086-.48-1.084-1.106L1.452 5.385A1.08 1.08 0 0 1 2.538 4.31h14.48c.6 0 1.086.48 1.084 1.041L19.55 21.1z"></path>
          <path d="M5.796 7.532V4.67c0-2.174 1.783-3.937 3.982-3.937 2.198 0 3.982 1.763 3.982 3.937v2.863h.724V4.67c0-2.57-2.108-4.653-4.706-4.653C7.179.016 5.072 2.1 5.072 4.67v2.863h.724z"></path>
          <path d="M5.434 8.606a.72.72 0 0 1-.724-.716.72.72 0 0 1 .724-.716c.4 0 .724.32.724.716a.72.72 0 0 1-.724.716zM14.122 8.606a.72.72 0 0 1-.724-.716.72.72 0 0 1 .724-.716c.4 0 .724.32.724.716a.72.72 0 0 1-.724.716zM.563 19.343h18.43v-.716H.563z"></path>
        </g>
      </svg>
    );
  }
}

CartIcon.propTypes = {
  dark: PropTypes.bool,
};

CartIcon.defaultProps = {
  dark: false,
};

export default CartIcon;
