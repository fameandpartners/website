// TODO: Will need to clean up
import React, { Component } from 'react';
import PropTypes from 'prop-types';

// CSS
import '../../../css/components/RadioToggle.scss';


const propTypes = {
  id: PropTypes.string.isRequired,
  options: PropTypes.arrayOf(PropTypes.shape({
    label: React.PropTypes.string,
    value: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.bool,
    ]),
  })).isRequired,
  value: PropTypes.oneOfType([
    React.PropTypes.string,
    React.PropTypes.bool,
  ]),
  onChange: PropTypes.func.isRequired,
};

const defaultProps = {
  value: null,
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
        {options[0].label
        ? (
          <span className={this.labelClass(0)} onClick={this.handleSelection(0)}>
            {options[0].label || options[0].value}
          </span>
        ) : null
      }
        <button
          className={`RadioToggle ${switchClass}`}
          type="checkbox"
          id={id}
          onClick={this.handleToggle}
        />
        <span className={this.labelClass(1)} onClick={this.handleSelection(1)}>
          {options[1].label || options[1].value}
        </span>
      </div>
    );
  }
}


RadioToggle.propTypes = propTypes;
RadioToggle.defaultProps = defaultProps;
export default RadioToggle;
