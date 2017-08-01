import React, { Component, PropTypes } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import autoBind from 'auto-bind';
import * as AppActions from '../actions/index';
import ProductListItem from '../components/ProductListItem';
import noop from '../../../libs/noop';

const propTypes = {
  product: PropTypes.object.isRequired,
  returnArray: PropTypes.array.isRequired,
  addProductToReturnArray: PropTypes.func,
  removeProductFromReturnArray: PropTypes.func,
  updatePrimaryReturnReason: PropTypes.func,
  updateOpenEndedReturnReason: PropTypes.func,
  returnSubtotal: PropTypes.number,
  confirmationPage: PropTypes.bool,
  checkboxStatus: PropTypes.bool,
  activeTextBox: PropTypes.number,
  orderIndex: PropTypes.number,
  showForm: PropTypes.bool,
  orderNumber: PropTypes.string,
  returnEligible: PropTypes.bool,
};

const defaultProps = {
  addProductToReturnArray: noop,
  removeProductFromReturnArray: noop,
  updatePrimaryReturnReason: noop,
  updateOpenEndedReturnReason: noop,
  returnSubtotal: 0,
  activeTextBox: null,
  confirmationPage: false,
  checkboxStatus: false,
  showForm: false,
  orderIndex: null,
  returnEligible: true,
  orderNumber: '',
};


class ProductContainer extends Component {
  constructor() {
    super();
    this.state = {
      checkboxStatus: false,
    };
    autoBind(this);
  }
  generateSecondaryOptionArray(optionsObject) {
    const product = this.props;
    const secondaryKeys = Object.keys(optionsObject);
    return secondaryKeys.map(p => ({
      active: p === product.product.secondaryReturnReason,
      name: optionsObject[p].name,
      id: p,
    }));
  }
  updateReturnArray(checkboxStatus) {
    // const { checkboxStatus } = this.state;
    const {
      addProductToReturnArray,
      removeProductFromReturnArray,
      returnSubtotal,
      returnArray,
      product,
    } = this.props;
    if (!checkboxStatus) {
      addProductToReturnArray(product, returnArray, returnSubtotal);
    } else {
      removeProductFromReturnArray(product, returnArray, returnSubtotal);
    }
  }
  render() {
    const {
      orderIndex,
      confirmationPage,
      updatePrimaryReturnReason,
      updateOpenEndedReturnReason,
      product,
      activeTextBox,
      returnArray,
      showForm,
      orderNumber,
      returnEligible,
    } = this.props;
    // const { checkboxStatus } = this.state;
    const checkboxStatus = returnArray.filter(r => r.id === product.id).length > 0;
    return (
      <div>
        <ProductListItem
          product={product}
          confirmationPage={confirmationPage}
          checkboxStatus={checkboxStatus}
          orderIndex={orderIndex}
          updateReturnArray={this.updateReturnArray}
          updatePrimaryReturnReason={updatePrimaryReturnReason}
          updateOpenEndedReturnReason={updateOpenEndedReturnReason}
          activeTextBox={activeTextBox}
          returnArray={returnArray}
          showForm={showForm}
          orderNumber={orderNumber}
          returnEligible={returnEligible}
        />
      </div>
    );
  }
}

function mapStateToProps(state) {
  return {
    returnArray: state.returnArray,
    returnSubtotal: state.returnSubtotal,
    activeTextBox: state.activeTextBox,
  };
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators(AppActions, dispatch);
}

ProductContainer.propTypes = propTypes;
ProductContainer.defaultProps = defaultProps;

export default connect(mapStateToProps, mapDispatchToProps)(ProductContainer);
