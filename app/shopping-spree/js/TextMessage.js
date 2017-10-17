/* eslint-disable */

import React from 'react';
import PropTypes from 'prop-types';

export default class TextMessage extends React.Component
{
    render()
    {
        const sameOwner = this.props.sameOwnerAsLastMessage;
        let name = "";
        if( !sameOwner )
        {
            name = (<div className='row equal'>
                    <div className='message-name col-xs-push-2 col-xs-10'>
                    {this.props.name}
                    </div>
                    </div>);
        }

        return(
                <li className='text-message'>
                {name}
                <div className='row equal no-left-gutter'>
                <div className={"avatar col-xs-2 " + (this.props.sameOwnerAsLastMessage ? "" : "avatar-" + this.props.iconNumber ) }></div>
                <div className="firebase-text col-xs-8">{this.props.text}</div>
                </div>
                </li>
        );
    }
}

TextMessage.propTypes = {
    text: PropTypes.string.isRequired,
    name: PropTypes.string.isRequired,
    email: PropTypes.string.isRequired,
    sameOwnerAsLastMessage: PropTypes.bool.isRequired,
    iconNumber: PropTypes.number.isRequired
}
