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
  render() {
    const { order, orderArray } = this.state;
    if (!order) {
      return <div />;
    }
    const { shipDate } = order;
    return (
      <div className="StepOne__Container">
        <div className="grid-noGutter-center">
          <div className="col-10_md-10_sm-11">
            <p className="instructions instructions__title">Sorry it didn't work out.
                <br /> Please select the item(s) you would like to return
            </p>
            <p className="instructions instructions__subtitle">
                Please note that any item must be in new, unused and resalable condition,
                with the DO NOT REMOVE tag still attached in the same place as
                originally sent.
            </p>
          </div>
        </div>
        <div className="grid-noGutter-center">
          <div className="col-10_md-12_sm-12">
            {
              orderArray.map(productArray => (
                <div key={shipDate}>
                  <p className="ship-date">
                      Shipped {shipDate}
                  </p>
                  <div className="Product__listItem__container">
                    {
                        productArray.map(p => (
                          <ProductContainer
                            key={Math.random()}
                            product={p}
                            showForm
                          />
                          ))
                      }
                  </div>
                </div>
                ))
            }
          </div>
        </div>
        <LineItem returnSubtotal={this.props.returnSubtotal} />
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
