import React from 'react';

export default class ToastTextMessage extends React.Component
{

    constructor( props )
    {
        super( props );
        this.remove = this.remove.bind( this );
    }
    
    componentDidMount()
    {
        this.timer = setTimeout( this.remove, 5000 );
    }

    remove()
    {
        this.props.removeToast( this );
    }
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
    iconNumber: React.PropTypes.number.isRequired,
    removeToast: React.PropTypes.func.isRequired    
}
