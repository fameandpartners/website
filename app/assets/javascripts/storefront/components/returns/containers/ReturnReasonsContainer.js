/* eslint-disable */
/* global window */
import React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { browserHistory } from 'react-router';
import autoBind from 'auto-bind';
import { assign } from 'lodash';
import scroll from 'scroll';
import scrollDoc from 'scroll-doc';
import pluralize from 'pluralize';

// Components
import EstimatedRefundTotal from '../components/EstimatedRefundTotal';
import SimpleButton from '../components/SimpleButton';
import ProductContainer from './ProductContainer';

// Actions
import * as ReturnActions from '../actions/index';


// const propTypes = {
//   orderData: PropTypes.array,
//   returnArray: PropTypes.array.isRequired,
//   returnIsLoading: PropTypes.bool.isRequired,
//   returnResponseErrors: PropTypes.object.isRequired,
//   returnRequestErrors: PropTypes.object.isRequired,
//   returnSubtotal: PropTypes.oneOfType([
//     PropTypes.string,
//     PropTypes.number,
//   ]),
//   params: PropTypes.object,
//   actions: PropTypes.object,
//   guestEmail: PropTypes.string,
// };

const defaultProps = {
  orderData: [],
  params: {},
  actions: {},
  returnSubtotal: '0.00',
  guestEmail: null,
};

const scrollElement = scrollDoc();

class ReturnReasonsContainer extends React.Component {
  constructor(props) {
    super(props);
    autoBind(this);
    this.state = {
      order: null,
      orderArray: null,
    };
  }

  doesNotHaveReturnReason(primaryReturnReason) {
    return (!primaryReturnReason || primaryReturnReason.length === 0);
  }

  checkForReturnRequestErrors() {
    const { actions, returnArray } = this.props;
    // This is a little convuluted
    // We're creating an error object that is keyed off of line_item_id
    const returnRequestErrors = returnArray.reduce(
      (prev, curr) => {
        const accum = assign({}, prev, {
          [curr.id]: this.doesNotHaveReturnReason(curr.primaryReturnReason),
        });
        return accum;
      },
      {},
    );

    if (Object.keys(returnRequestErrors).some(key => returnRequestErrors[key])) {
      actions.setReturnReasonErrors({ returnRequestErrors });
      return true;
    }

    actions.setReturnLoadingState({ isLoading: true });
    return false;
  }

  showError() {
    const {
      returnIsLoading,
      returnResponseErrors,
      returnRequestErrors,
    } = this.props;

    if (!returnIsLoading && returnResponseErrors && returnResponseErrors.error) {
      return returnResponseErrors.error;
    }
    if (!returnIsLoading && returnRequestErrors && returnRequestErrors.error) {
      return returnRequestErrors.error;
    }
    return '';
  }

  requestReturn() {
    const { actions, returnArray, guestEmail, returnIsLoading } = this.props;
    if (returnIsLoading || this.checkForReturnRequestErrors()) {
      return;
    } else if (returnArray.length === 0) {
      scroll.top(scrollElement, 0);
      actions.setReturnLoadingState({ isLoading: false });
      actions.setReturnReasonErrors({ returnRequestErrors: {
        error: 'Please select an item you would like to return.',
      } });
    }
    const { spree_order } = this.state.order;
    const returnsObj = {
      order_id: spree_order.id,
      line_items: returnArray.map(r => ({
        line_item_id: r.id,
        action: 'Return',
        reason_category: r.primaryReturnReason,
        reason: r.openEndedReturnReason,
      })),
    };
    actions.submitReturnRequest({ order: spree_order, returnsObj, guestEmail, lineItems: returnArray });
  }

  calculateCashCredit() {
    const { returnArray } = this.props;
    const cashCreditAmount = returnArray
    .filter(product => !product.store_credit_only)
    .reduce((sum, returnedProduct) =>
      sum + Number(returnedProduct.price), 0);

    if (cashCreditAmount) {
      return cashCreditAmount;
    }

    return 0;
  }

  calculateStoreCredit() {
    const { returnArray } = this.props;
    const storeCreditAmount = returnArray
    .filter(product => product.store_credit_only)
    .reduce((sum, returnedProduct) =>
      sum + Number(returnedProduct.price), 0);

    if (storeCreditAmount) {
      return storeCreditAmount;
    }

    return 0;
  }

  componentWillMount() {
    const { orderData } = this.props;
    if (!orderData || orderData.length === 0) {
      browserHistory.push('/view-orders');
      window.location.reload();
    } else {
      const activeOrder = this.props.orderData.filter(o =>
        o.spree_order.number === this.props.params.orderID)[0];
      const { items } = activeOrder;
      const cleanItems = [];
      items.map(i => cleanItems.push(i.line_item));
      // TODO: Figure out consistency between steps for order object
      // Pass in with props instead of state
      this.state = {
        order: activeOrder,
        orderArray: cleanItems,
      };
    }
  }

  buttonText() {
    const { returnArray } = this.props;
    if (returnArray.length === 0) {
      return 'Select Items to Return';
    }

    const pluralizeText = pluralize('Items', returnArray.length, true);
    return `Return ${pluralizeText}`;
  }

  componentDidMount() {
    scroll.top(scrollElement, 0);
  }

  render() {
    const { order, orderArray } = this.state;
    const {
      params,
      returnIsLoading,
      returnArray,
      returnRequestErrors,
      returnSubtotal,
    } = this.props;

    if (!order) {
      return <div />;
    }

    const { returnEligible } = order;
    return (
      <div className="ReturnReasonsContainer">
        <div className="grid-noGutter-center">
          <div className="col-10_md-10_sm-11">
            <p className="instructions instructions__title">
                Returns happen.
              <br /> Please select the item(s) you would like to return
            </p>
            <p className="instructions instructions__subtitle">
                Please note that any returns must be in new, unused, and
                resalable condition with the "DO&nbsp;NOT&nbsp;REMOVE" tag still attached.
            </p>
          </div>
        </div>
        <div className="grid-noGutter-spaceAround">
          <div className="col-10_md-12 u-no-padding order__container">
            <p className="order-id u-margin-bottom-small font-sans-serif">
              <a href={`/orders/${params.orderID}`}>
                  Order {params.orderID}
              </a>
            </p>
            <div className="Product__listItem__container u-no-margin">
              {
                orderArray
                .filter(p => !p.returns_meta)
                .map((p, i) => (
                  <ProductContainer
                    key={`${p.id}-${p.order_id}`}
                    canUpdateReturnArray
                    product={p}
                    showForm
                    returnEligible={returnEligible}
                    hasError={returnRequestErrors[p.id]}
                    lastChild={i === (orderArray.length - 1)}
                  />
                ))
              }

            </div>
            <div>
              <EstimatedRefundTotal
                returnSubtotal={returnSubtotal}
                refundCashTotal={this.calculateCashCredit()}
                storeCreditTotal={this.calculateStoreCredit()}
              />
              <div className="grid-right">
                <div className="col-4_md-12_sm-12">
                  <div role="button" className="SimpleButton__wrapper" onClick={this.requestReturn}>
                    <SimpleButton
                      buttonCopy={returnIsLoading ? 'Starting...' : this.buttonText()}
                      isLoading={returnIsLoading || returnArray.length === 0}
                    />
                  </div>
                  <div className="EstimatedRefundTotal__message EstimatedRefundTotal__message--error u-margin-top-medium u-display-inherit">
                    {this.showError()}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

// ReturnReasonsContainer.propTypes = propTypes;
ReturnReasonsContainer.defaultProps = defaultProps;

function mapStateToProps(state) {
  return {
    returnArray: state.returnsData.returnArray,
    returnIsLoading: state.returnsData.returnIsLoading,
    returnRequestErrors: state.returnsData.returnRequestErrors,
    returnResponseErrors: state.returnsData.returnResponseErrors,
    returnSubtotal: state.returnsData.returnSubtotal,
    guestEmail: state.returnsData.guestEmail,
    orderData: state.orderData.orders,
  };
}
function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(ReturnActions, dispatch),
  };
}
export default connect(mapStateToProps, mapDispatchToProps)(ReturnReasonsContainer);
