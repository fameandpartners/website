/* global window */
import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { browserHistory } from 'react-router';
import autoBind from 'auto-bind';
import { assign } from 'lodash';

// Components
import EstimatedRefundTotal from '../components/EstimatedRefundTotal';
import SimpleButton from '../components/SimpleButton';
import ProductContainer from './ProductContainer';

// Actions
import * as ReturnActions from '../actions/index';

const propTypes = {
  orderData: PropTypes.array,
  returnArray: PropTypes.array.isRequired,
  returnIsLoading: PropTypes.bool.isRequired,
  returnResponseErrors: PropTypes.object.isRequired,
  returnRequestErrors: PropTypes.object.isRequired,
  returnSubtotal: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.number,
  ]),
  params: PropTypes.object,
  actions: PropTypes.object,
  guestEmail: PropTypes.string,
};

const defaultProps = {
  orderData: [],
  params: {},
  actions: {},
  returnSubtotal: '0.00',
  guestEmail: null,
};

class ReturnReasonsContainer extends Component {
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

  requestReturn() {
    if (this.props.returnIsLoading || this.checkForReturnRequestErrors()) { return; }
    const { actions, returnArray, guestEmail } = this.props;
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
    actions.submitReturnRequest({ order: spree_order, returnsObj, guestEmail });
  }

  componentWillMount() {
    const { orderData, actions } = this.props;
    if (orderData === null) {
      actions.getProductData();
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
  // TODO: @mikeg must remove
  componentDidMount() {
    $('html, body').animate({
      scrollTop: 0,
    }, 600);
  }
  render() {
    const { order, orderArray } = this.state;
    const {
      returnIsLoading,
      returnResponseErrors,
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
          <div className="col-10_md-12 u-no-padding">
            <div className="order__container Product__listItem__container u-no-margin">
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
              />
              <div className="grid-right">
                <div className="col-4_md-12_sm-12">
                  <div className="SimpleButton__wrapper" onClick={this.requestReturn}>
                    <SimpleButton
                      buttonCopy={returnIsLoading ? 'Starting...' : 'Start Return'}
                      isLoading={returnIsLoading}
                    />
                    { !returnIsLoading && returnResponseErrors && returnResponseErrors.error ?
                      <span>{returnResponseErrors.error}</span>
                      :
                      <span />
                    }
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

ReturnReasonsContainer.propTypes = propTypes;
ReturnReasonsContainer.defaultProps = defaultProps;
function mapStateToProps(state) {
  return {
    returnArray: state.returnsData.returnArray,
    returnIsLoading: state.returnsData.returnIsLoading,
    returnRequestErrors: state.returnsData.returnRequestErrors,
    returnResponseErrors: state.returnsData.returnResponseErrors,
    returnSubtotal: state.returnsData.returnSubtotal,
    guestEmail: state.returnsData.guestEmail,
    orderData: state.orderData,
  };
}
function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(ReturnActions, dispatch),
  };
}
export default connect(mapStateToProps, mapDispatchToProps)(ReturnReasonsContainer);
