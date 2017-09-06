/* eslint-disable react/prefer-stateless-function */
import React, { Component } from 'react';
import ImmutablePropTypes from 'react-immutable-proptypes';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import autobind from 'react-autobind';
import { find } from 'lodash';

// polyfills
import win from '../../polyfills/windowPolyfill';

// Components
import ModalContainer from '../modal/ModalContainer';
import Modal from '../modal/Modal';
import CopyLink from '../generic/CopyLink';
import FacebookIconShareButton from '../generic/FacebookIconShareButton';
import TwitterIconShareButton from '../generic/TwitterIconShareButton';
import PinterestIconShareButton from '../generic/PinterestIconShareButton';

// Actions
import ModalActions from '../../actions/ModalActions';

// Constants
import ModalConstants from '../../constants/ModalConstants';

// CSS
import '../../../css/components/ShareModal.scss';

function stateToProps(state) {
  return {
    colorId: state.$$customizationState.get('selectedColor').get('id'),
    $$productImages: state.$$productState.get('productImages'),
  };
}

function dispatchToProps(dispatch) {
  const actions = bindActionCreators(ModalActions, dispatch);
  return { activateModal: actions.activateModal };
}

class ShareModal extends Component {
  constructor(props) {
    super(props);
    autobind(this);
  }

  handleCloseModal() {
    this.props.activateModal({ shouldAppear: false });
  }

  /**
   * Checks for our current color amongst images and returns that image, or default
   * @return {String} imageUrl
   */
  findColorSpecificFirstImageUrl() {
    const { $$productImages, colorId } = this.props;
    const productImages = $$productImages.toJS();
    const hasMatch = find(productImages, { colorId });
    return hasMatch ? hasMatch.bigImg : productImages[0].bigImg;
  }

  render() {
    const currentProductImage = this.findColorSpecificFirstImageUrl();
    const currentURL = win.location.href;

    return (
      <ModalContainer
        modalContainerClass="grid-middle"
        modalIds={[ModalConstants.SHARE_MODAL]}
      >
        <Modal
          headline="Share Your Design"
          handleCloseModal={this.handleCloseModal}
        >
          <div
            className="ShareModal typography Modal__layout-container"
          >
            <ul className="ShareModal__icons-row Modal__content--sm-margin-top">
              <li className="u-cursor--pointer">
                <FacebookIconShareButton
                  url={currentURL}
                />
              </li>
              <li className="u-cursor--pointer">
                <PinterestIconShareButton
                  url={currentURL}
                  image={currentProductImage}
                />
              </li>
              <li className="u-cursor--pointer">
                <TwitterIconShareButton
                  url={currentURL}
                />
              </li>
            </ul>
            <CopyLink url={currentURL} />
          </div>
        </Modal>
      </ModalContainer>
    );
  }
}

ShareModal.propTypes = {
  // Redux Actions
  activateModal: PropTypes.func.isRequired,
  // Redux Props
  colorId: PropTypes.number.isRequired,
  $$productImages: ImmutablePropTypes.listOf(ImmutablePropTypes.contains({
    id: PropTypes.number,
    colorId: PropTypes.number,
    smallImg: PropTypes.string,
    bigImg: PropTypes.string,
    height: PropTypes.number,
    width: PropTypes.number,
    position: PropTypes.number,
  })).isRequired,
};

export default connect(stateToProps, dispatchToProps)(ShareModal);
