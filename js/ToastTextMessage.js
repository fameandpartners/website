import React from 'react';
import PropTypes from 'prop-types';

export default class ToastTextMessage extends React.Component {

  constructor(props) {
    super(props);
    this.remove = this.remove.bind(this);
  }

  componentDidMount() {
    this.timer = setTimeout(this.remove, 5000);
  }

  remove() {
    this.props.removeToast(this);
  }
  render() {
    return (
      <li className="toast-text">
        {this.props.name} said "{this.props.text}"
                </li>
    );
  }
}

ToastTextMessage.propTypes = {
  text: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  removeToast: PropTypes.func.isRequired,
};
