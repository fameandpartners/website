import React, { Component, PropTypes } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import OrderHistory from '../components/OrderHistory';
import * as AppActions from '../actions/index';

const propTypes = {
  actions: PropTypes.object,
  orderData: PropTypes.array,
};

const defaultProps = {
  actions: {},
  orderData: [],
};

class OrderContainer extends Component {
  componentWillMount() {
    const { email, orderID } = this.props.params;
    if (email && orderID) {
      this.props.actions.getProductData(true, email, orderID);
    } else {
      this.props.actions.getProductData();
    }
  }
  render() {
    const { orderData } = this.props;
    if (!orderData) {
      return <div />;
    }
    return (
      <div>
        { orderData ?
          (
            <div>
              <h1 className="u-center-text">Orders</h1>
              {orderData.map(o => <OrderHistory key={o.spree_order.number} orderData={o} />)}
            </div>
          )
          : null
        }
      </div>
    );
  }
}

function mapStateToProps(state) {
  return {
    orderData: state.orderData,
  };
}
function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(AppActions, dispatch),
  };
}
OrderContainer.propTypes = propTypes;
OrderContainer.defaultProps = defaultProps;
export default connect(mapStateToProps, mapDispatchToProps)(OrderContainer);
