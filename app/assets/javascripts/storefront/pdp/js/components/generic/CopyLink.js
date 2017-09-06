import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autobind from 'react-autobind';
import Clipboard from 'clipboard';

// Components
import Button from '../generic/Button';
import Input from '../form/Input';


class CopyLink extends Component {
  constructor(props) {
    super(props);

    this.state = {
      clipboardError: false,
    };

    autobind(this);
  }

  handleCopyLinkClick() {
    /* eslint-disable no-console */
    console.log(`Copied Share Link: ${this.props.url}`);
    /* eslint-enable no-console */
    // TO-DO: Link Mike's Success Toast
  }

  handleCopyLinkClickError() {
    this.setState({
      clipboardError: true,
    });
  }

  /* eslint-disable react/no-did-mount-set-state */
  /* eslint-disable react/no-find-dom-node */
  componentDidMount() {
    this.setState({
      clipboard: new Clipboard(this.copyTrigger, {
        text: () => this.props.url,
        error: () => {
          this.handleCopyLinkClickError();
        },
      }),
    });
  }

  render() {
    const {
      url,
    } = this.props;

    const {
      clipboardError,
    } = this.state;

    return (
      <div>
        <Button
          tall
          secondary
          passedRef={i => this.copyTrigger = i}
          className="Modal__content--med-margin-bottom"
          text="Copy Link"
          handleClick={this.handleCopyLinkClick}
        />
        {
          clipboardError ?
          (
            <Input
              id="copy_link_fallback"
              label="Press Ctrl/Cmd-C To Copy"
              defaultValue={url}
              selectOnMount
              readOnly
              wrapperClassName="Modal__content--med-margin-bottom"
            />
          ) : null
        }
      </div>
    );
  }
}

CopyLink.propTypes = {
  url: PropTypes.string.isRequired,
};

export default CopyLink;
