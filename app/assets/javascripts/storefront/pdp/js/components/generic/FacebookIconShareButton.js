import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import FacebookShareButton from '../react-share/FacebookShareButton';

// Components
import IconSVG from '../generic/IconSVG';

// Assets
import FacebookShareIcon from '../../../svg/share-facebook.svg';

// CSS
import '../../../css/components/SocialShareIconButton.scss';


/* eslint-disable react/prefer-stateless-function */
class FacebookIconShareButton extends PureComponent {
  render() {
    const {
      url,
    } = this.props;

    return (
      <FacebookShareButton
        url={url}
        className="SocialShare__icon-button"
      >
        <IconSVG
          svgPath={FacebookShareIcon.url}
          width="40px"
          height="40px"
        />
      </FacebookShareButton>
    );
  }
}

FacebookIconShareButton.propTypes = {
  url: PropTypes.string.isRequired,
};

export default FacebookIconShareButton;
