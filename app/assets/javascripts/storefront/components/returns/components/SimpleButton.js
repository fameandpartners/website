import React, { PropTypes } from 'react';
import { Link } from 'react-router';
import classnames from 'classnames';

const propTypes = {
  buttonCopy: PropTypes.string.isRequired,
  className: PropTypes.string,
  containerClassName: PropTypes.string,
  isLoading: PropTypes.bool,
  link: PropTypes.string,
  localLink: PropTypes.bool,
  withLink: PropTypes.bool,
};

const defaultProps = {
  className: '',
  containerClassName: '',
  withLink: false,
  isLoading: false,
  isLoadingCopy: 'Loading...',
  link: '/',
  localLink: false,
};


const SimpleButton = ({
  buttonCopy,
  className,
  containerClassName,
  link,
  isLoading,
  localLink,
  withLink,
}) => (
    withLink ?
      <div
        className={classnames(
        'SimpleButton__container',
        containerClassName,
        { 'SimpleButton__container--loading': isLoading },
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
      <div
        className={classnames(
        'SimpleButton__container u-width-full',
        containerClassName,
        { 'SimpleButton__container--loading': isLoading },
      )}
      >
        <span className="copy co">{buttonCopy}</span>
      </div>
  );

SimpleButton.propTypes = propTypes;
SimpleButton.defaultProps = defaultProps;

export default SimpleButton;
