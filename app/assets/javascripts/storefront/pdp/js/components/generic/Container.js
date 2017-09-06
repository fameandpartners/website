/* eslint-disable react/prefer-stateless-function */
// Component:Presentational
import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';

class Container extends PureComponent {
  render() {
    const { className } = this.props;
    return (
      <div
        className={`Container ${className}`}
      >
        {this.props.children}
      </div>
    );
  }
}

Container.propTypes = {
  className: PropTypes.string,
  children: PropTypes.oneOfType([PropTypes.array, PropTypes.node]).isRequired,
};

Container.defaultProps = {
  className: '',
};

export default Container;
