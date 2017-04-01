// *****
// ** Input is a purely functional dumb/abstract component
// *****
import React, { Component, PropTypes } from 'react';

const propTypes = {
  id: PropTypes.string.isRequired,
  type: PropTypes.string,
  placeholder: PropTypes.string,
  onChange: PropTypes.func.isRequired,
};

const defaultProps = {
  type: 'input',
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
    console.log('props', this.props);
    const { id, placeholder, type } = this.props;
    return (
      <div className="Input-wrapper">
        <input
          ref={c => this.input = c}
          className="Input"
          id={id}
          onChange={this.handleChange}
          placeholder={placeholder}
          type={type}
        />
        <span className="Input-label">cm</span>
      </div>
    );
  }
}


Input.propTypes = propTypes;
Input.defaultProps = defaultProps;

export default Input;
