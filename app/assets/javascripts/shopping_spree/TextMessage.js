import React from 'react';

export default class TextMessage extends React.Component
{
    render()
    {
        return(
                <li className='text-message'>
                <div className='row equal'>
                <div className='message-name col-xs-push-2 col-xs-10'>
                {this.props.name}
                </div> 
               </div>
                <div className='row equal'>
                <div className={"avatar col-xs-2 " + "avatar-" + this.props.iconNumber }></div>
                <div className="firebase-text col-xs-8">{this.props.text}</div>
                </div>
                </li>
        )
    }
}

TextMessage.propTypes = {
    text: React.PropTypes.string.isRequired,
    name: React.PropTypes.string.isRequired,
    iconNumber: React.PropTypes.number.isRequired
}
