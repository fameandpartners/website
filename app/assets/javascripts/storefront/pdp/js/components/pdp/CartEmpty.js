import React, { PureComponent } from 'react';

/* eslint-disable react/prefer-stateless-function */
class CartEmpty extends PureComponent {
  render() {
    return (
      <div className="CartEmpty">
        Nothing to see here. Your cart is empty!
      </div>
    );
  }
}

export default CartEmpty;
