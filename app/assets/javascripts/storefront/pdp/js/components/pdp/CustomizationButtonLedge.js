import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { TransitionMotion } from 'react-motion';

// CSS
import '../../../css/components/CustomizationButtonLedge.scss';

// Utilities
import noop from '../../libs/noop';

// Actions
import * as CustomizationActions from '../../actions/CustomizationActions';
import * as AppActions from '../../actions/AppActions';

// Constants
import * as modalAnimations from '../../utilities/modal-animation';
import { COLOR_CUSTOMIZE, STYLE_CUSTOMIZE, SIZE_CUSTOMIZE } from '../../constants/CustomizationConstants';

// UI Components
import ButtonLedge from '../generic/ButtonLedge';

function stateToProps(state) {
  return {
    productCustomizationDrawerOpen: state.$$customizationState.get('productCustomizationDrawerOpen'),
    productCustomizationDrawer: state.$$customizationState.get('productCustomizationDrawer'),
    temporaryColor: state.$$customizationState.get('temporaryColor').toJS(),
    temporaryDressSize: state.$$customizationState.get('temporaryDressSize'),
    temporaryHeightValue: state.$$customizationState.get('temporaryHeightValue'),
    temporaryStyleCustomizations: state.$$customizationState.get('temporaryStyleCustomizations').toJS(),
    temporaryMeasurementMetric: state.$$customizationState.get('temporaryMeasurementMetric'),
  };
}

function dispatchToProps(dispatch) {
  const customizationActions = bindActionCreators(CustomizationActions, dispatch);
  const appActions = bindActionCreators(AppActions, dispatch);
  return {
    activateCustomizationDrawer: customizationActions.activateCustomizationDrawer,
    selectProductColor: customizationActions.selectProductColor,
    setShareableQueryParams: appActions.setShareableQueryParams,
    updateDressSizeSelection: customizationActions.updateDressSizeSelection,
    updateHeightSelection: customizationActions.updateHeightSelection,
    updateMeasurementMetric: customizationActions.updateMeasurementMetric,
    updateCustomizationStyleSelection: customizationActions.updateCustomizationStyleSelection,
  };
}

class CustomizationButtonLedge extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  handleLeftButtonClick() {
    this.props.activateCustomizationDrawer({ isActive: false });
  }

  saveColorSelection() {
    const {
      activateCustomizationDrawer,
      selectProductColor,
      setShareableQueryParams,
      temporaryColor,
    } = this.props;

    selectProductColor({ selectedColor: temporaryColor });
    setShareableQueryParams({ color: temporaryColor.id });
    activateCustomizationDrawer({ isActive: false });
  }

  saveStyleSelection() {
    const {
      activateCustomizationDrawer,
      setShareableQueryParams,
      temporaryStyleCustomizations,
      updateCustomizationStyleSelection,
    } = this.props;
    updateCustomizationStyleSelection({
      selectedStyleCustomizations: temporaryStyleCustomizations,
    });
    setShareableQueryParams({ customizations: temporaryStyleCustomizations });
    activateCustomizationDrawer({ isActive: false });
  }

  saveSizeSeletion() {
    console.warn('TODO: need to check validity......');
    // Check if valid
    // If Valid
    const {
      activateCustomizationDrawer,
      temporaryDressSize,
      temporaryMeasurementMetric,
      temporaryHeightValue,
      updateDressSizeSelection,
      updateHeightSelection,
      updateMeasurementMetric,
    } = this.props;


    updateDressSizeSelection({
      selectedDressSize: temporaryDressSize,
    });

    updateHeightSelection({
      selectedHeightValue: temporaryHeightValue,
    });

    updateMeasurementMetric({
      selectedMeasurementMetric: temporaryMeasurementMetric,
    });

    activateCustomizationDrawer({ isActive: false });
  }

  chooseCustomizationCallback() {
    const { productCustomizationDrawer } = this.props;
    switch (productCustomizationDrawer) {
      case COLOR_CUSTOMIZE:
        return this.saveColorSelection;
      case STYLE_CUSTOMIZE:
        return this.saveStyleSelection;
      case SIZE_CUSTOMIZE:
        return this.saveSizeSeletion;
      default:
        return noop;
    }
  }

  defaultStyles() {
    return modalAnimations.SLIDE_UP_DEFAULT_STYLES;
  }

  willEnter() {
    return modalAnimations.SLIDE_UP_WILL_ENTER;
  }

  willLeave() {
    return modalAnimations.SLIDE_UP_WILL_LEAVE;
  }

  render() {
    const {
      productCustomizationDrawerOpen,
    } = this.props;
    return (
      <TransitionMotion
        styles={productCustomizationDrawerOpen ? [this.defaultStyles()] : []}
        willEnter={this.willEnter}
        willLeave={this.willLeave}
      >
        {
        (items) => {
          if (items.length) {
            const { key, style } = items[0];
            return (
              <div
                key={key}
                className="CustomizationButtonLedge u-width--full"
                style={{
                  transform: `translate3d(0, ${style.y}%, 0)`,
                }}
              >
                <ButtonLedge
                  addHeight
                  handleLeftButtonClick={this.handleLeftButtonClick}
                  handleRightButtonClick={this.chooseCustomizationCallback()}
                />
              </div>
            );
          }
          return null;
        }
      }
      </TransitionMotion>
    );
  }
}

CustomizationButtonLedge.propTypes = {
  // Redux Props
  productCustomizationDrawerOpen: PropTypes.bool,
  productCustomizationDrawer: PropTypes.string,
  temporaryColor: PropTypes.shape({
    id: PropTypes.number,
    centsTotal: PropTypes.number,
    name: PropTypes.string,
    presentation: PropTypes.string,
    hexValue: PropTypes.string,
    patternUrl: PropTypes.string,
  }).isRequired,
  temporaryDressSize: PropTypes.number,
  temporaryHeightValue: PropTypes.number,
  temporaryMeasurementMetric: PropTypes.string.isRequired,
  temporaryStyleCustomizations: PropTypes.arrayOf(PropTypes.number),
  // Redux Actions
  activateCustomizationDrawer: PropTypes.func.isRequired,
  selectProductColor: PropTypes.func.isRequired,
  setShareableQueryParams: PropTypes.func.isRequired,
  updateDressSizeSelection: PropTypes.func.isRequired,
  updateHeightSelection: PropTypes.func.isRequired,
  updateMeasurementMetric: PropTypes.func.isRequired,
  updateCustomizationStyleSelection: PropTypes.func.isRequired,
};

CustomizationButtonLedge.defaultProps = {
  productCustomizationDrawerOpen: false,
  productCustomizationDrawer: null,
  temporaryColor: null,
  temporaryDressSize: null,
  temporaryHeightValue: null,
  temporaryStyleCustomizations: [],
};

export default connect(stateToProps, dispatchToProps)(CustomizationButtonLedge);
