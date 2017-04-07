// *****
// ** RadioToggle is a purely functional dumb/abstract component for toggling between two options
// *****
import React, { Component, PropTypes } from 'react';

const propTypes = {
  id: PropTypes.string.isRequired,
  options: PropTypes.arrayOf({
    label: React.PropTypes.string,
    value: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.bool,
    ]),
  }).isRequired,
  valueSelected: PropTypes.oneOfType([
    React.PropTypes.string,
    React.PropTypes.bool,
  ]).isRequired,
  onChange: PropTypes.func.isRequired,
};

class RadioToggle extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e) {
    const { onChange, id } = this.props;
    onChange({ id, value: e.target.value });
  }

  render() {
    const { id, valueSelected, options } = this.props;
    const switchClass = options[1].value === valueSelected ? 'right' : 'left';
    return (
      <div className={`RadioToggle-wrapper ${switchClass}`}>
        <span>{options[0].label || options[0].value}</span>
        <input
          className="RadioToggle"
          type="checkbox"
          id={id}
          value={valueSelected}
          onChange={this.handleChange}
        />
        <span>{options[1].label || options[1].value}</span>
      </div>
    );
  }
}


RadioToggle.propTypes = propTypes;
export default RadioToggle;
