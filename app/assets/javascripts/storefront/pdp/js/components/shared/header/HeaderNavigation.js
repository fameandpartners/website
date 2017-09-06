import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { TransitionMotion } from 'react-motion';
import classnames from 'classnames';
import noop from '../../../libs/noop';

// Constants
import { NAVIGATION_CONTAINERS } from '../../../constants/AppConstants';

// Components
import FadeIn from '../../generic/FadeIn';
import ShopAllNavigation from '../navigation/ShopAllNavigationDesktop';
import WhoWeAreNavigation from '../navigation/WhoWeAreNavigationDesktop';

// Constants
import * as modalAnimations from '../../../utilities/modal-animation';

// CSS
import '../../../../css/components/HeaderNavigation.scss';


const FADE_OUT_OPACITY_THRESHOLD = 0.2;
class HeaderNavigation extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  defaultStyles() {
    return modalAnimations.STANDARD_DEFAULT_STYLES;
  }

  didLeave() {
    this.containerHeight = 0;
    this.props.handleAnimationEnd();
  }

  willEnter() {
    return modalAnimations.STANDARD_WILL_ENTER;
  }

  willLeave() {
    return modalAnimations.STANDARD_WILL_LEAVE;
  }

  generateHeaderNavigationContents() {
    const { openNavItem } = this.props;
    switch (openNavItem) {
      case NAVIGATION_CONTAINERS.SHOP_ALL:
        return (
          <FadeIn key={NAVIGATION_CONTAINERS.SHOP_ALL}>
            <ShopAllNavigation
              childRef={el => this.childElement = el}
            />
          </FadeIn>
        );
      case NAVIGATION_CONTAINERS.WHO_WE_ARE:
        return (
          <FadeIn key={NAVIGATION_CONTAINERS.WHO_WE_ARE}>
            <WhoWeAreNavigation
              childRef={el => this.childElement = el}
            />
          </FadeIn>
        );
      default:
        return null;
    }
  }

  setToChildHeight() {
    if (this.childElement) {
      this.containerHeight = `${this.childElement.clientHeight + 30}px`;
    }
  }

  componentDidMount() {
    this.setToChildHeight();
    this.forceUpdate();
  }

  componentDidUpdate(lastProps) {
    if (lastProps.openNavItem !== this.props.openNavItem) {
      this.setToChildHeight();
      this.forceUpdate();
    }
  }

  render() {
    return (
      <TransitionMotion
        styles={this.props.isActive ? [this.defaultStyles()] : []}
        willEnter={this.willEnter}
        willLeave={this.willLeave}
        didLeave={this.didLeave}
      >
        {(items) => {
          if (items.length) {
            const style = items[0].style;
            return (
              <div
                className={classnames(
                  'HeaderNavigation u-width--full',
                  { 'u-pointerEvents--none': (style.opacity < FADE_OUT_OPACITY_THRESHOLD) },
                )}
                key={items[0].key}
                style={{
                  height: this.containerHeight,
                  opacity: style.opacity,
                }}
              >
                {this.generateHeaderNavigationContents()}
              </div>
            );
          }
          return null;
        }}
      </TransitionMotion>
    );
  }
}

HeaderNavigation.propTypes = {
  isActive: PropTypes.bool.isRequired,
  openNavItem: PropTypes.string,
  handleAnimationEnd: PropTypes.func,
};

HeaderNavigation.defaultProps = {
  openNavItem: null,
  handleAnimationEnd: noop,
};

export default HeaderNavigation;
