import React, { Component, PropTypes } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';

// window polyfill
import win from '../../../polyfills/windowPolyfill';

// Utilities
import { serialize } from '../../../utilities/HTMLUtility';

// Components
import OrderHistory from '../components/OrderHistory';
import * as AppActions from '../actions/index';
import ReturnConstants from '../../../constants/ReturnConstants';

const propTypes = {
  actions: PropTypes.object,
  orderData: PropTypes.array,
  hasRequestedOrders: PropTypes.bool,
  returnIsLoading: PropTypes.bool,
  params: PropTypes.object.isRequired,
  requiresViewOrdersRefresh: PropTypes.bool,
  userSignedIn: PropTypes.bool,
};

const defaultProps = {
  actions: {},
  hasRequestedOrders: false,
  orderData: [],
  returnIsLoading: false,
  requiresViewOrdersRefresh: false,
  userSignedIn: false,
};

class OrderContainer extends Component {
  /**
   * Generate a URL that returns back to view orders
   */
  redirectToLoginAndBack() {
    const data = { return_to: win.location.href };
    win.location.href = `/spree_user/sign_in?${serialize(data)}`;
  }

  componentWillMount() {
    const { email, orderID } = this.props.params;
    const { actions, hasRequestedOrders, requiresViewOrdersRefresh, userSignedIn } = this.props;

    actions.clearReturnProductArray();

    // We need to refresh whenever we visit this route after
    // our POST changes the order data
    if (requiresViewOrdersRefresh) {
      win.location = ReturnConstants.RETURN_ROUTES.ORDERS;
    }

    // Not logged in and no email
    if (!userSignedIn && !email) {
      this.redirectToLoginAndBack();
    }

    // Get the order product data only once
    if (!hasRequestedOrders) {
      actions.setHasRequestedOrders({ hasRequestedOrders: true });
      actions.setReturnLoadingState({ isLoading: true });
      if (email && orderID) {
        actions.getProductData(true, email, orderID);
      } else {
        actions.getProductData();
      }
    }
  }

  componentDidMount() {
    const { params } = this.props;
    if (params && params.email) { this.props.actions.setGuestEmail(params.email); }
  }

  render() {
    const { orderData, returnIsLoading } = this.props;

    return (
      <div className="OrderContainer">
        {
          returnIsLoading
          ? (
            <div>
              <div className="OrderContainer--loading animate-flicker">Loading Orders...</div>
              <div className="sk-folding-cube">
                <div className="sk-cube1 sk-cube" />
                <div className="sk-cube2 sk-cube" />
                <div className="sk-cube4 sk-cube" />
                <div className="sk-cube3 sk-cube" />
              </div>
            </div>
          )
          : null
        }
        { orderData.length ?
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
    userSignedIn: state.$$userStore.get('user_signed_in'),
    orderData: state.orderData.orders,
    hasRequestedOrders: state.orderData.hasRequestedOrders,
    returnIsLoading: state.returnsData.returnIsLoading,
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
