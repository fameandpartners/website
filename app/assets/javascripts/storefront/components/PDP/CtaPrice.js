import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';
import {MODAL_STYLE} from './utils';
import Modal from 'react-modal';

class CtaPrice extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      sending: false,
      modalIsOpen: false
    };

    this.openModal = this.openModal.bind(this);
    this.closeModal = this.closeModal.bind(this);
    this.addToBag = this.addToBag.bind(this);
  }

  openModal() {
    this.setState({modalIsOpen: true});
  }

  closeModal() {
    this.setState({modalIsOpen: false});
  }

  addToBag() {
    // TODO: redo this
    // this is just very hacky way to connect this with shopping cart
    if(this.props.customize.size.id
      && this.props.customize.color.id
      && this.props.customize.length.id) {
      // disable "ADD TO BAG" button and show spinner
      this.setState({sending:true});
      document.getElementById('pdpCartSizeId').value = this.props.customize.size.id;
      document.getElementById('pdpCartColorId').value = this.props.customize.color.id;
      document.getElementById('pdpCartCustomId').value = this.props.customize.customization.id;
      document.getElementById('pdpCartDressVariantId').value = this.props.customize.dressVariantId;
      document.getElementById('pdpCartLength').value = this.props.customize.length.id;
      document.getElementById('pdpCartVariantId').value = this.props.product.master_id;
      // TODO: build express making functionality
      document.getElementById('pdpCartMakingId').value = null;
      $('#pdpDataForCheckout').submit();
    } else {
      // set errors
      if(!this.props.customize.size.id) {
        let customize = {};
        customize.size = {};
        customize.size.error = true;
        customize.size.message = 'dress size';
        this.props.actions.customizeDress(customize);
      }
      if(!this.props.customize.length.id) {
        let customize = {};
        customize.length = {};
        customize.length.error = true;
        customize.length.message = 'dress length';
        this.props.actions.customizeDress(customize);
      }
    }
  }

  render() {

    const PRICE =
      parseFloat(this.props.price)
      + parseFloat(this.props.customize.color.price)
      + parseFloat(this.props.customize.customization.price)
      - parseFloat(this.props.discount);

    return (
      <div className="btn-wrap">
        <div className="price">${PRICE}</div>
          {(() => {
            if(this.props.siteVersion === "Australia" && this.props.flags.afterpay) {
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
            if(this.props.customize.size.id
              && this.props.customize.color.id
              && this.props.customize.length.id
              && !this.state.sending) {
              return (
                <a href="javascript:;" onClick={this.addToBag} className="btn btn-black btn-lrg">
                  ADD TO BAG
                </a>
              );
            } else if(this.state.sending) {
              return (
                <a href="javascript:;" className="btn btn-black btn-loading btn-lrg">
                  <img src="/assets/loader-bg-black.gif" alt="Adding to bag" />
                </a>
              );
            } else {
              return (
                <a href="javascript:;" onClick={this.addToBag} className="btn btn-lowlight btn-lrg" disabled="disabled">ADD TO BAG</a>
              );
            }
          })()}
        <div className="est-delivery">Estimated delivery 1-2 weeks</div>
        <Modal
          style={MODAL_STYLE}
          className="md"
          isOpen={this.state.modalIsOpen}
          onRequestClose={this.closeModal}>
          <div className="afterpay-modal">
            <div className="row">
              <div className="col-md-12">
                <div className="header-wrap">
                  <img src="/assets/_afterpay/logo-sml.png" alt="afterpay logo" />
                  <h4 className="h2 title">Buy Now.<em>Pay Later.</em>No Interest</h4>
                  <h5 className="h6 title">Just select <strong>Afterpay</strong> at checkout.</h5>
                </div>
              </div>
              <div className="col-md-12">
                <div className="content-wrap">
                  <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
                    ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
                    laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in
                    voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat
                    non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
                  <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
                    ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
                    laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in
                    voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat
                    non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
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
  actions: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    price: state.product.price.price.amount,
    discount: state.discount,
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
