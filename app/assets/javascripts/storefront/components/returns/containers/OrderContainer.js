import React, {Component} from 'react';
import {bindActionCreators} from 'redux'
import OrderHistory from '../components/OrderHistory'
import * as AppActions from '../actions/index'
import {connect} from 'react-redux';

class OrderContainer extends Component {
  componentWillMount() {
    this.props.actions.getProductData()
  }
  render() {
    const {orderData} = this.props
    if(!orderData) {
      return <div></div>
    }
    return (
        <div>
          <OrderHistory orderData={orderData} />
        </div>
    );
  }
}

function mapStateToProps(state) {
    return {
        orderData: state.orderData,
    };
}
function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(AppActions, dispatch),
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderContainer);