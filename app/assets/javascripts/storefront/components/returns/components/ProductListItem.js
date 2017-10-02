import React, { Component, PropTypes } from 'react';
import autoBind from 'auto-bind';
import classnames from 'classnames';

// Constants
import PrimaryReturnReasonsObject from '../../../constants/PrimaryReturnReasonsObject';
import noop from '../../../libs/noop';

// Utilities
import { displayHeight } from '../../../utilities/convertHeight';

// UI Components
import Checkbox from './Checkbox';
import Select from '../../shared/Select';
import SimpleButton from '../components/SimpleButton';
import ShippingInfo from './ShippingInfo';

const propTypes = {
  activeTextBox: PropTypes.number,
  canUpdateReturnArray: PropTypes.bool,
  confirmationPage: PropTypes.bool,
  checkboxStatus: PropTypes.bool,
  hasError: PropTypes.bool,
  internationalCustomer: PropTypes.bool,
  orderIndex: PropTypes.number,
  orderNumber: PropTypes.string,
  product: PropTypes.object.isRequired,
  returnArray: PropTypes.array.isRequired,
  returnEligible: PropTypes.bool.isRequired,
  showForm: PropTypes.bool,
  returnRequested: PropTypes.bool,
  handlePopulateLogistics: PropTypes.func,
  updateReturnArray: PropTypes.func,
  updatePrimaryReturnReason: PropTypes.func,
  updateOpenEndedReturnReason: PropTypes.func,
};

const defaultProps = {
  activeTextBox: null,
  canUpdateReturnArray: false,
  checkboxStatus: false,
  confirmationPage: false,
  hasError: false,
  internationalCustomer: false,
  orderIndex: 0,
  orderNumber: '',
  returnEligible: true,
  returnRequested: false,
  showForm: false,
  updatePrimaryReturnReason: null,
  updateOpenEndedReturnReason: null,
  handlePopulateLogistics: noop,
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
    const { returnEligible, showForm, orderIndex, product, returnRequested } = this.props;
    const { returns_meta: returnsMeta } = product;
    const NOT_RETURNABLE = !returnEligible && orderIndex === 0 && !returnRequested;
    const SHOW_FORM = showForm;
    const SHOW_RETURN_BUTTON = !showForm && returnEligible && orderIndex === 0 && !returnRequested;
    const SHOW_LOGISTICS_DATA = returnsMeta && orderIndex === 0 && returnRequested;
    return {
      NOT_RETURNABLE,
      SHOW_FORM,
      SHOW_RETURN_BUTTON,
      SHOW_LOGISTICS_DATA,
    };
  }
  handleUpdate() {
    const { canUpdateReturnArray } = this.props;

    return () => {
      if (canUpdateReturnArray) {
        this.props.updateReturnArray(this.props.checkboxStatus);
      }
    };
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
  pluralizeWord(count, word) {
    if (count === 1) {
      return word;
    }
    return `${word}s`;
  }
  showCharLimit(maxCharacterCount) {
    const { product } = this.props;
    const { openEndedReturnReason } = product;
    if (!openEndedReturnReason) {
      return false;
    }
    const charactersRemaining = maxCharacterCount - openEndedReturnReason.length;
    const characterCopy = this.pluralizeWord(charactersRemaining, 'character');
    return (
      <span
        className={classnames(
          { 'u-warning-text': charactersRemaining <= 20 },
          { 'u-hide': charactersRemaining > 100 },
      )}
      >
        {charactersRemaining} {characterCopy} left
      </span>
    );
  }

  componentDidUpdate() {
    const { product, activeTextBox } = this.props;
    const { id } = product;
    if (id === activeTextBox) {
      this.textInput.focus();
    }
  }

  render() {
    const {
      canUpdateReturnArray,
      confirmationPage,
      checkboxStatus,
      hasError,
      internationalCustomer,
      orderNumber,
      product,
      returnEligible,
      showForm,
    } = this.props;

    const {
      id,
      returnWindowEnd,
      openEndedReturnReason,
      store_credit_only: storeCreditOnly,
      products_meta: productMeta,
      returns_meta: returnsMeta = {},
      price,
      primaryReturnReason,
    } = product;

    const {
      name,
      height_value: heightValue,
      height_unit: heightUnit,
      size,
      color,
      image,
    } = productMeta;
    const {
      created_at_iso_mdy: returnCreatedAtMdy,
      label_url: labelUrl,
    } = returnsMeta;

    const primaryReturnReasonArray = this.generateOptions(PrimaryReturnReasonsObject);
    const uiState = this.generateUIState();
    const { SHOW_FORM, SHOW_RETURN_BUTTON, SHOW_LOGISTICS_DATA, NOT_RETURNABLE } = uiState;
    const maxCharacterCount = 255;
    return (
      <div
        className={confirmationPage ? 'grid-noGutter' : 'grid-noGutter-spaceAround u-background-white'}
      >
        <div className="col-8_md-10_sm-6_xs-12 Product__listItem">
          <Checkbox
            id={`${id}-checkbox`}
            wrapperClassName={returnEligible ? 'Modal__content--med-margin-bottom' : 'u-no-opacity'}
            onChange={this.handleUpdate()}
            checkboxStatus={checkboxStatus}
            showForm={showForm}
          />
          <img
            onClick={this.handleUpdate()}
            src={image}
            alt={name}
            className={classnames('product-image', { 'u-cursor--pointer': canUpdateReturnArray })}
          />
          <div className="u-line-height-medium">
            {
              storeCreditOnly ?
                <div className="ProductlistItem__meta-container">
                  <span className="ProductlistItem__meta-container-text font-sans-serif">
                    RETURNABLE FOR STORE CREDIT&nbsp;ONLY
                  </span> <br />
                </div>
              :
              null
            }

            <div
              className={classnames(
                'nameAndPrice--marginBottom',
                { 'u-margin-top-medium': storeCreditOnly })
              }
            >
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
                {displayHeight(heightValue, heightUnit)}
              </span>
            </div>
          </div>
        </div>
        {
          SHOW_LOGISTICS_DATA ?
            <div className="col-4_md-7_xs-9">
              <div className="grid-right-spaceAround">
                <ShippingInfo
                  copy={(<span>Return Started <br /> {returnCreatedAtMdy}</span>)}
                  listLinks={(
                    <div>
                      {
                        labelUrl || internationalCustomer ? (
                          <li
                            className="u-textDecoration--underline u-cursor--pointer"
                            onClick={this.handlePrintLabelClick}
                          >
                            {internationalCustomer ? 'View Return Instructions' : 'Print Label' }
                          </li>
                        )
                        :
                        (
                          <li
                            className="u-textDecoration--underline u-cursor--pointer"
                          >
                            <a href="/contact">Contact Customer Service</a>
                          </li>
                        )
                      }
                    </div>
                  )}
                />
              </div>
            </div>
            :
            null
        }
        {
          NOT_RETURNABLE ?
            <div className="col-4_md-9_xs-9">
              <div className="grid-right-spaceAround">
                <ShippingInfo
                  grayBackground
                  copy={(
                    <span>
                      This order is not eligible for a refund
                      because you elected the return discount of 10%.
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
            <div className="col-4_md-9_xs-12 returnButton__container grid-spaceAround">
              <div className="col-12_md-5_sm-12">
                <SimpleButton
                  big
                  containerClassName="SimpleButton__container--right-align"
                  className="u-width-full"
                  buttonCopy="Start Return"
                  link={`/start-return/${orderNumber}`}
                  localLink
                  withLink
                />
              </div>
            </div>
            :
            null
        }
        {
          SHOW_FORM ?
            <div className="col-4_md-9_xs-12 Form__Container">
              <div className={checkboxStatus ? 'u-show' : 'u-hide'}>
                <form>
                  <p className="u-no-margin-top">Why are you returning this?</p>
                  <Select
                    ref={(prc) => { this.prc = prc; }}
                    id={`${id}-primary`}
                    options={primaryReturnReasonArray}
                    onChange={this.updatePrimaryReason}
                    label={primaryReturnReason ? null : 'Please select an option'}
                    error={hasError}
                    focusOnError
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
                      maxLength={maxCharacterCount}
                    />
                    {this.showCharLimit(maxCharacterCount)}
                  </div>
                </form>
              </div>
            </div>
            :
            null
        }
        {
          Object.keys(uiState).every(state => !uiState[state]) ?
            <div className="col-4_md-9_xs-12" />
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
