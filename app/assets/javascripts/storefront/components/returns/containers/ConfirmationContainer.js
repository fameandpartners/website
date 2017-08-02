import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import Confirmation from '../components/Confirmation';

const propTypes = {
  orderData: PropTypes.object.isRequired,
  logisticsData: PropTypes.object.isRequired,
};

const ConfirmationContainer = ({ logisticsData, orderData }) => (
  <Confirmation
    orderData={orderData}
    logisticsData={logisticsData}
  />
);

function mapStateToProps(state) {
  return {
    orderData: state.orderData,
    logisticsData: state.returnsData.logisticsData,
  };
}

ConfirmationContainer.propTypes = propTypes;

export default connect(mapStateToProps)(ConfirmationContainer);
