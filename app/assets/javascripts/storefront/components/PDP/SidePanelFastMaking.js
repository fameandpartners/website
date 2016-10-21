import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import {Scrollbars} from 'react-custom-scrollbars';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';

// TODO: [WIP] This is just a placeholder. Valid logic for displaying the "express making" row properly is needed here.

class SidePanelFastMaking extends SidePanel {
  constructor(props, context) {
    super(props, context);

    this.onChange = this.onChange.bind(this);
  }

  onChange(event) {

  }

  render() {

    return (
      <div className="pdp-side-container pdp-side-container-fast-making checkbox-inline custom-form-element-thin form-small">
        <a href="javascript:;">
          <input type="checkbox" id="fast-making" />
          <label htmlFor="fast-making">
          <div className="c-card-customize__content__left">EXPRESS MAKING (6-9 days)</div>
          <div className="c-card-customize__content__right">$30</div>
          </label>
        </a>
      </div>
    );
  }
}

SidePanelFastMaking.propTypes = {
  customize: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {

  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelFastMaking);
