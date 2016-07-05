import React from 'react';
import SidePanelSize from './SidePanelSize';
import SidePanelLength from './SidePanelLength';
import SidePanelColor from './SidePanelColor';

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

export default PdpSidePanelRight;
