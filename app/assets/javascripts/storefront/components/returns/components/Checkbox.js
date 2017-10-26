import React, { Component } from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';

const propTypes = {
  id: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.number,
  ]),
  wrapperClassName: PropTypes.string,
  checkboxStatus: PropTypes.bool,
  showForm: PropTypes.bool,
  onChange: PropTypes.func.isRequired,
};

const defaultProps = {
  id: '',
  wrapperClassName: '',
  checkboxStatus: false,
  showForm: false,
};

class Checkbox extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e) {
    e.preventDefault();
    this.props.onChange();
  }
  render() {
    const {
      id,
      wrapperClassName,
      checkboxStatus,
      showForm,
    } = this.props;
    return (
      <div>
        { showForm
          ? (
            <div
              className={classNames(
               'Checkbox__wrapper',
               wrapperClassName,
             )}
            >
              <input
                className={checkboxStatus ? 'Checkbox Checkbox--active' : 'Checkbox'}
                id={id}
                onClick={this.handleChange}
              />
              <label htmlFor={id} />
            </div>
          )
          : null
        }
      </div>
    );
  }
}

Checkbox.propTypes = propTypes;
Checkbox.defaultProps = defaultProps;
export default Checkbox;
