// *****
// ** Input is a purely functional dumb/abstract component
// *****
import React, { PropTypes } from 'react';

const propTypes = {
  id: PropTypes.string.isRequired,
  placeholder: PropTypes.string,
  onChange: PropTypes.func.isRequired,
};

const defaultProps = {
  placeholder: '',
};

const Input = ({ id, onChange, placeholder }) => (
  <div className="Input-wrapper">
    <input
      className="Input"
      id={id}
      onChange={onChange}
      placeholder={placeholder}
    />
    <span className="Input-label">cm</span>
  </div>
);


Input.propTypes = propTypes;
Input.defaultProps = defaultProps;

export default Input;
