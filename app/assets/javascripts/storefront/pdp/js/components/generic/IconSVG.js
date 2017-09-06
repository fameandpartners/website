import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';

/* eslint-disable react/prefer-stateless-function */
class IconSVG extends PureComponent {
  render() {
    const {
      svgPath,
      className,
      width,
      height,
    } = this.props;

    return (
      <svg
        style={{ width, height }}
        className={className}
      >
        <use xlinkHref={svgPath} />
      </svg>
    );
  }
}

IconSVG.propTypes = {
  svgPath: PropTypes.string,
  className: PropTypes.string,
  width: PropTypes.string,
  height: PropTypes.string,
};

IconSVG.defaultProps = {
  svgPath: '',
  className: '',
  width: '40px',
  height: '40px',
};

export default IconSVG;
