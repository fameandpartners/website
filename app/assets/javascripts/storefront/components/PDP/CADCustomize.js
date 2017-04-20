import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import PDPConstants from '../../constants/PDPConstants';
import * as pdpActions from '../../actions/PdpActions';

// Constants
const { DRAWERS } = PDPConstants;

function mapStateToProps(state) {
  console.log('state', state);
  return {
    customize: state.customize,
    customOptions: state.product.available_options.table.customizations.table.all,
  };
}

function mapDispatchToProps(dispatch) {
  // Binds our dispatcher to Redux calls
  const actions = bindActionCreators(pdpActions, dispatch);
  const { toggleDrawer } = actions;

  return {
    toggleDrawer,
  };
}

const propTypes = {
  customize: PropTypes.object.isRequired,
  // Redux actions
  toggleDrawer: PropTypes.func.isRequired,
};

class CADCustomize extends Component {
  constructor(props, context) {
    super(props, context);
    this.openMenu = this.openMenu.bind(this);
    this.closeMenu = this.closeMenu.bind(this);
    this.handleApply = this.handleApply.bind(this);
  }

  openMenu() {
    const { toggleDrawer } = this.props;
    toggleDrawer(DRAWERS.CAD_CUSTOMIZE);
  }

  closeMenu() {
    const { toggleDrawer } = this.props;
    toggleDrawer(null);
  }

  /**
   * Creates a readable string for size summary based on units
   * @return {String} summary
   */
  addonsSummarySelectedOptions() {
    return '';
  }

  /**
   * Generates a description of addons selected
   * @return {Node} addonsSummary
   */
  generateAddonsSummary() {
    return (
      <div>
        <a className="c-card-customize__content__left">Customize It</a>
        <div className="c-card-customize__content__right">
          {this.addonsSummarySelectedOptions()}
        </div>
      </div>
    );
  }

  handleApply() {

  }

  render() {
    const { drawerOpen } = this.props.customize;
    let menuClass = 'pdp-side-menu';
    const selectedClass = 'c-card-customize__content';
    menuClass += drawerOpen === DRAWERS.CAD_CUSTOMIZE ? ' is-active' : '';

    return (
      <div className="pdp-side-container pdp-side-container-custom">
        <a
          className={selectedClass}
          onClick={this.openMenu}
        >
          {this.generateAddonsSummary()}
        </a>

        <div className={menuClass}>
          <div className="text-right">
            <a
              className="btn-close med"
              onClick={this.closeMenu}
            >
              <span className="hide-visually">Close Menu</span>
            </a>
          </div>
          <h2 className="h4 c-card-customize__header textAlign--left">Customize It</h2>
          <p>
            Select as many as you want
          </p>

          <div className="height-selection clearfix">
            <h4>CAD HERE</h4>
          </div>

          <div className="btn-wrap">
            <div onClick={this.handleApply} className="btn btn-black btn-lrg">
              Apply Customizations
            </div>
          </div>

        </div>
      </div>
    );
  }
}

CADCustomize.propTypes = propTypes;

export default connect(mapStateToProps, mapDispatchToProps)(CADCustomize);
