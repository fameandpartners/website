import { Link } from 'react-router';
import autoBind from 'auto-bind';
import React, { Component, PropTypes } from 'react';
import moment from 'moment';
import PrimaryReturnReasonsObject from '../../../constants/PrimaryReturnReasonsObject';
import Checkbox from './Checkbox';
import Select from '../../shared/Select';
import Button from '../components/Button';
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
  checkboxStatus: false,
  orderIndex: 0,
  orderNumber: '',
};

class ProductListItem extends Component {
  constructor() {
    super();
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
  render() {
    const {
      product,
      showForm,
      confirmationPage,
      orderIndex,
      checkboxStatus,
      updateReturnArray,
      orderNumber,
    } = this.props;
    const {
          id,
          orderPlaced,
          returnWindowEnd,
        } = product;
    let { primaryReturnReason } = product;
    const { openEndedReturnReason, productMeta, price } = product;
    const { name, size, color, image } = productMeta;
    const heightValue = productMeta.height_value;
    if (!primaryReturnReason) {
      primaryReturnReason = {};
    }
    const primaryReturnReasonArray = this.generateOptions(PrimaryReturnReasonsObject);
    const currentDay = moment();
    const lastDay = moment(new Date(orderPlaced));
    const lastDayArray = moment([[lastDay.format('YYYY')][0], [lastDay.format('M')][0], [lastDay.format('D')][0]]);
    const currentDayArray = moment([[currentDay.format('YYYY')][0], [currentDay.format('M')][0], [currentDay.format('D')][0]]);
    const returnEligible = currentDayArray.diff(lastDayArray, 'days') < 50;
    return (
      <div
        className={confirmationPage || showForm ? 'grid-noGutter-center' : 'grid-noGutter-center'}
      >
        <div className="col-7_md-9_sm-5_xs-9 Product__listItem">
          <Checkbox
            id={`${id}-checkbox`}
            wrapperClassName={returnEligible ? 'Modal__content--med-margin-bottom' : 'u-no-opacity'}
            onChange={() => updateReturnArray()}
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
                ${price}
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
        <div className={!returnEligible && showForm ? 'col-4_md-10_sm-10_xs-12 returnWindowPassed__container' : 'u-hide'}>
          <div className="grid-middle">
            <div className="col-12">
              <p className="windowClosed-copy">
                Return window closed on <br />
                {returnWindowEnd}
              </p>
            </div>
            <div className="col-12">
              <ul className="windowClosed-list">
                <li>
                  <a href="https://www.fameandpartners.com/faqs#collapse-returns-policy">View Return Policy</a>
                </li>
                <li>
                  <a href="https://www.fameandpartners.com/contact">Contact Customer Service</a>
                </li>
              </ul>
            </div>
          </div>

        </div>
        <div className={showForm ? 'u-hide' : 'col-3_md-9_xs-9 returnButton__container'}>
          <div className={orderIndex === 0 ? 'grid-spaceAround' : 'u-hide'}>
            <Button primary className="col-12_md-5_sm-12">
              <Link
                to={`/start-return/${orderNumber}`}
                className="u-white-text button-link"
              >
                Start Return
              </Link>
            </Button>
          </div>
        </div>
        <div className={showForm ? 'col-4_md-10_sm-10_xs-12 Form__Container' : 'u-hide'}>
          <div className={showForm && checkboxStatus && returnEligible ? 'u-show' : 'u-hide'}>
            <form>
              <p className="u-no-margin">Why are you returning this?</p>
              <Select
                id={`${id}-primary`}
                options={primaryReturnReasonArray}
                onChange={this.updatePrimaryReason}
              />
              <div className={primaryReturnReason ? 'u-show' : 'u-hide'}>
                <p className="u-no-margin">Let us know what you didn’t like.</p>
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
