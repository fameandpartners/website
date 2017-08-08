import React, { PropTypes } from 'react';
import { Link } from 'react-router';
import classnames from 'classnames';

const propTypes = {
  buttonCopy: PropTypes.string.isRequired,
  className: PropTypes.string,
  isLoading: PropTypes.bool,
  link: PropTypes.string,
  localLink: PropTypes.bool,
  withLink: PropTypes.bool,
};

const defaultProps = {
  className: '',
  withLink: false,
  isLoading: false,
  isLoadingCopy: 'Loading...',
  link: '/',
  localLink: false,
};


const SimpleButton = ({
  buttonCopy,
  className,
  link,
  isLoading,
  localLink,
  withLink,
}) => (
  withLink ?
    <div
      className={classnames(
      'SimpleButton__container',
      { SimpleButton__container__loading: isLoading },
    )}
    >
      <div className={className}>
        {localLink ?
          <Link to={link}>
            <span className="copy">{buttonCopy}</span>
          </Link>
        :
          <a href={link}>
            <span className="copy">{buttonCopy}</span>
          </a>}
      </div>
    </div>
    :
    <div className="SimpleButton__container u-width-full">
      <span className="copy">{buttonCopy}</span>
    </div>
);

SimpleButton.propTypes = propTypes;
SimpleButton.defaultProps = defaultProps;

export default SimpleButton;
