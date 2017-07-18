import {Link} from 'react-router'
import autoBind from 'auto-bind'
import React, {Component, PropTypes} from 'react';
import PrimaryReturnReasonsObject from '../../../constants/PrimaryReturnReasonsObject'
import Checkbox from './Checkbox'
import Select from '../../shared/Select'
import Button from '../components/Button'

const propTypes = {
  product: PropTypes.object.isRequired,
  orderIndex: PropTypes.number.isRequired,
  activeTextBox: PropTypes.number,
  updatePrimaryReturnReason: PropTypes.func,
  updateOpenEndedReturnReason: PropTypes.func,
  returnArray: PropTypes.array.isRequired,
  showForm: PropTypes.bool,
  confirmationPage: PropTypes.bool,
  checkboxStatus: PropTypes.bool,
  updateReturnArray: PropTypes.func,
};

const defaultProps = {
  activeTextBox: null,
  updatePrimaryReturnReason: null,
  updateOpenEndedReturnReason: null,
  updateReturnArray: null,
  showForm: false,
  confirmationPage: false,
  checkboxStatus: false,
};


class ProductListItem extends Component {
  constructor() {
    super()
    autoBind(this);
  }
  updatePrimaryReason(reason) {
    const {updatePrimaryReturnReason, product, returnArray} = this.props
    updatePrimaryReturnReason(reason, product, returnArray)
  }
  updateOpenEndedReason(e) {
    const {updateOpenEndedReturnReason, product, returnArray} = this.props
    const reason = e.target.value
    updateOpenEndedReturnReason(reason, product, returnArray)
  }
  generateOptions() {
    const product = this.props
    let primaryKeys = Object.keys(PrimaryReturnReasonsObject)
    return primaryKeys.map(p => {
      return {
        active: p === product.product.primaryReturnReason,
        name: PrimaryReturnReasonsObject[p].name,
        id: p
      }
    })
  }
  componentDidMount() {
    const {product, activeTextBox} = this.props
    const {productOrderID} = product
    if(productOrderID === activeTextBox) {
      this.textInput.focus()
    }
  }
  render() {
    const {
      product,
      showForm,
      confirmationPage,
      orderIndex,
      checkboxStatus, 
      updateReturnArray
    } = this.props
    const { productName,
          productOrderID, 
          image, 
          price, 
          auSize, 
          usSize, 
          color, 
          height, 
        } = product
    let {primaryReturnReason} = product
    const {openEndedReturnReason} = product
    if(!primaryReturnReason) {
      primaryReturnReason = {}
    }
    const primaryReturnReasonArray = this.generateOptions(PrimaryReturnReasonsObject)
    return (
          <div 
            key={productOrderID}
            className={confirmationPage || showForm ? "grid-noGutter-center" : "grid-noGutter-center"}
          >
           <div className="col-7_md-9_sm-5_xs-9 Product__listItem">
              <Checkbox 
                id={`${productOrderID}-checkbox`}
                wrapperClassName="Modal__content--med-margin-bottom"
                onChange={() => updateReturnArray()}
                checkboxStatus={checkboxStatus} 
                showForm={showForm} 
              />  

              <img src={image} alt={productName} className="product-image" />
              <div>
                <div className="nameAndPrice--marginBottom">
                  <span className="meta--key">
                    {productName}
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
                    US {usSize}/AU {auSize}
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
                    {height}
                  </span>
                </div>
              </div>          
           </div>
           <div className={!showForm ? "col-3_md-9_xs-9 ReturnButton__Container" : "u-hide"}>
                <div className={orderIndex === 0 ? "grid-spaceAround" : "u-hide"}>
                  <Button className="col-12_md-5_sm-12">
                    <a 
                      href="https://www.ups.com/WebTracking/track?loc=en_us" 
                      className="button-link button-link--black-text"
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                      Track Shipping
                    </a>
                  </Button>
                  <Button primary className="col-12_md-5_sm-12">
                    <Link 
                      to={'/start-return/123'}
                      className="u-white-text button-link"
                    >
                      Start Return
                    </Link>
                  </Button>
                </div>
              </div>
             <div className={showForm ? "col-4_md-10_sm-10_xs-12 Form__Container" : "u-hide"}>
                <div className={showForm && checkboxStatus ? "u-show" : "u-hide"}>
                 <form>
                       <p className="u-no-margin">Why are you returning this?</p>
                       <Select
                         id={`${productOrderID}-primary`}
                         options={primaryReturnReasonArray}
                         onChange={this.updatePrimaryReason}
                       />
                       <div className={primaryReturnReason ? "u-show" : "u-hide"}>
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
    )
  }
}
ProductListItem.propTypes = propTypes;
ProductListItem.defaultProps = defaultProps;

export default ProductListItem;