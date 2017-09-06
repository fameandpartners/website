/* eslint-disable react/prefer-stateless-function */
// Component:Presentational
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autobind from 'react-autobind';

// Components
import IconSVG from '../generic/IconSVG';

// Assets
import FacebookLogo from '../../../svg/i-facebook.svg';

// Utilities
import { reassignProps } from '../../utilities/props';

// Components
import Button from './Button';

class FacebookButton extends Component {
  constructor(props) {
    super(props);
    autobind(this);
  }

  handleClick() {
    return null;
  }

  facebookText() {
    const { login, text } = this.props;
    if (text) { return text; }
    return login
      ? 'Log in with Facebook'
      : 'Sign up with Facebook';
  }

  render() {
    const props = reassignProps(
      this.props,
      {
        className: `Button--facebook ${this.props.className}`,
        handleClick: this.handleClick,
      },
    );

    return (
      <div
        className="FacebookButton"
      >
        <Button
          {...props}
          metaIcon={(
            <IconSVG
              svgPath={FacebookLogo.url}
              width="20px"
              height="20px"
            />
          )}
          text={this.facebookText()}
        />
      </div>
    );
  }
}

FacebookButton.propTypes = {
  className: PropTypes.string,
  login: PropTypes.bool,
  text: PropTypes.string,
};

FacebookButton.defaultProps = {
  className: '',
  login: false,
  text: '',
};


export default FacebookButton;
