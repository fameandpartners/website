import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import ShareButton from './ShareButton';
import { pinterest } from './social-media-share-links';

/* eslint-disable react/prefer-stateless-function */
export default class PinterestShareButton extends PureComponent {
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
      media,
      description,
    } = this.props;

    const pinterestLink = pinterest(url, { media, description });

    return (
      <ShareButton
        className={className}
        disabled={disabled}
        disabledStyle={disabledStyle}
        network="pinterest"
        link={pinterestLink}
        style={style}
        windowWidth={windowWidth}
        windowHeight={windowHeight}
        media={media}
        description={description}
      >
        {children}
      </ShareButton>
    );
  }

}

/* eslint-disable react/require-default-props */
/* eslint-disable react/forbid-prop-types */
PinterestShareButton.propTypes = {
  children: PropTypes.node,
  className: PropTypes.string,
  disabled: PropTypes.bool,
  disabledStyle: PropTypes.object,
  url: PropTypes.string.isRequired,
  style: PropTypes.object,
  windowWidth: PropTypes.number,
  windowHeight: PropTypes.number,
  media: PropTypes.string,
  description: PropTypes.string,
};

PinterestShareButton.defaultProps = {
  media: '',
  description: '',
  windowWidth: 1000,
  windowHeight: 730,
};
