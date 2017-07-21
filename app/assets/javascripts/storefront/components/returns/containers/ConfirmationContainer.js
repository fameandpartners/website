import React, {Component} from 'react';
import {connect} from 'react-redux';
import Confirmation from '../components/Confirmation'

class ConfirmationContainer extends Component {
  render() {
    const {returnArray} = this.props
    let internationalCustomer = true
    return (
       <Confirmation returnArray={returnArray} internationalCustomer={internationalCustomer} />
    );
  }
}

function mapStateToProps(state) {
    return {
        returnArray: state.returnArray
    };
}
export default connect(mapStateToProps)(ConfirmationContainer);