import React from 'react';
import ChatList from './ChatList';
import ChatBar from './ChatBar';
import Cart from './Cart';


export default class SizeButton extends React.Component
{
    render()
    {
        return (
            <div onClick={() => this.props.selectionCallback( this.props.size )} className={"size-box" + (this.props.selectedSize == this.props.size ? ' selected' : '') }>
              <div className="size-inner">{this.props.size}</div>
            </div>
        );
        
    }
}

SizeButton.propTypes = {
    size: React.PropTypes.string.isRequired,
    selectedSize: React.PropTypes.string.isRequired,
    selectionCallback: React.PropTypes.func.isRequired
};
