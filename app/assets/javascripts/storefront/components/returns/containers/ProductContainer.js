import React, { Component, PropTypes} from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import autoBind from 'auto-bind';
import * as AppActions from '../actions/index'
import ProductListItem from '../components/ProductListItem'

const propTypes = {
  product: PropTypes.object.isRequired,
  returnArray: PropTypes.array.isRequired,
  addProductToReturnArray: PropTypes.func,
  removeProductFromReturnArray: PropTypes.func,
  returnSubtotal: PropTypes.number,
  checkboxStatus: PropTypes.bool,
  confirmationPage: PropTypes.bool,
  orderIndex: PropTypes.number,
};

const defaultProps = {
	addProductToReturnArray: null,
	removeProductFromReturnArray: null,
	returnSubtotal: 0,
	confirmationPage: false,
	checkboxStatus: false,
	orderIndex: null,
};


class ProductContainer extends Component {
  constructor() {
    super();
    this.state = {
      checkboxStatus: false,
    }
    autoBind(this);
  }
  generateSecondaryOptionArray(optionsObject) {
    const product = this.props
    let secondaryKeys = Object.keys(optionsObject)
    return secondaryKeys.map(p => {
      return {
        active: p === product.product.secondaryReturnReason,
        name: optionsObject[p].name,
        id: p
      }
    });
  }
  updateReturnArray() {
    const { checkboxStatus } = this.state
    const { product } = this.props
    const {
      addProductToReturnArray,
      removeProductFromReturnArray,
      returnSubtotal,
      returnArray
    } = this.props
    if (!checkboxStatus) {
      addProductToReturnArray(product, returnArray, returnSubtotal)
    } else {
      removeProductFromReturnArray(product, returnArray, returnSubtotal)
    }
  }
  componentWillMount() {
    const { checkboxStatus } = this.props
    const { returnArray, product } = this.props
    let currentCheckboxStatus = checkboxStatus
    returnArray.map(r => {
      if (r.id === product.id) {
        currentCheckboxStatus = true
        return true
      }
      return false
    });
    this.setState({
      checkboxStatus: currentCheckboxStatus,
    });
  }
  render() {
    const {
      orderIndex,
      confirmationPage,
    } = this.props
    const { checkboxStatus } = this.state
    return ( 
    <div>
      <ProductListItem { ...this.props } 
      	confirmationPage={confirmationPage} 
      	checkboxStatus={checkboxStatus} 
      	orderIndex={orderIndex} 
      	updateReturnArray={() => this.updateReturnArray()}
      />
    </div>
    )
  }
}

function mapStateToProps(state) {
  return {
    returnArray: state.returnArray,
    returnSubtotal: state.returnSubtotal,
    activeTextBox: state.activeTextBox
  };
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators(AppActions, dispatch);
}

ProductContainer.propTypes = propTypes;
ProductContainer.defaultProps = defaultProps;

export default connect(mapStateToProps, mapDispatchToProps)(ProductContainer);
