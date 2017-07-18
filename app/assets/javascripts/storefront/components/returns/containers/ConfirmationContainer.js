import React, {Component} from 'react';
import {connect} from 'react-redux';
import Confirmation from '../components/Confirmation'

class ConfirmationContainer extends Component {
  constructor(props) {
    super(props)
    const {returnArray} = this.props
    this.state = {
      returnArray: returnArray
    }
  }
  render() {
    const {returnArray} = this.state
    return (
       <Confirmation returnArray={returnArray} />
    );
  }
}

function mapStateToProps(state) {
    return {
        returnArray: state.returnArray
    };
}
export default connect(mapStateToProps)(ConfirmationContainer);