// *****
// ** Radio is an dumb, abstracted child component for Radio selections
// *****
import React, { Component, PropTypes } from 'react';

const propTypes = {
  value: PropTypes.string.isRequired,
  display: PropTypes.string.isRequired,
};

class Radio extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange() {
    const { radioGroup } = this.context;
    const { value } = this.props;
    if (typeof radioGroup.onChange === 'function') {
      radioGroup.onChange({ value });
    }
  }

  render() {
    const { name, selectedValue } = this.context.radioGroup;
    const { value, display } = this.props;

    return (
      <div className="Radio">
        <input
          type="radio"
          id={value}
          name={name}
          onChange={this.handleChange}
          checked={this.props.value === selectedValue}
        />
        <label htmlFor={value} />
        <span>{display}</span>
      </div>
    );
  }
}

Radio.propTypes = propTypes;
Radio.contextTypes = {
  radioGroup: PropTypes.object,
};

export default Radio;
