import React from 'react';
import PropTypes from 'prop-types';

export default class JoinedMessage extends React.Component {
  constructor(props) {
    super(props);
    this.formatDate = this.formatDate.bind(this);
  }

  formatDate(timeInMilliseconds) {
    const d = new Date(timeInMilliseconds);
    let minutes = d.getMinutes() < 10 ? `0${d.getMinutes()}` : d.getMinutes();
    const hours = d.getHours() > 12 ? d.getHours() - 12 : d.getHours();
    minutes = d.getHours() >= 12 ? `${minutes}pm` : `${minutes}am`;

    return `${d.getMonth() + 1}/${d.getDate()}/${d.getFullYear()} ${hours}:${minutes}`;
  }

  render() {
    return (
      <li className="joined-message">
        <div className="row equal">
          <div
            className="joined-text col-xs-push-2 col-xs-8"
          >
            {this.formatDate(this.props.createdAt)} - {this.props.name}
            <br />joined this shopping spree
          </div>
        </div>
      </li>
    );
  }
}

JoinedMessage.propTypes = {
  name: PropTypes.string.isRequired,
  createdAt: PropTypes.number.isRequired,
};
