import React, { Component, PropTypes } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';

// window polyfill
import win from '../../../polyfills/windowPolyfill';

// Components
import OrderHistory from '../components/OrderHistory';
import * as AppActions from '../actions/index';
import ReturnConstants from '../../../constants/ReturnConstants';

const propTypes = {
  actions: PropTypes.object,
  orderData: PropTypes.array,
  returnIsLoading: PropTypes.bool,
  params: PropTypes.object.isRequired,
  requiresViewOrdersRefresh: PropTypes.bool,
};

const defaultProps = {
  actions: {},
  orderData: [],
  returnIsLoading: false,
  requiresViewOrdersRefresh: false,
};

class OrderContainer extends Component {
  constructor(props) {
    super(props);
    this.state = {
      hasRequestedReturns: false,
    };
  }

  componentWillMount() {
    const { email, orderID } = this.props.params;

    // We need to refresh whenever we visit this route after
    // our POST changes the order data
    if (this.props.requiresViewOrdersRefresh) {
      win.location = ReturnConstants.RETURN_ROUTES.ORDERS;
    }

    // Get the order product data only once
    if (!this.state.hasRequestedReturns) {
      const { actions } = this.props;
      this.setState({ hasRequestedReturns: true });
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
              <div className="OrderContainer__loading animate-flicker">Loading Orders...</div>
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
