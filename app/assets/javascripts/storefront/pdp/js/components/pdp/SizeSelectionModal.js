import React, { PureComponent } from 'react';
import autoBind from 'react-autobind';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

// Components
import Modal from '../modal/Modal';

// Actions
import CustomizationActions from '../../actions/CustomizationActions';
import ModalActions from '../../actions/ModalActions';

// Components
import ButtonLedge from '../generic/ButtonLedge';
import ProductCustomizationSize from './ProductCustomizationSize';

// Constants
import CustomizationConstants from '../../constants/CustomizationConstants';

// CSS
import '../../../css/components/ProductFabricSwatches.scss';

function stateToProps(state) {
  return {
    temporaryDressSize: state.$$customizationState.get('temporaryDressSize'),
    temporaryHeightValue: state.$$customizationState.get('temporaryHeightValue'),
    temporaryMeasurementMetric: state.$$customizationState.get('temporaryMeasurementMetric'),
  };
}

function dispatchToProps(dispatch) {
  const {
    updateDressSizeSelection,
    updateHeightSelection,
    updateMeasurementMetric,
  } = bindActionCreators(CustomizationActions, dispatch);
  const { activateModal } = bindActionCreators(ModalActions, dispatch);

  return {
    activateModal,
    updateDressSizeSelection,
    updateHeightSelection,
    updateMeasurementMetric,
  };
}

class StyleSelectionModal extends PureComponent {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  handleCloseModal() {
    this.props.activateModal({ shouldAppear: false });
  }

  handleSaveSizeSelection() {
    console.warn('TODO: need to check validity......');
    // Check if valid
    // If Valid
    const {
      activateModal,
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

    activateModal({ shouldAppear: false });
  }

  render() {
    return (
      <Modal
        handleCloseModal={this.handleCloseModal}
        headline={CustomizationConstants.SIZE_HEADLINE}
        modalClassName="u-flex u-flex--1"
        modalContentClassName="u-width--full u-overflow-y--scroll"
        modalWrapperClassName="u-flex--col"
      >
        <ProductCustomizationSize hasNavItems={false} />
        <div className="u-position--absolute u-bottom u-width--full">
          <ButtonLedge
            handleLeftButtonClick={this.handleCloseModal}
            handleRightButtonClick={this.handleSaveSizeSelection}
          />
        </div>
      </Modal>
    );
  }
}

StyleSelectionModal.propTypes = {
  // Redux Props
  temporaryDressSize: PropTypes.number,
  temporaryHeightValue: PropTypes.number,
  temporaryMeasurementMetric: PropTypes.string.isRequired,
  // Redux Actions
  activateModal: PropTypes.func.isRequired,
  updateDressSizeSelection: PropTypes.func.isRequired,
  updateHeightSelection: PropTypes.func.isRequired,
  updateMeasurementMetric: PropTypes.func.isRequired,
};

StyleSelectionModal.defaultProps = {
  temporaryDressSize: null,
  temporaryHeightValue: null,
};


export default connect(stateToProps, dispatchToProps)(StyleSelectionModal);
