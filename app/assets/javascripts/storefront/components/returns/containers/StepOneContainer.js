import React, {Component, PropTypes} from 'react';
import {connect} from 'react-redux';
import LineItem from '../components/LineItem'
import ReturnNavigation from '../components/ReturnNavigation'
import ProductContainer from './ProductContainer'
import {getOrderArray} from '../../../libs/getOrderArray';

const propTypes = {
  orderData: PropTypes.object.isRequired,
  returnSubtotal: PropTypes.number.isRequired,
};

class StepOneContainer extends Component {
  constructor(props) {
    super(props)
    this.state = {
      order: this.props.orderData,
      orderArray: getOrderArray(this.props.orderData['items'])
    }
  } 
  render() {
    let {order, orderArray} = this.state
    let {shipDate} = order
    return (
        <div className="StepOne__Container">
            <div className="grid-noGutter-center">
              <div className="col-10_md-10_sm-11">
                  <p className="instructions instructions__title">Sorry it didn't work out.
                      <br/> Please select the item(s) you would like to return                      
                  </p>
                  <p className="instructions instructions__subtitle">
                      Please note that any item must be in new, unused and resalable condition, 
                      with the DO NOT REMOVE tag still attached in the same place as 
                      originally sent.
                  </p>
              </div>
            </div>                        
            <div className="grid-noGutter-center">
              <div className="col-10_md-12_sm-12">
                {
                  orderArray.map(productArray => {
                    return (
                      <div key={Math.random()}>
                        <p className="ship-date">
                          Shipped {shipDate}
                        </p>
                        <div key={Math.random()} className="Product__listItem__container">
                          {
                            productArray.map(p => {
                              return (
                                <ProductContainer
                                  key={Math.random()} 
                                  product={p} 
                                  showForm={true}
                                />
                              )
                            })
                          }
                        </div>
                      </div>
                    )
                  })
                }
              </div>
            </div>
            <LineItem returnSubtotal={this.props.returnSubtotal} />
        </div>
    );
  }
}

StepOneContainer.propTypes = propTypes;

function mapStateToProps(state) {
    return {
        returnSubtotal: state.returnSubtotal,
        returnArray: state.returnArray,
        orderData: state.orderData
    };
}
export default connect(mapStateToProps)(StepOneContainer);