import React, {Component} from 'react';
import {bindActionCreators} from 'redux';
import {connect} from 'react-redux';
import * as AppActions from '../actions/index'
import autoBind from 'auto-bind'
import generateSecondaryObject from '../../../libs/generateSecondaryReasons'
import ProductListItem from '../components/ProductListItem'

class ProductContainer extends Component {
	constructor(props) {
		super(props)
		const { product,
			    showForm,
			    orderIndex,
			    confirmationPage,
			    returnSubtotal,
			    activeTextBox 
		} = this.props
		this.state = {
			product: product,
			showForm: showForm,
			orderIndex: orderIndex,
			confirmationPage: confirmationPage,
			returnSubtotal: returnSubtotal,
			activeTextBox: activeTextBox,
			checkboxStatus: false,
			secondaryReturnReasonsArray: [],
		}
		autoBind(this);
	}
	generateSecondaryOptionArray(optionsObject) {
	  const product = this.props
	  const {secondaryReturnReason} = product
	  let secondaryKeys = Object.keys(optionsObject)
	  return secondaryKeys.map(p => {
	    return {
	      active: p === product.product.secondaryReturnReason,
	      name: optionsObject[p].name,
	      id: p
	    }
	  })
	}
	componentWillMount() {
		const {product, checkboxStatus} = this.state
		const {returnArray} = this.props
		const {secondaryReturnReason} = product
		let currentCheckboxStatus = checkboxStatus
		returnArray.map(r => {
			if(r.productOrderID === product.productOrderID) {
				currentCheckboxStatus = true
				return true
			}
			return false
		})
		let secondaryReasonsObject = generateSecondaryObject(product.primaryReturnReason)
		let secondaryReturnReasonsArray = this.generateSecondaryOptionArray(secondaryReasonsObject)
		this.setState({
			checkboxStatus: currentCheckboxStatus,
			secondaryReturnReasonsArray: secondaryReturnReasonsArray
		});
	}
	updateReturnArray() {
		const {checkboxStatus, product} = this.state
		const {addProductToReturnArray, removeProductFromReturnArray, returnSubtotal, returnArray} = this.props
		if(!checkboxStatus){	
			addProductToReturnArray(product, returnArray, returnSubtotal)
		} else {	
			removeProductFromReturnArray(product, returnArray, returnSubtotal)
		}
	}
	render() {
		const {	orderIndex, 
				confirmationPage, 
				checkboxStatus, 
				secondaryReturnReasonsArray, 
		} = this.state 
		return (
		  <div>
			 <ProductListItem 
			 {...this.props} 
			 confirmationPage={confirmationPage} 
			 checkboxStatus={checkboxStatus}
			 secondaryReturnReasonsArray={secondaryReturnReasonsArray}
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
function matchDispatchToProps(dispatch){
    return bindActionCreators(AppActions, dispatch);
}
export default connect(mapStateToProps, matchDispatchToProps)(ProductContainer);