import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';

// Components
import IconSVG from '../generic/IconSVG';

// CSS
import '../../../css/components/IconButton.scss';

/* eslint-disable react/prefer-stateless-function */
class IconButton extends PureComponent {
  render() {
    const {
      handleClick,
      svgPath,
      width,
      height,
    } = this.props;

    return (
      <button
        onClick={handleClick}
        className="IconButton"
      >
        <IconSVG
          svgPath={svgPath}
          width={width}
          height={height}
        />
      </button>
    );
  }
}

IconButton.propTypes = {
  handleClick: PropTypes.func.isRequired,
  svgPath: PropTypes.string.isRequired,
  width: PropTypes.string,
  height: PropTypes.string,
};

IconButton.defaultProps = {
  width: '40px',
  height: '40px',
};

export default IconButton;
