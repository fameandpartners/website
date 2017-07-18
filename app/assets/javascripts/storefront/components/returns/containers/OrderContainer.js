import React, {Component} from 'react';
import {getOrderArray} from '../../../libs/getOrderArray';
import OrderHistory from '../components/OrderHistory'
import {connect} from 'react-redux';

class OrderContainer extends Component {
  constructor(props) {
    super(props)
    const {orderData} = this.props
    const {products} = orderData
    this.state = {
        orderData: orderData,    
        orderArray: getOrderArray(products)    
    }
  }
  render() {
    const {orderData, orderArray} = this.state
    return (
        <div>
          <OrderHistory orderData={orderData} orderArray={orderArray} />
        </div>
    );
  }
}

function mapStateToProps(state) {
    return {
        orderData: state.orderData,
    };
}

export default connect(mapStateToProps)(OrderContainer);