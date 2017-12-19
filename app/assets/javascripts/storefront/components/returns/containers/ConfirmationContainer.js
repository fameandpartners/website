/* eslint-disable */
/* global window */
import React from 'react';
import { connect } from 'react-redux';
import autobind from 'auto-bind';
import scroll from 'scroll';
import scrollDoc from 'scroll-doc';
import Confirmation from '../components/Confirmation';

const scrollElement = scrollDoc();

// const propTypes = {
//   orderData: PropTypes.array.isRequired,
//   logisticsData: PropTypes.object.isRequired,
// };

class ConfirmationContainer extends React.Component {
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
      scroll.top(scrollElement, 0);
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
    orderData: state.orderData.orders,
    logisticsData: state.returnsData.logisticsData,
  };
}

// ConfirmationContainer.propTypes = propTypes;

export default connect(mapStateToProps)(ConfirmationContainer);
