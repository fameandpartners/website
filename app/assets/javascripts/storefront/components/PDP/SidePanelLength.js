import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import {Scrollbars} from 'react-custom-scrollbars';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';

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

    this.closeMenu();
  }

  render() {
    const AUTO_HIDE = true;

    const ERROR = this.props.customize.length.error
      ? "c-card-customize__content__left error"
      : "c-card-customize__content__left";
    const MENU_STATE = this.state.active ? "pdp-side-menu is-active" : "pdp-side-menu";
    const TRIGGER_STATE = this.props.customize.length.id
      ? "c-card-customize__content is-selected" : "c-card-customize__content";
    const LENGTHS = this.props.lengths.map((length, index) => {
      const ITEM_STATE = this.props.customize.length.id === length.value
        ? "selector-size is-selected" : "selector-size";
      return (
        <div className="row" key={index}>
          <a href="javascript:;" className={ITEM_STATE}
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
        <a href="javascript:;"
          className={TRIGGER_STATE}
          onClick={this.openMenu}>
          <div className={ERROR}>Height & Hemline</div>
          <div className="c-card-customize__content__right">{this.props.customize.length.presentation}</div>
        </a>

        <div className={MENU_STATE}>
          <Scrollbars autoHide={AUTO_HIDE}>
            <div className="custom-scroll">
              <div className="text-right">
                <a href="javascript:;"
                  className="btn-close lg"
                  onClick={this.closeMenu}>
                    <span className="hide-visually">Close Menu</span>
                </a>
              </div>
              <h2 className="h4 c-card-customize__header">Choose your height</h2>
              <p>Tell us your height category and we can adjust the length of the hemline and sleeves on your garment for free!</p>
              {LENGTHS}
            </div>
          </Scrollbars>
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
