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
  orderData: PropTypes.object,
  orderIndex: PropTypes.number,
  showForm: PropTypes.bool,
  orderNumber: PropTypes.string,
  returnEligible: PropTypes.bool,
  // Redux Functions
  populateLogisticsData: PropTypes.func,
};

const defaultProps = {
  returnSubtotal: 0,
  activeTextBox: null,
  confirmationPage: false,
  checkboxStatus: false,
  showForm: false,
  orderIndex: null,
  returnEligible: true,
  orderData: null,
  orderNumber: '',
  addProductToReturnArray: noop,
  removeProductFromReturnArray: noop,
  updatePrimaryReturnReason: noop,
  updateOpenEndedReturnReason: noop,
};


class ProductContainer extends Component {
  constructor() {
    super();
    autoBind(this);
    this.state = {
      checkboxStatus: false,
    };
  }

  findReturnRequestedItems() {
    return this.props.orderData.items.filter(li => (li.line_item.returns_meta && li.line_item.returns_meta.return_item_state === 'requested')).map(li => ({
      line_item_id: li.line_item.id,
      item_return_label: li.line_item.returns_meta,
    }));
  }

  handlePopulateLogistics() {
    this.props.populateLogisticsData(
      {
        order: this.props.orderData.spree_order,
        lineItems: this.findReturnRequestedItems(),
      });
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
    const checkboxStatus = returnArray.filter(r => r.id === product.id).length > 0;
    return (
      <div>
        <ProductListItem
          product={product}
          confirmationPage={confirmationPage}
          checkboxStatus={checkboxStatus}
          activeTextBox={activeTextBox}
          returnArray={returnArray}
          showForm={showForm}
          orderIndex={orderIndex}
          orderNumber={orderNumber}
          returnEligible={returnEligible}
          handlePopulateLogistics={this.handlePopulateLogistics}
          updateReturnArray={this.updateReturnArray}
          updatePrimaryReturnReason={updatePrimaryReturnReason}
          updateOpenEndedReturnReason={updateOpenEndedReturnReason}
        />
      </div>
    );
  }
}

function mapStateToProps(state) {
  return {
    returnArray: state.returnsData.returnArray,
    returnSubtotal: state.returnsData.returnSubtotal,
    activeTextBox: state.activeTextBox,
  };
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators(AppActions, dispatch);
}

ProductContainer.propTypes = propTypes;
ProductContainer.defaultProps = defaultProps;

export default connect(mapStateToProps, mapDispatchToProps)(ProductContainer);
