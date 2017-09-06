import React, { Component } from 'react';
import classnames from 'classnames';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';

// Utilities
import noop from '../../libs/noop';

// UI Components
import Button from '../generic/Button';

// CSS
import '../../../css/components/ButtonLedge.scss';

class ButtonLedge extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  render() {
    const {
      addHeight,
      leftText,
      rightText,
      rightNode,
      handleLeftButtonClick,
      handleRightButtonClick,
    } = this.props;

    return (
      <div
        className={classnames(
        'ButtonLedge',
        { 'ButtonLedge--height': addHeight },
      )}
      >
        <div
          className={classnames(
            'ButtonLedge__button-wrapper grid-center-middle-noGutter u-height--full',
          )}
        >
          {handleLeftButtonClick
            ? (
              <div className="col-6">
                <Button
                  tall
                  secondary
                  text={leftText}
                  handleClick={handleLeftButtonClick}
                />
              </div>
            )
            : null
          }

          {handleRightButtonClick || rightNode
            ? (
              <div className="col-6">
                { rightNode ||
                  (
                    <Button
                      tall
                      text={rightText}
                      handleClick={handleRightButtonClick}
                    />
                  )
                }
              </div>
            )
            : null
          }
        </div>
      </div>
    );
  }
}

ButtonLedge.propTypes = {
  addHeight: PropTypes.bool,
  leftText: PropTypes.string,
  rightNode: PropTypes.node,
  rightText: PropTypes.string,
  handleLeftButtonClick: PropTypes.func,
  handleRightButtonClick: PropTypes.func,
};

ButtonLedge.defaultProps = {
  addHeight: false,
  leftText: 'Cancel',
  rightNode: null,
  rightText: 'Save',
  handleLeftButtonClick: noop,
  handleRightButtonClick: noop,
};

export default ButtonLedge;
