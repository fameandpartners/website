import React from 'react';

export default class ToastTextMessage extends React.Component
{
    render()
    {
        return(
                <li className='toast-text'>
                {this.props.name} said "{this.props.text}"
                </li>
        );
    }
}

ToastTextMessage.propTypes = {
    text: React.PropTypes.string.isRequired,
    name: React.PropTypes.string.isRequired,
    email: React.PropTypes.string.isRequired,
    iconNumber: React.PropTypes.number.isRequired
}
