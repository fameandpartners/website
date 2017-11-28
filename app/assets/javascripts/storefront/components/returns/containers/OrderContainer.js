/* eslint-disable */
import React from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import classNames from 'classnames';

// window polyfill
import win from '../../../polyfills/windowPolyfill';

// Utilities
import { serialize } from '../../../utilities/HTMLUtility';

// Components
import OrderHistory from '../components/OrderHistory';
import * as AppActions from '../actions/index';
import ReturnConstants from '../../../constants/ReturnConstants';
import SimpleButton from '../components/SimpleButton';

// const propTypes = {
//   actions: PropTypes.object,
//   orderData: PropTypes.array,
//   hasRequestedOrders: PropTypes.bool,
//   returnIsLoading: PropTypes.bool,
//   params: PropTypes.object.isRequired,
//   requiresViewOrdersRefresh: PropTypes.bool,
//   userSignedIn: PropTypes.bool,
// };

const defaultProps = {
  actions: {},
  hasRequestedOrders: false,
  orderData: [],
  returnIsLoading: false,
  requiresViewOrdersRefresh: false,
  userSignedIn: false,
};

class OrderContainer extends React.Component {
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
        { !returnIsLoading && !orderData.length ?
          <div>
            <div>
              <div
                className={classNames(
                  'grid-noGutter-center-spaceAround',
                  'ProductListItem__empty-orders-container',
                )}
              >
                <div className="col-10_md-12 u-no-padding">
                  <div className="order__container">
                    <div className="Product__listItem__container u-center-text">
                      <p className="ProductListItem__empty-orders-container-headline">
                        You have no orders
                      </p>
                      <p className="ProductListItem__empty-orders-container-copy">
                        Let’s change that
                      </p>
                      <SimpleButton
                        containerClassName="SimpleButton__container u-margin-auto"
                        className="u-width-full"
                        buttonCopy="Start Shopping"
                        link="/dresses/best-sellers"
                        withLink
                      />
                    </div>
                  </div>
                  <p
                    className={classNames(
                      'u-margin-top-medium',
                      'font-sans-serif',
                      'ProductListItem__empty-orders-container-customer-service',
                    )}
                  >
                    Have a Question? &nbsp;
                    <a
                      href="/contact"
                      className="u-underline"
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                    Contact Customer Service
                    </a>
                  </p>
                </div>
              </div>
            </div>
          </div>
          :
          null
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
// OrderContainer.propTypes = propTypes;
OrderContainer.defaultProps = defaultProps;
export default connect(mapStateToProps, mapDispatchToProps)(OrderContainer);
