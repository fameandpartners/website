import React from 'react';
import PropTypes from 'prop-types';

const TextMessage = ({ text, sameOwnerAsLastMessage, iconNumber }) => {
  const sameOwner = sameOwnerAsLastMessage;
  let name = '';
  if (!sameOwner) {
    name = (<div className="row equal">
      <div className="message-name col-xs-push-2 col-xs-10">
        {name}
      </div>
    </div>);
  }
  return (
    <li className="text-message">
      {name}
      <div className="row equal no-left-gutter">
        <div className={`avatar col-xs-2 ${sameOwnerAsLastMessage ? '' : `avatar-${iconNumber}`}`} />
        <div className="firebase-text col-xs-8">{text}</div>
      </div>
    </li>
  );
};

TextMessage.propTypes = {
  text: PropTypes.string.isRequired,
  sameOwnerAsLastMessage: PropTypes.bool.isRequired,
  iconNumber: PropTypes.number.isRequired,
};

export default TextMessage;
