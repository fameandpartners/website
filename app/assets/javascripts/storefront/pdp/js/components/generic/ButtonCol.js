import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import classnames from 'classnames';

/* eslint-disable react/prefer-stateless-function */
class ButtonCol extends PureComponent {
  render() {
    const {
      className,
      left,
      right,
      tall,
      isSelected,
      handleClick,
    } = this.props;

    return (
      <button
        onClick={handleClick}
        className={classnames(
          'Button Button--tertiary ButtonCol grid-middle-noGutter noselect',
          className,
          { 'Button--selected': isSelected },
          { 'Button--tall': tall },
        )}
      >
        <div className="col-6 u-text-align-left">{left}</div>
        <div className="col-6 u-text-align-right">{right}</div>
      </button>
    );
  }
}

ButtonCol.propTypes = {
  className: PropTypes.string,
  left: PropTypes.node,
  right: PropTypes.node,
  tall: PropTypes.bool,
  isSelected: PropTypes.bool,
  handleClick: PropTypes.func.isRequired,
};

ButtonCol.defaultProps = {
  className: '',
  left: null,
  right: null,
  tall: false,
  isSelected: false,
};

export default ButtonCol;
