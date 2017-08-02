import React, { PropTypes } from 'react';
import { Link } from 'react-router';

const propTypes = {
  buttonCopy: PropTypes.string.isRequired,
  link: PropTypes.string,
  localLink: PropTypes.bool,
  withLink: PropTypes.bool,
};

const defaultProps = {
  withLink: false,
  link: '/',
  localLink: false,
};


const SimpleButton = ({ buttonCopy, link, localLink, withLink }) => (
  withLink ?
    <div className="simpleButton__container">
      {localLink ?
        <Link to={link}>
          <span className="copy">{buttonCopy}</span>
        </Link>
      :
        <a href={link}>
          <span className="copy">External Link</span>
        </a>}
    </div>
    :
    <div className="simpleButton__container u-padding-medium">
      <span className="copy u-no-padding">{buttonCopy}</span>
    </div>
);

SimpleButton.propTypes = propTypes;
SimpleButton.defaultProps = defaultProps;

export default SimpleButton;
