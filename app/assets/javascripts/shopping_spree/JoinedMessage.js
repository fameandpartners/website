import React from 'react';

export default class JoinedMessage extends React.Component
{
    render()
    {
        
        return(
                <li className='joined-message'>
                {name}
                <div className='row equal'>
                <div className="joined-text col-xs-push-2 col-xs-8">{this.props.createdAt} - {this.props.name} joined this shopping spree</div>
                </div>
                </li>
        )
    }
}

JoinedMessage.propTypes = {
    name: React.PropTypes.string.isRequired,
    email: React.PropTypes.string.isRequired,
    createdAt: React.PropTypes.number.isRequired
}
