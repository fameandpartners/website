import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';

class CtaPrice extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.addToBag = this.addToBag.bind(this);
  }

  addToBag() {
    // TODO: redo this
    // this is just very hacky way to connect this with shopping cart
    if(this.props.customize.size.id
      && this.props.customize.color.id
      && this.props.customize.length.id) {
      document.getElementById('pdpCartSizeId').value = this.props.customize.size.id;
      document.getElementById('pdpCartColorId').value = this.props.customize.color.id;
      document.getElementById('pdpCartCustomId').value = this.props.customize.customization.id;
      document.getElementById('pdpCartDressVariantId').value = this.props.customize.dressVariantId;
      document.getElementById('pdpCartLength').value = this.props.customize.length.id;
      document.getElementById('pdpCartVariantId').value = this.props.product.master_id;
      // TODO: build express making functionality
      document.getElementById('pdpCartMakingId').value = null;
      $('#pdpDataForCheckout').submit();
    }
  }

  render() {
    const price =
      parseFloat(this.props.price)
      + parseFloat(this.props.customize.color.price)
      + parseFloat(this.props.customize.customization.price)
      - parseFloat(this.props.discount);
    return (
      <div className="btn-wrap">
        <div className="price">${price}</div>
          {(() => {
            if(this.props.customize.size.id
              && this.props.customize.color.id
              && this.props.customize.length.id) {
              return (
                <a href="javascript:;" onClick={this.addToBag} className="btn btn-black btn-lrg">ADD TO BAG</a>
              );
            } else {
              return (
                <a href="javascript:;" className="btn btn-black btn-lrg" disabled="disabled">ADD TO BAG</a>
              );
            }
          })()}
        <div className="est-delivery">Estimated delivery 3-4 weeks</div>
      </div>
    );
  }
}

CtaPrice.propTypes = {
  customize: PropTypes.object,
  price: PropTypes.string,
  discount: PropTypes.number,
  product: PropTypes.object
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    price: state.product.price.price.amount,
    discount: state.discount,
    product: state.product
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(CtaPrice);
