/* global window */
import React, { Component, PropTypes } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import OrderHistory from '../components/OrderHistory';
import * as AppActions from '../actions/index';

const propTypes = {
  actions: PropTypes.object,
  orderData: PropTypes.array,
  params: PropTypes.object.isRequired,
  requiresViewOrdersRefresh: PropTypes.bool,
};

const defaultProps = {
  actions: {},
  orderData: [],
  requiresViewOrdersRefresh: false,
};

class OrderContainer extends Component {
  componentWillMount() {
    const { email, orderID } = this.props.params;

    // We need to refresh whenever we visit this route after
    // our POST changes the order data
    if (this.props.requiresViewOrdersRefresh) {
      window.location = '/view-orders';
    }


    // Get the order product data
    if (email && orderID) {
      this.props.actions.getProductData(true, email, orderID);
    } else {
      this.props.actions.getProductData();
    }
  }
  componentDidMount() {
    const { email } = this.props.params;
    this.props.actions.setGuestEmail(email);
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
    requiresViewOrdersRefresh: state.returnsData.requiresViewOrdersRefresh,
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
