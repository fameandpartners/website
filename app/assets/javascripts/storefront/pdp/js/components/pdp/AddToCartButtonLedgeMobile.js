import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

// Actions
import * as ModalActions from '../../actions/ModalActions';

// Constants
import ModalConstants from '../../constants/ModalConstants';
import CustomizationConstants from '../../constants/CustomizationConstants';

// Breakpoint Decoration
import Resize from '../../decorators/Resize';
import PDPBreakpoints from '../../libs/PDPBreakpoints';

// UI
import ButtonLedge from '../generic/ButtonLedge';
import AddToCartButton from './AddToCartButton';

// Utilities
import { sizingDisplayText } from '../../utilities/pdp';

function stateToProps(state) {
  return {
    // SELECTIONS
    selectedDressSize: state.$$customizationState.get('selectedDressSize'),
    selectedHeightValue: state.$$customizationState.get('selectedHeightValue'),
    selectedMeasurementMetric: state.$$customizationState.get('selectedMeasurementMetric'),
  };
}

function dispatchToProps(dispatch) {
  const modalActions = bindActionCreators(ModalActions, dispatch);
  return { activateModal: modalActions.activateModal };
}

class AddToCartButtonLedgeMobile extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  handleSizeClick() {
    this.props.activateModal({ modalId: ModalConstants.SIZE_SELECTION_MODAL });
  }

  generateSizingButtonText() {
    const {
      selectedHeightValue,
      selectedMeasurementMetric,
      selectedDressSize,
    } = this.props;
    const sizingInformation = sizingDisplayText({
      selectedDressSize,
      selectedHeightValue,
      selectedMeasurementMetric,
    });
    if (sizingInformation) {
      return `${CustomizationConstants.SIZE_HEADLINE} - ${sizingInformation}`;
    }
    return CustomizationConstants.SIZE_HEADLINE;
  }

  render() {
    const { breakpoint } = this.props;

    return (breakpoint === 'tablet' || breakpoint === 'mobile')
    ? (
      <div className="AddToCartButtonLedgeMobile">
        <ButtonLedge
          leftText={this.generateSizingButtonText()}
          rightNode={(<AddToCartButton />)}
          handleLeftButtonClick={this.handleSizeClick}
        />
      </div>
    ) : null;
  }
}

/*  eslint-disable react/forbid-prop-types */
AddToCartButtonLedgeMobile.propTypes = {
  // Decorator Props
  breakpoint: PropTypes.string.isRequired,
  // Redux Props
  selectedDressSize: PropTypes.number,
  selectedHeightValue: PropTypes.number,
  selectedMeasurementMetric: PropTypes.string.isRequired,
  // Redux Actions
  activateModal: PropTypes.func.isRequired,
};

AddToCartButtonLedgeMobile.defaultProps = {
  selectedDressSize: null,
  selectedHeightValue: null,
};

// eslint-disable-next-line
export default Resize(PDPBreakpoints)(connect(stateToProps, dispatchToProps)(AddToCartButtonLedgeMobile));
