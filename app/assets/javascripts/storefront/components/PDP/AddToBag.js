import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as pdpActions from '../../actions/PdpActions';
import PDPConstants from '../../constants/PDPConstants';
import { MODAL_STYLE } from './utils';
import Modal from 'react-modal';

class CtaPrice extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      sending: false,
      modalIsOpen: false,
    };

    this.openModal = this.openModal.bind(this);
    this.closeModal = this.closeModal.bind(this);
    this.addToBag = this.addToBag.bind(this);
  }

  openModal() {
    this.setState({ modalIsOpen: true });
  }

  closeModal() {
    this.setState({ modalIsOpen: false });
  }

  addToBag() {
    const { customize, actions, product } = this.props;
    // TODO: redo this
    // this is just EXTREMELY hacky way to connect this with shopping cart
    if (customize.size.id
      && customize.color.id
      && customize.height.heightValue) {
      // disable "ADD TO BAG" button and show spinner
      this.setState({ sending: true });
      document.getElementById('pdpCartSizeId').value = customize.size.id;
      document.getElementById('pdpCartColorId').value = customize.color.id;
      document.getElementById('pdpCartCustomId').value = customize.customization.id;
      document.getElementById('pdpCartDressVariantId').value = customize.dressVariantId;
      document.getElementById('pdpCartHeight').value = customize.height.heightValue;
      document.getElementById('pdpCartHeightUnit').value = customize.height.heightUnit;
      document.getElementById('pdpCartVariantId').value = product.master_id;
      document.getElementById('pdpCartMakingId').value = customize.makingOption.id;
      $('#pdpDataForCheckout').submit();
    } else {
      // force size profile
      actions.addToBagPending(true);
      actions.toggleDrawer(PDPConstants.DRAWERS.SIZE_PROFILE);
    }
  }

  render() {
    const prices = this.props.product.prices;

    const parsedPrice = parseFloat(prices.original_amount) || 0;
    const parsedSale  = parseFloat(prices.sale_amount) || 0;

    const calculatePrice = (price) => {
      const parsedColorPrice  = parseFloat(this.props.customize.color.price) || 0;
      const parsedCustomPrice = parseFloat(this.props.customize.customization.price) || 0;
      const parsedOptionPrice = parseFloat(this.props.customize.makingOption.price) || 0;

      const PRICE = price + parsedColorPrice + parsedCustomPrice + parsedOptionPrice
      return PRICE;
    }

    let calculatedPrice = {
      original: calculatePrice(parsedPrice)
    };

    if (parsedSale) {
      calculatedPrice.sale = calculatePrice(parsedSale);
    }

    let deliveryPeriod = this.props.product.delivery_period;
    if (this.props.customize.makingOption.id && !this.props.product.cny_delivery_delays) {
      deliveryPeriod = this.props.product.fast_making_delivery_period;
    }

    const isAfterpayEnabled = this.props.siteVersion === 'Australia' && this.props.flags.afterpay;
    const afterpayPrice = ( (calculatedPrice.sale || calculatedPrice.original) / 4).toFixed(2)

    return (
      <div className="btn-wrap">
        <div className="price">${PRICE}</div>
        {(() => {
          if (isAfterpayEnabled) {
            return (
              <div className="afterpay-message">
                <span>or 4 easy payments of ${PRICE / 4} with</span>
                <img src="/assets/_afterpay/logo-sml.png" alt="afterpay logo" />
                <a href="javascript:;" onClick={this.openModal}>info</a>
              </div>
            );
          }
        })()}
        {(() => {
          if (this.state.sending) {
            return (
              <a href="javascript:;" className="btn btn-black btn-loading btn-lrg">
                <img src="/assets/loader-bg-black.gif" alt="Adding to bag" />
              </a>
            );
          }
          return (
            <a href="javascript:;" onClick={this.addToBag} className="btn btn-black btn-lrg">
              ADD TO BAG
            </a>
          );
        })()}
        <ul className="est-delivery">
          <li>Free Shipping</li>
          <li>Estimated delivery, {deliveryPeriod}</li>
        </ul>
        {(() => {
          if (this.props.product.cny_delivery_delays) {
            return (
              <div className="deliveryNote">We're experiencing a high order volume right now, so it's taking longer than usual to handcraft each made-to-order garment. We'll be back to our normal timeline of 7-10 days soon.</div>
            );
          }
        })()}
        <Modal
          style={MODAL_STYLE}
          className="md"
          isOpen={this.state.modalIsOpen}
          onRequestClose={this.closeModal}
        >
          <div className="afterpay-modal">
            <div className="row">
              <div className="col-md-12">
                <div className="header-wrap">
                  <img src="/assets/_afterpay/logo-sml.png" alt="afterpay logo" />
                  <h4 className="h2 title">Buy Now. <em>Pay Later.</em> No Interest</h4>
                  <h5 className="h6 title">Just select <strong>Afterpay</strong> at checkout.</h5>
                </div>
              </div>
              <div className="col-md-12">
                <div className="content-wrap">
                  <h4>How it works.</h4>
                  <ol>
                    <li>Select Afterpay as your payment method when you check out.
                      <span>Use your existing debit or credit card.</span></li>
                    <li>Completed your check.
                      <span>No long forms, instant approval online.</span></li>
                    <li>Pay over 4 equal instalments.
                      <span>Pay fortnightly, enjoy your purchase straight away!</span></li>
                  </ol>
                  <h4>You simply need:</h4>
                  <ul>
                    <li>A debit card or credit card</li>
                    <li>To be over 18 years of age</li>
                    <li>To live in Australia</li>
                  </ul>
                  <p>To see Afterpay’s complete terms, visit <a href="https://www.afterpay.com.au/terms" target="_blank">www.afterpay.com.au/terms</a></p>
                </div>
              </div>
            </div>
          </div>
          <a href="javascript:;" className="btn-close" onClick={this.closeModal}>
            <span className="hide-visually">Close Menu</span>
          </a>
        </Modal>
      </div>
    );
  }
}

CtaPrice.propTypes = {
  customize: PropTypes.object,
  price: PropTypes.string,
  discount: PropTypes.number,
  product: PropTypes.object,
  siteVersion: PropTypes.string,
  flags: PropTypes.object,
  actions: PropTypes.object.isRequired,
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    price: state.product.price.price.amount,
    discount: state.discount.table.amount,
    siteVersion: state.siteVersion,
    product: state.product,
    flags: state.flags
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(CtaPrice);
