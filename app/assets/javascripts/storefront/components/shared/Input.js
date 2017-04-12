// *****
// ** Input is a purely functional dumb/abstract component
// *****
import React, { Component, PropTypes } from 'react';

const propTypes = {
  id: PropTypes.string.isRequired,
  error: PropTypes.bool.isRequired,
  type: PropTypes.string,
  defaultValue: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.number,
  ]),
  placeholder: PropTypes.string,
  onChange: PropTypes.func.isRequired,
};

const defaultProps = {
  error: false,
  type: 'input',
  defaultValue: '',
  placeholder: '',
};

class Input extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }
  componentDidMount() {
    this.input.focus();
  }

  handleChange(e) {
    const { onChange, id } = this.props;
    onChange({ id, value: e.target.value });
  }

  render() {
    const { id, defaultValue, placeholder, type, error } = this.props;
    return (
      <div className={`Input--wrapper ${error ? 'Input--wrapper__error' : ''}`}>
        <input
          ref={c => this.input = c}
          className="Input"
          id={id}
          onChange={this.handleChange}
          placeholder={placeholder}
          type={type}
          defaultValue={defaultValue}
        />
        <span className="Input-label">cm</span>
      </div>
    );
  }
}


Input.propTypes = propTypes;
Input.defaultProps = defaultProps;

export default Input;
