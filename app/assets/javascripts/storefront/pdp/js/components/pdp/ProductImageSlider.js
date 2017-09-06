/* eslint-disable max-len */
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

// Decorators
import Resize from '../../decorators/Resize';
import PDPBreakpoints from '../../libs/PDPBreakpoints';

// Utilities
import { addonSelectionDisplayText } from '../../utilities/pdp';

// UI Components
import Slider from '../shared/Slider';
import Slide from '../shared/Slide';
// import ProductFabric from './ProductFabric';


// Constants
// import ModalConstants from '../../constants/ModalConstants';

// Actions
import * as ModalActions from '../../actions/ModalActions';

// CSS
import '../../../css/components/ProductDisplayOptionsTouch.scss';


function stateToProps(state) {
  // Which part of the Redux global state does our component want to receive as props?
  return {
    addonOptions: state.$$customizationState.get('addons').get('addonOptions').toJS(),
    fabric: state.$$productState.get('fabric').toJS(),
    garmentCareInformation: state.$$productState.get('garmentCareInformation'),
    productImages: state.$$productState.get('productImages').toJS(),
    selectedColor: state.$$customizationState.get('selectedColor').toJS(),
    selectedStyleCustomizations: state.$$customizationState.get('selectedStyleCustomizations').toJS(),
  };
}

function dispatchToProps(dispatch) {
  const { activateModal } = bindActionCreators(ModalActions, dispatch);
  return { activateModal };
}

class ProductDisplayOptionsTouch extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  retrieveSelectedAddonOptions() {
    const { addonOptions, selectedStyleCustomizations } = this.props;
    return addonOptions.filter(a => selectedStyleCustomizations.indexOf(a.id) > -1);
  }

  generateBackgroundImageStyle(url) {
    // TODO: @elgrecode
    // Tentatively leaving this here until I have a better idea what to do with slides
    return {
      background: `url(${url})`,
      backgroundSize: 'cover',
    };
  }

  generateAddonButtonText(selectedAddonOptions) {
    if (selectedAddonOptions && selectedAddonOptions.length) {
      return addonSelectionDisplayText({ selectedAddonOptions });
    }
    return '-';
  }

  handleOpenModalClick(modalId) {
    return () => { this.props.activateModal({ modalId }); };
  }

  calculateSliderHeight() {
    const { breakpoint, winHeight } = this.props;
    const MOBILE_HEIGHT_ELEMS = 301; // 56 BUTTON + 185 PRODUCT OPTIONS + 60 HEADER
    const TABLET_HEIGHT_ELEMS = 301; // 56 BUTTON + 185 PRODUCT OPTIONS + 60 HEADER
    const MAX_HEIGHT = 740;
    const MIN_HEIGHT = 350;
    let sliderHeight = MIN_HEIGHT;

    if (breakpoint === 'tablet') {
      sliderHeight = winHeight - TABLET_HEIGHT_ELEMS;
    }

    if (breakpoint === 'mobile') {
      sliderHeight = winHeight - MOBILE_HEIGHT_ELEMS;
    }

    if (sliderHeight > MAX_HEIGHT) {
      return `${MAX_HEIGHT}px`;
    } else if (sliderHeight < MIN_HEIGHT) {
      return `${MIN_HEIGHT}px`;
    }

    return `${sliderHeight}px`;
  }

  render() {
    const {
      // breakpoint,
      // fabric,
      // garmentCareInformation,
      productImages,
      winHeight,
      winWidth,
    } = this.props;

    return (
      <div className="ProductImageSlider">
        <Slider sliderHeight={this.calculateSliderHeight()} winWidth={winWidth} winHeight={winHeight}>
          { productImages.map(img => (
            <Slide key={img.id}>
              <img
                alt="Something"
                src={img.bigImg}
                className="u-height--full"
              />
            </Slide>
            ))}
          {
          // LEAVE FOR PRODUCT FABRIC
          //   <Slide style={{ width: '90%' }}>
          //   <ProductFabric
          //     breakpoint={breakpoint}
          //     fabric={fabric}
          //     garmentCareInformation={garmentCareInformation}
          //     handleFabricInfoModalClick={this.handleOpenModalClick(ModalConstants.FABRIC_MODAL)}
          //   />
          // </Slide>
          }
        </Slider>
      </div>
    );
  }
}

/* eslint-disable react/forbid-prop-types */
ProductDisplayOptionsTouch.propTypes = {
  // Redux Properties
  addonOptions: PropTypes.array.isRequired,
  // fabric: PropTypes.shape({
  //   id: PropTypes.string,
  //   smallImg: PropTypes.string,
  //   name: PropTypes.string,
  //   description: PropTypes.string,
  // }).isRequired,
  // garmentCareInformation: PropTypes.string,
  productImages: PropTypes.array.isRequired,
  selectedStyleCustomizations: PropTypes.arrayOf(PropTypes.number),
  // Redux Actions
  activateModal: PropTypes.func.isRequired,
  // Decorator props
  breakpoint: PropTypes.string.isRequired,
  winHeight: PropTypes.number.isRequired,
  winWidth: PropTypes.number.isRequired,
};
ProductDisplayOptionsTouch.defaultProps = {
  garmentCareInformation: 'Professional dry-clean only.\rSee label for further details.',
  selectedStyleCustomizations: [],
  winHeight: 640,
  winWidth: 320,
};

export default
Resize(
  PDPBreakpoints,
)(connect(
  stateToProps, dispatchToProps,
)(ProductDisplayOptionsTouch));
