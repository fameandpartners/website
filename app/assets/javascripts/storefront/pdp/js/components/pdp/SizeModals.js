import React, { Component } from 'react';
import autoBind from 'react-autobind';
import { connect } from 'react-redux';
import { string } from 'prop-types';

// Components
import ModalContainer from '../modal/ModalContainer';
import SizeGuideModal from '../../components/pdp/SizeGuideModal';
import SizeSelectionModal from '../../components/pdp/SizeSelectionModal';

// Constants
import ModalConstants from '../../constants/ModalConstants';

function stateToProps(state) {
  // Which part of the Redux global state does our component want to receive as props?
  return {
    activeModalId: state.$$modalState.get('modalId'),
  };
}

function dispatchToProps() {
  return {};
}


class SizeModals extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  injectModalStep() {
    const { activeModalId } = this.props;
    if (activeModalId === ModalConstants.SIZE_SELECTION_MODAL) {
      return <SizeSelectionModal />;
    } else if (activeModalId === ModalConstants.SIZE_GUIDE_MODAL) {
      return <SizeGuideModal />;
    }
    return null;
  }

  render() {
    const {
      activeModalId,
    } = this.props;

    return (
      <ModalContainer
        slideUp={activeModalId === ModalConstants.SIZE_SELECTION_MODAL}
        slideLeft={activeModalId === ModalConstants.SIZE_GUIDE_MODAL}
        dimBackground={false}
        modalContainerClass="grid-middle"
        modalIds={[
          ModalConstants.SIZE_SELECTION_MODAL,
          ModalConstants.SIZE_GUIDE_MODAL,
        ]}
      >
        { this.injectModalStep() }
      </ModalContainer>
    );
  }
}

SizeModals.propTypes = {
  activeModalId: string,
};

SizeModals.defaultProps = {
  // Redux
  activeModalId: null,
};


export default connect(stateToProps, dispatchToProps)(SizeModals);
