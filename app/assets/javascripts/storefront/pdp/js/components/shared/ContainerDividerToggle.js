import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { TransitionMotion, spring } from 'react-motion';

// CSS
import '../../../css/components/ContainerDividerToggle.scss';


class ContainerDividerToggle extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  stagnantStyles() {
    return {
      key: 'dividerToggleB',
      style: {
        x: 0,
        opacity: 1,
      },
    };
  }

  transitionedStyles() {
    return {
      key: 'dividerToggle',
      style: {
        x: spring(-50),
        opacity: spring(1),
      },
    };
  }

  willEnter() {
    return {
      x: 0,
      opacity: 0,
    };
  }

  willLeave() {
    return {
      x: spring(0),
      opacity: spring(1),
    };
  }

  handleForegroundClick(e) {
    e.stopPropagation();
  }

  renderContainerDividerToggle(key, style) {
    const {
      leftContainerNode,
      rightContainerNode,
    } = this.props;

    return (
      <div
        className="ContainerDividerToggle u-flex"
        key={key}
        style={{
          WebkitTransform: `translate3d(${style.x}%, 0, 0)`,
          transform: `translate3d(${style.x}%, 0, 0)`,
        }}
      >
        <div
          style={{ opacity: (style.opacity) }}
          className="ContainerDividerToggle__left-node u-width--full u-height--full"
        >
          {leftContainerNode}
        </div>
        <div
          style={{ opacity: (style.opacity) }}
          className="ContainerDividerToggle__right-node u-width--full u-height--full"
        >
          {rightContainerNode}
        </div>
      </div>
    );
  }

  render() {
    const { activeId, activationIdSet } = this.props;
    return (
      <div className="u-position--relative u-overflow--hidden">
        <TransitionMotion
          styles={activationIdSet.indexOf(activeId) > -1 ? [this.transitionedStyles()] : []}
          willEnter={this.willEnter}
          willLeave={this.willLeave}
        >
          {
            (items) => {
              if (items.length) {
                return this.renderContainerDividerToggle(items[0].key, items[0].style);
              }

              // Default
              const stagnantStyles = this.stagnantStyles();
              return this.renderContainerDividerToggle(stagnantStyles.key, stagnantStyles.style);
            }
          }
        </TransitionMotion>
      </div>
    );
  }
}

ContainerDividerToggle.propTypes = {
  activeId: PropTypes.string,
  activationIdSet: PropTypes.arrayOf(PropTypes.string).isRequired,
  leftContainerNode: PropTypes.node.isRequired,
  rightContainerNode: PropTypes.node.isRequired,
};

ContainerDividerToggle.defaultProps = {
  activeId: null,
};


export default ContainerDividerToggle;
