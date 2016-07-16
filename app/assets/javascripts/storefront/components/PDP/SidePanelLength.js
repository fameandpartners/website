import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';
import SidePanelLengthChart from './SidePanelLengthChart';

class SidePanelLength extends SidePanel {
  constructor(props, context) {
    super(props, context);

    this.onChange = this.onChange.bind(this);
  }

  onChange(event) {
    let customize = {};
    customize.length = {};
    customize.length.id = event.currentTarget.dataset.id;
    customize.length.presentation = event.currentTarget.dataset.id;
    this.props.actions.customizeDress(customize);
  }

  render() {
    const menuState = this.state.active ? 'pdp-side-menu is-active' : 'pdp-side-menu';
    const triggerState = this.props.customize.length.id
      ? "c-card-customize__content is-selected" : "c-card-customize__content";
    const lengths = this.props.lengths.map((length, index) => {
      const itemState = this.props.customize.length.id === length.value
        ? "selector-size is-selected" : "selector-size";
      return (
        <div className="row" key={index}>
          <a href="#" className={itemState}
            onClick={this.onChange} data-id={length.value}>
            {length.value}
          </a>
          <div className="copy-wrap">
            {length.presentation_1}
            <br />
            {length.presentation_2}
          </div>
        </div>
      );
    });
    return (
      <div className="pdp-side-container pdp-side-container-length">
        <a href="#"
          className={triggerState}
          onClick={this.openMenu}>
          <div className="c-card-customize__content__left">Skirt Length</div>
          <div className="c-card-customize__content__right txt-truncate-1">{this.props.customize.length.presentation}</div>
        </a>

        <div className={menuState}>
          <div className="text-right">
            <a href="#"
              className="btn-close lg"
              onClick={this.closeMenu}>
                <span className="hide-visually">Close Menu</span>
            </a>
          </div>
          <h2 className="h4 c-card-customize__header">Choose your skirt length</h2>
          <p>Tell us your height category and we can adjust your
            skirt length for free!</p>
          {lengths}
          <SidePanelLengthChart />
        </div>
      </div>
    );
  }
}

SidePanelLength.propTypes = {
  customize: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    lengths: state.lengths
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelLength);
