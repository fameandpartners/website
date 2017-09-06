import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { connect } from 'react-redux';
import objnoop from '../../libs/objnoop';

// UI Components
import CartEmpty from './CartEmpty';
import Cart from './Cart';

// CSS
import '../../../css/components/Cart.scss';


function stateToProps(state) {
  // Which part of the Redux global state does our component want to receive as props?
  return {
    lineItems: state.$$cartState.get('lineItems').toJS(),
    complementaryProducts: state.$$productState.get('complementaryProducts').toJS(),
  };
}


class CartDrawer extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  subTotal() {
    const { lineItems } = this.props;
    if (lineItems.length > 0) {
      // Reduces subTotal based on base price, colors, and addons chosen
      return lineItems.reduce(
        (prevTotal, currLineItem) => {
          const lineItemTotal
            = currLineItem.color.centsTotal
            + currLineItem.productCentsBasePrice
            + currLineItem.addons.reduce((subTotal, c) => subTotal + c.centsTotal, 0);
          return prevTotal + lineItemTotal;
        }, 0,
      );
    }
    return '';
  }

  render() {
    const { complementaryProducts, lineItems } = this.props;

    return (
      <div className="CartDrawer u-flex--col u-height--full">
        <div className="CartDrawer__header">
          <h4>Shopping Bag</h4>
        </div>
        { lineItems.length > 0
          ? <Cart complementaryProducts={complementaryProducts} lineItems={lineItems} />
          : <CartEmpty />
        }
      </div>
    );
  }
}

CartDrawer.propTypes = {
  complementaryProducts: PropTypes.arrayOf(PropTypes.shape({
    centsPrice: PropTypes.number,
    smallImg: PropTypes.string,
    productId: PropTypes.string,
    productTitle: PropTypes.string,
    url: PropTypes.string,
  })).isRequired,
  lineItems: PropTypes.arrayOf(PropTypes.shape({
    color: PropTypes.shape({
      id: PropTypes.number,
      name: PropTypes.string,
      centsTotal: PropTypes.number,
      hexValue: PropTypes.string,
    }),
    addons: PropTypes.arrayOf(PropTypes.shape({
      id: PropTypes.number,
      description: PropTypes.string,
      centsTotal: PropTypes.number,
    })),
  })).isRequired,
  // modelDescription: PropTypes.string.isRequired,
};

export default connect(stateToProps, objnoop)(CartDrawer);
