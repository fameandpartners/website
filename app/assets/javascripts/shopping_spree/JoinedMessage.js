import React from 'react';

export default class JoinedMessage extends React.Component
{
    constructor( props )
    {
        super( props );
        this.formatDate = this.formatDate.bind( this );
    }

    formatDate( timeInMilliseconds )
    {
        var d = new Date( timeInMilliseconds );
        return (d.getMonth() + 1) + '/' + d.getDate() + '/' + d.getFullYear() + ' ' + d.getHours() + ":" + d.getMinutes()        
    }
    
    render()
    {
        
        return(
                <li className='joined-message'>
                <div className='row equal'>
                <div className="joined-text col-xs-push-2 col-xs-8">{this.formatDate(this.props.createdAt)} - {this.props.name} joined this shopping spree</div>
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
