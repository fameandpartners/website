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
  value: PropTypes.oneOfType([
    React.PropTypes.string,
    React.PropTypes.bool,
  ]).isRequired,
  onChange: PropTypes.func.isRequired,
};

class RadioToggle extends Component {
  constructor(props) {
    super(props);
    this.labelClass = this.labelClass.bind(this);
    this.handleChange = this.handleChange.bind(this);
  }


  /**
   * Constructs class for labels
   * @param  {Number} position
   * @return {String} className
   */
  labelClass(position) {
    const { options, value } = this.props;
    const positionName = position === 0 ? 'left' : 'right';
    let labelClassName = `RadioToggle--label RadioToggle--label__${positionName}`;

    if (options[position].value === value) { labelClassName += ' RadioToggle--label__selected'; }
    return labelClassName;
  }

  /**
   * Propagates change upwards
   * @param  {Object} e - event
   */
  handleChange() {
    const { onChange, options, value } = this.props;
    const newSelection = options[0].value === value ?
      { value: options[1].value } :
      { value: options[0].value };
    onChange(newSelection);
  }

  render() {
    const { id, value, options } = this.props;
    const switchClass = options[1].value === value ? 'right' : 'left';

    return (
      <div className={`RadioToggle--wrapper ${switchClass}`}>
        <span className={this.labelClass(0)}>
          {options[0].label || options[0].value}
        </span>
        <input
          className="RadioToggle"
          type="checkbox"
          id={id}
          value={value}
          onChange={this.handleChange}
        />
        <span className={this.labelClass(1)}>
          {options[1].label || options[1].value}
        </span>
      </div>
    );
  }
}


RadioToggle.propTypes = propTypes;
export default RadioToggle;
