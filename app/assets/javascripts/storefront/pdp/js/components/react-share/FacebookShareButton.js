import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import ShareButton from './ShareButton';
import { facebook } from './social-media-share-links';

/* eslint-disable react/prefer-stateless-function */
export default class FacebookShareButton extends PureComponent {
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
      quote,
      hashtag,
    } = this.props;

    const facebookShareLink = facebook(url);

    return (
      <ShareButton
        className={className}
        disabled={disabled}
        disabledStyle={disabledStyle}
        network="facebook"
        link={facebookShareLink}
        style={style}
        windowWidth={windowWidth}
        windowHeight={windowHeight}
        quote={quote}
        hashtag={hashtag}
      >
        {children}
      </ShareButton>
    );
  }

}

/* eslint-disable react/require-default-props */
/* eslint-disable react/forbid-prop-types */
FacebookShareButton.propTypes = {
  children: PropTypes.node,
  className: PropTypes.string,
  disabled: PropTypes.bool,
  disabledStyle: PropTypes.object,
  url: PropTypes.string.isRequired,
  style: PropTypes.object,
  windowWidth: PropTypes.number,
  windowHeight: PropTypes.number,
  quote: PropTypes.string,
  hashtag: PropTypes.string,
};

FacebookShareButton.defaultProps = {
  quote: '',
  hashtag: '',
  windowWidth: 550,
  windowHeight: 400,
};
