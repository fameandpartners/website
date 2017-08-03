import React, { PropTypes } from 'react';
import { Link } from 'react-router';
import classnames from 'classnames';

const propTypes = {
  buttonCopy: PropTypes.string.isRequired,
  className: PropTypes.string,
  link: PropTypes.string,
  localLink: PropTypes.bool,
  withLink: PropTypes.bool,
};

const defaultProps = {
  className: '',
  withLink: false,
  link: '/',
  localLink: false,
};


const SimpleButton = ({ buttonCopy, className, link, localLink, withLink }) => (
  withLink ?
    <div className="simpleButton__container">
      <div
        className={classnames(
      'simpleButton__container',
      className,
    )}
      >
        {localLink ?
          <Link to={link}>
            <span className="copy">{buttonCopy}</span>
          </Link>
        :
          <a href={link}>
            <span className="copy">External Link</span>
          </a>}
      </div>
    </div>
    :
    <div className="simpleButton__container u-width-full">
      <span className="copy">{buttonCopy}</span>
    </div>
);

SimpleButton.propTypes = propTypes;
SimpleButton.defaultProps = defaultProps;

export default SimpleButton;
