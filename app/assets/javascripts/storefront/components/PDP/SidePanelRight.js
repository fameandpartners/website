import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import SidePanelSize from './SidePanelSize';
import SidePanelLength from './SidePanelLength';
import SidePanelColor from './SidePanelColor';
import SidePanelCustom from './SidePanelCustom';
import SidePanelFastMaking from './SidePanelFastMaking';
import CtaPrice from './CtaPrice';

class PdpSidePanelRight extends React.Component {
  constructor(props, context) {
    super(props, context);
  }

  render() {
    const ERROR_MESSAGE = (() => {
      if(this.props.customize.size.error && this.props.customize.length.error) {
        return (
          <div className="error-message">
            Please select a {this.props.customize.size.message} and {this.props.customize.length.message} to continue.
          </div>
        );
      } else if(this.props.customize.size.error && !this.props.customize.length.error) {
        return (
          <div className="error-message">
            Please select a {this.props.customize.size.message} to continue.
          </div>
        );
      } else if(!this.props.customize.size.error && this.props.customize.length.error) {
        return (
          <div className="error-message">
            Please select a {this.props.customize.length.message} to continue.
          </div>
        );
      } else {
        return (
          <span></span>
        );
      }
    })();

    // TODO: Do we want to check makingOption here if fast making is enabled? and thus remove color option
    // Maybe, maybe not depending on whatever is best for UX, this.props.customize.makingOption or this.props.customize.customization
    if(this.props.product.is_active) {
      return (
        <div className="panel-side-container">
          <div>
            <ul className="row l-tab-controls hidden-md hidden-lg" role="tablist">
              <li className="col-xs-6 col-sm-6 active" role="presentation">
                <a href="#tab-size-fit" role="tab" data-toggle="tab">Size + Fit</a>
              </li>
              <li className="col-xs-6 col-sm-6" role="presentation">
                <a href="#tab-color-cust" role="tab" data-toggle="tab">Color + Customize</a>
              </li>
            </ul>

            <div id="tab-size-fit" className="c-card-customize active" role="tabpanel">
              <h2 className="h4 c-card-customize__header hidden-xs hidden-sm">Specify your size</h2>
              {ERROR_MESSAGE}
              <SidePanelSize />
              <SidePanelLength />
            </div>

            <div id="tab-color-cust" className="c-card-customize" role="tabpanel">
              <h2 className="h4 c-card-customize__header hidden-xs hidden-sm">Design your dress</h2>
                <SidePanelColor />
                {(() => {
                  if(this.props.skirts.length) {
                    return (
                      <SidePanelCustom />
                    );
                  }
                })()}
            </div>
          </div>
          <SidePanelFastMaking />
          <CtaPrice />
        </div>
      );
    } else {
      return (
        <div className="panel-side-container">
          <div>
            <p>Sorry, the dress you are looking for is currently unavailable.</p>
            <p>
              <a href="/dresses" className="link">Search similar dresses</a>
            </p>
          </div>
        </div>
      );
    }
  }
}

PdpSidePanelRight.propTypes = {
  skirts: PropTypes.array.isRequired,
  customize: PropTypes.object.isRequired,
  product: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    skirts: state.skirts,
    customize: state.customize,
    product: state.product
  };
}

export default connect(mapStateToProps)(PdpSidePanelRight);
