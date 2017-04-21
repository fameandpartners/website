import React, {Component, PropTypes,} from 'react';
import sampleData from './tempData/sampleData.js';

export default class CollectionFastNav extends Component {
  render() {

    console.log(sampleData);

    return (
      <div className="CollectionFastNav">
        <div className="FilterSort">
          <div className="ExpandablePanel--wrapper">
            <div className="ExpandablePanel__heading">
              <span className="ExpandablePanel__mainTitle">Clothing</span>
            </div>
            <div>[[Rest of &lt;FastNav /&gt; Component]]</div>
          </div>
        </div>
      </div>
    );
  }
}
