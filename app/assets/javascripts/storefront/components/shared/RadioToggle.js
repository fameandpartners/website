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
    this.handleToggle = this.handleToggle.bind(this);
    this.handleSelection = this.handleSelection.bind(this);
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
   * Propagates toggle change upwards
   */
  handleToggle() {
    const { onChange, options, value } = this.props;
    const newSelection = options[0].value === value ?
      { value: options[1].value } :
      { value: options[0].value };
    onChange(newSelection);
  }
  /**
   * Propagates change upwards
   * @param  {Number} position
   */
  handleSelection(position) {
    const { onChange, options } = this.props;
    return () => {
      onChange({ value: options[position].value });
    };
  }

  render() {
    const { id, value, options } = this.props;
    const switchClass = options[1].value === value ? 'right' : 'left';

    return (
      <div className="RadioToggle--wrapper">
        <option className={this.labelClass(0)} onClick={this.handleSelection(0)}>
          {options[0].label || options[0].value}
        </option>
        <input
          className={`RadioToggle ${switchClass}`}
          type="checkbox"
          id={id}
          onChange={this.handleToggle}
        />
        <option className={this.labelClass(1)} onClick={this.handleSelection(1)}>
          {options[1].label || options[1].value}
        </option>
      </div>
    );
  }
}


RadioToggle.propTypes = propTypes;
export default RadioToggle;
