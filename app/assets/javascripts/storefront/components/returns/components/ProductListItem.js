import { Link } from 'react-router';
import autoBind from 'auto-bind';
import React, { Component, PropTypes } from 'react';
import moment from 'moment';
import PrimaryReturnReasonsObject from '../../../constants/PrimaryReturnReasonsObject';
import Checkbox from './Checkbox';
import Select from '../../shared/Select';
import SimpleButton from '../components/SimpleButton';
import noop from '../../../libs/noop';

const propTypes = {
  product: PropTypes.object.isRequired,
  orderIndex: PropTypes.number,
  activeTextBox: PropTypes.number,
  updatePrimaryReturnReason: PropTypes.func,
  updateOpenEndedReturnReason: PropTypes.func,
  returnArray: PropTypes.array.isRequired,
  showForm: PropTypes.bool,
  confirmationPage: PropTypes.bool,
  returnEligible: PropTypes.bool.isRequired,
  checkboxStatus: PropTypes.bool,
  updateReturnArray: PropTypes.func,
  orderNumber: PropTypes.string,
};

const defaultProps = {
  activeTextBox: null,
  updatePrimaryReturnReason: null,
  updateOpenEndedReturnReason: null,
  updateReturnArray: noop,
  showForm: false,
  confirmationPage: false,
  returnEligible: true,
  checkboxStatus: false,
  orderIndex: 0,
  orderNumber: '',
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
  componentDidMount() {
    const { product, activeTextBox } = this.props;
    const { id } = product;
    if (id === activeTextBox) {
      this.textInput.focus();
    }
  }
  handleUpdate() {
    return () => this.props.updateReturnArray(this.props.checkboxStatus);
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
        } = product;
    const { openEndedReturnReason, products_meta, price, primaryReturnReason } = product;
    const productMeta = products_meta;
    const { name, size, color, image } = productMeta;
    const heightValue = productMeta.height_value;
    const primaryReturnReasonArray = this.generateOptions(PrimaryReturnReasonsObject);
    return (
      <div
        className={confirmationPage ? 'grid-noGutter' : 'grid-noGutter-middle-spaceAround u-background-white'}
      >
        <div className="col-6_md-9_sm-5_xs-9 Product__listItem">
          <Checkbox
            id={`${id}-checkbox`}
            wrapperClassName={returnEligible ? 'Modal__content--med-margin-bottom' : 'u-no-opacity'}
            onChange={this.handleUpdate()}
            checkboxStatus={checkboxStatus}
            showForm={showForm}
          />
          <img src={image} alt={name} className="product-image" />
          <div>
            <div className="nameAndPrice--marginBottom">
              <span className="meta--key">
                {name}
              </span>
              <span className="meta--value">
                ${Number(price).toFixed(2)}
              </span>
            </div>
            <div className="meta--marginBottom">
              <span className="meta--key">
                Size:
              </span>
              <span className="meta--value">
                {size}
              </span>
            </div>
            <div className="meta--marginBottom">
              <span className="meta--key">
                Color:
              </span>
              <span className="meta--value">
                {color}
              </span>
            </div>
            <div className="meta--marginBottom">
              <span className="meta--key">
                Height:
              </span>
              <span className="meta--value">
                {Math.floor(heightValue / 12)}ft {heightValue % 12}in
              </span>
            </div>
          </div>
        </div>
        <div className={!returnEligible && showForm ? 'col-4_md-9_xs-9' : 'u-hide'}>
          <div className="grid-center">
            <div className="returnWindowPassed__container">
              <div className="col-12">
                <p className="windowClosed-copy">
                      Your 30-day return window closed on <br />
                  {returnWindowEnd} and this item is no longer eligible for a return.
                    </p>
              </div>
              <div className="col-12">
                <ul className="windowClosed-list">
                  <li>
                    <a href="https://www.fameandpartners.com/faqs#collapse-returns-policy" rel="noopener noreferrer" target="_blank">View Return Policy</a>
                  </li>
                  <li>
                    <a href="https://www.fameandpartners.com/contact" rel="noopener noreferrer" target="_blank">Contact Customer Service</a>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <div className={showForm ? 'u-hide' : 'col-4_md-9_xs-9 returnButton__container'}>
          <div className={orderIndex === 0 ? 'grid-spaceAround' : 'u-hide'}>
            <div className="col-12_md-5_sm-12">
              <SimpleButton
                buttonCopy="Start Return"
                link={`/start-return/${orderNumber}`}
                localLink
                withLink
              />
            </div>
          </div>
        </div>
        <div className={showForm ? 'col-4_md-9_xs-9 Form__Container' : 'u-hide'}>
          <div className={showForm && checkboxStatus && returnEligible ? 'u-show' : 'u-hide'}>
            <form>
              <p className="u-no-margin">Why are you returning this?</p>
              <Select
                id={`${id}-primary`}
                options={primaryReturnReasonArray}
                onChange={this.updatePrimaryReason}
                label={primaryReturnReason ? null : 'Please select an option'}
              />
              <div className={primaryReturnReason ? 'u-show' : 'u-no-opacity'}>
                <p className="u-no-margin">
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
      </div>
    );
  }
}
ProductListItem.propTypes = propTypes;
ProductListItem.defaultProps = defaultProps;

export default ProductListItem;
