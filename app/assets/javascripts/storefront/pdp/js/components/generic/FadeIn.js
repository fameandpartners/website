import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import classnames from 'classnames';

// CSS
import '../../../css/components/FadeIn.scss';

class FadeIn extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
    this.state = {
      fadeIn: false,
    };
  }

  /* eslint-disable react/no-did-mount-set-state */
  componentDidMount() {
    this.setState({ fadeIn: true });
  }

  render() {
    return (
      <div
        className={classnames(
          'FadeIn',
          { 'FadeIn--fade-in': this.state.fadeIn },
        )}
      >
        {this.props.children}
      </div>
    );
  }
}

FadeIn.propTypes = {
  children: PropTypes.node.isRequired,
};

export default FadeIn;
