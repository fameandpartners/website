/* eslint-disable react/prefer-stateless-function */
import React, { PureComponent } from 'react';
import { PropTypes } from 'prop-types';
import classnames from 'classnames';

// Utilities
import noop from '../../libs/noop';

// Components
import CancelOut from '../shared/CancelOut';
import Container from '../generic/Container';

class Modal extends PureComponent {
  render() {
    const {
      children,
      handleCloseModal,
      headline,
      modalClassName,
      modalContentClassName,
      modalWrapperClassName,
    } = this.props;

    return (
      <div
        className={classnames([
          'Modal__wrapper u-height--full',
          modalWrapperClassName,
        ])}
      >
        <div
          className={classnames(
            'Modal__header Modal__layout-container',
            {
              'Modal__header--headline': !!headline,
            },
          )}
        >
          <div
            className={classnames(
             'CancelOut__wrapper',
           )}
          >
            <CancelOut onClick={handleCloseModal} />
          </div>
          <h3 className="h5">{headline}</h3>
        </div>

        <div
          className={classnames([
            'Modal',
            modalClassName,
          ])}
        >
          <Container
            className={classnames([
              'Modal__content',
              modalContentClassName,
            ])}
          >
            {children}
          </Container>
        </div>
      </div>
    );
  }
}

Modal.propTypes = {
  children: PropTypes.oneOfType([PropTypes.object, PropTypes.node]).isRequired,
  handleCloseModal: PropTypes.func,
  headline: PropTypes.string,
  modalClassName: PropTypes.string,
  modalContentClassName: PropTypes.string,
  modalWrapperClassName: PropTypes.string,
};

Modal.defaultProps = {
  headline: null,
  handleCloseModal: noop,
  modalClassName: '',
  modalContentClassName: '',
  modalWrapperClassName: '',
};

export default Modal;
