import React, { Component } from 'react';
import PropTypes from 'prop-types';
import classnames from 'classnames';

// CSS
import '../../../css/components/Checkbox.scss';

class Checkbox extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e) {
    const { onChange, id } = this.props;
    onChange({ id, value: e.target.value });
  }

  render() {
    const {
      id,
      label,
      wrapperClassName,
    } = this.props;

    return (
      <div
        className={classnames(
          'Checkbox__wrapper',
          wrapperClassName,
        )}
      >
        <input className="Checkbox" id={id} type="checkbox" defaultChecked />
        { label
          ? (
            <label htmlFor={id}>
              <span className="u-vertical-align-middle">{label}</span>
            </label>
          )
          : null
        }
      </div>
    );
  }
}

Checkbox.propTypes = {
  id: PropTypes.string.isRequired,
  label: PropTypes.string,
  wrapperClassName: PropTypes.string,
  onChange: PropTypes.func.isRequired,
};

Checkbox.defaultProps = {
  label: null,
  wrapperClassName: '',
};

export default Checkbox;
