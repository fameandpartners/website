/* eslint-disable react/prefer-stateless-function */
import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { func } from 'prop-types';
import autobind from 'react-autobind';

// Components
import Input from '../form/Input';
import FacebookButton from '../generic/FacebookButton';
import Button from '../generic/Button';
import Modal from '../modal/Modal';

// Actions
import ModalActions from '../../actions/ModalActions';

// Constants
import ModalConstants from '../../constants/ModalConstants';

function stateToProps() {
  return {};
}

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
        headline="Log in save your creation"
        handleCloseModal={this.handleCloseModal}
      >
        <div
          className="LoginModal typography"
        >
          <FacebookButton login />
          <h4 className="h5 hr">OR</h4>
          <div className="Modal__content--med-margin-bottom">
            <Input
              id="signup_email"
              label="Email"
              focusOnMount
              wrapperClassName="Modal__content--med-margin-bottom"
            />
            <Input
              id="signup_password"
              type="password"
              label="Password"
              inlineMeta={(
                <span
                  className="App__link"
                  onClick={this.handleSwitchModal(ModalConstants.FORGOT_PASSWORD_MODAL)}
                >
                  Forgot
                </span>)
              }
              wrapperClassName="Modal__content--med-margin-bottom"
            />
          </div>
          <Button
            tall
            className="Modal__content--sm-margin-bottom"
            text="Log in"
            handleClick={() => {}}
          />
          <p className="Modal__content--med-margin-bottom">
            <span>Don't have an account?&nbsp;</span>
            <span
              onClick={this.handleSwitchModal(ModalConstants.SIGN_UP_MODAL)}
              className="App__link"
            >Sign up</span>
          </p>
        </div>
      </Modal>
    );
  }
}

LoginModal.propTypes = {
  // Redux
  activateModal: func.isRequired,
};

export default connect(stateToProps, dispatchToProps)(LoginModal);
