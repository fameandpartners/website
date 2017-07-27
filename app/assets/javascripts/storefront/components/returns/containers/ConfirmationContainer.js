import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import Confirmation from '../components/Confirmation'

const propTypes = {
  returnArray: PropTypes.array.isRequired,
};
let internationalCustomer = true
const ConfirmationContainer = (props) => (
  <Confirmation returnArray={props.returnArray} internationalCustomer={internationalCustomer} />
);

function mapStateToProps(state) {
    return {
        returnArray: state.returnArray
    };
}

ConfirmationContainer.propTypes = propTypes

export default connect(mapStateToProps)(ConfirmationContainer);