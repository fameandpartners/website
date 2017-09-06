/* eslint-disable react/prefer-stateless-function */
import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { func } from 'prop-types';
import autobind from 'react-autobind';

// Components
import Input from '../form/Input';
import Checkbox from '../form/Checkbox';
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

class SignupModal extends Component {
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

  handleTrendUpdateCheck() {
    return () => {};
  }

  handleFormSubmission() {
    return () => {};
  }

  render() {
    return (
      <Modal
        headline="Sign up to save your creation"
        handleCloseModal={this.handleCloseModal}
      >
        <div
          className="SignupModal typography Modal__layout-container"
        >
          <FacebookButton />
          <h4 className="h5 hr">OR</h4>
          <div className="Modal__content--sm-margin-bottom">
            <Input
              id="signup_first"
              label="First Name"
              focusOnMount
              wrapperClassName="Modal__content--sm-margin-bottom"
            />
            <Input
              id="signup_last"
              label="Last Name"
              wrapperClassName="Modal__content--sm-margin-bottom"
            />
            <Input
              id="signup_email"
              label="Email"
              wrapperClassName="Modal__content--sm-margin-bottom"
            />
            <Input
              id="signup_password"
              type="password"
              label="Password"
              wrapperClassName="Modal__content--sm-margin-bottom"
            />
            <Checkbox
              id="latest_trends"
              label="Get emails on latest updates"
              wrapperClassName="Modal__content--med-margin-bottom"
              onChange={this.handleTrendUpdateCheck()}
            />
          </div>
          <Button
            tall
            className="Modal__content--sm-margin-bottom"
            text="Sign up"
            handleClick={this.handleFormSubmission()}
          />
          <p className="Modal__content--med-margin-bottom">
            <span>Already a member?&nbsp;</span>
            <span
              onClick={this.handleSwitchModal(ModalConstants.LOG_IN_MODAL)}
              className="App__link"
            >
              Log in
            </span>
          </p>
        </div>
      </Modal>
    );
  }
}

SignupModal.propTypes = {
  // Redux
  activateModal: func.isRequired,
};

export default connect(stateToProps, dispatchToProps)(SignupModal);
