import React, { PropTypes } from 'react';
import { Link } from 'react-router';

const propTypes = {
  buttonCopy: PropTypes.string.isRequired,
  link: PropTypes.string.isRequired,
  localLink: PropTypes.bool.isRequired,
};


const SimpleButton = ({ buttonCopy, link, localLink }) => (
  localLink ?
    <div className="simpleButton__container">
      <Link to={link}>
        <span className="copy">{buttonCopy}</span>
      </Link>
    </div>
    :
    <div className="simpleButton__container">
      <a href={link}>
        <span className="copy">{buttonCopy}</span>
      </a>
    </div>
);

SimpleButton.propTypes = propTypes;

export default SimpleButton;
