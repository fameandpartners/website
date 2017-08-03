import React, { Component, PropTypes } from 'react';
import autoBind from 'auto-bind';

class ShippingInfo extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  render() {
    // const {
    //   product,
    //   showForm,
    //   confirmationPage,
    //   orderIndex,
    //   checkboxStatus,
    //   orderNumber,
    //   returnEligible,
    // } = this.props;
    // const {
    //   id,
    //   returnWindowEnd,
    // } = product;
    // const { openEndedReturnReason, products_meta, returns_meta, price, primaryReturnReason } = product;
    // const productMeta = products_meta;
    // console.log('returns_meta', returns_meta);
    // const { name, size, color, image } = productMeta;
    // const heightValue = productMeta.height_value;
    // const primaryReturnReasonArray = this.generateOptions(PrimaryReturnReasonsObject);
    // const uiState = this.generateUIState();
    // const { SHOW_FORM, SHOW_RETURN_BUTTON, WINDOW_CLOSED, SHOW_LOGISTICS_DATA } = uiState;
    // console.log('uiState', SHOW_FORM, SHOW_RETURN_BUTTON, WINDOW_CLOSED);
    const { returns_meta: returnsMeta } = this.props;
    const { return_item_state: returnItemState } = returnsMeta;
    return (
      <div>
        { returnsMeta ?
          <div className="grid-center">
            { returnItemState === 'requested' ?
              <div>
                <div className="col-12">
                  <p className="windowClosed-copy">
                    Return Started <br /> MM/DD/YYYY
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
              :
              null
            }
          </div>
          :
          null

        }
      </div>
    );
  }
}

ShippingInfo.propTypes = {
  returns_meta: PropTypes.shape({
    item_return_id: PropTypes.number,
    label_image_url: PropTypes.string,
    label_pdf_url: PropTypes.string,
    label_url: PropTypes.string,
    return_item_state: PropTypes.string, // "requested"
  }),
};
ShippingInfo.defaultProps = {
  returns_meta: null,
};

export default ShippingInfo;
