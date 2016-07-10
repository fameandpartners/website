import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';

class CtaPrice extends React.Component {
  constructor(props, context) {
    super(props, context);
  }

  componentDidUpdate() {
    // TODO: redo this
    // this is just very hacky way to connect this with shopping cart
    document.getElementById('pdpCartSizeId').value = this.props.customize.size.id;
    document.getElementById('pdpCartColorId').value = this.props.customize.color.id;
    document.getElementById('pdpCartCustomIds').value = this.props.customize.custom.id;
    document.getElementById('pdpCartLength').value = this.props.customize.length.id;
  }

  render() {
    const price =
      parseFloat(this.props.price)
      + this.props.customize.color.price
      + this.props.customize.custom.price
      - this.props.discount;
    return (
      <div className="btn-wrap">
        <div className="price">${price}</div>
        <a href="javascript:;" className="btn btn-black btn-lrg">ADD TO BAG</a>
        <div className="est-delivery">Estimated delivery 3-4 weeks</div>
      </div>
    );
  }
}

CtaPrice.propTypes = {
  customize: PropTypes.object,
  price: PropTypes.string,
  discount: PropTypes.number
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    price: state.product.price.price.amount,
    discount: state.discount
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(CtaPrice);
