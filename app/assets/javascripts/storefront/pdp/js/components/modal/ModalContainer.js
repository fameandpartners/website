import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { TransitionMotion } from 'react-motion';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import classnames from 'classnames';

// Actions
import * as ModalActions from '../../actions/ModalActions';

// Constants
import * as modalAnimations from '../../utilities/modal-animation';

// CSS
import '../../../css/components/Modal.scss';

function stateToProps(state) {
  // Which part of the Redux global state does our component want to receive as props?
  return {
    shouldAppear: state.$$modalState.get('shouldAppear'),
    activeModalId: state.$$modalState.get('modalId'),
  };
}

function dispatchToProps(dispatch) {
  const actions = bindActionCreators(ModalActions, dispatch);
  return {
    activateModal: actions.activateModal,
  };
}


class ModalContainer extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  defaultStyles() {
    if (this.props.slideUp) {
      return modalAnimations.SLIDE_UP_DEFAULT_STYLES;
    } else if (this.props.slideLeft) {
      return modalAnimations.SLIDE_LEFT_DEFAULT_STYLES;
    }
    return modalAnimations.STANDARD_DEFAULT_STYLES;
  }

  willEnter() {
    if (this.props.slideUp) {
      return modalAnimations.SLIDE_UP_WILL_ENTER;
    } else if (this.props.slideLeft) {
      return modalAnimations.SLIDE_LEFT_WILL_ENTER;
    }
    return modalAnimations.STANDARD_WILL_ENTER;
  }

  willLeave() {
    if (this.props.slideUp) {
      return modalAnimations.SLIDE_UP_WILL_LEAVE;
    } else if (this.props.slideLeft) {
      return modalAnimations.SLIDE_LEFT_WILL_LEAVE;
    }
    return modalAnimations.STANDARD_WILL_LEAVE;
  }

  handleBackgroundClick() {
    const { activateModal, closeOnBackgroundClick } = this.props;
    if (closeOnBackgroundClick) {
      activateModal({ shouldAppear: false });
    }
  }

  handleForegroundClick(e) {
    e.stopPropagation();
  }

  hasActivatedModal() {
    const { activeModalId, modalIds, shouldAppear } = this.props;
    return shouldAppear && modalIds.indexOf(activeModalId) > -1;
  }

  renderModalContainer(key, style) {
    const {
      dimBackground,
      height,
      modalContainerClass,
      zIndex,
      children,
      slideUp,
      slideLeft,
      fullScreen,
    } = this.props;

    return (
      <div
        className={classnames([
          'ModalContainer u-center',
          modalContainerClass,
          {
            'ModalContainer--dim-background': dimBackground,
            'u-pointerEvents--none': !this.hasActivatedModal(),
          },
        ])}
        style={{ zIndex, opacity: style.opacity }}
        key={key}
        onClick={this.handleBackgroundClick}
      >
        <div
          className={classnames([
            'ModalContainer__content-wrapper u-center col',
            { ModalContainer__fullScreen: fullScreen || slideUp || slideLeft },
          ])}
          onClick={this.handleForegroundClick}
          style={{
            height,
            zIndex,
            transform: `translate3d(${style.x || 0}%, ${style.y || 0}%, 0)`,
          }}
        >
          {children}
        </div>
      </div>
    );
  }

  render() {
    return (
      <TransitionMotion
        styles={this.hasActivatedModal() ? [this.defaultStyles()] : []}
        willEnter={this.willEnter}
        willLeave={this.willLeave}
      >
        {
        (items) => {
          if (items.length) {
            return this.renderModalContainer(items[0].key, items[0].style);
          }
          return null;
        }
      }
      </TransitionMotion>
    );
  }
}


ModalContainer.propTypes = {
  closeOnBackgroundClick: PropTypes.bool,
  dimBackground: PropTypes.bool,
  height: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
  modalContainerClass: PropTypes.string,
  slideUp: PropTypes.bool,
  slideLeft: PropTypes.bool,
  fullScreen: PropTypes.bool,
  zIndex: PropTypes.number,
  children: PropTypes.oneOfType([PropTypes.object, PropTypes.node]),
  // Redux
  activateModal: PropTypes.func.isRequired,
  activeModalId: PropTypes.string,
  modalIds: PropTypes.arrayOf(PropTypes.string),
  shouldAppear: PropTypes.bool,
};

ModalContainer.defaultProps = {
  closeOnBackgroundClick: true,
  dimBackground: true,
  children: null,
  slideUp: false,
  slideLeft: false,
  fullScreen: false,
  height: null,
  modalContainerClass: '',
  zIndex: 999,
  modalIds: [],
  // Redux
  activeModalId: null,
  shouldAppear: false,
};


export default connect(stateToProps, dispatchToProps)(ModalContainer);
