import React, { PropTypes, } from 'react';
import { connect, } from 'react-redux';
import SizeProfile from './SizeProfile';
import SidePanelColor from './SidePanelColor';
import SidePanelCustom from './SidePanelCustom';
import SidePanelFastMaking from './SidePanelFastMaking';
import CtaPrice from './CtaPrice';

class PdpSidePanelRight extends React.Component {
  constructor(props, context) {
    super(props, context);
  }

  render() {
    if (this.props.product.is_active) {
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


            <div id="tab-color-cust" className="c-card-customize" role="tabpanel">
              <h2 className="h4 c-card-customize__header hidden-xs hidden-sm">Design your dress</h2>
              <SidePanelColor />
              {this.props.skirts.length ? <SidePanelCustom /> : null}
              <SizeProfile />

            </div>
          </div>
          <SidePanelFastMaking />
          <CtaPrice />
        </div>
      );
    }
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

PdpSidePanelRight.propTypes = {
  skirts: PropTypes.array.isRequired,
  customize: PropTypes.object.isRequired,
  product: PropTypes.object.isRequired,
};

function mapStateToProps(state) {
  return {
    skirts: state.skirts,
    customize: state.customize,
    product: state.product,
  };
}

export default connect(mapStateToProps)(PdpSidePanelRight);
