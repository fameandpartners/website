import React, { PureComponent } from 'react';
import autoBind from 'react-autobind';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

// Components
import ModalContainer from '../modal/ModalContainer';
import Modal from '../modal/Modal';

// Actions
import AppActions from '../../actions/AppActions';
import CustomizationActions from '../../actions/CustomizationActions';
import ModalActions from '../../actions/ModalActions';

// Components
import ButtonLedge from '../generic/ButtonLedge';
import ProductCustomizationStyle from './ProductCustomizationStyle';

// Constants
import ModalConstants from '../../constants/ModalConstants';
import CustomizationConstants from '../../constants/CustomizationConstants';

// CSS
import '../../../css/components/ProductFabricSwatches.scss';

function stateToProps(state) {
  return {
    temporaryStyleCustomizations: state.$$customizationState.get('temporaryStyleCustomizations').toJS(),
  };
}

function dispatchToProps(dispatch) {
  const { activateModal } = bindActionCreators(ModalActions, dispatch);
  const { setShareableQueryParams } = bindActionCreators(AppActions, dispatch);
  const {
    activateCustomizationDrawer,
    updateCustomizationStyleSelection,
  } = bindActionCreators(CustomizationActions, dispatch);

  return {
    activateModal,
    activateCustomizationDrawer,
    setShareableQueryParams,
    updateCustomizationStyleSelection,
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

  handleSaveStyleSelection() {
    const {
      activateModal,
      setShareableQueryParams,
      temporaryStyleCustomizations,
      updateCustomizationStyleSelection,
    } = this.props;

    updateCustomizationStyleSelection({
      selectedStyleCustomizations: temporaryStyleCustomizations,
    });
    setShareableQueryParams({ customizations: temporaryStyleCustomizations });
    activateModal({ shouldAppear: false });
  }

  /**
   * Handle clearing of addon selections
   * @action -> activateAddonIdLayers
   */
  handleClearAddonSelections() {
    this.activateAddonIdLayers([]);
  }

  render() {
    return (
      <ModalContainer
        slideUp
        dimBackground={false}
        modalIds={[ModalConstants.STYLE_SELECTION_MODAL]}
      >
        <Modal
          handleCloseModal={this.handleCloseModal}
          headline={CustomizationConstants.STYLE_HEADLINE}
          modalClassName="u-flex u-flex--1"
          modalContentClassName="u-width--full u-overflow-y--scroll"
          modalWrapperClassName="u-flex--col"
        >
          <ProductCustomizationStyle hasNavItems={false} clearAll={false} />
          <div className="u-position--absolute u-bottom u-width--full">
            <ButtonLedge
              handleLeftButtonClick={this.handleCloseModal}
              handleRightButtonClick={this.handleSaveStyleSelection}
            />
          </div>
        </Modal>
      </ModalContainer>
    );
  }
}

StyleSelectionModal.propTypes = {
  // Redux Props
  temporaryStyleCustomizations: PropTypes.arrayOf(PropTypes.number),
  // Redux Actions
  activateModal: PropTypes.func.isRequired,
  setShareableQueryParams: PropTypes.func.isRequired,
  updateCustomizationStyleSelection: PropTypes.func.isRequired,
};

StyleSelectionModal.defaultProps = {
  temporaryStyleCustomizations: [],
};


export default connect(stateToProps, dispatchToProps)(StyleSelectionModal);
