import React from 'react';

export default class TextMessage extends React.Component
{
    render()
    {
        return(
                <li className='text-message'>{this.props.text}</li>
        )
    }
}

TextMessage.propTypes = {
    text: React.PropTypes.string.isRequired
}
