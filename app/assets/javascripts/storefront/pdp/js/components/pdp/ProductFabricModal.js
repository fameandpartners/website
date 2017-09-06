import React, { PureComponent } from 'react';
import autoBind from 'react-autobind';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

// Components
import ModalContainer from '../modal/ModalContainer';
import Modal from '../modal/Modal';
import ProductFabricInfo from './ProductFabricInfo';

// Actions
import ModalActions from '../../actions/ModalActions';

// Constants
import ModalConstants from '../../constants/ModalConstants';

function stateToProps(state) {
  // Which part of the Redux global state does our component want to receive as props?
  return {
    activeModalId: state.$$modalState.get('modalId'),
    fabric: state.$$productState.get('fabric').toJS(),
    garmentCareInformation: state.$$productState.get('garmentCareInformation'),
  };
}

function dispatchToProps(dispatch) {
  const { activateModal } = bindActionCreators(ModalActions, dispatch);
  return { activateModal };
}

class ProductFabricModal extends PureComponent {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  handleCloseModal() {
    this.props.activateModal({ shouldAppear: false });
  }

  render() {
    const {
      fabric,
      garmentCareInformation,
    } = this.props;

    return (
      <ModalContainer
        slideUp
        dimBackground={false}
        modalIds={[ModalConstants.FABRIC_MODAL]}
      >
        <Modal
          handleCloseModal={this.handleCloseModal}
          modalClassName="grid-middle u-flex--1"
          modalContentClassName="u-width--full"
          modalWrapperClassName="u-flex--col"
        >
          <div className="ProductFabricModal u-text-align--center grid-middle">
            <div className="Modal__content--med-margin-bottom">
              <ProductFabricInfo
                fabric={fabric}
                garmentCareInformation={garmentCareInformation}
              />
            </div>
          </div>
        </Modal>
      </ModalContainer>
    );
  }
}

ProductFabricModal.propTypes = {
  // Redux Properties
  fabric: PropTypes.shape({
    id: PropTypes.string,
    smallImg: PropTypes.string,
    name: PropTypes.string,
    description: PropTypes.string,
  }).isRequired,
  garmentCareInformation: PropTypes.string.isRequired,
  // Redux Actions
  activateModal: PropTypes.func.isRequired,
};

ProductFabricModal.defaultProps = {
  // Redux
  activeModalId: null,
};


export default connect(stateToProps, dispatchToProps)(ProductFabricModal);
