import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import ShareButton from './ShareButton';
import { twitter } from './social-media-share-links';

/* eslint-disable react/prefer-stateless-function */
export default class TwitterShareButton extends PureComponent {
  render() {
    const {
      children,
      className,
      disabled,
      disabledStyle,
      url,
      style,
      windowWidth,
      windowHeight,
      hashtags,
      title,
      via,
    } = this.props;

    const twitterShareLink = twitter(url, { title, via, hashtags });

    return (
      <ShareButton
        className={className}
        disabled={disabled}
        disabledStyle={disabledStyle}
        network="twitter"
        link={twitterShareLink}
        style={style}
        windowWidth={windowWidth}
        windowHeight={windowHeight}
        hashtags={hashtags}
        title={title}
        via={via}
      >
        {children}
      </ShareButton>
    );
  }

}

/* eslint-disable react/require-default-props */
/* eslint-disable react/forbid-prop-types */
TwitterShareButton.propTypes = {
  children: PropTypes.node,
  className: PropTypes.string,
  disabled: PropTypes.bool,
  disabledStyle: PropTypes.object,
  url: PropTypes.string.isRequired,
  style: PropTypes.object,
  windowWidth: PropTypes.number,
  windowHeight: PropTypes.number,
  hashtags: PropTypes.arrayOf(PropTypes.string),
  title: PropTypes.string,
  via: PropTypes.string,
};

TwitterShareButton.defaultProps = {
  hashtags: [],
  title: '',
  via: '',
  windowWidth: 550,
  windowHeight: 400,
};
