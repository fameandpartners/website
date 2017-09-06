import React, { Component } from 'react';
import PropTypes from 'prop-types';
import raf from 'raf';
import autoBind from 'react-autobind';
import shouldUpdate from '../../../libs/HeaderHiderShouldUpdate';
import window from '../../../polyfills/windowPolyfill';
import noop from '../../../libs/noop';

// CSS
import '../../../../css/components/HeaderHider.scss';

class HeaderHider extends Component {
  constructor(props) {
    super(props);
    // Class variables.
    this.currentScrollY = 0;
    this.lastKnownScrollY = 0;
    this.ticking = false;
    this.state = {
      state: 'unfixed',
      translateY: 0,
      className: 'HeaderHider HeaderHider--unfixed',
    };
    autoBind(this);
  }

  setHeightOffset() {
    this.setState({
      height: this.inner.offsetHeight,
    });
  }

  getScrollY() {
    if (this.props.parent().pageYOffset !== undefined) {
      return this.props.parent().pageYOffset;
    } else if (this.props.parent().scrollTop !== undefined) {
      return this.props.parent().scrollTop;
    }
    return (
      window.document.documentElement
      || window.document.body.parentNode
      || window.document.body
    ).scrollTop;
  }

  getViewportHeight() {
    return (
      window.innerHeight
      || window.document.documentElement.clientHeight
      || window.document.body.clientHeight
    );
  }

  getDocumentHeight() {
    const body = window.document.body;
    const documentElement = window.document.documentElement;

    return Math.max(
      body.scrollHeight, documentElement.scrollHeight,
      body.offsetHeight, documentElement.offsetHeight,
      body.clientHeight, documentElement.clientHeight,
    );
  }

  getElementPhysicalHeight(elm) {
    return Math.max(
      elm.offsetHeight,
      elm.clientHeight,
    );
  }

  getElementHeight(elm) {
    return Math.max(
      elm.scrollHeight,
      elm.offsetHeight,
      elm.clientHeight,
    );
  }

  getScrollerPhysicalHeight() {
    const parent = this.props.parent();

    return (parent === window || parent === window.document.body)
    ? this.getViewportHeight()
    : this.getElementPhysicalHeight(parent);
  }

  getScrollerHeight() {
    const parent = this.props.parent();

    return (parent === window || parent === window.document.body)
    ? this.getDocumentHeight()
    : this.getElementHeight(parent);
  }

  isOutOfBound(currentScrollY) {
    const pastTop = currentScrollY < 0;

    const scrollerPhysicalHeight = this.getScrollerPhysicalHeight();
    const scrollerHeight = this.getScrollerHeight();

    const pastBottom = currentScrollY + scrollerPhysicalHeight > scrollerHeight;

    return pastTop || pastBottom;
  }

  handleScroll() {
    if (!this.ticking) {
      this.ticking = true;
      raf(this.update);
    }
  }

  unpin() {
    this.props.onUnpin();

    this.setState({
      translateY: '-100%',
      className: 'HeaderHider HeaderHider--unpinned',
    }, () => {
      setTimeout(() => {
        this.setState({ state: 'unpinned' });
      }, 0);
    });
  }

  pin() {
    this.props.onPin();

    this.setState({
      translateY: 0,
      className: 'HeaderHider HeaderHider--pinned',
      state: 'pinned',
    });
  }

  unfix() {
    this.props.onUnfix();

    this.setState({
      translateY: 0,
      className: 'HeaderHider HeaderHider--unfixed',
      state: 'unfixed',
    });
  }

  update() {
    this.currentScrollY = this.getScrollY();

    if (!this.isOutOfBound(this.currentScrollY)) {
      const { action } = shouldUpdate(
        this.lastKnownScrollY,
        this.currentScrollY,
        this.props,
        this.state,
      );

      if (action === 'pin') {
        this.pin();
      } else if (action === 'unpin') {
        this.unpin();
      } else if (action === 'unfix') {
        this.unfix();
      }
    }

    this.lastKnownScrollY = this.currentScrollY;
    this.ticking = false;
  }

  componentDidMount() {
    this.setHeightOffset();
    if (!this.props.disable) {
      this.props.parent().addEventListener('scroll', this.handleScroll);
    }
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.disable && !this.props.disable) {
      this.unfix();
      this.props.parent().removeEventListener('scroll', this.handleScroll);
    } else if (!nextProps.disable && this.props.disable) {
      this.props.parent().addEventListener('scroll', this.handleScroll);
    }
  }

  componentDidUpdate(prevProps) {
    // If children have changed, remeasure height.
    if (prevProps.children !== this.props.children) {
      this.setHeightOffset();
    }
  }

  componentWillUnmount() {
    this.props.parent().removeEventListener('scroll', this.handleScroll);
    window.removeEventListener('scroll', this.handleScroll);
  }


  render() {
    const { style, wrapperStyle } = this.props;

    // NOTE: this should probably be taken care of using React-Motion
    let innerStyle = {
      position: this.props.disable || this.state.state === 'unfixed' ? 'relative' : 'fixed',
      top: 0,
      left: 0,
      right: 0,
      zIndex: 1,
      WebkitTransform: `translateY(${this.state.translateY})`,
      MsTransform: `translateY(${this.state.translateY})`,
      transform: `translateY(${this.state.translateY})`,
    };


    let className = this.state.className;

    // Don't add css transitions until after we've done the initial
    // negative transform when transitioning from 'unfixed' to 'unpinned'.
    // If we don't do this, the header will flash into view temporarily
    // while it transitions from 0 — -100%.
    if (this.state.state !== 'unfixed') {
      innerStyle = {
        ...innerStyle,
        WebkitTransition: 'all .2s ease-in-out',
        MozTransition: 'all .2s ease-in-out',
        OTransition: 'all .2s ease-in-out',
        transition: 'all .2s ease-in-out',
      };
      className += ' HeaderHider--scrolled';
    }

    if (!this.props.disableInlineStyles) {
      innerStyle = {
        ...innerStyle,
        ...style,
      };
    } else {
      innerStyle = style;
    }

    const wrapperStyles = {
      ...wrapperStyle,
      height: this.state.height ? this.state.height : null,
    };

    return (
      <div style={wrapperStyles} className="HeaderHider__wrapper u-width--full">
        <div
          ref={(inner) => { this.inner = inner; }}
          style={innerStyle}
          className={className}
        >
          {this.props.children}
        </div>
      </div>
    );
  }
}
/* eslint-disable react/forbid-prop-types */
/* eslint-disable react/no-unused-prop-types */
// NOTE: Proptypes are used in comparison for decision of whether to hide or show
HeaderHider.propTypes = {
  parent: PropTypes.func,
  children: PropTypes.any.isRequired,
  disableInlineStyles: PropTypes.bool,
  disable: PropTypes.bool,
  upTolerance: PropTypes.number,
  downTolerance: PropTypes.number,
  onPin: PropTypes.func,
  onUnpin: PropTypes.func,
  onUnfix: PropTypes.func,
  wrapperStyle: PropTypes.object,
  pinStart: PropTypes.number,
  style: PropTypes.object,
};

HeaderHider.defaultProps = {
  parent: () => window,
  disableInlineStyles: false,
  disable: false,
  upTolerance: 5,
  downTolerance: 0,
  onPin: noop,
  onUnpin: noop,
  onUnfix: noop,
  wrapperStyle: {},
  pinStart: 0,
  style: {},
};

export default HeaderHider;
