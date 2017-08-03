import React, { Component, PropTypes } from 'react';
import autoBind from 'auto-bind';
import classnames from 'classnames';

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
    const {
      copy,
      grayBackground,
      listLinks,
    } = this.props;

    return (
      <div>
        <div
          className={classnames(
          'ShippingInfo',
            {
              'ShippingInfo--gray': grayBackground,
            },
        )}
        >
          <div className="col-12">
            <p className="ShippingInfo__copy">
              {copy}
            </p>
          </div>
          <div className="col-12">
            <ul className="ShippingInfo__list">
              { listLinks ? listLinks :
                (
                  <div>
                    <li>
                      <a
                        className="u-underline"
                        href="https://www.fameandpartners.com/faqs#collapse-returns-policy"
                        rel="noopener noreferrer"
                        target="_blank"
                      >
                        View Return Policy
                      </a>
                    </li>
                    <li>
                      <a
                        className="u-underline"
                        href="https://www.fameandpartners.com/contact"
                        rel="noopener noreferrer"
                        target="_blank"
                      >
                        Contact Customer Service
                      </a>
                    </li>
                  </div>
                )
              }
            </ul>
          </div>
        </div>
      </div>
    );
  }
}

ShippingInfo.propTypes = {
  copy: PropTypes.node,
  listLinks: PropTypes.node,
  grayBackground: PropTypes.bool,
};
ShippingInfo.defaultProps = {
  copy: null,
  grayBackground: false,
};

export default ShippingInfo;

// <div className="ShippingInfo">
//   <div className="col-12">
//     <p className="ShippingInfo__copy">
//         Your 30-day return window closed on <br />
//       {returnWindowEnd} and this item is no longer eligible for a return.
//     </p>
//   </div>
// <div className="col-12">
//   <ul className="ShippingInfo__list">
//     <li>
//       <a
//         className="u-underline"
//         href="https://www.fameandpartners.com/faqs#collapse-returns-policy"
//         rel="noopener noreferrer"
//         target="_blank"
//       >
//         View Return Policy
//       </a>
//     </li>
//     <li>
//       <a
//         className="u-underline"
//         href="https://www.fameandpartners.com/contact"
//         rel="noopener noreferrer"
//         target="_blank"
//       >
//           Contact Customer Service
//       </a>
//     </li>
//   </ul>
// </div>
// </div>
