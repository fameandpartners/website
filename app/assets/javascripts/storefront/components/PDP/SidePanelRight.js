import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import SidePanelSize from './SidePanelSize';
import SidePanelLength from './SidePanelLength';
import SidePanelColor from './SidePanelColor';
import SidePanelCustom from './SidePanelCustom';
import CtaPrice from './CtaPrice';

class PdpSidePanelRight extends React.Component {
  constructor(props, context) {
    super(props, context);
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
        <CtaPrice />
      </div>
    );
  }
}

PdpSidePanelRight.propTypes = {
  customOptions: PropTypes.array.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    customOptions: state.customOptions
  };
}

export default connect(mapStateToProps)(PdpSidePanelRight);
