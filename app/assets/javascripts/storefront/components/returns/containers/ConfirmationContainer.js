import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import Confirmation from '../components/Confirmation';

const propTypes = {
  returnArray: PropTypes.array.isRequired,
};
const internationalCustomer = true;
const ConfirmationContainer = ({ returnArray }) => (
  <Confirmation returnArray={returnArray} internationalCustomer={internationalCustomer} />
);

function mapStateToProps(state) {
  return {
    returnArray: state.returnArray,
  };
}

ConfirmationContainer.propTypes = propTypes;

export default connect(mapStateToProps)(ConfirmationContainer);
