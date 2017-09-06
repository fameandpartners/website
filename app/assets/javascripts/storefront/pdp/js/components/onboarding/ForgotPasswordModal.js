/* eslint-disable react/prefer-stateless-function */
import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { func } from 'prop-types';
import autobind from 'react-autobind';

// Utilities
import objnoop from '../../libs/objnoop';

// Components
import Input from '../form/Input';
import Button from '../generic/Button';
import Modal from '../modal/Modal';

// Actions
import ModalActions from '../../actions/ModalActions';

function dispatchToProps(dispatch) {
  const actions = bindActionCreators(ModalActions, dispatch);
  return { activateModal: actions.activateModal };
}

class LoginModal extends Component {
  constructor(props) {
    super(props);
    autobind(this);
  }

  handleCloseModal() {
    this.props.activateModal({ shouldAppear: false });
  }

  handleSwitchModal(modalId) {
    return () => {
      this.props.activateModal({ modalId });
    };
  }

  render() {
    return (
      <Modal
        headline="Forgot your password?"
        headlineSubtext="Fill out the form below and
          instructions to reset your password will be emailed to&nbsp;you"
        handleCloseModal={this.handleCloseModal}
      >
        <div
          className="ForgotPasswordModal typography"
        >
          <Input
            id="forgot_email"
            label="Email"
            focusOnMount
            wrapperClassName="Modal__content--med-margin-bottom"
          />
          <Button tall className="Modal__content--sm-margin-bottom" text="Reset Password" />
        </div>
      </Modal>
    );
  }
}

LoginModal.propTypes = {
  // Redux
  activateModal: func.isRequired,
};

export default connect(objnoop, dispatchToProps)(LoginModal);
