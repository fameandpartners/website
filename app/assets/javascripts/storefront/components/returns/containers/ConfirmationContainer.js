import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import Confirmation from '../components/Confirmation';

const propTypes = {
  returnArray: PropTypes.array.isRequired,
  logisticsData: PropTypes.object.isRequired,
};
const internationalCustomer = false;
const ConfirmationContainer = ({ returnArray, logisticsData }) => (
  <Confirmation
    logisticsData={logisticsData}
    returnArray={returnArray}
    internationalCustomer={internationalCustomer}
  />
);

function mapStateToProps(state) {
  return {
    returnArray: state.returnsData.returnArray,
    logisticsData: state.returnsData.logisticsData,
  };
}

ConfirmationContainer.propTypes = propTypes;

export default connect(mapStateToProps)(ConfirmationContainer);
