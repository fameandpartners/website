// *****
// ** RadioGroup is an abstracted component for Fame and Partners Radio selections
// ** that manages the state of the selection
// ** It requires an array of Radio chilren to iterate over to build the options
// *****
import React, { Component, PropTypes } from 'react';
import autobind from 'auto-bind';

const propTypes = {
  name: PropTypes.string,
  selectedValue: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.number,
    PropTypes.bool,
  ]).isRequired,
  onChange: PropTypes.func.isRequired,
  children: PropTypes.node.isRequired,
  className: PropTypes.string,
  ComponentWrapper: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.func,
    PropTypes.object,
  ]),
};

const defaultProps = {
  name: 'RadioGroup',
  ComponentWrapper: 'div',
  className: 'radio-group',
};

class RadioGroup extends Component {
  constructor(props) {
    super(props);
    autobind(this);
  }

  getChildContext() {
    const {
      name,
      selectedValue,
      onChange,
    } = this.props;

    return {
      radioGroup: {
        name,
        selectedValue,
        onChange,
      },
    };
  }

  render() {
    const { ComponentWrapper, children, className } = this.props;
    return (
      <ComponentWrapper className={`RadioGroup ${className}`}>{children}</ComponentWrapper>
    );
  }
}

RadioGroup.propTypes = propTypes;
RadioGroup.defaultProps = defaultProps;
RadioGroup.childContextTypes = {
  radioGroup: React.PropTypes.object,
};

export default RadioGroup;
