import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router';
import autoBind from 'auto-bind';
import moment from 'moment';
import ReactDOM from 'react-dom';

// Constants
import PrimaryReturnReasonsObject from '../../../constants/PrimaryReturnReasonsObject';
import noop from '../../../libs/noop';

// UI Components
import Checkbox from './Checkbox';
import Select from '../../shared/Select';
import SimpleButton from '../components/SimpleButton';
import ShippingInfo from './ShippingInfo';

const propTypes = {
  product: PropTypes.object.isRequired,
  orderIndex: PropTypes.number,
  activeTextBox: PropTypes.number,
  returnArray: PropTypes.array.isRequired,
  showForm: PropTypes.bool,
  confirmationPage: PropTypes.bool,
  returnEligible: PropTypes.bool.isRequired,
  checkboxStatus: PropTypes.bool,
  orderNumber: PropTypes.string,

  handlePopulateLogistics: PropTypes.func,
  updateReturnArray: PropTypes.func,
  updatePrimaryReturnReason: PropTypes.func,
  updateOpenEndedReturnReason: PropTypes.func,
};

const defaultProps = {
  activeTextBox: null,
  showForm: false,
  confirmationPage: false,
  returnEligible: true,
  checkboxStatus: false,
  orderIndex: 0,
  orderNumber: '',
  handlePopulateLogistics: noop,
  updatePrimaryReturnReason: null,
  updateOpenEndedReturnReason: null,
  updateReturnArray: noop,
};

class ProductListItem extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  updatePrimaryReason(reason) {
    const { updatePrimaryReturnReason, product, returnArray } = this.props;
    updatePrimaryReturnReason(reason, product, returnArray);
  }

  updateOpenEndedReason(e) {
    const { updateOpenEndedReturnReason, product, returnArray } = this.props;
    const reason = e.target.value;
    updateOpenEndedReturnReason(reason, product, returnArray);
  }

  generateOptions() {
    const product = this.props;
    const primaryKeys = Object.keys(PrimaryReturnReasonsObject);
    return primaryKeys.map(p => ({
      active: p === product.product.primaryReturnReason,
      name: PrimaryReturnReasonsObject[p].name,
      id: p,
    }));
  }

  generateUIState() {
    const { returnEligible, showForm, orderIndex, product } = this.props;
    const { returns_meta: returnsMeta } = product;
    const WINDOW_CLOSED = showForm && !returnEligible;
    const SHOW_FORM = showForm;
    const SHOW_RETURN_BUTTON = !showForm && returnEligible && orderIndex === 0;
    const SHOW_LOGISTICS_DATA = returnsMeta && orderIndex === 0;
    return {
      WINDOW_CLOSED,
      SHOW_FORM,
      SHOW_RETURN_BUTTON,
      SHOW_LOGISTICS_DATA,
    };
  }
  handleUpdate() {
    return () => this.props.updateReturnArray(this.props.checkboxStatus);
  }

  handlePrintLabelClick() {
    const {
      returns_meta: returnsMeta,
      id: lineItemId,
    } = this.props.product;

    this.props.handlePopulateLogistics(
      {
        line_item_id: lineItemId,
        item_return_label: returnsMeta,
      },
    );
  }

  componentDidMount() {
    const { product, activeTextBox } = this.props;
    const { id } = product;
    if (id === activeTextBox) {
      this.textInput.focus();
    }
    // const rect = ReactDOM.findDOMNode(this)
    //   .getBoundingClientRect();
  }


  render() {
    const {
      product,
      showForm,
      confirmationPage,
      orderIndex,
      checkboxStatus,
      orderNumber,
      returnEligible,
    } = this.props;

    const {
      id,
      returnWindowEnd,
      openEndedReturnReason,
      products_meta: productMeta,
      returns_meta: returnsMeta,
      price,
      primaryReturnReason,
    } = product;

    const {
      name,
      height_value: heightValue,
      size,
      color,
      image,
    } = productMeta;
    const primaryReturnReasonArray = this.generateOptions(PrimaryReturnReasonsObject);
    const uiState = this.generateUIState();
    const { SHOW_FORM, SHOW_RETURN_BUTTON, SHOW_LOGISTICS_DATA, WINDOW_CLOSED } = uiState;

    return (
      <div
        className={confirmationPage ? 'grid-noGutter' : 'grid-noGutter-middle-spaceAround u-background-white'}
      >
        <div className="col-8_md-9_sm-5_xs-12 Product__listItem">
          <Checkbox
            id={`${id}-checkbox`}
            wrapperClassName={returnEligible ? 'Modal__content--med-margin-bottom' : 'u-no-opacity'}
            onChange={this.handleUpdate()}
            checkboxStatus={checkboxStatus}
            showForm={showForm}
          />
          <img src={image} alt={name} className="product-image" />
          <div className="u-line-height-medium">
            <div className="nameAndPrice--marginBottom">
              <span className="meta--key">
                {name}
              </span>
              <span className="meta--value">
                ${Number(price).toFixed(2)}
              </span>
            </div>
            <div>
              <span className="meta--key">
                Size:
              </span>
              <span className="meta--value">
                {size}
              </span>
            </div>
            <div>
              <span className="meta--key">
                Color:
              </span>
              <span className="meta--value">
                {color}
              </span>
            </div>
            <div>
              <span className="meta--key">
                Height:
              </span>
              <span className="meta--value">
                {Math.floor(heightValue / 12)}ft {heightValue % 12}in
              </span>
            </div>
          </div>
        </div>
        {
          SHOW_LOGISTICS_DATA ?
            <div className="col-4_md-9_xs-11">
              <div className="grid-right">
                <ShippingInfo
                  copy={(<span>Return Started <br /> MM/DD/YYYY</span>)}
                  listLinks={(
                    <div>
                      <li
                        className="u-underline u-cursor-pointer"
                        onClick={this.handlePrintLabelClick}
                      >
                        Print Label
                      </li>
                    </div>
                  )}
                />
              </div>
            </div>
            :
            null
        }
        {
          WINDOW_CLOSED ?
            <div className="col-4_md-9_xs-11">
              <div className="grid-right">
                <ShippingInfo
                  grayBackground
                  copy={(
                    <span>
                      Your 30-day return window closed on <br />
                      {returnWindowEnd} and this item is no longer eligible for a return.
                    </span>
                  )}
                />
              </div>
            </div>
            :
            null
        }
        {
          SHOW_RETURN_BUTTON ?
            <div className="col-4_md-9_xs-11 returnButton__container">
              <div className="grid-spaceAround">
                <div className="col-12_md-5_sm-12">
                  <SimpleButton
                    className="u-width-full"
                    buttonCopy="Start Return"
                    link={`/start-return/${orderNumber}`}
                    localLink
                    withLink
                  />
                </div>
              </div>
            </div>
            :
            null
        }
        {
          SHOW_FORM ?
            <div className="col-4_md-9_xs-11 Form__Container">
              <div className={checkboxStatus ? 'u-show' : 'u-hide'}>
                <form>
                  <p className="u-no-margin-top">Why are you returning this?</p>
                  <Select
                    id={`${id}-primary`}
                    options={primaryReturnReasonArray}
                    onChange={this.updatePrimaryReason}
                    label={primaryReturnReason ? null : 'Please select an option'}
                  />
                  <div className={primaryReturnReason ? 'u-show' : 'u-no-opacity'}>
                    <p className="u-no-margin-top">
                    Let's get specific. What didn't you like?
                    </p>
                    <textarea
                      onChange={this.updateOpenEndedReason}
                      value={openEndedReturnReason}
                      ref={(text) => { this.textInput = text; }}
                      type="text"
                    />
                  </div>
                </form>
              </div>
            </div>
            :
            null
        }
        {
          Object.keys(uiState).every(state => !uiState[state]) ?
            <div className="col-4_md-9_xs-11" />
            :
            null
        }
      </div>
    );
  }
}
ProductListItem.propTypes = propTypes;
ProductListItem.defaultProps = defaultProps;

export default ProductListItem;
