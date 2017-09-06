import ModalConstants from '../constants/ModalConstants';

export function activateModal({ modalId, shouldAppear = true }) {
  return {
    type: ModalConstants.ACTIVATE_MODAL,
    modalId,
    shouldAppear,
  };
}

export default {
  activateModal,
};
