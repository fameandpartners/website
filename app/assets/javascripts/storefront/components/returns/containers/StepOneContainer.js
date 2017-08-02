import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { browserHistory } from 'react-router';
import autoBind from 'auto-bind';
import LineItem from '../components/LineItem';
import ProductContainer from './ProductContainer';
import * as AppActions from '../actions/index';

const propTypes = {
  orderData: PropTypes.array,
  returnArray: PropTypes.array.isRequired,
  returnSubtotal: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.number,
  ]),
  params: PropTypes.object,
  actions: PropTypes.object,
};

const defaultProps = {
  orderData: [],
  params: {},
  actions: {},
  returnSubtotal: '0.00',
};

class StepOneContainer extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
    this.state = {
      order: null,
      orderArray: null,
    };
  }

  requestReturn() {
    const { actions, returnArray } = this.props;
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

    actions.submitReturnRequest(returnsObj);
  }

  componentWillMount() {
    const { orderData, actions } = this.props;
    if (orderData === null) {
      actions.getProductData();
      browserHistory.push('/view-orders');
      location.reload();
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
  componentDidMount() {
    $('html, body').animate({
      scrollTop: 0,
    }, 600);
  }
  render() {
    const { order, orderArray } = this.state;
    if (!order) {
      return <div />;
    }
    const spreeOrder = order.spree_order;
    const shipDate = spreeOrder.date_iso_mdy;
    const { returnEligible } = order;
    return (
      <div className="StepOne__Container">
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
            <p className="ship-date">
                Shipped {shipDate}
            </p>
            <div className="order__container Product__listItem__container">
              {
                orderArray.map(p => (
                  <ProductContainer
                    key={`${p.id}-${p.order_id}`}
                    product={p}
                    showForm
                    returnEligible={returnEligible}
                  />
                ))
              }

            </div>
            <div>
              <LineItem
                handleSubmission={this.requestReturn}
                returnSubtotal={this.props.returnSubtotal}
              />
            </div>
          </div>
        </div>
      </div>
    );
  }
}

StepOneContainer.propTypes = propTypes;
StepOneContainer.defaultProps = defaultProps;
function mapStateToProps(state) {
  return {
    returnSubtotal: state.returnsData.returnSubtotal,
    returnArray: state.returnsData.returnArray,
    orderData: state.orderData,
  };
}
function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(AppActions, dispatch),
  };
}
export default connect(mapStateToProps, mapDispatchToProps)(StepOneContainer);
