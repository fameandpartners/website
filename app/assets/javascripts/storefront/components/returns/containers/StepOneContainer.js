import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { browserHistory } from 'react-router';
import LineItem from '../components/LineItem';
import ProductContainer from './ProductContainer';
import getOrderArray from '../../../libs/getOrderArray';
import * as AppActions from '../actions/index';

const propTypes = {
  orderData: PropTypes.array,
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
    this.state = {
      order: null,
      orderArray: null,
    };
  }
  componentWillMount() {
    const { orderData, actions } = this.props;
    if (orderData === null) {
      actions.getProductData();
      browserHistory.push('/view-orders');
      location.reload();
    } else {
      const activeOrder = this.props.orderData.filter(o =>
        o.number === this.props.params.orderID)[0];
      this.state = {
        order: activeOrder,
        orderArray: getOrderArray(activeOrder.items),
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
    const { shipDate, returnEligible } = order;
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
          <div className="col-10_md-12 u-no-padding-right">
            <p className="ship-date">
                Shipped {shipDate}
            </p>
            <div className="order__container Product__listItem__container">
              {
              orderArray.map(productArray => (
                <div key={shipDate}>
                  {
                      productArray.map(p => (
                        <ProductContainer
                          key={Math.random()}
                          product={p}
                          showForm
                          returnEligible={returnEligible}
                        />
                        ))
                  }
                </div>
                ))
            }
            </div>
            <div>
              <LineItem returnSubtotal={this.props.returnSubtotal} />
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
    returnSubtotal: state.returnSubtotal,
    returnArray: state.returnArray,
    orderData: state.orderData,
  };
}
function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(AppActions, dispatch),
  };
}
export default connect(mapStateToProps, mapDispatchToProps)(StepOneContainer);
