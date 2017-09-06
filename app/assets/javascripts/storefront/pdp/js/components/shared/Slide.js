/* eslint-disable react/prefer-stateless-function */
import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';

class Slide extends PureComponent {
  render() {
    const { children } = this.props;

    return (
      <div className="Slide u-height--full">
        { children }
      </div>
    );
  }
}

Slide.propTypes = {
  children: PropTypes.node.isRequired,
};

export default Slide;
