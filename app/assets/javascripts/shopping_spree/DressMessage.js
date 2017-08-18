import React from 'react';

export default class DressMessage extends React.Component
{
    render()
    {
        const sameOwner = this.props.sameOwnerAsLastMessage;
        let name = ""
        if( !sameOwner )
        {
            name = (<div className='row equal'>
                    <div className='message-name col-xs-push-2 col-xs-10'>
                    {this.props.name}
                    </div>
                    </div>);
        }
        
        return(
                <li className='dress-message'>
                {name}
                <div className='row equal'>
                <div className={"avatar col-xs-2 " + (this.props.sameOwnerAsLastMessage ? "" : "avatar-" + this.props.iconNumber ) }></div>
                <div className="dress-card col-xs-6">
                <div className="dress-card-content">
                <div className="row">
                <div className="dress-card-image col-xs-12">
                <img alt={this.props.dress.name} src={this.props.dress.image}/>
                </div>
                </div>
                <div className="row dress-card-headline">
                <div className="col-xs-8">
                {this.props.dress.name}
                </div>
                <div className="dress-price col-xs-4">
                ${parseInt(this.props.dress.price)}
                </div>
                </div>
                <div className="row add-to-spree-btn">
                <div className="col-xs-12">
                <a className='center-block btn btn-black btn-lrg'>Add to my cart</a>
                </div>
                </div>
                </div>
                </div>
                </div>
                </li>
        )
    }
}

DressMessage.propTypes =
    {
        name: React.PropTypes.string.isRequired,
        email: React.PropTypes.string.isRequired,
        sameOwnerAsLastMessage: React.PropTypes.bool.isRequired,
        iconNumber: React.PropTypes.number.isRequired,
        dress: React.PropTypes.node.isRequired
    }
