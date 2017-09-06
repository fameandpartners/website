import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import '../../../../css/components/Hamburger.scss';

/* eslint-disable react/prefer-stateless-function */
class Hamburger extends PureComponent {
  render() {
    const { className, isOpen, handleClick } = this.props;
    return (
      <div
        role="menu"
        className={`Hamburger ${className} ${isOpen ? 'Hamburger--is-open' : ''}`}
        onClick={handleClick}
      >
        <span />
        <span />
        <span />
        <span />
      </div>
    );
  }
}

Hamburger.propTypes = {
  className: PropTypes.string,
  handleClick: PropTypes.func.isRequired,
  isOpen: PropTypes.bool,
};
Hamburger.defaultProps = {
  className: '',
  isOpen: false,
};

export default Hamburger;
