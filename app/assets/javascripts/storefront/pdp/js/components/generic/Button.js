import React, { Component } from 'react';
import PropTypes from 'prop-types';
import classnames from 'classnames';

// CSS
import '../../../css/components/Button.scss';

class Button extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    if (!this.props.disabled) {
      this.props.handleClick();
    }
  }

  render() {
    const {
      className,
      disabled,
      metaIcon,
      secondary,
      selected,
      square,
      tall,
      tertiary,
      text,
      handleClick,
      passedRef,
    } = this.props;

    return (
      <button
        ref={passedRef}
        onClick={handleClick}
        className={
          classnames(
            'Button',
            className,
            {
              'Button--secondary': secondary,
              'Button--selected': selected,
              'Button--disabled': disabled,
              'Button--square': square,
              'Button--tall': tall,
              'Button--tertiary': tertiary,
            },
          )
        }
      >
        { metaIcon
          ? <span className="Button__meta">{metaIcon}</span>
          : null
        }
        <span>{text}</span>
      </button>
    );
  }
}

Button.propTypes = {
  passedRef: PropTypes.func,
  className: PropTypes.string,
  disabled: PropTypes.bool,
  metaIcon: PropTypes.node,
  secondary: PropTypes.bool,
  selected: PropTypes.bool,
  square: PropTypes.bool,
  tall: PropTypes.bool,
  tertiary: PropTypes.bool,
  text: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
  handleClick: PropTypes.func.isRequired,
};

Button.defaultProps = {
  passedRef: null,
  className: '',
  disabled: false,
  metaIcon: null,
  secondary: false,
  selected: false,
  square: false,
  tall: false,
  text: 'Submit',
  tertiary: false,
};

export default Button;
