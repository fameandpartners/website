import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';

class CtaPrice extends React.Component {
  constructor(props, context) {
    super(props, context);
  }

  render() {
    const price =
      parseFloat(this.props.productPrice.amount)
      + this.props.customize.color.price
      + this.props.customize.custom.price
      - this.props.productDiscount;
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
  productPrice: PropTypes.object.isRequired,
  productDiscount: PropTypes.number.isRequired,
  customize: PropTypes.object.isRequired,
  actions: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    productPrice: state.productPrice.price,
    productDiscount: state.productDiscount,
    customize: state.customize
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(CtaPrice);
