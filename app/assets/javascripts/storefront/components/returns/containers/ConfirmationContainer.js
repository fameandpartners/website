/* global window */
import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import autobind from 'auto-bind';
import Confirmation from '../components/Confirmation';
import scroll from 'scroll';

const page = require('scroll-doc')();

const propTypes = {
  orderData: PropTypes.object.isRequired,
  logisticsData: PropTypes.object.isRequired,
};

class ConfirmationContainer extends Component {
  constructor(props) {
    super(props);
    autobind(this);
  }

  componentWillMount() {
    if (this.props.logisticsData && !this.props.logisticsData.order_id) {
      window.location = '/view-orders';
    }
  }

  componentDidMount() {

  }

  render() {
    const { orderData, logisticsData } = this.props;
    if (logisticsData) {
      scroll.top(page, 0);
    }
    return (
      <Confirmation
        orderData={orderData}
        logisticsData={logisticsData}
      />
    );
  }

}
function mapStateToProps(state) {
  return {
    orderData: state.orderData,
    logisticsData: state.returnsData.logisticsData,
  };
}

ConfirmationContainer.propTypes = propTypes;

export default connect(mapStateToProps)(ConfirmationContainer);
