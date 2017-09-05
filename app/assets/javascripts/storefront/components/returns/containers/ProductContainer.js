import React, { Component, PropTypes } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import autoBind from 'auto-bind';
import classnames from 'classnames';
import * as AppActions from '../actions/index';
import ProductListItem from '../components/ProductListItem';
import noop from '../../../libs/noop';

const propTypes = {
  activeTextBox: PropTypes.number,
  canUpdateReturnArray: PropTypes.bool,
  confirmationPage: PropTypes.bool,
  product: PropTypes.object.isRequired,
  hasError: PropTypes.bool,
  internationalCustomer: PropTypes.bool,
  lastChild: PropTypes.bool,
  orderData: PropTypes.object,
  orderNumber: PropTypes.string,
  orderIndex: PropTypes.number,
  returnArray: PropTypes.array.isRequired,
  returnSubtotal: PropTypes.number,
  returnEligible: PropTypes.bool,
  showForm: PropTypes.bool,
  // Functions
  removeProductFromReturnArray: PropTypes.func,
  updatePrimaryReturnReason: PropTypes.func,
  updateOpenEndedReturnReason: PropTypes.func,
  addProductToReturnArray: PropTypes.func,
  // Redux Functions
  populateLogisticsData: PropTypes.func.isRequired,
};

const defaultProps = {
  activeTextBox: null,
  canUpdateReturnArray: false,
  confirmationPage: false,
  checkboxStatus: false,
  hasError: false,
  internationalCustomer: false,
  lastChild: false,
  orderData: null,
  orderIndex: null,
  orderNumber: '',
  returnEligible: true,
  returnSubtotal: 0,
  showForm: false,
  addProductToReturnArray: noop,
  removeProductFromReturnArray: noop,
  updatePrimaryReturnReason: noop,
  updateOpenEndedReturnReason: noop,
};


class ProductContainer extends Component {
  constructor() {
    super();
    autoBind(this);
  }

  findReturnRequestedItems() {
    return this.props.orderData.items.filter(li => (li.line_item.returns_meta)).map(li => ({
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
      activeTextBox,
      canUpdateReturnArray,
      confirmationPage,
      hasError,
      lastChild,
      orderNumber,
      internationalCustomer,
      orderIndex,
      product,
      returnArray,
      returnEligible,
      showForm,
      updatePrimaryReturnReason,
      updateOpenEndedReturnReason,
    } = this.props;
    const checkboxStatus = returnArray.filter(r => r.id === product.id).length > 0;
    return (
      <div
        className={classnames(
        'ProductContainer',
        { 'ProductContainer__last-child': lastChild },
      )}
      >
        <ProductListItem
          activeTextBox={activeTextBox}
          canUpdateReturnArray={canUpdateReturnArray}
          confirmationPage={confirmationPage}
          checkboxStatus={checkboxStatus}
          internationalCustomer={internationalCustomer}
          orderIndex={orderIndex}
          orderNumber={orderNumber}
          product={product}
          returnArray={returnArray}
          returnEligible={returnEligible}
          showForm={showForm}
          handlePopulateLogistics={this.handlePopulateLogistics}
          hasError={hasError}
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
