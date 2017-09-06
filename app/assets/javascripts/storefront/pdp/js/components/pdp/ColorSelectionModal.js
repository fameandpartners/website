import React, { PureComponent } from 'react';
import autoBind from 'react-autobind';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

// Components
import ModalContainer from '../modal/ModalContainer';
import Modal from '../modal/Modal';
import ProductCustomizationColor from '../pdp/ProductCustomizationColor';

// Components
import ButtonLedge from '../generic/ButtonLedge';

// Actions
import AppActions from '../../actions/AppActions';
import CustomizationActions from '../../actions/CustomizationActions';
import ModalActions from '../../actions/ModalActions';

// Constants
import CustomizationConstants from '../../constants/CustomizationConstants';
import ModalConstants from '../../constants/ModalConstants';

// CSS
import '../../../css/components/ProductFabricSwatches.scss';


function stateToProps(state) {
  return {
    temporaryColor: state.$$customizationState.get('temporaryColor').toJS(),
  };
}


function dispatchToProps(dispatch) {
  const { setShareableQueryParams } = bindActionCreators(AppActions, dispatch);
  const { activateModal } = bindActionCreators(ModalActions, dispatch);
  const { selectProductColor } = bindActionCreators(CustomizationActions, dispatch);
  return {
    activateModal,
    selectProductColor,
    setShareableQueryParams,
  };
}

class ProductFabricModal extends PureComponent {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  handleCloseModal() {
    this.props.activateModal({ shouldAppear: false });
  }

  handleColorSelection(color) {
    const { selectProductColor } = this.props;
    selectProductColor({ color });
    this.handleCloseModal();
  }

  handleSaveColorSelection() {
    const {
      activateModal,
      selectProductColor,
      setShareableQueryParams,
      temporaryColor,
    } = this.props;

    selectProductColor({ selectedColor: temporaryColor });
    setShareableQueryParams({ color: temporaryColor.id });
    activateModal({ shouldAppear: false });
  }

  render() {
    return (
      <ModalContainer
        slideUp
        dimBackground={false}
        modalIds={[ModalConstants.COLOR_SELECTION_MODAL]}
      >
        <Modal
          headline={CustomizationConstants.COLOR_HEADLINE}
          handleCloseModal={this.handleCloseModal}
          modalClassName="u-flex u-flex--1"
          modalContentClassName="u-width--full u-overflow-y--scroll"
          modalWrapperClassName="u-flex--col"
        >

          <ProductCustomizationColor
            hasNavItems={false}
          />
          <div className="u-position--absolute u-bottom u-width--full">
            <ButtonLedge
              handleLeftButtonClick={this.handleCloseModal}
              handleRightButtonClick={this.handleSaveColorSelection}
            />
          </div>
        </Modal>
      </ModalContainer>
    );
  }
}

ProductFabricModal.propTypes = {
  // Redux Props
  temporaryColor: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
    centsTotal: PropTypes.number,
    hexValue: PropTypes.string,
    patternUrl: PropTypes.string,
  }).isRequired,
  // Redux Actions
  activateModal: PropTypes.func.isRequired,
  selectProductColor: PropTypes.func.isRequired,
  setShareableQueryParams: PropTypes.func.isRequired,
};

ProductFabricModal.defaultProps = {
  activeModalId: null,
};


export default connect(stateToProps, dispatchToProps)(ProductFabricModal);
