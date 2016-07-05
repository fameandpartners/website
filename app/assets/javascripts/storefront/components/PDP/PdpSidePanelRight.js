import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';
import SidePanelSize from './SidePanelSize';
import SidePanelLength from './SidePanelLength';
import SidePanelColor from './SidePanelColor';
import SidePanelCustom from './SidePanelCustom';

class PdpSidePanelRight extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      customize: {}
    };
  }

  render() {
    return (
      <div className="panel-side-container">
        <div>
          <div className="c-card-customize">
            <h2 className="h4 c-card-customize__header">Specify your size</h2>
            <SidePanelSize />
            <SidePanelLength />
          </div>

          <div className="c-card-customize">
            <h2 className="h4 c-card-customize__header">Design your dress</h2>
            <SidePanelColor />
              {(() => {
                if(this.props.customOptions.length) {
                  return (
                    <SidePanelCustom />
                  );
                }
              })()}
          </div>
        </div>

        <div className="btn-wrap">
          <div className="price js-product-price">$0000</div>
          <a href="javascript:;" className="btn btn-black btn-lrg js-buy-button">ADD TO BAG</a>
          <div className="est-delivery">Estimated delivery 3-4 weeks</div>
        </div>
      </div>
    );
  }
}

PdpSidePanelRight.propTypes = {
  customize: PropTypes.object.isRequired,
  customOptions: PropTypes.array.isRequired,
  actions: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    customOptions: state.customOptions
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(PdpSidePanelRight);
