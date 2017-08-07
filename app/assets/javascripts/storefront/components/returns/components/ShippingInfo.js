import React, { Component, PropTypes } from 'react';
import autoBind from 'auto-bind';
import classnames from 'classnames';

class ShippingInfo extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  render() {
    const {
      copy,
      grayBackground,
      listLinks,
    } = this.props;

    return (
      <div className="u-width-full">
        <div
          className={classnames(
          'ShippingInfo',
            {
              'ShippingInfo--gray': grayBackground,
            },
        )}
        >
          <div className="col-12">
            <p className="ShippingInfo__copy font-sans-serif">
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
