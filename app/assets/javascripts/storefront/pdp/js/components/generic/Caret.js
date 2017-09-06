import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import classnames from 'classnames';

// Components
import IconSVG from '../generic/IconSVG';

// Assets
import Carat from '../../../svg/carat.svg';

// CSS
import '../../../css/components/Caret.scss';

/* eslint-disable react/prefer-stateless-function */
class Caret extends PureComponent {
  render() {
    const {
      height,
      width,
      left,
      right,
    } = this.props;

    return (
      <IconSVG
        svgPath={Carat.url}
        className={classnames(
          'Caret',
          {
            'Caret--left': left,
            'Caret--right': right,
          },
        )}
        height={height}
        width={width}
      />
    );
  }
}

Caret.propTypes = {
  height: PropTypes.string, // px
  width: PropTypes.string, // px
  left: PropTypes.bool,
  right: PropTypes.bool,
};

Caret.defaultProps = {
  height: '16px',
  width: '16px',
  right: false,
  left: false,
};

export default Caret;
