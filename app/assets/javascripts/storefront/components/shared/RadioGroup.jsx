//*****
// ** RadioGroup is an abstracted component for Fame and Partners Radio selections
// ** that manages the state of the selection
// ** It requires an array of Radio chilren to iterate over to build the options
//*****
import React, {Component, PropTypes,} from 'react';
import autobind from 'auto-bind';

const propTypes = {
  name: PropTypes.string,
  selectedValue: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.number,
    PropTypes.bool,
  ]),
  onChange: PropTypes.func,
  children: PropTypes.node.isRequired,
  Component: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.func,
    PropTypes.object,
  ]),
};

const defaultProps = {
  Component: 'div',
};

class RadioGroup extends Component {
  constructor(props){
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
    const {Component, name, selectedValue, onChange, children,} = this.props;
    return <Component>{children}</Component>;
  }
}

RadioGroup.propTypes = propTypes;
RadioGroup.defaultProps = defaultProps;
RadioGroup.childContextTypes = {
  radioGroup: React.PropTypes.object,
};

export default RadioGroup;
