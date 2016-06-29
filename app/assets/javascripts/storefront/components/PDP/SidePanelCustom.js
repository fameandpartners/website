import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';
import PdpSidePanelRight from './PdpSidePanelRight';

class SidePanelCustom extends PdpSidePanelRight {
  constructor(props, context) {
    super(props, context);
  }

  render() {
    return (
      <a href="javascript:;" className="c-card-customize__content is-selected">
        <div className="c-card-customize__content__left">Customize</div>
        <div className="c-card-customize__content__right"></div>
      </a>
    );
  }
}

export default SidePanelCustom;
