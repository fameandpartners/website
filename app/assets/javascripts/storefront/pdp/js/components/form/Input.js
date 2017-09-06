// *****
// ** Input is a purely functional dumb/stateless component
// *****
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import classnames from 'classnames';
import autoBind from 'react-autobind';
import noop from '../../libs/noop';

// CSS
import '../../../css/components/Input.scss';

class Input extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  handleChange(e) {
    const { onChange, id } = this.props;
    onChange({ id, value: e.target.value });
  }

  handleBlur(e) {
    const { onBlur, id } = this.props;
    onBlur({ id, value: e.target.value });
  }

  componentDidMount() {
    if (this.props.focusOnMount) {
      this.input.focus();
    } else if (this.props.selectOnMount) {
      this.input.focus();
      this.input.select();
    }
  }

  render() {
    const {
      id,
      defaultValue,
      error,
      label,
      indent,
      inlineMeta,
      lineInput,
      placeholder,
      type,
      wrapperClassName,
      readOnly,
    } = this.props;

    return (
      <div
        className={classnames(
          'Input__wrapper',
          wrapperClassName,
          {
            Input__wrapper__error: error,
          },
        )}
      >
        { label
          ? <label className="Input__label" htmlFor={id}>{label}</label>
          : null
        }
        <input
          ref={c => this.input = c}
          className={classnames(
            'Input',
            { 'Input--indent': indent },
            { 'Input--line-input': lineInput },
          )}
          id={id}
          placeholder={placeholder}
          type={type}
          defaultValue={defaultValue}
          readOnly={readOnly}
          onBlur={this.handleBlur}
          onChange={this.handleChange}
        />
        {inlineMeta && error
          ? <span className="Input__meta-label--error">{inlineMeta}</span>
          : null
        }
        {inlineMeta && !error
            ? <span className="Input__meta-label">{inlineMeta}</span>
            : null
        }
      </div>
    );
  }
}

Input.propTypes = {
  id: PropTypes.string.isRequired,
  defaultValue: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.number,
  ]),
  error: PropTypes.bool,
  focusOnMount: PropTypes.bool,
  selectOnMount: PropTypes.bool,
  readOnly: PropTypes.bool,
  indent: PropTypes.bool,
  inlineMeta: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.node,
    PropTypes.instanceOf(null),
  ]),
  label: PropTypes.string,
  lineInput: PropTypes.bool,
  placeholder: PropTypes.string,
  type: PropTypes.string,
  wrapperClassName: PropTypes.string,
  onBlur: PropTypes.func.isRequired,
  onChange: PropTypes.func.isRequired,
};

Input.defaultProps = {
  defaultValue: '',
  error: false,
  focusOnMount: false,
  selectOnMount: false,
  readOnly: false,
  indent: false,
  inlineMeta: null,
  label: null,
  lineInput: false,
  placeholder: '',
  type: 'input',
  wrapperClassName: '',
  onBlur: noop,
  onChange: noop,
};

export default Input;
