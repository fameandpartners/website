import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as pdpActions from '../../actions/PdpActions';
import SidePanel from './SidePanel';
import SidePanelSizeChart from './SidePanelSizeChart';

class SidePanelSize extends SidePanel {
  constructor(props, context) {
    super(props, context);

    this.state = {
      customize: {size: {id: '', presentation: ''}}
    };

    this.onSizeChange = this.onSizeChange.bind(this);
  }

  onSizeChange(event) {
    let customize = this.state.customize;
    customize.size.id = event.target.dataset.id;
    customize.size.presentation = event.target.dataset.presentation;
    this.setState({customize});
    this.props.actions.selectSize(this.state.customize);
  }

  render() {
    const menuState = this.state.active ? 'side-menu is-active' : 'side-menu';
    const triggerState = this.props.customize.size.id
      ? "c-card-customize__content is-selected" : "c-card-customize__content";
    const sizes = this.props.defaultSizes.map((size, index) => {
      const itemState = this.props.customize.size.id == size.table.id
        ? "selector-size is-selected" : "selector-size";
      return (
        <a href="#" className={itemState}
          onClick={this.onSizeChange} key={index}
          data-id={size.table.id} data-presentation={size.table.presentation}>
          {size.table.presentation}
        </a>
      );
    });

    return (
      <div className="side-container side-container-size">
        <a href="#"
          className={triggerState}
          onClick={this.openMenu}>
          <div className="c-card-customize__content__left">Dresses Size</div>
          <div className="c-card-customize__content__right txt-truncate-1">{this.props.customize.size.presentation}</div>
        </a>

        <div className={menuState}>
          <div className="text-right">
            <a href="#"
              className="btn-close lg"
              onClick={this.closeMenu}>
                <span className="hide-visually">Close Menu</span>
            </a>
          </div>
          <h2 className="h4 c-card-customize__header">Choose your size</h2>
          <div className="row">{sizes}</div>
          <SidePanelSizeChart />
        </div>
      </div>
    );
  }
}

SidePanelSize.propTypes = {
  customize: PropTypes.object.isRequired,
  actions: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    defaultSizes: state.defaultSizes
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(pdpActions, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SidePanelSize);
